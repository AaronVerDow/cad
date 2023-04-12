use <joints.scad>;
in=25.4;
zero=0.01;
pad=0.1;
$fn=90;

bit=in/4;

couch_to_wall=350; // estimation
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
top_top=wood;
top_base=wood;
top_wood=top_top+top_base;

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
bp_width=1800;
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

couch_gap=5; // to opposite wall
back_wall=2425;

couch=back_wall-couch_gap-couch_to_wall;

outlet_offset=outlet/2+40;
outlet_depth=7.9*in;

bracket_x=2*in;
bracket_y=1.5*in;
bracket_z=in/4;
bracket_h=6*in;
bracket_d=in/2;

module dirror_y(y=0) {
	children();
	translate([0,y])
	mirror([0,1])
	children();
}

module bp() {
	module positive() {
		difference() {
			square([bp_depth,bp_width]);
			dirror_y(bp_width)
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

//color("chocolate")
color("gray")
translate([couch_depth-bp_depth,-couch/2-bp_width/2,height])
wood()
bp();

pintail_gap=1;
pintail_ear=bit;

module mcm_leg(x=0) {
	pins=floor(x/100);
	difference() {
		hull() {
			translate([mcm_tip_offset,0])
			square([mcm_tip,zero]);
			translate([mcm_base_offset,height-zero])
			square([mcm_base,zero]);
		}
		translate([mcm_base_offset-mcm_base,height-top_wood])
		square([x+mcm_base,top_wood]);
	}
	difference() {
		translate([mcm_base_offset,height-skirt])
		difference() {
			square([x,skirt-top_top]);
			translate([0,skirt+pad-top_top])
			rotate([0,0,-90])
			negative_pins(x,wood+pad,pins,pintail_gap,0,pintail_ear);
		}
	}
}

module diag_leg(w=mcm_width,rot=0) {
	rotate([90,0,45+rot])
	translate([0,0,-w/2])
	linear_extrude(height=w)
	children();
}

front_spine=275;

module front_leg() {
	mcm_leg(front_spine);
}

module mcm() {
	// front
	diag_leg()
	front_leg();

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

		if(desk_outlet)
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

couch_leg=167;

module couch() {
	translate([0,0,couch_leg])
	scale([11.4,13.78,8.5])
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

plant=10*in;
plant_h=1*in;

module plant_wall(x=1,y=1) {
	color("green")
	translate([couch_depth-plant_h,-plant*x,0])
	cube([plant_h,plant*x,plant*y]);
}

shelf_thick=2.5*in;
shelf_depth=10*in;

wall_h=2645;
shelf_gap=(wall_h-height)/3;
bottom_shelf=height+shelf_gap;
top_shelf=height+shelf_gap*2;

shelf_width=back_wall-shelf_gap*1.5;

shelf_wire=in/2;

// https://www.amazon.com/dp/B07KC8P2KD/ref=emc_b_5_t?th=1I
led_width=17;
led_depth=8; // flush bubble

step=250;

shelves();

module shelves() {
	color("chocolate")
	translate([-shelf_depth+couch_depth,couch_to_wall+shelf_width/2-back_wall/2,bottom_shelf-shelf_thick/2])
	rotate([0,0,-90])
	shelf();

	color("chocolate")
	translate([-shelf_depth+couch_depth,couch_to_wall+shelf_width/2-back_wall/2,top_shelf-shelf_thick/2])
	rotate([0,0,-90])
	shelf();


	color("chocolate") {
		*for(z=[shelf_gap/2:shelf_gap:shelf_gap*2.0])
		for(y=[0:-back_wall+step:-back_wall+step-1])
		step(y,z);

		//step(0,shelf_gap*2.5);
		//step(0,shelf_gap/2);
		//step(step-back_wall,shelf_gap*1.5);
	}
}

first_stud=700;

studs=[first_stud,first_stud+16*in,first_stud+32*in];


for(y=studs)
bracket(-y,shelf_gap);

inner_wall=in+led_width;

access_holes=[600,1000];

access_hole_x=100;
access_hole_y=wood;
shelf_bracket_top=3*in;

stud_offset=shelf_width/2-back_wall/2;

module shelf_front() {
	square([shelf_width,shelf_thick]);
}

module shelf_back() {
	difference() {
		square([shelf_width,shelf_thick]);
		for(x=studs)
		translate([x+stud_offset-bracket_x/2-bit,shelf_thick/2-bit-bracket_y/2])
		square([bracket_x+bit*2,bracket_y+bit*2]);

		for(x=access_holes)
		translate([x-access_hole_x/2,shelf_thick/2-access_hole_y/2])
		square([access_hole_x,access_hole_y]);
	}
}

module shelf_side() {
	square([shelf_depth,shelf_thick]);
}

module shelf_inner() {
	difference() {
		square([shelf_width,shelf_depth]);
		difference() {
			translate([inner_wall,inner_wall])
			square([shelf_width-inner_wall*2,shelf_depth-inner_wall*2]);
			// cover for brackets
			#for(y=studs)
			translate([y+stud_offset-shelf_bracket_top/2,0])
			square([shelf_bracket_top,shelf_depth]);
		}
		for(y=studs)
		translate([y+stud_offset-bit-bracket_x/2,shelf_depth-bracket_z])
		square([bracket_x+bit*2,bracket_z]);

		dirror_y(shelf_depth+wood)
		dirror_x(shelf_width)
		translate([wood,wood+led_width/2])
		#circle(d=shelf_wire);
	}
}

module shelf_outer() {
	translate([wood,wood])
	square([shelf_width-wood*2,shelf_depth-wood*2]);
}

module shelf_tracks() {
	translate([0,wood,0])
	square([shelf_width,led_width]);

	translate([0,shelf_depth-led_width-wood,0])
	square([shelf_width,led_width]);
}

module shelf_bracket_guide() {
	square([bracket_h,bracket_d+wood*2]);
}

module dirror_x(x=0) {
	children();
	translate([x,0])
	mirror([1,0])
	children();
}

post_d=in/2;

module shelf() { 
	color("red")
	translate([0,wood])
	rotate([90,0])
	wood()
	shelf_front();

	color("red")
	translate([0,shelf_depth])
	rotate([90,0])
	wood()
	shelf_back();

	color("blue")
	dirror_x(shelf_width)
	rotate([90,0,90])
	wood()
	shelf_side();
	
	color("lime") {
		translate([0,0,shelf_thick/2-wood-post_d/2])
		wood()
		shelf_inner();

		translate([0,0,shelf_thick/2+post_d/2])
		wood()
		shelf_inner();
	}

	color("magenta") {
		difference() {
			wood()
			shelf_outer();
			translate([0,0,led_depth-wood])
			wood()
			shelf_tracks();
		}

		difference() {
			translate([0,0,shelf_thick-wood])
			wood()
			shelf_outer();
			translate([0,0,shelf_thick-led_depth])
			wood()
			shelf_tracks();
		}
	}

	for(x=studs)
	translate([x+stud_offset,shelf_depth,shelf_thick/2])
	rotate([0,0,90])
	raw_bracket();

	
	color("blue")
	for(x=studs)
	translate([x+stud_offset,0])
	dirror_x()
	translate([bracket_d/2,shelf_depth-bracket_z-bracket_h,shelf_thick/2-bracket_d/2-wood])
	rotate([90,0,90])
	wood()
	shelf_bracket_guide();
}

module bracket(x=0,y=0) {
	translate([couch_depth,x+couch_to_wall,height+y])
	raw_bracket();
}

module raw_bracket() {
	color("#333333") {
		translate([-bracket_z,-bracket_x/2,-bracket_y/2])
		cube([bracket_z,bracket_x,bracket_y]);

		rotate([0,-90])
		cylinder(d=bracket_d,h=bracket_h);
	}
}


module step(y,z) {
	translate([-shelf_depth+couch_depth,couch_to_wall-step+y,height-shelf_thick/2+z])
	cube([shelf_depth,step,shelf_thick]);
}

*translate([0,0,height])
plant_wall(6,2);


module wall() {
	wall=in;


	window_wall=1380;
	window_x=480;
	window_y=1310;
	window_x_off=465;
	window_y_off=780;

	translate([couch_depth-wall_depth,couch_to_wall]) {
		// side
		cube([wall_depth,wall,wall_h]);
		// window
		rotate([0,0,90+window_angle])
		translate([0,-wall])
		difference() {
			cube([window_wall,wall,wall_h]);
			translate([window_x_off,-wall/2,window_y_off])
			cube([window_x,wall*2,window_y]);
		}

	}
	
	// back
	translate([couch_depth+wall,couch_to_wall+wall,0])
	rotate([0,0,180])
	cube([wall,back_wall+wall*2,wall_h]);

	// other side
	translate([-couch_depth/2,couch_to_wall-back_wall-wall,0])
	cube([couch_depth*1.5,wall,wall_h]);
}

module preview() {
	color("white")
	wall();

	couch();

	assembled();

	cat();
}

desk_outlet=0;

module assembled() {
	color("blue")
	translate([0,0,height-top_wood])
	wood(top_base)
	top();

	color("lime")
	mcm();

	if(desk_outlet)
	translate([0,0,height-outlet_depth])
	place_outlet()
	color("#444444")
	cylinder(d=outlet,h=outlet_depth);
}

//assembled();

preview();
