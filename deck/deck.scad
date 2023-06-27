pad=1;
in=25.4;
ft=12*in;
zero=0.01;

two=2*in;
ground=10;

landing_height=1270;

addition_width=4200+1700;
addition_height=1270+2500;
addition_depth=2190;

kitchen=1270;

house_width=kitchen+addition_width;
house_height=addition_height;
house_depth=10*ft;

grass_width=3900;
grass_depth=5700;

fence_gap=8900;
fence_height=1130;
fence_width=1*in;

gate_width=1170;
gate_depth=fence_width;
gate_height=7*ft;

flower_depth=1700;
flower_gap=900;  // not used yet

driveway_width=fence_gap-grass_width;

left_fence=-gate_width-kitchen;

right_fence=fence_gap+left_fence;

right_gap=right_fence-addition_width;

fence_length=addition_depth+flower_depth+grass_depth;

gate_color=("brown");
fence_color=("silver");
driveway_color="#BBBBBB";

door_width=770;
door_height=2160;
door_depth=addition_width/2;

door_offset=230;

step_depth=280;
deck_depth=2300+step_depth;
deck_width=4170;

landing_width=1260;
landing_offset=1180;

basement_depth=4*ft;
basement_width=8*ft;
basement_height=6*ft;

step_width=landing_width;
steps=8;

step_gap=(landing_height)/(steps-1);

deck_level=3;

deck_height=step_gap*deck_level;

dstep_depth=step_depth;
dsteps=3;
dstep_gap=(deck_height)/(dsteps-1);
deck_corner=2*ft;

corner_angle=45/2;

//landing_depth=landing_offset+deck_depth-step_depth*(steps-3);
//landing_depth=landing_offset+1460;
landing_depth=landing_offset+step_depth*2;

wall=8*in;

window_width=2380; // inner edge of outside trim
window_height=1135;
window_depth=addition_depth-wall*4;
window_sill=1040+1270; // existing_deck to sill + existing deck
window_offset=1800;

ac_side=750;
ac_height=650;

ac_x_offset=950;
ac_y_offset=320;

color("#333333")
translate([addition_width-ac_side-ac_x_offset,-ac_y_offset-ac_side])
cube([ac_side,ac_side,ac_height]);

module deck_profile(extra=0) {

	//
	// a |\ h
	//   --   
	//   o

	d_a=extra;
	d_o=tan(corner_angle)*d_a;

	translate([-landing_width,-deck_depth])
	hull() {
		translate([0,-extra])
		square([deck_width+landing_width-deck_corner+d_o,deck_depth+extra]);
		translate([0,deck_corner-d_o,0])
		square([deck_width+landing_width+extra,deck_depth-deck_corner+d_o]);
	}
}

color(deck_color)
translate([0,0,deck_height-two])
linear_extrude(height=two)
difference() {
	deck_profile(); 
	landing(step_depth*(steps-deck_level-2));
}

color(deck_color)
for(n=[0:1:deck_level-1])
translate([0,0,deck_height-step_gap*n-two])
linear_extrude(height=two)
difference() {
	deck_profile(dstep_depth*n); 
	deck_profile(dstep_depth*(n-1)); 
	mirror([0,1])
	square([addition_width,ac_side+ac_y_offset+step_depth/2]);
}

module house() {
	difference() {
		cube([addition_width,addition_depth,addition_height]);
		translate([-pad,door_offset,landing_height])
		cube([door_depth,door_width,door_height]);
		basement();

		translate([window_offset,-pad,window_sill])
		cube([window_width,window_depth,window_height]);
		translate([wall,wall,landing_height])
		cube([addition_width-wall*2,addition_depth-wall*2,addition_height-landing_height-wall]);
	}
	translate([addition_width-house_width,addition_depth])
	cube([house_width,house_depth,house_height]);
}

module basement() {
	translate([-kitchen,addition_depth-basement_depth+pad,landing_height-basement_height-wall])
	cube([basement_width,basement_depth,basement_height]);
}

module fence() {
	color(fence_color)
	translate([left_fence,-grass_depth-flower_depth,0])
	cube([fence_width,fence_length,fence_height]);

	color(fence_color)
	translate([right_fence,-flower_depth-grass_depth,0])
	cube([fence_width,fence_length,fence_height]);

	color(gate_color)
	translate([left_fence,addition_depth])
	cube([gate_width,gate_depth,gate_height]);

	color(gate_color)
	translate([right_fence-right_gap,addition_depth])
	cube([right_gap,gate_depth,gate_height]);
}

*for(n=[0:1:steps-2])
color(deck_color)
translate([-step_width/2-landing_width/2,landing_offset-landing_depth-n*step_depth,landing_height-two-step_gap*n])
cube([step_width,step_depth,two]);

house();

color("green")
translate([right_fence-grass_width,-grass_depth-flower_depth,-zero])
cube([grass_width,grass_depth,zero]);

color("tan")
translate([right_fence-grass_width,-flower_depth])
cube([grass_width,flower_depth+addition_depth,zero]);

difference() {
	color(driveway_color)
	translate([left_fence,addition_depth-fence_length-ground])
	cube([driveway_width,fence_length,ground]);
	basement();
}

fence();

deck_color="brown";

module landing(extra=0) {
	d_a=extra;
	d_o=tan(corner_angle)*d_a;
	translate([-landing_width,landing_offset-landing_depth]) {
		square([landing_width,landing_depth]);
		hull() {
			translate([0,-extra])
			square([landing_width+d_o,landing_depth-landing_offset+extra]);
			translate([0,-d_o])
			square([landing_width+extra,landing_depth-landing_offset+d_o]);
		}
	}
}

color(deck_color)
translate([0,0,landing_height-two])
linear_extrude(height=two)
landing();

module landing_step(n) {
	color(deck_color)
	translate([0,0,landing_height-two-step_gap*n])
	linear_extrude(height=two)
	difference() {
		landing(step_depth*n);
		landing(step_depth*(n-1));
	}
}


for(n=[1:1:(steps-deck_level-1)])
landing_step(n);


translate([addition_width*0.37,wall,window_sill])
scale(2)
translate([0,0,82])
import("LaserCat-LowPoly.stl");
//cylinder(d=200,h=330);
