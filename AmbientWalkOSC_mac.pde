/**
 * oscP5sendreceive by andreas schlegel
 * example shows how to send and receive osc messages.
 * oscP5 website at http://www.sojamo.de/oscP5
 */

import oscP5.*;
import netP5.*;


OscP5 oscP5;
NetAddress myRemoteLocation;
float period=0,volume=0,volume1=0,volume2=0;
int timelapsed,starttime=0;
double pace=0,ratio=0,ratio1=0,ratio2=0;
String deviceip="",deviceip1="",deviceip2="";
int xPos=0,yPos1=300,yPos2=700;
String isOSC="false";
//float[] colorRGB={255,255,255};

void setup() {
  NetInfo.print();
  size(1500,900);
  //noStroke();
  //background(255,255,255);
  colorMode(RGB);
  background(0,0,0);
  frameRate(1);
  /* start oscP5, listening for incoming messages at port 12000 */
  oscP5 = new OscP5(this,12000);

  /* myRemoteLocation is a NetAddress. a NetAddress takes 2 parameters,
   * an ip address and a port number. myRemoteLocation is used as parameter in
   * oscP5.send() when sending osc packets to another computer, device, 
   * application. usage see below. for testing purposes the listening port
   * and the port of the remote location address are the same, hence you will
   * send messages back to this sketch.
   */
  /*change  192.168.0.10 to your own IP address*/
  //set both to java mode and use ip 127.0.0.1 for debugging
  //myRemoteLocation = new NetAddress("172.20.10.4",12000);//phone's ip
}

void draw() {
//change color based on the ratio intervals
//intense(low ratio): R=255, G increase when ratio increase, B=0
//medium (medium ratio=3-8): R decrease when ratio increase, G=255,B=0
//ideal=5 (1 step/s, 5s breath period)
//relax(high ratio): R=0, G=255, B increase when ratio increase
//if breath period increase, B increase (B=ratio*breath period)
fill(0,0,0);noStroke();rect(0,0,width,100);
textSize(20);fill(255,255,255);
text("Real-time Data Visualisation (Time elapsed: "+timelapsed+" sec)", 50,50);
textSize(15);
text("Device 1: "+deviceip1,50,125);
text("Device 2: "+deviceip2,50,525);
float[] color1=getColor(ratio1);
fill(color1[0],color1[1],color1[2],125);stroke(color1[0],color1[1],color1[2],125);
  rect(xPos,yPos1-volume1/2,10,volume1);
float[] color2=getColor(ratio2);
fill(color2[0],color2[1],color2[2],125);stroke(color2[0],color2[1],color2[2],125);
  rect(xPos,yPos2-volume2/2,10,volume2);
  xPos+=10;
  if (xPos>=width){background(0,0,0);xPos=0;}
   //period=0;volume=0;pace=0;ratio=0;
}

/* incoming osc message are forwarded to the oscEvent method. */
void oscEvent(OscMessage theOscMessage) {
//println(theOscMessage);

  if(theOscMessage.checkAddrPattern("/data")) 
  {
    /* print the address pattern and the typetag of the received OscMessage */
    //  print("### received an osc message.");
    //  print(" addrpattern: "+theOscMessage.addrPattern());
    //  println(" typetag: "+theOscMessage.typetag());
  isOSC=theOscMessage.get(0).stringValue();
  println("isOSC: "+ isOSC);
  deviceip=theOscMessage.get(1).stringValue();
  println("Device: "+ deviceip);
  
  //if(deviceip.equals("172.20.10.3")){
    if(deviceip.equals("192.168.0.101")){
    deviceip1=deviceip;
    volume1=volume;
    ratio1=ratio;
  }
  //else if(deviceip.equals("172.20.10.4")){
    else if(deviceip.equals("192.168.0.103")){
    deviceip2=deviceip;
    volume2=volume;
    ratio2=ratio;
  }
  
  
  if(isOSC.equals("true")){   
    timelapsed=(millis()-starttime)/1000;
   period=theOscMessage.get(2).floatValue();
  println("Breath Period: "+ period);
   pace=theOscMessage.get(3).doubleValue();
  println("Walking Pace: "+ pace);
  if(pace!=0){
    ratio=(double)period/pace;
  }
  else{ratio=0;}
  println("Ratio: "+ ratio);
  volume=theOscMessage.get(4).floatValue();
  println("Volume: "+ volume);
  }
  else if (isOSC.equals("false")){
    period=0;volume=0;pace=0;ratio=0;timelapsed=0;starttime=millis();
  }
  
 } 
}
public float[] getColor(double ratio) {
  float[] colorRGB={255,255,255};
  if (ratio>0&&ratio<=2){colorRGB[0]=255;colorRGB[1]=(float)ratio*80;colorRGB[2]=0;}
else if (ratio>2&&ratio<=6){colorRGB[0]=(float)(255-ratio*20); colorRGB[1]=255;colorRGB[2]=0;}
else if (ratio==0){colorRGB[0]=255;colorRGB[1]=255;colorRGB[2]=255;stroke(colorRGB[0],colorRGB[1],colorRGB[2]);}
else{colorRGB[0]=0;colorRGB[1]=255-(float)ratio*10;colorRGB[2]=(float)ratio*10;}
  return colorRGB;
}
