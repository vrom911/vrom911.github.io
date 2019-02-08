var w = $("#link").width();
int flagin;
float sh, x1, x2, y1,y2, angle,x,y;
float stepx, stepy, max_distance;
String title;
void setup(){    
    size(w,w/4);
    nav_settings();
    max_distance=dist(0,sh,width,height-sh);
    stepx=stepy=sh/2;
    title=$("#nav1").text();
}

void draw(){
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
                        fill(third);
                        for(float i = 0; i <= width; i +=2* sh) {
                            for(float j = sh; j <= height-sh; j +=2* sh) {
                              float siz = dist(x, y, i, j);
                              siz = siz/max_distance * sh*2;
                              ellipse(i, j, siz, siz);
                            }
                        }
                        x+=stepx; y+=stepy;
                        if((x>width+sh*4)||(x<-2*sh)){stepx=-stepx;}
                        if((y>height+sh)||(y<-sh)){stepy=-stepy;}

                        white_title();
                    }
                }
            }
            break;
        case 2:
            case2();
    }
   
}
public void resizeNav(){
    var w = $("#link").width();
    size(w,w/4);
    nav_resize();
    max_distance=dist(0,sh,width,height-sh);
    stepx=stepy=sh/2;
}