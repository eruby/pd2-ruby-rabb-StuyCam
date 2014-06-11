// Pixelation of Capture

import processing.video.*;

int scale = 8;
//Scale can be adjusted via a slider
int cols, rows;
Capture video;

void setup(){
  size(320,240);
  
  cols = width/scale;
  rows = height/scale;
  video = new Capture(this,width,height);
  video.start();
}

void draw(){
  if (video.available()){
    video.read();
  }
  video.loadPixels();
  
  for(int a = 0; a < cols; a++){
    for (int b = 0; b < rows; b++){
      int x = a * scale;
      int y = b * scale;
      
      color c = video.pixels[x + y * video.width];
      fill(c);
      stroke(0);
      rect(x,y,scale,scale);
    }
  }
}
