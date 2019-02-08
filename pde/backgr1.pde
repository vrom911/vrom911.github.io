float x,y,r;
color back=color(60,10,85);
void setup(){
    size($("#background").width(),$("#background").height());
    
    noFill();
    stroke(back);
    r=30;
    x=r/2; y=r;
}
void draw(){
    background(255);
    translate(x,y);
    rotate(-PI/2);
    uzor(-x,0,r);
    exit();
}

void uzor(x,y,r){

    strokeWeight(3);
    arc(x,y,r,r,PI/2,TWO_PI-PI/2);
    strokeWeight(2);
    arc(x,y+r,3*r,3*r,-PI/2,PI/2);
    strokeWeight(1.5);
    arc(x+2*r,y+2*r,2*r,3*r,PI/3,PI);
    leaf(x+2*r+r/2,y+2*r+3*r/2-r/5,PI/4);
    arc(x,y+2*r,r,r,PI/2,3*PI/2);
    arc(x,y+2*r-r/4,r/2,r/2,-PI/2,PI/2);
    strokeWeight(0.7);
    arc(x+3*r/2,y+2*r,r,r,0,PI);
    arc(x+3*r/2,y+2*r,r,2*r,PI/3,PI);
    arc(x+3*r/2+r/4,y+2*r,r/2,r/2,PI-PI/6,TWO_PI);
    line(x+r,y+2*r,x+r/2,y+3*r);
    strokeWeight(1);
    pushMatrix();
    translate(x+r/2,y+3*r);
    rotate(-PI/3)
    arc(0,r/4,r/2,r/2,PI/2,3*PI/2);
    arc(0,r/4+r/8,r/4,r/4,3*PI/2,TWO_PI+PI/2);
    arc(0,r/4+r/8-r/16,r/8,r/8,PI/2,3*PI/2);
    popMatrix();
    leaf(x+r,y+2*r,-TWO_PI/6);
    leaf(x+3*r/2,y+3*r,PI/3);
    leaf(x,y-r/2,PI/3)
}
void leaf(x,y,a){
    pushMatrix();
    translate(x,y);
    rotate(a);
    beginShape();
    noFill();
    vertex(0,0);
    arc(-r/sqrt(2)/2,-r/sqrt(2)/2,r,r,-radians(45),radians(45));
    arc(r/sqrt(2)/2,-r/sqrt(2)/2,r,r,PI-radians(45),PI+radians(45));
    fill(14);
    noFill();
    endShape(CLOSE);
    popMatrix();
}