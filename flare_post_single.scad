pole=10;

pole_h=50;


flare_x=25;
flare_y=20;
flare_z=35;

// used for preview only
flare_corner=4;
flare_lamp=flare_x/3*2;
flare_lamp_depth=flare_y/2;
$fn=90;
pad=0.1;

flare_gap=10;

depth=80;
tip_wall=1;

overhang=1;


module flare(c="red") {
	rotate([-90,0])
	translate([-flare_x/2,-flare_y,-flare_z/2])
	difference() {
		color("gray")
		translate([flare_corner/2,flare_corner/2,flare_corner/2])
		minkowski() {
			sphere(d=flare_corner);
			cube([flare_x-flare_corner,flare_y-flare_corner,flare_z-flare_corner]);
		}
		color(c)
		translate([flare_x/2,flare_lamp_depth-pad,flare_z/2])
		rotate([90,0])
		cylinder(d1=3,d2=flare_lamp,h=flare_lamp_depth);
	}
}

*color("orange")
translate([0,0,-depth])
cylinder(d=pole,h=pole_h+depth);

flare();
cap_corner=3;
cap_base=1;
cap_sphere=flare_x;
cap_sphere_offset=6;
cap_fn=13;


module cap() {
	difference() {
		translate([0,0,cap_sphere_offset])
		sphere(d=flare_x,$fn=cap_fn);
		translate([0,0,-flare_x/2])
		cube([flare_x,flare_z,flare_x],center=true);
	}

	linear_extrude(height=cap_base)
	offset(cap_corner)
	offset(-cap_corner)
	square([flare_x,flare_z],center=true);
}


translate([0,0,flare_y])
cap();

base_y=flare_z;
base_x=flare_x;
base_z=0.1;
backing_y=flare_gap;
backing_x=flare_x;
backing_z=flare_z;

screw=4.5;
screw_head=screw;
screw_head_hollow=50;
screw_head_d2=screw_head+screw_head_hollow*2;

screw_length=15;

module positive() {
	hull() {
		translate([0,0,-depth])
		cylinder(d=pole+tip_wall*2,h=depth);
		translate([0,0,-base_z/2])
		linear_extrude(height=base_z)
		offset(base_corner)
		offset(-base_corner)
		square([base_x,base_y],center=true);

	}

}

backing_gap=0.1;
base_gap=0.3;
base_corner=2;
backing_corner=2;

module negative_pole() {
	translate([0,0,-depth-pad])
	cylinder(d=pole,h=depth+pad*2);
}

module bolt(y=0,z=0) {
	dirror_y()
	translate([0,y,z])
	rotate([0,90,0]) {
		cylinder(d=screw,h=base_x+pad*2,center=true);
		mirror([0,0,1])
		translate([0,0,screw_length/2])
		cylinder(d1=screw_head,d2=screw_head_d2,h=screw_head_hollow);
	}
}

module dirror_y() {
	children();
	mirror([0,1])
	children();
}

module side() {

	difference() {
		positive();

		translate([-base_gap/2,-base_y/2-pad,-depth-pad])
		cube([base_x,base_y+pad*2,depth+pad*2]);


		hull() {
			negative_pole();
			translate([base_x,0])
			negative_pole();
		}

		min=0.1;
		max=0.6;
		mid=(max-min)/2+min;

		step=3;
		start=pole/2+screw/2;


		bolt(start+step*2,-depth*min);
		bolt(start+step,-depth*mid);
		bolt(start,-depth*max);
	}
}

side();
rotate([0,0,180])
side();
