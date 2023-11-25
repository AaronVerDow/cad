in=25.4;
pad=0.1;
zero=0.001;


//70.07 in
right_width=1780;

//90.55 in
left_width=2300;

wood=in/2;

cusion=50;
cusion_x=right_width;
cusion_y=22*in;
cusion_z=cusion;

bench_height=18*in-cusion;
bench_depth=22*in;

roborock=100;

lid_wood=18;

led_x=17;
led_y=7;

front_base=roborock;
front_top=lid_wood+wood+led_y;
front_inset=200;
//front_inset=10*in;
front_lip=led_x;

lip=cusion*1.5;
back_inset=45;
back_base=zero;
back_top=lip;

bo=back_inset;
ba=bench_height-back_top;
back_angle=atan(bo/ba);
bh=ba/cos(back_angle);

base_y=bench_depth-front_inset-back_inset;

lid=bench_depth-lip;

// s=o/h c=a/h t=o/a
fo=bench_height-lid_wood-front_base-wood-led_y;
fa=front_inset-led_x-front_lip;
front_angle=atan(fo/fa);

fh=fa/cos(front_angle);

led_holder=led_x+in;

module dirror_x(x=0) {
    children();
    translate([x,0,0])
    mirror([1,0,0])
    children();
}

module dirror_y(y=0) {
    children();
    translate([0,y,0])
    mirror([0,1,0])
    children();
}

module side() {
	difference() {
		side_positive();

		translate([-pad,bench_height-lid_wood])
		square([lid+pad,lid_wood+pad]);

		//square([front_lip,bench_height]);
	}

	*color("orange")
	translate([front_lip,bench_height-lid_wood-led_y-wood])
	square([led_x,led_y]);
}

//zero=10;

module led_holder(width) {
	square([width,led_holder]);
}


module side_positive() {
	hull() {
		translate([led_x+front_lip,bench_height-front_top])
		square([zero,front_top]);

		translate([bench_depth-zero,bench_height-back_top])
		square([zero,back_top]);

		translate([front_inset,front_base])
		square([zero,zero]);

		translate([bench_depth-back_inset-zero,back_base])
		square([zero,zero]);
	}
	translate([front_inset,0])
	square([bench_depth-front_inset-back_inset,bench_height-pad]);
}

module base(width) {
	square([width,base_y]);
}

module front_base(width) {
	square([width,front_base]);  // trig
}

module back_top(width) {
	square([width,back_top]);  // trig?
}

module lid(width) {
	square([width,lid]);
}

module lip(width) {
	square([width,lip]);
}

module wood(height=wood) {
	linear_extrude(height=height)
	children();
}

ribs=4;


module front_face(width) {
	square([width,fh]);
}

module back_face(width) {
	square([width,bh]);
}

module assembled(width=right_width) {
	color("blue")
	for(x=[wood/2:(width-wood)/(ribs-1):width-wood/2])
	translate([x-wood/2,0])
	rotate([90,0,90])
	wood()
	side();

	color("red")
	translate([0,front_inset])
	wood()
	base(width);

	color("lime")
	translate([0,front_inset+wood])
	rotate([90,0])
	wood()
	front_base(width);

	color("magenta")
	translate([0,0,bench_height-lid_wood])
	wood(lid_wood)
	lid(width);

	color("lime")
	translate([0,bench_depth,bench_height-back_top])
	rotate([90,0])
	wood()
	back_top(width);

	color("red")
	translate([0,bench_depth-lip,bench_height-wood])
	wood()
	lip(width);

	translate([0,front_lip,bench_height-wood-lid_wood])
	wood()
	led_holder(width);

	color("cyan")
	translate([0,front_inset,front_base])
	rotate([-front_angle,0])
	translate([0,-fh])
	wood()
	front_face(width);

	translate([0,bench_depth-back_inset])
	rotate([90-back_angle])
	wood()
	back_face(width);

	#translate([cusion_r,cusion_r,cusion_r+bench_height])
	minkowski() {
		cube([cusion_x-cusion_r*2,cusion_y-cusion_r*2,cusion_z-cusion_r*2]);
		sphere(r=cusion_r);
	}

}

cusion_r=10;

assembled();
