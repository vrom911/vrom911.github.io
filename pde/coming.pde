color back=color(255,160,190), first=color(125,255,225), second=color(60,10,85), third=color(170,47,190);
float rad, h, step, angle, fsize;
color[] colors = new color[4];

void setup(){
  var w = $("#coming").outerWidth()*3/4;
  size(w,w/2);
  background(255);
  daisy_settings();
  background(second);
  fsize=width/4;
  textSize(fsize);
}

void draw(){
  fill(back);
   text("C",width/12,height/4);
   text("MING",8*width/12,height/4);
   text("S",3*width/12,3*height/4);
   text("N",9*width/12,3*height/4);
  pushMatrix();
   translate(3*width/12,height/4);
   scale(0.6);
   daisy(rad,-2*rad+h);
   centre(rad,-2*rad+h);
  popMatrix();
  pushMatrix();
   translate(5*width/12,3*height/4);
   scale(0.6);
   daisy(rad,-2*rad+h);
   centre(rad,-2*rad+h);
  popMatrix();
  pushMatrix();
   translate(7*width/12,3*height/4);
   scale(0.6);
   daisy(rad,-2*rad+h);
   centre(rad,-2*rad+h);
  popMatrix();
}
public void resizeComing(){
  var wi = $("#coming").outerWidth()*3/4;
  size(wi,wi/2);
  fsize=width/4;
  daisyResize();
}