laptop_x=358;
laptop_y=246;
laptop_corner=10;

wood=13;
base=wood/2;

vesa_sizes=[100];
mountpoints=[140-laptop_y/2];

pad=15;
pad_offset=15+15/2;

in=25.4;
bit=in/4;
screw=bit*1.1;
pocket_overhang=bit;

module laptop() {
	offset(laptop_corner)
	offset(-laptop_corner)
	square([laptop_x,laptop_y],center=true);
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

module body() {
	laptop();
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

module pads(){ 
	dirror_x()
	dirror_y()
	translate([laptop_x/2-pad_offset,laptop_y/2-pad_offset])
	circle(d=pad);
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
	anchor();
}

anchor=10;
anchor_x=-laptop_x/2-anchor*2;
anchor_y=-laptop_y-anchor*2;

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
