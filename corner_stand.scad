in=25.4;
zero=0.01;
pad=0.1;
$fn=90;

bit=in/4;

couch_to_wall=295; // measured
couch_depth=980; // measured, leaves small gap with 5" backplate

// s=o/h c=a/h t=o/a

//    o
//    _
// h  \| a
//     d

window_angle=45;

window_lip=34;
window_lip_hyp=window_lip/sin(window_angle);
wall_depth=400+window_lip_hyp; // measured

// https://www.amazon.com/Countertop-Embedded-Wireless-Diameter-Integrated/dp/B0B775R4Y8/ref=psdc_6396125011_t3_B08CZHW18R?th=1
outlet=3.15*in;

couch_to_window=couch_to_wall+couch_depth-wall_depth;

ledge=couch_to_wall;
// window_width=1175; // measured to end of lip
window_width=1080; // measured to middle of trim

// https://www.ikea.com/us/en/p/morabo-sofa-grann-bomstad-black-metal-s09316670/

wood=in/2;
top_wood=wood*2;

// s=o/h c=a/h t=o/a
//window_angle=atan((couch_depth-wall_depth)/(couch_to_window-couch_to_wall));

lip=wood*2;
skirt=in*3;

height=635; // measured

leg_fillet=skirt;
leg=skirt;

front_extra=200;

window_gap=in*2;


bp_depth=5*in;
bp_width=2130;
vent_wall=in;
vent_hole=bit*1.5;
vent_slat=vent_wall;
bp_outlet_offset=outlet*2;

function diagonal(x) = sqrt(x*x*2);

// mid century modern
mcm_width=wood*3;
mcm_tip=mcm_width;
mcm_base=skirt*1.5;
mcm_tip_offset=diagonal(skirt/2);
mcm_base_offset=diagonal(skirt*1.5);

back_mcm_diag=diagonal(couch_to_wall)/2-mcm_base_offset;

spine=couch_depth-couch_to_wall;

module bp() {
	module positive() {
		difference() {
			square([bp_depth,bp_width]);
			translate([bp_depth/2,bp_outlet_offset])
			circle(d=outlet);
		}
	}
	
	slat=diagonal(bp_depth+vent_hole);
	difference() {
		positive();

		offset(bit/2)
		offset(-bit/2)
		intersection() {
			offset(-vent_wall)
			positive();
			for(y=[0:diagonal(vent_hole+vent_slat):bp_width+slat])
			translate([0,y-slat])
			rotate([0,0,45])
			square([slat,vent_hole]);
		}
	}
}

color("chocolate")
translate([couch_depth-bp_depth,-bp_width,height+20])
wood()
bp();

!wood()
bp();

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
	// front
	diag_leg()
	mcm_leg(275);

	*translate([couch_depth,0])
	diag_leg(rot=90)
	mcm_leg(back_mcm_diag);

	*translate([couch_depth,couch_to_wall])
	diag_leg(rot=180)
	mcm_leg(back_mcm_diag);

	// don't need this with single back leg
	*translate([couch_to_wall/2,couch_to_wall/2,height-skirt])
	rotate([90,0])
	translate([0,0,-mcm_width/2])
	wood(mcm_width)
	spine();

	// back leg
	//translate([-couch_to_wall/2,couch_depth])
	translate([couch_depth,couch_to_wall/2])
	diag_leg(rot=45+90)
	mcm_leg(600);


	// window leg
	translate([couch_depth-wall_depth,couch_to_wall,0])
	rotate([0,0,window_angle])
	translate([-ledge/2,window_width+30])
	diag_leg(rot=-90-45)
	mcm_leg(window_width-100);
}

module spine() {
	square([spine,skirt]);
}
module wood(h=wood) {
	linear_extrude(height=h)
	children();
}

outlet_offset=outlet/2+40;
outlet_depth=7.9*in;

module place_outlet() {
	translate([couch_depth-outlet_offset,couch_to_wall/2])
	children();
}

module top() {

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


	difference() {
		positive();
		translate([-couch_depth,-window_width])
		square([couch_depth*2,window_width]);

		place_outlet()
		circle(d=outlet);
	}
}

module double_leg(x=0) {
	leg(x);
	translate([x,0])
	mirror([1,0])
	leg(x);
}

module leg(x=0) {
	plywood_leg(x);
	post_leg(x);
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


module square_legs() {
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
}


module small_couch() {
	rotate([90,0])
	import("Couch.stl");
	translate([20,-21,25])
	rotate([90,0])
	import("Couch_cushion.stl");
}

module couch() {
	scale([11.4,14,11.4])
	color("gray")
	translate([75,0])
	rotate([0,0,-90])
	small_couch();
}

module cat() {
	// https://www.thingiverse.com/thing:151074/files
	color("tan")
	translate([couch_depth-wall_depth,couch_to_wall,0])
	rotate([0,0,window_angle])
	translate([-ledge/2,window_width/4*3])
	translate([0,0,height])
	rotate([0,0,90]) {
		scale(2)
		translate([0,0,82])
		import("LaserCat-LowPoly.stl");
		//cylinder(d=200,h=330);
	}
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

module preview() {
	color("white")
	wall();

	couch();

	assembled();

	cat();

}

module assembled() {
	color("chocolate")
	translate([0,0,height-top_wood])
	wood(top_wood)
	top();

	color("chocolate")
	mcm();

	translate([0,0,height-outlet_depth])
	place_outlet()
	color("#444444")
	cylinder(d=outlet,h=outlet_depth);
}

//assembled();

preview();
