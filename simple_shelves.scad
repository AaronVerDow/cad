

module spaced_holes(x,offset,diameter,count) {
	new_x=x/count*(count-1);
	wire_holes(new_x,offset,diameter,count);
}
module wire_holes(x,offset,diameter,count) {
	for(i=[0:x/(count-1):x])
	translate([i-x/2,offset])
	circle(d=diameter);
}

pad=0.1;

module shelf(x,y,corner) {
	difference() {
		translate([-x/2,-corner])
		offset(corner)
		offset(-corner)
		square([x,y+corner]);
		translate([-x/2-pad,-corner-pad])
		square([x+pad*2,corner+pad]);
		children();
	}
}
in=25.4;
ft=12*in;

shelf(7.5*ft,20*in,50)
spaced_holes(7.5*ft,50,50,4);
