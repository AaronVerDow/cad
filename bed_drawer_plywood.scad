pad=0.1;
in=25.4;
zero=0.01;

bed_x=1530;
bed_y=2030;
bed_z=12*in;
bed_r=5*in;

mattress_z=6*in;
mattress_r=2*in;

overhang=10*in;
back_overhang=bed_r;

leg_x=4*in;

spine=3*in;
spines=6;

bed_wood=18;
wood=in/2;

edge=2*in;
inner=spine*2;
tip=overhang/2;
total_leg_x=bed_x-overhang*2;

module corner(r) {
	offset(r*2)
	offset(-r*2)
	children();
}

module wood(w=wood) {
	linear_extrude(height=w)
	children();
}

module dirror_y(y=0) {
	children();
	translate([0,y])
	mirror([0,1])
	children();

}

module dirror_x(x=0) {
	children();
	translate([x,0])
	mirror([1,0])
	children();

}

module bed() {
	translate([-bed_x/2,0])
	corner(mattress_r)
	square([bed_x,bed_y]);
}

module assembled() {
	color("blue")
	translate([0,0,bed_z-bed_wood])
	wood(bed_wood)
	bed();

	color("cyan")
	dirror_x()
	translate([bed_x/2-overhang-leg_x,back_overhang,bed_z])
	dirror_x(leg_x)
	rotate([0,90])
	wood()
	leg_side();

	for(y=[back_overhang:spine_gap:bed_y-overhang])
	translate([0,y,bed_z])
	rotate([-90,0])
	wood()
	spine();

	dirror_x()
	translate([bed_x/2,back_overhang,bed_z])
	rotate([-90,0,90])
	wood()
	side_edge();

	dirror_y(bed_y)
	translate([0,0,bed_z])
	rotate([-90,0])
	wood()
	end_edge();
}

module end_edge() {
	hull() {
		translate([-total_leg_x/2,0])
		square([total_leg_x,edge]);
		translate([-tip-total_leg_x/2,0])
		square([total_leg_x+tip*2,bed_wood]);
	}
}

module side_edge() {
	hull() {
		square([leg_y,edge]);
		square([leg_y+tip,bed_wood]);
	}
}

module spine() {
	translate([overhang-bed_x/2,0])
	square([bed_x-overhang*2,spine]);

	dirror_x()
	translate([bed_x/2-overhang-leg_x,0])
	square([leg_x,leg_z]);

	dirror_x()
	translate([bed_x/2-overhang-leg_x,0])
	hull() {
		square([leg_x,inner]);
		square([leg_x+overhang,edge]);
	}
}

leg_y=bed_y-overhang-back_overhang;
leg_z=bed_z;

spine_gap=(leg_y-wood)/(spines-1);

module leg_side() {
	square([leg_z,leg_y]);

	hull() {
		translate([0,-back_overhang])
		square([edge,bed_y]);
		square([inner,leg_y]);
	}
}

assembled();

