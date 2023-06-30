in=25.4;
two=38;
four=90;

bar=1.5*in;

wood=18;

box_x=1450;
box_y=1220;
box_z=2210;

wall=bar*3;

base=four;
base_angle=10;

ratio=0.8;
arch=box_x/2*ratio;

trig=340;

side_bars=4;
bar_start=800;
bar_end=box_z-arch;

bar_gap=(bar_end-bar_start)/(side_bars-1);

arc_bars=[0,10,30];

spine=wood;

// h
// /| o
// -
// a
// c=a/h;
// a/h=c;
// 1/h=c/a;
// h=a/c;


step_x=(box_x/2-wood/2)/cos(base_angle);


module dirror_x(x) {
	children();
	translate([x,0])
	mirror([1,0])
	children();
}

module bar() {
	circle(d=bar);
}

module step() {
	square([shelf_x,box_y]);
}

module place_bars() {
	dirror_x(box_x)
	for(z=[0:1:side_bars-1])
	translate([wall/2,bar_start+bar_gap*z])
	children();

	translate([box_x/2,box_z-wall/2])
	children();
}

module positive() {
	square([box_x,box_z-arch]);

	translate([box_x/2,box_z-arch])
	scale([1,ratio])
	circle(d=box_x);
}

module front() {
	difference() {
		positive();

		place_bars()
		bar();

		difference() {
			translate([wall,base])
			square([box_x-wall*2,box_z-base-arch]);

			translate([box_x/2,base])
			dirror_x()
			rotate([0,0,base_angle])
			translate([wood/2,-trig])
			square([box_x,trig]);
		}

		offset(-wall)
		translate([box_x/2,box_z-arch])
		scale([1,ratio])
		circle(d=box_x);

	}
}

module back() {
	front();
}

module wood() {
	linear_extrude(height=wood)
	children();
}

translate([0,box_y])
rotate([90,0])
wood()
back();

translate([0,wood])
rotate([90,0])
wood()
front();
