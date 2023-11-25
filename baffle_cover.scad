pad=0.1;
in=25.4;
foam=in/4;

// RENDER svg
module library() {
	ac_y=313;

	baffle(
		out_x=888,
		out_y=ac_y+65,
		ac_x=417,
		ac_y=ac_y
	);
}

// RENDER svg
module guest() {
	ac_y=288;
	baffle(
		out_x=885,
		out_y=ac_y+65,
		ac_x=407,
		ac_y=ac_y
	);
}


module baffle(out_x, out_y, ac_x, ac_y) {
	fout_x=out_x-foam*2;
	fac_x=ac_x+foam*2;
	fac_y=ac_y+foam;
	difference() {
		square([fout_x,out_y]);
		translate([fout_x/2-fac_x/2,-pad])
		square([fac_x,fac_y+pad]);
	}
}

library();

translate([0,400])
guest();
