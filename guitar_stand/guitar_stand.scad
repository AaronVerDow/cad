base_x=500;
base_y=300;

top_x=base_x;
top_y=base_y/3*2;

height=1230;

z=800;
in=25.4;
wood=in/2;

zero=0.01;

neck=66;
neck_y=top_y-60;

shelf_z=900;

shelf_y=top_y+24; // do trig later

stand=(height-shelf_z)/2;

extra=30;

module models() {
	// https://www.thingiverse.com/thing:2118092/files
	translate([0,0,1200])
	rotate([180,-90])
	translate([-900,-63,-177])
	import("guitar.stl");

	// https://www.printables.com/model/177529-guitar-amp-phone-stand
	scale([4,2.5,4])
	import("Amp Stand.v2.stl");
}

module base() {
	translate([-base_x/2,-base_y])
	square([base_x,base_y]);
}

module wood(thickness=wood) {
	linear_extrude(height=thickness)
	children();
}

module stand() {
	square([stand,shelf_y]);
}

module neck(extra=0, extra2=0) {
	hull() {
		translate([0,-neck_y])
		circle(d=neck+extra);
		translate([0,-top_x-neck])
		circle(d=neck+extra2);
	}
}

module top() {
	difference() {
		translate([-top_x/2,-top_y])
		square([top_x,top_y]);
		neck();
	}
}

module shelf() {
	difference() {
		translate([-base_x/2,-shelf_y])
		square([base_x,shelf_y]);
		//neck(30,380);
		neck(30,30);
	}
}

module side() {
	hull() {
		translate([0,height-wood])
		square([top_y,wood]);
		square([base_y,wood]);
	}
}

module dirror() {
	children();
	mirror([1,0])
	children();
}

module back() {
	hull() {
		translate([-top_x/2,height-wood])
		square([top_x,wood]);
		translate([-base_x/2,0])
		square([base_x,wood]);
	}
}

dirror()
translate([-neck/2-extra/2,-shelf_y,shelf_z])
rotate([0,-90,0])
wood()
stand();

translate([0,0,shelf_z])
wood()
shelf();

rotate([90,0])
wood()
back();

color("cyan")
dirror()
translate([base_x/2,0])
rotate([90,0,-90])
wood()
side();

translate([0,0,height-wood])
wood()
top();

wood()
base();

translate([0,-base_y/2,wood])
color("gray")
models();
