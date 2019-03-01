var w = $("#link2").width();
int flagin;
float sh, x1, x2, y1,y2, angle,x,y;
float startAng, ang, step;
int rad;
String title;
void setup(){
    size(w,w/4);
    nav_settings();
    rad = 18;
    startAng = 270;
    angle = startAng;
    step = 0;
    title=$("#nav2").text();
}

void draw(){
    noStroke();
    switch(flagin){
        case 0:
            case0();
            break;
        case 1:
            background(back);
            if(x2-x1>sh){ horizont_move();}
            else{
                if(angle<PI/2){sticks_rotate();}
                else{
                    if((y2-sh>0)&&(y1+sh<height))  {vertical_move();}
                    else{

                        stroke(third);
                        strokeWeight(2);
                        noFill();
                        pushMatrix();
                        translate(width/2, height/2+10);
                        startAng=startAng%360.0;
                        ang = startAng;

                        for(int r=width/2+50; r >= rad; r*=0.5) {
                            star(r, ang);
                            ang += step;
                          }
                          startAng+=0.5;
                          float stepSize = map(0, 0, width, -1, 1);
                          step+=stepSize;
                        popMatrix();
                        noStroke();
                        white_title();
                    }
                }
            }
            break;
        case 2:
            case2();
    }

}
void star(float r,float a){
    beginShape();
      for(int i = 0; i < 10; i++) {
        float xPos = r*cos(radians(a));
        float yPos = r*sin(radians(a));
        vertex(xPos, yPos);
        a+=145;
      }
    endShape(CLOSE);
}
public void resizeNav(){
    var w = $("#link2").width();
    size(w,w/4);
    nav_resize();
    rad = 18;    step = 0;
    angle=startAng = 270;
}