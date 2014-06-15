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
   text(label, bX, bY+15,bW, bH);
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
 
 //code adapted from processing.org for class Scrollbar
 class Scrollbar {
  int bwidth, bheight;    // width and height of bar
  float xpos, ypos;       // x and y position of bar
  float spos, newspos;    // x position of slider
  float sposMin, sposMax; // max and min values of slider
  int loose;              // how loose/heavy
  boolean over;           // is the mouse over the slider?
  boolean locked;
  float ratio;

  Scrollbar (float xp, float yp, int bw, int bh, int l) {
    bwidth = bw;
    bheight = bh;
    int widthtoheight = bw - bh;
    ratio = (float)bw / (float)widthtoheight;
    xpos = xp;
    ypos = yp-bheight/2;
    spos = xpos + bwidth/2 - bheight/2;
    newspos = spos;
    sposMin = xpos;
    sposMax = xpos + bwidth - bheight;
    loose = l;
  }
   void update() {
    if (overEvent()) 
      over = true;
    else 
      over = false;
    if (mousePressed && over) 
      locked = true;
    if (!mousePressed) 
      locked = false;
    if (locked) 
      newspos = constrain(mouseX-bheight/2, sposMin, sposMax);
    if (abs(newspos - spos) > 1) 
      spos = spos + (newspos-spos)/loose;
  }

  float constrain(float val, float minv, float maxv) {return min(max(val, minv), maxv);}

  boolean overEvent() {
    if (mouseX > xpos && mouseX < xpos+bwidth &&
       mouseY > ypos && mouseY < ypos+bheight) 
      return true;
    return false;
  }

  void display() {
    stroke(0,0,225);
    fill(255,51,51);
    rect(xpos, ypos, bwidth, bheight);
    if (over || locked) {
      fill(0, 0, 255);
    } else {
      fill(0,0,51);
    }
    rect(spos, ypos, bheight, bheight);
  }
  float getPos() {return spos * ratio;}
}
 
Capture video;
PImage prevFrame;

Button bwhite;
Button neg;
Button post;
Button pix;
Button flashLight;
Button motion;
Button doodler;
Button Gray;
Button Bug;

Scrollbar pixScroll;
Scrollbar pointScroll;

int scale, rows, cols;
int pointillize = 8;
int pcols,prows;
float threshold = 50;
float x,y;

void setup(){
  size(320,500);
  smooth();
  
  x = 320/2;
  y = 240/2;
  scale = 8;
  video = new Capture(this,320,240,30);
  prevFrame = createImage(video.width,video.height,RGB);
  video.start();
  background(0);
    
  pointScroll =new Scrollbar(220,400,90,10,16);
  pixScroll = new Scrollbar(10,320,90,10,16);
  
  post = new Button("Posterize", 115,260,90,50,20,255,128);
  neg = new Button("Negative",115,340,90,50,20,255,128 );
  bwhite = new Button("Etch-A-Sketch",115,420,90,50,20,255,128);
  
  Gray = new Button("GrayScale", 220, 420, 90,50,20,255,128);
  Bug = new Button("Bugs Eye View", 220,340 ,90,50,20,255,128); 
  doodler = new Button("Doodle Machine",220,260,90,50,20,255,128);
 
  motion = new Button("Motion Detector",10,420,90,50,20,255,128);
  flashLight = new Button("Flashlight",10, 340, 90, 50,20, 255, 128);
  pix = new Button("Pixelate", 10,260,90, 50, 20, 255, 128);
}

void draw(){
  noStroke();
  if (video.available()) {
    prevFrame.copy(video,0,0,video.width,video.height,0,0,video.width,video.height);
    prevFrame.updatePixels();
    video.read();
  }
  image(video,0,0);
  loadPixels();
  video.loadPixels();
  prevFrame.loadPixels();
  
  pointScroll.update();
  pointScroll.display();
  changePoint();
  pixScroll.update();
  pixScroll.display();
  changeScale();
  
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
  neg.highLight();
  neg.makeButton();
  post.highLight();
  post.makeButton();
  bwhite.highLight();
  bwhite.makeButton();
 
 if (pix.bPress ==1){
   pixelate(); 
 } if (flashLight.bPress == 1){
   flash(); 
 } if (motion.bPress ==1){
   motionD(); 
 } if (doodler.bPress ==1){
   doodle(); 
 } if (Gray.bPress ==1){
   grayer(); 
 } if (Bug.bPress ==1){
   point(); 
 } if (post.bPress == 1){
   poster();
 }if (neg.bPress == 1){
   negative();
 }if (bwhite.bPress == 1){
   etcher();
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
   Gray.bPress = 1; 
 }  else if (neg.overButton() && (neg.bPress == 1)){
   neg.bPress = 0; 
  } else if (neg.overButton()){
   neg.bPress = 1; 
  }  else if (bwhite.overButton() && (bwhite.bPress == 1)){
   bwhite.bPress = 0; 
  } else if (bwhite.overButton()){
   bwhite.bPress = 1; 
  }  else if (post.overButton() && (post.bPress == 1)){
   post.bPress = 0; 
  } else if (post.overButton()){
   post.bPress = 1; 
  }
}

void changeScale(){
  scale = (int)((pixScroll.spos + 50.00)/10);
  cols = 320/scale;
  rows = 240/scale;
}
void changePoint(){
  pointillize = (int)((pointScroll.spos-210 +50)/10.00);
  pcols = 320/pointillize;
  prows = 240/pointillize;
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
void negative(){
  video.filter(INVERT);
}
void etcher(){
  video.filter(THRESHOLD);
}
void poster(){
 video.filter(POSTERIZE, 4); 
}
void grayer(){
  video.filter(GRAY);
}
