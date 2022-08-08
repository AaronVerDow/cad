shelf_x=300;

shelf_y=800;
pad=40;
pad_h=5;

tub=700;

edge_r=70;

pad_angle=60;
tub_display=shelf_x*2;
pad_wall=3;
$fn=90;

shelf_z=edge_r+pad_h*2;

pad_screw=3;
pad_screw_h=15;

module dirror_y(y=0) {
	children();
	translate([0,y])
	mirror([0,1])
	children();
}

module tub(extra=0) {
	//color("white")
	dirror_y(tub)
	rotate([0,90,0])
	cylinder(r=edge_r+extra,h=tub_display,center=true);
}

//tub();

module place_pad() {
	rotate([pad_angle/2,0])
	translate([0,0,edge_r])
	children();
}

module pad() {
	cylinder(d=pad_screw,h=pad_h+pad_screw_h);
	cylinder(d=pad,h=pad_h);
}

module pads() {
	dirror_y()
	place_pad()
	pad();
}

zero=0.001;

module pad_base() {
	place_pad()
	translate([0,0,pad_h])
	cylinder(d=pad+pad_wall*2,h=zero);
}

module base() {
	translate([0,0,shelf_z-zero])
	linear_extrude(height=zero)
	hull()
	projection()
	dirror_y()
	pad_base();
}

module slide() {
	difference() { 
		dirror_y()
		hull() {
			base();
			pad_base();
		}
		tub(pad_h);
		pads();
	}
}

//pads();
slide();
