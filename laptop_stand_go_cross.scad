laptop_x=278;
laptop_y=206;
laptop_corner=10;

wood=13;
base=wood/2;
vesa_sizes=[100];

mount_offset=23;
mountpoints=[mount_offset];

pad=15;
pad_offset=15+15/2;

in=25.4;
bit=in/8;
screw=bit*1.1;
pocket_overhang=bit;

slot_x=265;
slot_y=4;
slot_gap=175;

wall=laptop_y-slot_gap+slot_y;

negative_corner=bit;

module laptop() {
	square([laptop_x,laptop_y],center=true);
}

dock_x=

module dock() {
}

module wires() {
}

module vesa() {
	for(mountpoint=mountpoints)
	translate([0,mountpoint])
	for(vesa=vesa_sizes)
	for(r=[0:90:359])
	rotate([0,0,r])
	translate([vesa/2,vesa/2])
	circle(d=screw);	
}

module cross() {
		for(mountpoint=mountpoints)
		translate([0,mountpoint])
		rotate([0,0,45])
		square([wall,laptop_y*2],center=true);
}

module negative() {
	offset(negative_corner)
	offset(-negative_corner)
	difference() {
		square([laptop_x-wall,laptop_y-wall*2],center=true);


		dirror_x()
		cross();

	}
}

module body() {
	difference() {
		offset(laptop_corner)
		offset(-laptop_corner)
		intersection() {
			laptop();
			dirror_x()
			hull() {
				cross();
				translate([0,laptop_y])
				cross();
			}
		}
		negative();
	}
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

module pads() {
	dirror_y()
	translate([0,slot_gap/2])
	hull()
	dirror_x()
	translate([slot_x/2,0])
	circle(d=slot_y);
}

module assembled() {
	linear_extrude(height=wood)
	outside_profile();
}

// RENDER svg
module outside_profile() {
	difference() {
		body();
		vesa();
		pads();
	}
}

anchor=10;
anchor_x=-laptop_x/2-anchor*2;
anchor_y=-laptop_y-anchor*2;
preview_height=1;

assembled();
