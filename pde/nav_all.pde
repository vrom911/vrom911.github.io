/* @pjs font="../fonts/poiret/poiret-one-v7-latin-regular.ttf"; */
color back=color(60,10,85), first=color(125,255,225), second=color(255,160,190), third=color(170,47,190);

void nav_settings(){
    background(back);
    noStroke();
    sh=height/10;    flagin=0;
    x1=angle=x=y=0;
    x2=width;
    y1=y2=height/2;
  PFont font;
  fsize=width/9;
    font = createFont("../fonts/poiret/poiret-one-v7-latin-regular.ttf");
    textFont(font,fsize);
    textSize(fsize);
    textAlign(CENTER,CENTER);
}

void nav_resize(){
  sh=height/10;   flagin=0;
    x1=angle=x=y=0;   x2=width;
    y1=y2=height/2;
}
void rotateStick(float ang,color colour){
    pushMatrix();
    translate(width/2,height/2);
    rotate(ang);
    fill(colour);
    rect(0,-height/2-abs(ang)*(200/PI),sh,height+abs(ang)*(400/PI));
    popMatrix();
}
void mouseOver(){
    flagin=1;
    angle=0;
    y1=y2=height/2;
    x=y=0;
}
void mouseOut(){
    flagin=2;
}
void case0(){
  // without any event, just title
  background(back);
    fill(first);
    rect(x1,0,sh,height);
    fill(second);
    rect(x2-sh,0,sh,height);
    fill(first);
    text(title.toUpperCase(),width/2,height/2);
}
void case2(){
  background(back);
            if(abs(y1-y2)>sh){
                fill(first);
                rect(0,y1,width,sh);
                fill(second);
                rect(0,y2-sh,width,sh);
                y2+=sh;
                y1-=sh;
            }
            else{
                if(angle>0){
                    rotateStick(-angle,first);
                    rotateStick(angle,second);
                    angle-=PI/20;}
                else{
                    if(x2-x1<width){
                        background(back);
                        fill(first);
                        rect(x1,0,sh,height);
                        fill(second);
                        rect(x2-sh,0,sh,height);
                        x1-=3*sh; x2+=3*sh;}
                    else{  flagin=0;   x1=0; x2=width; }
                    }
            }
}
void white_title(){
  fill(first);
    rect(0,height-sh,width,sh);
    fill(second);
    rect(0,0,width,sh);
    fill(255);
    text(title.toUpperCase(),width/2,height/2);
}
//case1 stuff
  //horizontal move of blocks to each other
void horizont_move(){
    fill(first);
    rect(x1,0,sh,height);
    fill(second);
    rect(x2-sh,0,sh,height);
    x1+=3*sh; x2-=3*sh;
}
// rotate sticks
void sticks_rotate(){
  rotateStick(angle,first);
    rotateStick(-angle,second);
    angle+=PI/20;
}
//vertical move of blocks
void vertical_move(){
  fill(first);
    rect(0,y1,width,sh);
    fill(second);
    rect(0,y2-sh,width,sh);
    y2-=sh;   y1+=sh;
}
