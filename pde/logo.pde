float rad,h,step, angle;
color[] colors = new color[4];

void setup(){
    var w = $("#logo-div").width();
    size(w,w);
    background(60,10,85);
    frameRate(30);
    rad=width/10;    h=-rad/32;    step=-rad/32;    angle=0;
    colors[0]=color(125,255,225);    colors[1]=color(255,160,190);    colors[2]=color(170,47,190);    
}
void draw(){
    background(60,10,85);
    pushMatrix();
        translate(width/2,height/2);
        rotate(angle);
        daisy(rad,-2*rad+h);
        rotate(-20*angle);
        centre(rad,-2*rad+2*h);
    popMatrix();
    if((h<=-rad) || (h>=rad/4))
        { step=-step; }
    h+=step;
    angle+=PI/100;
    if( angle==2*PI ) { angle=0; }
}

void centre(float r, float z){     
    noStroke();
    ellipse(0,0,-r-z,-r-z);
    float rz=r+z, k=4/3*(sqrt(2)-1);
    strokeWeight(3);
    for(int i=0;i<3;i++){
        stroke(colors[i%3]);
        fill(colors[i%3]);
        beginShape();
        vertex(0,0);
        bezierVertex(rz/2,rz*k/3,rz*k/2,rz/2,0,rz/2);
        endShape(CLOSE);
        arc(0,0,-rz,-rz,-PI/2, PI/6);
        rotate(2*PI/3);
    }
    fill(colors[0]);
    stroke(colors[0]);
    beginShape();
        vertex(0,0);
        bezierVertex(rz/2,rz*k/3,rz*k/2,rz/2,0,rz/2);
    endShape(CLOSE);
    noStroke();
}
void daisy( float r,float z){
  noStroke();
    float a=2*PI/9;
    for(int i=0; i<9; i++){
        fill(colors[i%3]);
        rotate(a);
        ellipse(0,z,r*4/3+z,r*8/3);   
    }
}
public void resizeLogo(){
    var w = $("#logo-div").width();
    size(w,w);
    rad=width/10;    h=-rad/32;    step=-rad/32;    angle=0;
}