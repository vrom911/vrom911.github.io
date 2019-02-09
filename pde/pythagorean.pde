$w = $(".art.col-3").width();
    size($w,$w);

background(2255);
float coord1=27/5, coord2=sqrt(81-pow(coord1,2));
scale(2);
noStroke();
for(int j=0; j<height; j+=15){
    for(int i=0; i<width; i+=15){
        fill(77,104,97)
        triangle(i,j,i+15,j,i+coord1,j+coord2);
        fill(155,199,186)
        triangle(i,j,i,j+15,i+coord1,j+coord2);
        fill(224,201,169)
        triangle(i+15,j,i+15,j+15,i+15-coord2,j+15-coord1);
        fill(161,135,112)
        triangle(i,j+15,i+15,j+15,i+15-coord2,j+15-coord1);
    }
}