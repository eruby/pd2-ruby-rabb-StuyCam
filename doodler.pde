import processing.video.*;

float x;
float y;

Capture video;

void setup() {
  size(320,240);
  smooth();
  background(255);
  
  x = width/2;
  y = height/2;

  video = new Capture(this,width,height,30); 
  video.start();
}

void draw() {

  if (video.available()) {
    video.read();
  }
  video.loadPixels();
  
  float newx = constrain(x + random(-20,20),0,width-1);
  float newy = constrain(y + random(-20,20),0,height-1);
  
  int midx = int((newx + x) / 2);
  int midy = int((newy + y) / 2);
  
  color c = video.pixels[(width-1-midx) + midy*video.width];

  stroke(c);
  strokeWeight(2);
  line(x,y,newx,newy);

  x = newx;
  y = newy;
  
  
}
