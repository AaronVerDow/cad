dock_x=202;
dock_y=180;

laptop_x=335;
laptop_y=232;
laptop_corner=10;

dock_overlap=30;

lip=5;

wood=13;
base=wood/2;
pad=0.1;

vesa_sizes=[100];
mountpoints=[140-laptop_y,dock_y/2];

in=25.4;
bit=in/4;
screw=bit*1.1;
pocket_overhang=bit;

module laptop() {
	translate([-laptop_x/2,dock_overlap-laptop_y])
	offset(laptop_corner)
	offset(-laptop_corner)
	square([laptop_x,laptop_y]);
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

module dock() {
	translate([-dock_x/2,0])
	square([dock_x,dock_y]);
}

module body() {
	hull() {
		laptop_overhang();
		offset(lip)
		dock();
	}
}

module laptop_overhang(extra=0) {
	difference() {
		offset(extra)
		laptop();
		translate([-laptop_x/2-pad*2-extra,-lip])
		square([laptop_x+pad*4+extra*2,laptop_y]);
	}
}


module assembled() {
	difference() {
		linear_extrude(height=wood)
		outside_profile();

		translate([0,0,base])
		linear_extrude(height=wood)
		pockets();
	}
}

// RENDER svg
module outside_profile() {
	difference() {
		body();
		vesa();
	}
	anchor();
}

// RENDER svg
module pockets() {
	dock();
	laptop_overhang(pocket_overhang);
	anchor();
}

anchor=10;
anchor_x=-laptop_x/2-anchor*2;
anchor_y=-laptop_y+dock_overlap-anchor*2;

preview_height=1;

module preview() {
	color("red")
	linear_extrude(height=preview_height)
	outside_profile();

	color("blue")
	translate([0,0,1])
	linear_extrude(height=preview_height)
	pockets();
}

//preview();
assembled();

module anchor() {
	color("lime")
	translate([anchor_x,anchor_y])
	square([anchor, anchor]);
}
