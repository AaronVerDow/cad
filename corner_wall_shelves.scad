in=25.4;

pad=0.1;

wood=in/2;

module wood(height=wood) {
	linear_extrude(height=height)
	children();
}

module shelf(x,y,x_thick,y_thick,corner) {
	intersection() {
		translate([-corner,-corner])
		offset(corner)
		offset(-corner) {
			square([x+corner,x_thick+corner]);
			square([y_thick+corner,y+corner]);
		}
		square([x+pad,y+pad]);
	}
}

thick=5*in;
wood()
shelf(18*in,20*in,thick,thick,2*in);


