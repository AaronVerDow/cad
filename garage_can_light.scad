light=165;

box_x=240;
box_y=177;
light_x=90;


difference() {
	square([box_x,box_y]);
	circle(d=light);
}
