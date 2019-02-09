float x,y,r;
void setup(){
    w=$("#names").width()/10;
    size(w,w/2);
    stroke(second);
    r=width/4;
    x=r/2; y=r;
    noLoop();
}
void draw(){
    noFill();
    stroke(second);
    background(back);
    translate(3*x,2*r-r/15);
    rotate(-PI/2);
    scale(0.6);
    uzor(x,0,r);
    noLoop();
}
void resizeUzor(){
    w=$("#names").width()/8;
    size(w,w/2);
    r=width/4;
    x=r/2; y=r;
}