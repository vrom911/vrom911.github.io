color back=color(60,10,85), first=color(125,255,225), second=color(255,160,190), third=color(170,47,190);
void setup(){
  size($("main.grid").width(),$(window).height());
  noStroke();
  background(255);
  noStroke();
  smooth();
  noLoop();
  
}

void draw(){
  translate(3*width/5,height/2);
  rotate(PI/15);
  fill(back);
  ellipse(0,0,2*width/10,4*height/5);
  arc(0,0,width-2*width/6,4*height/5,-PI/2,PI/2);
  arc(0,0,3*width/2 - 2*width/6,4*height/5,PI/2,3*PI/2);
  
} 