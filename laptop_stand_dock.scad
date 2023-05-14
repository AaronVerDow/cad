in=25.4;
laptop_x=278;
laptop_y=206;
laptop_corner=10;

wood=in*3/4;
base=wood/2;
vesa=100;
vesa_sizes=[vesa];

mountpoint=20;

pad=15;
pad_offset=15+15/2;

bit=in/8;
screw=bit*1.1;
pocket_overhang=bit;

slot_x=265;
slot_y=4;
slot_gap=175;

wall=laptop_y-slot_gap;
side_wall=wall*3/4;

negative_corner=bit;

module laptop() {
	square([laptop_x,laptop_y],center=true);
}

dock_x=105;
dock_y=40;
dock_z=23;

wire=10;

bundle=85;

vesa_metal=120;

grip_y=laptop_y/2+mountpoint-vesa_metal/2;
grip_top=bundle;
grip_base=bundle*2;
zero=3;

module dock() {
	translate([0,mountpoint]) {
		square([dock_x,dock_y],center=true);
		square([vesa+side_wall*3,wire],center=true);
	}
	square([bundle,laptop_y+pad*2],center=true);
	
}

module wires() {
}

module vesa() {
	translate([0,mountpoint])
	for(vesa=vesa_sizes)
	for(r=[0:90:359])
	rotate([0,0,r])
	translate([vesa/2,vesa/2])
	circle(d=screw);	
}

module cross() {
		translate([0,mountpoint])
		rotate([0,0,45])
		square([wall,laptop_y*2],center=true);
}

module old_negative() {
	offset(negative_corner)
	offset(-negative_corner)
	difference() {
		square([laptop_x-wall,laptop_y-wall*2],center=true);


		dirror_x()
		cross();

	}
}

module valley() {
	difference() {
		square([laptop_x+pad*2,laptop_y-wall*2],center=true);
		square([laptop_x-side_wall*2,laptop_y],center=true);
	}
}

module negative() {
	dock();
}

module grip() {
	hull() {
		translate([-grip_top/2,mountpoint-zero-vesa_metal/2])
		square([grip_top,zero]);
		translate([-grip_base/2,-zero-laptop_y/2])
		square([grip_base,zero]);
	}
}

module body() {
	difference() {
		offset(laptop_corner)
		offset(-laptop_corner)
		laptop();

		grip();
		vent();
	}
}

module vent() {
	difference() {
		square([laptop_x-side_wall*2,laptop_y-wall*2],center=true);
		square([vesa+side_wall,laptop_y+pad*2],center=true);
		offset(side_wall)
		grip();
	}
}


module old_body() {
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

module cut(h) {
	translate([0,0,wood-h])
	linear_extrude(height=wood+pad*2)
	children();
}

module assembled() {
	difference() {
		linear_extrude(height=wood)
		body();

		cut(in/2)
		dock();

		cut(3)
		pads();

		cut(wood)
		vesa();

		cut(in/4)
		valley();
	}

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
