in=25.4;
zero=0.01;
pad=0.1;
$fn=90;

couch_to_wall=430;
couch_depth=1000;

wall_depth=650;
couch_to_window=couch_to_wall+couch_depth-wall_depth;

ledge=200;
window_width=600;

wood=in/2;

// s=o/h c=a/h t=o/a
window_angle=atan((couch_depth-wall_depth)/(couch_to_window-couch_to_wall));

lip=wood*2;
skirt=in*3;

height=500;

leg_fillet=skirt;
leg=skirt;

front_extra=200;

module positive() {

	square([couch_depth,couch_to_wall]);
	hull() {
		square([zero,couch_to_window]);
		translate([couch_depth-zero-wall_depth,0])
		square([zero,couch_to_wall]);
	}

	translate([couch_depth-wall_depth,couch_to_wall])
	rotate([0,0,90+window_angle])
	square([window_width,ledge]);
}

module wood(h=wood) {
	linear_extrude(height=h)
	children();
}

module top() {
	difference() {
		positive();
		translate([-couch_depth,-window_width])
		square([couch_depth*2,window_width]);
	}
}

module double_leg(x=0) {
	leg(x);
	translate([x,0])
	mirror([1,0])
	leg(x);
}

module leg(x=0) {
	difference() {
		square([leg+leg_fillet,height]);
		translate([leg,-skirt-height])
		offset(leg_fillet)
		offset(-leg_fillet)
		square([leg+leg_fillet*2,height*2]);

	}
	translate([0,height-skirt])
	square([x,skirt]);
}

translate([0,0,height-wood])
wood()
top();

translate([lip,lip+wood])
rotate([90,0])
wood()
double_leg(couch_depth-lip*2);

translate([couch_depth-lip-leg,lip])
rotate([90,0,90])
wood()
double_leg(couch_to_wall-lip*2);

translate([couch_depth-lip,couch_to_wall-lip-wood-leg])
rotate([90,0,180])
wood()
leg(wall_depth);


translate([couch_depth-wall_depth,couch_to_wall,0])
rotate([0,0,window_angle]) {
	translate([lip-ledge,window_width-lip])
	rotate([90,0,-90])
	translate([0,0,-wood])
	wood()
	leg(window_width);
	
	translate([lip-ledge,window_width-lip])
	rotate([90,0,0])
	wood()
	leg(ledge-lip*2);
}

translate([lip,lip])
rotate([90,0,90])
wood()
leg(couch_to_wall-lip*2+front_extra);


module small_couch() {
	rotate([90,0])
	import("Couch.stl");
	translate([20,-21,25])
	rotate([90,0])
	import("Couch_cushion.stl");
}

module couch() {
	scale([13.3,10,10])
	color("gray")
	translate([75,0])
	rotate([0,0,-90])
	small_couch();
}

module wall() {
	wall=in;
	wall_h=12*in*8;

	translate([couch_depth-wall_depth,couch_to_wall]) {
		cube([wall_depth,wall,wall_h]);
		rotate([0,0,90+window_angle])
		translate([0,-wall])
		cube([window_width*1.5,wall,wall_h]);

	}
	translate([couch_depth+wall,couch_to_wall+wall,0])
	rotate([0,0,180])
	cube([wall,couch_to_wall*5,wall_h]);


}

color("white")
wall();

couch();
