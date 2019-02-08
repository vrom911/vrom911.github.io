size(400,400);
int side=width/20;
int row=height/20;
int cur_side=0;
int cur_row=0;
stroke();
for(cur_row=0;cur_row<=height;cur_row+=row){
	for(cur_side=0;cur_side<=width;cur_side+=side){
		fill(102,106,134);//dark
		triangle(cur_side,cur_row,cur_side,cur_row+row,cur_side+side,cur_row);
		fill(186,169,165); //
		triangle(cur_side+side,cur_row+row,cur_side,cur_row+row,cur_side+side,cur_row);
		cur_side = cur_side+side;
		fill(249,222,201);//weak pink
		triangle(cur_side,cur_row,cur_side,cur_row+row,cur_side+side,cur_row+row);
		fill(225,226,234);//weak blue
		triangle(cur_side,cur_row,cur_side+side,cur_row,cur_side+side,cur_row+row);
		cur_side = cur_side+side;
		fill(102,106,204);//blue
		triangle(cur_side,cur_row,cur_side,cur_row+row,cur_side+side,cur_row);
		fill(187,94,0);
		triangle(cur_side+side,cur_row+row,cur_side,cur_row+row,cur_side+side,cur_row);
		cur_side = cur_side+side;
		fill(236,153,91); //orange
		//fill(120,138,163);
		triangle(cur_side,cur_row,cur_side,cur_row+row,cur_side+side,cur_row+row);
		fill(255,197,138);
		triangle(cur_side,cur_row,cur_side+side,cur_row,cur_side+side,cur_row+row);
		cur_side = cur_side+side;
		fill(192,192,192);
		triangle(cur_side,cur_row,cur_side,cur_row+row,cur_side+side,cur_row);
		fill(103,103,180)
		triangle(cur_side+side,cur_row+row,cur_side,cur_row+row,cur_side+side,cur_row);
		cur_side = cur_side+side;
		fill(255,159,255);
		triangle(cur_side,cur_row,cur_side,cur_row+row,cur_side+side,cur_row+row);
		fill(163,163,163);
		triangle(cur_side,cur_row,cur_side+side,cur_row,cur_side+side,cur_row+row);


	}
}


