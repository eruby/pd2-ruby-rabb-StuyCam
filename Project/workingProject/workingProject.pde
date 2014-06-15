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

Button pix;
Button flashLight;
Button motion;
Button doodler;
Button Gray;
Button Bug;

int scale, rows, cols;
int pointillize = 8;
int pcols,prows;
float threshold = 50;
float x,y;

void setup(){
  size(320,470);
  smooth();
  
  x = 320/2;
  y = 240/2;
  scale = 8;
  pcols = 320/pointillize;
  prows = 240/pointillize;
  cols = 320/scale;
  rows = 240/scale;
  video = new Capture(this,320,240,30);
  prevFrame = createImage(video.width,video.height,RGB);
  video.start();
  background(0);
  
  Gray = new Button("GrayScale", 210, 400, 100,50,20,255,128);
  Bug = new Button("Bugs Eye View", 210,330 ,100,50,20,255,128); 
  doodler = new Button("Doodle Machine",210,260,100,50,20,255,128);
  motion = new Button("Motion Detector",10,400,100,50,20,255,128);
  flashLight = new Button("Flashlight",10, 330, 100, 50,20, 255, 128);
  pix = new Button("Pixelate", 10,260,100, 50, 20, 255, 128);
}

void draw(){
  if (video.available()) {
    prevFrame.copy(video,0,0,video.width,video.height,0,0,video.width,video.height);
    prevFrame.updatePixels();
    video.read();
  }
  image(video,0,0);
  loadPixels();
  video.loadPixels();
  prevFrame.loadPixels();
  
  pix.highLight();
  pix.makeButton();
  flashLight.highLight();
  flashLight.makeButton();
  motion.highLight();
  motion.makeButton();
  doodler.highLight();
  doodler.makeButton();
  Bug.highLight();
  Bug.makeButton();
  Gray.highLight();
  Gray.makeButton();
 
 
 if (pix.bPress ==1){
   pixelate(); }
 if (flashLight.bPress == 1){
   flash(); }
 if (motion.bPress ==1){
   motionD(); 
   }
 if (doodler.bPress ==1){
   doodle(); 
   }
 if (Gray.bPress ==1){
   grayer(); 
   }
 if (Bug.bPress ==1){
   point(); 
   }
}
 
void mousePressed(){
  if (pix.overButton() && (pix.bPress == 1)){
    pix.bPress = 0;
  } else if (pix.overButton()){
    pix.bPress = 1;
  } else if (flashLight.overButton() && (flashLight.bPress == 1)){
   flashLight.bPress = 0; 
  } else if (flashLight.overButton()){
   flashLight.bPress = 1; 
  } else if (motion.overButton() && (motion.bPress == 1)){
   motion.bPress = 0; 
  } else if (motion.overButton()){
   motion.bPress = 1; 
  } else if (doodler.overButton() && (doodler.bPress == 1)){
   doodler.bPress = 0; 
  } else if (doodler.overButton()){
   doodler.bPress = 1; 
 }  else if (Bug.overButton() && (Bug.bPress == 1)){
   Bug.bPress = 0; 
  } else if (Bug.overButton()){
   Bug.bPress = 1; 
  } else if (Gray.overButton() && (Gray.bPress == 1)){
   Gray.bPress = 0; 
  } else if (Gray.overButton()){
   Gray.bPress = 1; }
}

void pixelate(){
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
void flash(){
  for (int x = 0; x < video.width; x++) {
    for (int y = 0; y < video.height; y++) {
      int loc = x + y*video.width;
      float r,g,b;
      
      r = red (video.pixels[loc]);
      g = green (video.pixels[loc]);
      b = blue (video.pixels[loc]);
      
      float maxdist = 100;
      float d = dist(x,y,mouseX,mouseY);
      float adjustbrightness = (maxdist-d)/maxdist;
      
      r *= adjustbrightness;
      g *= adjustbrightness;
      b *= adjustbrightness;
      
      r = constrain(r,0,255);
      g = constrain(g,0,255);
      b = constrain(b,0,255);

      color c = color(r,g,b);
      pixels[loc] = c;
    }
  }
  updatePixels();
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
  updatePixels();
}

void doodle(){
  float newx = constrain(x + random(-20,20),0,320-1);
  float newy = constrain(y + random(-20,20),0,240-1);
  
  int midx = int((newx + x) / 2);
  int midy = int((newy + y) / 2);
  
  color c = video.pixels[(320-1-midx) + midy*320];

  stroke(c);
  strokeWeight(2);
  line(x,y,newx,newy);

  x = newx;
  y = newy;
  
}

void point(){
   for(int c = 0; c < pcols; c++){
    for(int d = 0; d < prows; d++){
      
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

void grayer(){
  filter(GRAY);
}
