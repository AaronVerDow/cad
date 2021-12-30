function segment_radius(height, chord) = (height/2)+(chord*chord)/(8*height);

arc_height=40;
arc_chord=100;

depth=40;

arc_radius=segment_radius(arc_height, arc_chord);
arc_od=arc_radius*2;

opp=arc_chord/2;
adj=arc_radius-arc_height;
arc_angle=atan(opp/adj)*2;
wall=3;

zero=0.01;

//cylinder(d=arc_od, h=depth);

lip_x=5;
lip_y=lip_x/2;

cutout=arc_height/3*2;

screw=4.5;

screw_y=cutout+(arc_height-cutout)/2;

big_fn=200;
med_fn=50;
mink_fn=12;
pad=0.1;

module dirror_x() {
	children();
	mirror([1,0])
	children();
}

module profile(thick=wall) {
	hull() {
		dirror_x()
		translate([depth/2-lip_x,0])
		circle(d=thick);
	}
	dirror_x()
	hull() {
		translate([depth/2-lip_x,0])
		circle(d=thick);
		translate([depth/2,lip_y])
		circle(d=thick);
	}
}


module arc_body(thick=wall) {
	translate([arc_chord/2,0,depth/2])
	rotate([0,0,-180+(180-arc_angle)/2])
	translate([arc_radius,0])
	rotate_extrude(angle=arc_angle, $fn=big_fn)
	rotate([0,0,90])
	translate([0,arc_od/2])
	profile(thick);

	intersection() {
		back(thick);
		back_space(thick);
	}
} 

module back_space(thick) {
	translate([0,arc_height-arc_od/2,-thick/2-pad])
	rotate([0,0,(180-arc_angle)/2])
	rotate_extrude(angle=arc_angle, $fn=big_fn)
	square([arc_od/2+lip_y, thick+pad*2]);
}

module back(thick) {
	translate([0,0,-thick/2])
	difference() {
		translate([0,arc_height-arc_od/2])
		cylinder(d=arc_od+lip_y*2,h=thick, $fn=big_fn);

		cutout_od=segment_radius(cutout,arc_chord+lip_y*2)*2;
		translate([0,cutout-cutout_od/2,-pad])
		cylinder(d=cutout_od,h=thick+pad*2, $fn=big_fn);
	}
}


module simple(thick=wall) {
	difference() {
		arc_body(thick);
		translate([0,screw_y,-thick/2-pad])
		cylinder(d=screw,h=thick+pad*2, $fn=med_fn);
	}
}

// RENDER stl
module assembled(thick=wall) {
	difference() {
		minkowski() {
			arc_body(zero);
			sphere(d=thick-zero*2, $fn=mink_fn);
		}
		translate([0,screw_y,-thick/2-pad])
		cylinder(d=screw,h=thick+pad*2, $fn=med_fn);
	}
}

simple();
