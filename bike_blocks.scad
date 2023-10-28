in=25.4;
$fn=200;
wood=in/2;
pad=0.1;
zero=0.0001;

use <joints.scad>;

width=100;
front_frame=100;
back_frame=80;

axle=12;
axle_wall=in;
axle_d=axle+axle_wall*2;

front_height=150+wood;
back_height=wood+axle_wall;

base_width=400;
back_width=200;

front_depth=front_height*1.5;
back_depth=front_height;

corner=axle_d/4;


bit=in/4;

pins=1;
pintail_gap=bit/8;
pintail_hole=bit*1.1;
pintail_ear=bit;


module wood(height=wood) {
	linear_extrude(height=height)
	children();
}

module base(depth,bwidth,frame) {
	difference() {
		offset(corner)
		offset(-corner)
		square([bwidth,depth]);
		translate([bwidth/2-frame/2,0])
		dirror_x(frame)
		dirror_x(wood)
		negative_tails(depth+pad*2,wood+pad,pins,pintail_gap,0,pintail_ear);
	}
}


module side(height, depth, center=false) {
	difference() {
		hull() {
			translate([0,height])
			circle(d=axle_d);
			translate([-depth/2,0])
			square([depth,wood]);
		}
		translate([0,height])
		circle(d=axle);
		translate([depth/2+pad,-pad])
		rotate([0,0,90])
		negative_pins(depth+pad*2,wood+pad,pins,pintail_gap,0,pintail_ear);
		if(center)
		translate([-wood/2,wood])
		dirror_x(wood)
		negative_tails(center_h+pad*2,wood+pad,pins,pintail_gap,0,pintail_ear);
	}
}

center_h=front_height-axle/2-wood;

module center(height,frame) {
	difference() {
		square([frame,center_h]);
		dirror_x(frame)
		translate([-pad,-pad])
		negative_pins(center_h+pad*2,wood+pad,pins,pintail_gap,0,pintail_ear);
	}
}

// RENDER svg
module back_center() {
	square([back_frame-wood*2,back_height-wood-axle/2]);
}

module dirror_x(x=0) {
	children();
	translate([x,0])
	mirror([1,0])
	children();

}


// RENDER svg
module front_side() {
	side(front_height,front_depth,true);
}

// RENDER svg
module front_base() {
	base(front_depth,base_width,front_frame);
}

// RENDER svg
module front_center() {
	center(front_height, front_frame);
}

module front() {
	dirror_x()
	translate([-front_frame/2,0])
	rotate([90,0,90])
	wood()
	front_side();

	translate([-base_width/2,-front_depth/2,0])
	color("lime")
	wood()
	front_base();

	rotate([90,0])
	translate([-front_frame/2,wood,-wood/2])
	color("magenta")
	wood()
	front_center();
}

// RENDER svg
module back_side() {
	side(back_height, back_depth);
}

// RENDER svg
module back_base() {
	base(back_depth,back_width,back_frame);
}

module back() {
	dirror_x()
	translate([-back_frame/2,0])
	rotate([90,0,90])
	wood()
	back_side();

	translate([-back_width/2,-back_depth/2,0])
	color("lime")
	wood()
	back_base();

	rotate([90,0])
	translate([-back_frame/2+wood,wood,-wood/2])
	color("magenta")
	wood()
	back_center();
}

back();

translate([0,front_depth*2,0])
front();
