in=25.4;
pad=0.1;
vesa_large=100;
vesa_small=75;
vesa_sizes=[vesa_large,vesa_small];
mountpoint=25;
bit=in/8;

laptop_x=278;
laptop_y=206;
laptop_corner=10;

wood=in*3/4;

wall=30;
cross_wall=wall;
side_wall=wall;
end_wall=wall;

$fn=60;

slot_x=265;
slot_y=4;
slot_gap=175;

bundle=90;

dock_x=117;
dock_y=54;

dock_wall=in/4;
base=dock_x+dock_wall*2;

wire=10;

corner=5;
dock_corner=3;

screw=5;
screw_head=15;
screw_head_h=1.5;

dock_h=wood*2/3+2;

module vesas(d=screw) {
	for(vesa=vesa_sizes)
	vesa(d,vesa);
}

module vesa(d, vesa) {
	translate([0,mountpoint])
	for(r=[0:90:359])
	rotate([0,0,r])
	translate([vesa/2,vesa/2])
	circle(d=d);	
}

module dirror_y() {
	children();
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
module wires() {
	dock();
	translate([0,mountpoint]) {
		square([bundle,laptop_y+pad*2],center=true);
		square([laptop_x-side_wall*2.5,wire],center=true);
	}
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

module positive() {
	difference() {
		laptop();
		vent();
	}
	base();
}

module pads() {
	dirror_y()
	translate([0,slot_gap/2])
	hull()
	dirror_x()
	translate([slot_x/2,0])
	circle(d=slot_y);
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
}

module large_heads() {
	vesa(screw_head,vesa_large);
}

module small_heads() {
	vesa(screw_head,vesa_small);
}


difference() {
	wood()
	tips();

	translate([0,0,1])
	wood()
	pads();

	wood()
	wires();

	translate([0,0,1])
	wood()
	vesas();

	translate([0,0,1])
	wood()
	large_heads();
}

difference() {
	wood(wood*2/3)
	corner()
	positive();

	wood()
	vesas();

	translate([0,0,wood/3])
	wood()
	wires();

	translate([0,0,wood*2/3-screw_head_h])
	wood()
	large_heads();

	translate([0,0,wood/3-screw_head_h])
	wood()
	small_heads();

	translate([0,0,wood-dock_h])
	wood()
	dock();
}
