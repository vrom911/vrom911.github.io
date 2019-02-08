size(200,200);
biggest = width/4;
for(int row=0;row<=height; row+=biggest){
    for(int i=0; biggest*i/2<=height; i++){
        for(int rad=biggest; rad>=5; rad-=5){
            fill(i*rad,rad,rad)
            ellipse(width-biggest*i/2,height-(row+biggest*i/2),rad,rad)
            ellipse(biggest*i/2,row+biggest*i/2,rad,rad)
        }
        
    }
}