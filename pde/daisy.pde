/* @pjs font="../fonts/PoiretOneNormal/PoiretOneNormal.ttf"; */
void daisy_settings(){
    colors[0]=color(125,255,225);  colors[1]=color(255,160,190);  colors[2]=color(170,47,190);
  rad=width/12;   h=-rad/8;    step=-rad/32;    angle=0;
    PFont font;
    fsize=width/4;
    font = createFont("../fonts/PoiretOneNormal/PoiretOneNormal.ttf",fsize);
    textFont(font,fsize);
    textAlign(CENTER,CENTER);
  smooth();  noLoop(); noStroke();
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
        ellipse(0,z/2,r*4/3+z,r*8/3+z/2);
    }
}

void daisyResize(){
    rad=width/12;  h=-rad/8;  step=-rad/32;  angle=0;
    textSize(fsize);
}
