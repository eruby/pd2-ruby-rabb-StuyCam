import processing.video.*;

// Step 2. Declare a Capture object
Capture video;
String pix;
int pixX, pixY, pixW, pixH;
color pixColor;
color pixHighlight;
boolean pixOver = false;
int ppress = 0;

int scale;
int rows, cols;

void setup() {
  size(600,300);
  background(0);
  
  scale = 8;
  cols = 320/scale;
  rows = 240/scale;
  video = new Capture(this,320,240,30);
  video.start();
    
  colorMode(RGB);
  pix = "Pixelate";
  pixColor = color(255);
  pixHighlight = color(128);
  pixX = 420;
  pixY = 120;
  pixW = 50;
  pixH = 25;
  
}


void draw() {
  update(mouseX, mouseY);
  
  if (video.available()) {
    video.read();
  }
  image(video,0,0);
  video.loadPixels();
 
 if (pixOver){
  fill(pixHighlight);
   }
  else{ 
   fill(pixColor); 
  }
  stroke(0,0,255);
  fill(pixColor);
  rect(pixX, pixY, pixW, pixH, 10);
  fill(0,0,255);
  textAlign(CENTER);
  text(pix,pixX, pixY, 50, 25);
  
  if (ppress==1){
   pixelate(); 
  }
}
    
void mousePressed(){
  if (pixOver & (ppress == 1)){
   ppress = 0; 
  }
  else if (pixOver){
     ppress = ppress +1; 
  }
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

void update(int x, int y){
 if (overPix(pixX, pixY, pixW, pixH)){
   pixOver = true;
 }
 else {
  pixOver = false; 
 }
}

boolean overPix(int x, int y, int w, int h){
  if (mouseX >= x && mouseX <= x+w &&
      mouseY >= y && mouseY <= y+h){
       return true; 
      }
   return false;
}