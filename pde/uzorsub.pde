float x,y,r;
void setup(){
    var w=$("#subname").width()/15;
    size(w,w/2);
    stroke(first);
    r=width/5;
    x=r/2; y=r;
    noLoop();
}
void draw(){
    background(back);
    noFill();
    stroke(first);
    translate(3*x,2*r-r/15);
    rotate(-PI/2);
    scale(0.5);
    uzor(x,0,r);
    noLoop();
}
void resizeUzor(){
    w=$("#names").width()/8;
    size(w,w/2);
    r=width/4;
    x=r/2; y=r;
}