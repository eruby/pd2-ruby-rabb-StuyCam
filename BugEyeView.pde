import processing.video.*;
Capture video;
int pointillize = 8;
int cols, rows;

void setup() {
  size(320,240);
  
  cols = width/pointillize;
  rows = height/pointillize;
  video = new Capture(this, 320,240,30);
  background(255);
  smooth();
  video.start();
}

void draw() {
  
  if(video.available()){
    video.read();
  }
  video.loadPixels();
  
  for(int c = 0; c < cols; c++){
    for(int d = 0; d < rows; d++){
      
  int x = c * pointillize;
  int y = d * pointillize;;
  int loc = x + y * video.width;
  
  
  float r = red(video.pixels[loc]);
  float g = green(video.pixels[loc]);
  float b = blue(video.pixels[loc]);
  
  stroke(0);
  fill(r,g,b,100);
  ellipse(x,y,pointillize,pointillize);
  
    }
  }
}
