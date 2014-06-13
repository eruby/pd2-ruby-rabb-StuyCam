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
Button pix;
Button flashLight;

//pixels[] pixArray;
int scale, rows, cols;

void setup(){
  size(600,340);
  
  
  scale = 8;
  cols = 320/scale;
  rows = 240/scale;
  video = new Capture(this,320,240,30);
  video.start();
  background(0);
  
  flashLight = new Button("Flashlight", 420, 90, 100, 50,20, 255, 128);
  pix = new Button("Pixelate", 420,20,100, 50, 20, 255, 128);
}

void draw(){
  if (video.available()) {
    video.read();
  }
  image(video,0,0);
  loadPixels();
  video.loadPixels();
  
  pix.highLight();
  pix.makeButton();
  flashLight.highLight();
  flashLight.makeButton();
 
 if (pix.bPress ==1){
   pixelate(); }
 if (flashLight.bPress == 1){
   flash(); }
   
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
void flash(){
  loadPixels();
  //assign variables to pixArray
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
