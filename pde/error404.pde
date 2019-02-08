color back=color(60,10,85);
float rad, h, step, angle, fsize;
color[] colors = new color[4];

void setup(){
  var w = window.innerWidth/2;
  size(w,w/2);
  daisy_settings();
  background(back);  
  fsize=width/2;
  textSize(fsize);  
}

void draw(){
  fill(colors[0]);
   text("4",width/6,height/2);
   pushMatrix();
   translate(width/2,height/2);
   scale(1.4);
   daisy(rad,-2*rad+h);
   centre(rad,-2*rad+h);
   popMatrix();
   fill(colors[1]);
   text("4",5*width/6,height/2);   
} 

public void resizeComing(){
  var wi = window.innerWidth/2;
  size(wi,wi/2);
  fsize=width/2;
  daisyResize();  
}