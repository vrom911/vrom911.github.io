int flagin;
var wid = $("#link3").width();
float sh, x1, x2, y1,y2, angle,x,y;
int xsp = 8;   // How far apart should each horizontal location be spaced
int w;              // Width of entire wave
float theta;       // Start angle at 0
float amplitude;  // Height of wave
float period;    // How many pixels before the wave repeats
float dx;                 // Value for incrementing X, to be calculated as a function of period and xspacing
float[] yvalues;          // Using an array to store height values for the wave (not entirely necessary)

String title;
void setup(){
    size(wid,wid/4);
    nav_settings();
    amplitude = height;
    theta = 0.0;
    period = width/8;

    xsp = width/30;
    w = width+xsp;
    dx = (TWO_PI / period) * xsp;
    yvalues = new float[w/xsp];

    title=$("#nav3").text();
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
                        calcWave(amplitude);
                        renderWave();
                        calcWave(amplitude*3/2);
                        renderWave();
                        calcWave(amplitude*2);
                        renderWave();

                        white_title();
                    }
                }
            }
            break;
        case 2:
            case2();
    }
}
void calcWave(float amp) {
  // Increment theta (try different values for 'angular velocity' here
  theta += 0.02;

  // For every x value, calculate a y value with sine function
  float x = theta;
  for (int i = 0; i < yvalues.length; i++) {
    yvalues[i] = sin(x)*amp;
    x+=dx;
  }
}
void renderWave() {
    fill(third);
  // A simple way to draw the wave with an triangle at each location
  for (int x = 0; x < yvalues.length; x++) {
    noStroke();

    //ellipseMode(CENTER);
    triangle(x*xsp,width/2+yvalues[x],x*xsp+2*xsp,width/2+yvalues[x],x*xsp,width/2+yvalues[x]-2*xsp);
  }
}
public void resizeNav(){
    var wi = $("#link3").width();
    size(wi,wi/4);
    nav_resize();
    amplitude = height;
    theta = 0.0;
    period = width/8;
    xsp = width/30;
    w = width+5*xsp;
    dx = (TWO_PI / period) * xsp;
    yvalues = new float[width/xsp];

}