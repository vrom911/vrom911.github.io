int flagin;
float sh, x1, x2, y1,y2, angle,x,y;
String title;
void setup(){
    size($("#link4").width(),$("#link4").width()/4);
    nav_settings();
    title=$("#nav4").text();
}
void draw(){
    switch(flagin){
        case 0:
            case0();
            break;
        case 1:
            background(back);
            if(x2-x1>sh)  { horizont_move();}
            else{
                if(angle<PI/2)  { sticks_rotate();}
                else{
                    if((y2-sh>0)&&(y1+sh<height))  { vertical_move();}
                    else{
                        for(float i=0;i<=width;i+=width/20){
                            int r = int(random(3,12));
                            fill(170,47,190,r*10);
                            rect(i,0,width/30,height);
                        }
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
    var w = $("#link4").width();
    size(w,w/4);
    nav_resize();
}