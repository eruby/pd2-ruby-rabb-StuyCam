
import processing.video.*;

int grayScaler = 2;

int cols, rows;

Capture video;

void setup() {
  size(320,240);
  cols = width/grayScaler ;
  rows = height/grayScaler;
  smooth();
  video = new Capture(this,cols,rows,30);
  video.start();
}

void draw() {
  if (video.available()) {
    video.read();
  }
  background(0);

  video.loadPixels();

  for (int i = 0; i < cols ; i++) {
    for (int j = 0; j < rows; j++) {

      int x = i*grayScaler;
      int y = j*grayScaler;

      int loc = (video.width - i - 1) + j*video.width;

      color c = video.pixels[loc];

      float sz = (brightness(c)/255.0)*grayScaler; 
      rectMode(CENTER);
      fill(255);
      noStroke();
      rect(x + grayScaler/2,y + grayScaler/2,sz,sz);

    }
  }
}
