$w = $(".art.col-3").width();
size($w,$w);
noStroke();
float a=width/5, h=a*sqrt(3)/2, midy=a/sqrt(3);
int i=1, k=0;
for(float y=0; y<=height; y+=h){
    for(float x=0; x<=width; x+=a){
        if ((i%2==0) &&(k==0)){x-=a/2; k=1; }
            fill(0,210,80);
            triangle(x-a/2,y+h,x,y,x,y+midy);
            triangle(x,y,x+a/2,y+(h-midy),x+a/2,y+h);
            fill(150,250,200);
            triangle(x,y,x,y+midy,x+a/2,y+h);
            triangle(x+a/2,y+(h-midy),x+a/2,y+h,x+a,y);
            fill(80,250,150);
            triangle(x,y+midy,x+a/2,y+h,x-a/2,y+h);
            fill(100,250,200);
            triangle(x,y,x+a,y,x+a/2,y+(h-midy));
    }
    i++;    k=0;
}
