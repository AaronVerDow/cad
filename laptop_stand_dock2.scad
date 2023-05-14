in=25.4;
pad=0.1;
dock_airgap=3;
vesa_large=100;
vesa_small=75;
vesa_sizes=[vesa_large,vesa_small];
mountpoint=29;
bit=in/8;

laptop_x=278;
laptop_y=206;
laptop_corner=10;

wood=12;
wall=30;
cross_wall=wall;
side_wall=wall;
end_wall=wall;

$fn=60;

slot_x=265;
slot_y=4;
slot_z=slot_y;
slot_gap=175;


dock_x=118;
dock_y=54;

bundle_wall=15;
bundle=dock_x-bundle_wall*2;

dock_wall=in/4;
base=dock_x+dock_wall*2;

wire=8;

corner=5;
dock_corner=4;

screw=4.8;
screw_head=12.2;
screw_head_h=1.2*2;

dock_h=16+dock_airgap;
wires_h=dock_h-3;

air_gap=7;

COLOR="";

module if_color(_color) {
    if(COLOR == _color || COLOR == "")
    color(_color)
    children();
}

module plywood(veneer=0.5, layers=3, height=12, glue=0.2, max_x=1000, max_y=1000) {

	module layer(start, end) {
		intersection() {
			translate([-max_x/2, -max_y/2, start])
			cube([max_x, max_y, end-start]);
			children();
		}
	}

	range=height-veneer*2;

	glue_gap=range/(layers);
	layer_gap=range/(layers);

	// glue
	if_color("#72481f")
	for(z=[0:glue_gap:range])
	layer(z+veneer-glue/2,z+veneer+glue/2)
	children();

	// outer inner layers
	if_color("#b78d64")
	for(n=[0:2:layers-1])
	layer(n*layer_gap+veneer+glue/2,n*layer_gap+veneer+layer_gap-glue/2)
	children();

	// middle inner layers
	if_color("#9e734a")
	for(n=[1:2:layers-1])
	layer(n*layer_gap+veneer+glue/2,n*layer_gap+veneer+layer_gap-glue/2)
	children();
	
	// veneer
	if_color("#dca97a") {
		layer(0,veneer-glue/2)
		children();

		layer(height-veneer+glue/2,height)
		children();
	}
	
}

module vesas(d=screw) {
	for(vesa=vesa_sizes)
	vesa(d,vesa);
	anchor();
}

module vesa(d, vesa, end=359) {
	translate([0,mountpoint])
	for(r=[0:90:end])
	rotate([0,0,r])
	translate([vesa/2,vesa/2])
	circle(d=d);	
}

module dirror_y(y=0) {
	children();
	translate([0,y])
	mirror([0,1])
	children();
}

module dirror_x() {
	children();
	mirror([1,0])
	children();
}

module dock() {
	translate([0,mountpoint])
	offset(dock_corner)
	offset(-dock_corner)
	square([dock_x,dock_y],center=true);
}

// RENDER svg
module wires() {
	// dock();
	translate([0,mountpoint]) {
		square([bundle,laptop_y+pad*2],center=true);
		square([laptop_x-side_wall*2.5,wire],center=true);
	}
	anchor();
}

module v() {
	translate([0,mountpoint])
	dirror_y()
	rotate([0,0,45])
	translate([cross_wall/2-laptop_x/2,0])
	square([laptop_x,cross_wall],center=true);

}

module x() {
	intersection() {
		dirror_x()
		v();
		body();
	}
}

module base() {
	translate([0,mountpoint])
	square([base,base],center=true);
}

module body() {
	square([laptop_x,laptop_y],center=true);
}

module laptop() {
	dirror_x()
	intersection() {
		body();
		hull()
		v();
	}
}

module inner_laptop() {
	square([laptop_x-side_wall*2,laptop_y-end_wall*2],center=true);
}

module vent() {
		corner()
		difference() {
			inner_laptop();
			x();
			base();
		}	
}

// RENDER svg
module positive_cut() {
	difference() {
		corner()
		positive();

		dock();

		difference() {
			heads();
			vesas();
		}
	}
	anchor();
}

module positive() {
	difference() {
		laptop();
		vent();
	}
	base();
}

// RENDER svg
module pads() {
	dirror_y()
	translate([0,slot_gap/2])
	hull()
	dirror_x()
	translate([slot_x/2,0])
	circle(d=slot_y);
	anchor();
}

module wood(h=wood) {
	linear_extrude(height=h)
	children();
}

module corner() {
	offset(corner)
	offset(-corner)
	children();
}

// RENDER svg
module tips() {
	corner()
	difference() {
		intersection() {
			positive();
			dirror_y()
			translate([-laptop_x/2,-laptop_y/2])
			square([laptop_x,end_wall]);
		}
		wires();
	}
	anchor();
}

module large_heads() {
	vesa(screw_head,vesa_large);
	anchor();
}

module large_heads_top() {
	vesa(screw_head,vesa_large, 90);
}

module large_heads_bottom() {
	// getting lazy
	translate([0,mountpoint])
	mirror([0,1])
	translate([0,-mountpoint])
	vesa(screw_head,vesa_large, 90);
}

module small_heads() {
	vesa(screw_head,vesa_small);
	anchor();
}


module heads() {
	small_heads();
	large_heads();
}

module assembled() {

	// tips
	color("cyan")
	translate([0,0,wood])
	difference() {
		wood()
		tips();

		translate([0,0,wood-slot_z])
		wood()
		pads(); // slots

		wood()
		wires();

		*translate([0,0,1])
		wood()
		vesas();

		*translate([0,0,wood-screw_head_h])
		wood()
		large_heads_top();
	}

	// base
	difference() {
		wood()
		corner()
		positive();

		translate([0,0,-pad])
		wood()
		vesas();

		translate([0,0,wood*2-wires_h])
		wood()
		wires();

		translate([0,0,wood-screw_head_h])
		wood()
		large_heads();

		translate([0,0,wood*2-wires_h-screw_head_h])
		wood()
		small_heads();

		translate([0,0,wood*2-dock_h])
		wood()
		dock();
	}
}

module anchor() {
	big=20;
	small=5;
	gap=20;
	
	dirror_y()
	dirror_x()
	translate([-laptop_x/2-small-gap,-laptop_y/2-small-gap]) {
		square([big,small]);
		square([small,big]);
	}
	
}


// ENDER obj
module colorized() {
	plywood(height=wood,layers=5)
	assembled();
}

assembled();
