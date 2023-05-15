in=25.4;
pad=0.1;
zero=0.001;


//70.07 in
right_width=1780;

//90.55 in
left_width=2300;

wood=in/2;

cusion=50;

bench_height=18*in-cusion;
bench_depth=22*in;

roborock=100;

lid_wood=18;

front_base=roborock;
front_top=wood;
front_inset=200;
//front_inset=10*in;
front_lip=lid_wood;

lip=cusion*1.5;
back_inset=45;
back_base=zero;
back_top=lip;

base_y=bench_depth-front_inset-back_inset;

lid=bench_depth-lip;

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

		square([front_lip,bench_height]);
	}
}

module side_positive() {
	hull() {
		translate([0,bench_height-front_top])
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
	square([width,front_base+wood]);  // trig
}

module back_top(width) {
	square([width,back_top+wood]);  // trig?
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

module assembled(width=right_width) {
	color("blue")
	dirror_x(width)
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
	translate([0,bench_depth,bench_height-back_top-wood])
	rotate([90,0])
	wood()
	back_top(width);

	color("red")
	translate([0,bench_depth-lip,bench_height-wood])
	wood()
	lip(width);


}

assembled();
