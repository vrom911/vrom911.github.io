$w = $(".art.col-3").width();
size($w,$w);
background(250,60,160);
stroke(255);
strokeWeight(3);

 float xa=width/5;
 float ya=xa;
 float x=0, y=0;
for(y=0; y<=height; y+=xa){
    fill(255,140,240);
    for(x=-2*xa; x<=width; x+=2*xa){
        rotate(-PI/12);
        beginShape();
        vertex(x+xa,y+ya);
        vertex(x+xa*9/10-xa/100,y+ya*9/10);
        bezierVertex(x+xa*4/10,y+ya*7/10,x+xa*0.85,y,x+xa,y+ya*0.65);
        bezierVertex(x+xa*1.15,y,x+xa*1.60,y+ya*0.7,x+xa*1.1+xa/100,y+ya*0.9);
        vertex(x+xa*1.1+xa/100,y+ya*0.9);
        endShape(CLOSE);
        rotate(PI/12);
    }
    
    fill(120,190,255);
    for(x=-xa; x<=width; x+=2*xa){
        rotate(-PI/12);
        beginShape();
        vertex(x+xa,y+ya);
        vertex(x+xa*9/10-xa/100,y+ya*9/10);
        bezierVertex(x+xa*4/10,y+ya*7/10,x+xa*0.85,y,x+xa,y+ya*0.65);
        bezierVertex(x+xa*1.15,y,x+xa*1.60,y+ya*0.7,x+xa*1.1+xa/100,y+ya*0.9);
        vertex(x+xa*1.1+xa/100,y+ya*0.9);
        endShape(CLOSE);
        rotate(PI/12);
    }
   
}