import processing.video.*;
Capture video;
int pointillize = 8;

void setup() {
  size(320,240);
  video = new Capture(this, 320,240,30);
  background(255);
  smooth();
}

void draw() {
  
  if(video.available()){
    video.read();
  }
  image(video,0,0);
  
  int x = int(random(video.width));
  int y = int(random(video.height));
  int loc = x + y*video.width;
  
  video.loadPixels();
  float r = red(video.pixels[loc]);
  float g = green(video.pixels[loc]);
  float b = blue(video.pixels[loc]);
  
  noStroke();
  fill(r,g,b,100);
  ellipse(x,y,pointillize,pointillize); 
}
