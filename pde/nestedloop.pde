$w = $(".art.col-3").width();
    size($w,$w);

background(250,200,210);
float a=width/6, h=a*sqrt(3)/2, midy=a/sqrt(3);
int i=1;
for(float y=0; y<=height; y+=h){
    for(float x=0; x-a/2<=width; x+=a){
        fill(160+i*x,i*x/4,70+i*x/4);
        if (i%2==0){
            triangle(x-a/2,y+h,x,y,x,y+midy);
            triangle(x,y,x,y+midy,x+a/2,y+h);
            triangle(x,y+midy,x+a/2,y+h,x-a/2,y+h);
        }
        else{
            triangle(x,y,x+a,y,x+a/2,y+(h-midy));
            triangle(x,y,x+a/2,y+(h-midy),x+a/2,y+h);
            triangle(x+a/2,y+(h-midy),x+a/2,y+h,x+a,y);
        }
    }
    i++;
}
