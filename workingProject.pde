import processing.video.*;

 class Button {
   String label;
   int bX, bY, bH, bW, bR ;//where R is the radius of rounded edges
   color buttonColor;
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

 }
Capture video;
Button pix;
color poColor;

int scale, rows, cols;

void setup(){
  size(600,340);
  background(0);
  
  scale = 8;
  cols = 320/scale;
  rows = 240/scale;
  video = new Capture(this,320,240,30);
  video.start();
  
  pix = new Button("Pixelate", 420,20,100, 50, 20, 255, 128);
  poColor = pix.buttonColor;
}

void draw(){
  if (video.available()) {
    video.read();
  }
  image(video,0,0);
  video.loadPixels();
  
 if (pix.overButton()){
   pix.buttonColor = pix.bHighlight;
 } else{
  pix.buttonColor = poColor; }
  
  pix.makeButton();
 
 if (pix.bPress ==1){
   pixelate(); }
}
 
void mousePressed(){
  if (pix.overButton() && (pix.bPress == 1)){
    pix.bPress = 0;
  } else{
    pix.bPress = 1;
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
 