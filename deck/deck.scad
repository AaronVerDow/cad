pad=1;
in=25.4;
ft=12*in;
zero=0.01;

two=2*in;
ground=10;

addition_width=13*ft;
addition_height=20*ft;
addition_depth=10*ft; 

kitchen=5*ft;

house_width=kitchen+addition_width;
house_height=addition_height;
house_depth=10*ft;

grass_width=10*ft;
grass_depth=14*ft;

fence_gap=26*ft;
fence_height=4*ft;
fence_width=1*in;

gate_width=4*ft;
gate_depth=fence_width;
gate_height=7*ft;

flower_depth=6*ft;

driveway_width=fence_gap-grass_width;

left_fence=-gate_width-kitchen;

right_fence=fence_gap+left_fence;

right_gap=right_fence-addition_width;

fence_length=addition_depth+flower_depth+grass_depth;

gate_color=("brown");
fence_color=("silver");
driveway_color="#BBBBBB";

door_width=32*in;
door_height=72*in;
door_depth=addition_width/2;

door_offset=1*ft;

deck_depth=8*ft;
deck_width=10*ft;

landing_height=4*ft;
landing_width=kitchen;
landing_offset=5*ft;

basement_depth=4*ft;
basement_width=8*ft;
basement_height=6*ft;

step_width=landing_width;
step_depth=12*in;
steps=6;

step_gap=(landing_height)/(steps-1);

deck_height=step_gap*2;

dstep_depth=12*in;
dsteps=3;
dstep_gap=(deck_height)/(dsteps-1);
deck_corner=2*ft;

corner_angle=45/2;

landing_depth=landing_offset+deck_depth-step_depth*(steps-3);

window_width=9*ft;
window_height=4*ft;
window_depth=addition_depth;
window_sill=landing_height+4*ft;

wall=8*in;

module deck_profile(extra=0) {

	//
	// a |\ h
	//   --   
	//   o

	d_a=extra;
	d_o=tan(corner_angle)*d_a;

	translate([0,-deck_depth])
	hull() {
		translate([0,-extra])
		square([deck_width-deck_corner+d_o,deck_depth+extra]);
		translate([0,deck_corner-d_o,0])
		square([deck_width+extra,deck_depth-deck_corner+d_o]);
	}
}

color(deck_color)
translate([0,0,deck_height-two])
linear_extrude(height=two)
difference() {
	deck_profile(); 
	landing(step_depth*(steps-4));
}

color(deck_color)
translate([0,0,dstep_gap-two])
linear_extrude(height=two)
difference() {
	deck_profile(dstep_depth); 
	deck_profile(); 
}

module house() {
	difference() {
		cube([addition_width,addition_depth,addition_height]);
		translate([-pad,door_offset,landing_height])
		cube([door_depth,door_width,door_height]);
		basement();

		translate([addition_width/2-window_width/2,-pad,window_sill])
		cube([window_width,window_depth,window_height]);
		translate([wall,wall,landing_height])
		cube([addition_width-wall*2,addition_depth,addition_height-landing_height-wall]);
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

for(n=[0:1:steps-2])
color(deck_color)
translate([-step_width/2-landing_width/2,landing_offset-landing_depth-n*step_depth,landing_height-two-step_gap*n])
cube([step_width,step_depth,two]);

house();

color("green")
translate([right_fence-grass_width,-grass_depth-flower_depth,-zero])
cube([grass_width,grass_depth,zero]);

color("#333333")
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

landing_step(1);
landing_step(2);


translate([addition_width*0.3,wall,window_sill])
scale(2)
translate([0,0,82])
import("LaserCat-LowPoly.stl");
//cylinder(d=200,h=330);
