import processing.video.*;
Capture video;

void setup() 
{
  size(640, 480);
  video = new Capture(this, width, height, 30);
  video.start();
}

void draw() {
  if(video.available()){
    video.read();
  }
  
  image(video, 0, 0);
  filter(GRAY);
}
