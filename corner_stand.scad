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
top_wood=18;

// s=o/h c=a/h t=o/a
window_angle=atan((couch_depth-wall_depth)/(couch_to_window-couch_to_wall));

lip=wood*2;
skirt=in*3;

height=500;

leg_fillet=skirt;
leg=skirt;

front_extra=200;

window_gap=in*2;

function diagonal(x) = sqrt(x*x*2);

// mid century modern
mcm_width=wood*3;
mcm_tip=mcm_width;
mcm_base=mcm_tip*3;
mcm_tip_offset=diagonal(lip);
mcm_base_offset=diagonal(skirt);

back_mcm_diag=diagonal(couch_to_wall)/2-mcm_base_offset;

spine=couch_depth-couch_to_wall;

module mcm_leg(x=0) {
	hull() {
		translate([mcm_tip_offset,0])
		square([mcm_tip,zero]);
		translate([mcm_base_offset,height-zero])
		square([mcm_base,zero]);
	}
	translate([mcm_base_offset,height-skirt])
	square([x,skirt]);

}

module diag_leg(w=mcm_width,rot=0) {
	rotate([90,0,45+rot])
	translate([0,0,-w/2])
	linear_extrude(height=w)
	children();
}

module mcm() {
	diag_leg()
	mcm_leg(350);

	translate([couch_depth,0])
	diag_leg(rot=90)
	mcm_leg(back_mcm_diag);

	translate([couch_depth,couch_to_wall])
	diag_leg(rot=180)
	mcm_leg(back_mcm_diag);

	translate([couch_to_wall/2,couch_to_wall/2,height-skirt])
	rotate([90,0])
	translate([0,0,-mcm_width/2])
	wood(mcm_width)
	spine();

	translate([couch_depth-wall_depth,couch_to_wall,0])
	rotate([0,0,window_angle])
	translate([-ledge/2,window_width+30])
	diag_leg(rot=-90-45)
	mcm_leg(730);
}

module spine() {
	square([spine,skirt]);
}

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
	//plywood_leg(x);
	//post_leg(x);
}

module post_leg(x=0) {
	translate([0,height-skirt])
	square([x,skirt]);
}
module plywood_leg(x=0) {
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

// couch side
translate([lip,lip+wood])
rotate([90,0])
wood()
double_leg(couch_depth-lip*2);

// back
translate([couch_depth-lip,lip])
rotate([90,0,90])
wood()
double_leg(couch_to_wall-lip*2);

// wall side
translate([couch_depth-lip,couch_to_wall-lip-wood])
rotate([90,0,180])
wood()
leg(wall_depth);

// window legs
translate([couch_depth-wall_depth,couch_to_wall,0])
rotate([0,0,window_angle]) {
	// window front
	translate([lip-ledge,window_width-lip])
	rotate([90,0,-90])
	translate([0,0,-wood])
	wood()
	leg(window_width);
	
	// window side
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


module assembled() {
	color("white")
	wall();

	couch();

	color("chocolate")
	translate([0,0,height-top_wood])
	wood(top_wood)
	top();

	color("chocolate")
	mcm();
}

assembled();
