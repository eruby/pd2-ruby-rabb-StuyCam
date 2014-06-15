import processing.video.*;

 class Button {
   String label;
   int bX, bY, bH, bW, bR ;//where R is the radius of rounded edges
   color buttonColor, oColor;
   color bHighlight;
   int bPress = 0;
   
   Button(String l , int x, int y, int w, int h, int r,
   int c, int hl){
       label = l;
       bX = x;
       bY = y;
       bH = h;
       bW = w;
       bR = r;
       buttonColor = color(c);
       oColor = buttonColor;
       bHighlight = color(hl);        
           }
           
  void makeButton(){
   stroke(0,0,255);
   fill(buttonColor);
   rect(bX,bY,bW,bH,bR); 
   
   fill(0,0,255);
   textAlign(CENTER);
   text(label, bX, bY, bW, bH);
  }
  
  boolean overButton(){
   if (mouseX >= bX && mouseX <= bX + bW &&
       mouseY >= bY && mouseY <= bY+ bH){
        return true;
       } 
    return false;
  }
  
  void highLight(){
    if (overButton()){
     buttonColor = bHighlight;
     } else{
    buttonColor = oColor; }
  }

 }
Capture video;
PImage prevFrame;
float threshold = 50;
Button motion;

void setup() {
  size(600, 300);
  video = new Capture(this, 320, 240, 30);
  prevFrame = createImage(320,240,RGB);
  video.start();
  
  motion = new Button("motion detector",420,20,100,50,20,255,128);
}

void draw() {
  
  if (video.available()) {

    prevFrame.copy(video,0,0,320,240,0,0,320,240); 
    prevFrame.updatePixels();
    video.read();
  }
  image(video,0,0);
  loadPixels();
  video.loadPixels();
   prevFrame.loadPixels();
 
  
  motion.highLight();
  motion.makeButton();

   if (motion.bPress ==1){
   motionD(); 
   video.updatePixels();
   prevFrame.updatePixels();
   }
}
void mousePressed(){
  if (motion.overButton() && (motion.bPress == 1)){
    motion.bPress = 0;
  } else if (motion.overButton()){
    motion.bPress = 1;
  }
}

void motionD(){

  for (int x = 0; x < video.width; x ++ ) {
    for (int y = 0; y < video.height; y ++ ) {
      
      int loc = x + y*video.width;         
      color current = video.pixels[loc];     
      color previous = prevFrame.pixels[loc];
      
      float r1 = red(current); float g1 = green(current); float b1 = blue(current);
      float r2 = red(previous); float g2 = green(previous); float b2 = blue(previous);
      float diff = dist(r1,g1,b1,r2,g2,b2);
      
      if (diff > threshold) { 

        pixels[loc] = color(0);
      } else {

        pixels[loc] = color(255);
      }
    }
  }
 // video.updatePixels();
 // prevFrame.updatePixels();
}
