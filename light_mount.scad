socket=50;
flange=60;
offset=80;

flat_width=flange*1.3;
flat_height=flat_width;

wall=3; // how thick light holding part is
slope=6; // extra on base of wall

total_height=flat_height*2+wall;

fillet=6; // roundness of corner

base=1.5; // how thick base is
base_tip=0.3;  // how thick end of base is

zero=0.001;
pad=0.1;
$fn=200;

screw=4.5;

zip_tie=5;
wire_x=10;
wire_y=5;

module old() {
	cube([flat_width,flat_height*2+wall,base],center=true);

	hull() {
		translate([0,0,offset-base/2])
		rotate([90,0])
		cylinder(d=flange,h=wall,center=true);
		cube([flat_width,wall,base],center=true);
	}
}

module fillet(y=0,z=0) {
	translate([-flat_width/2,wall/2+fillet+y,base+fillet+z])
	rotate([0,90])
	cylinder(r=fillet,h=flat_width+pad*2);
}

y=[0,1];
x=[1,0];

module dirror(a) {
	children();
	mirror(a)
	children();
}

module place_cylinder() {
	translate([0,total_height/2,offset])
	rotate([90,0])
	children();
}

difference() {
	hull() {
		place_cylinder()
		cylinder(d=flange,h=total_height);
		translate([-flat_width/2,-total_height/2])
		cube([flat_width,total_height,zero]);
	}
	dirror(y)
	hull() {
		fillet(slope);
		fillet(flat_height-slope,base_tip-base);
		fillet(flat_height,offset+flange/2);
		fillet(0,offset+flange/2-fillet);
		fillet(0,offset-fillet);
	}
	place_cylinder()
	cylinder(d=socket,h=total_height);

	dirror(y)
	place_cylinder()
	cylinder(d=flange+pad*2,h=flat_height);

	dirror(y)
	translate([0,flat_height/2+wall/2,-pad])	
	cylinder(d=screw,h=base+pad*2);

    // zip tie holes
    *dirror(x)
    translate([wire/2+zip_tie/2,0,zip_tie/2+base-offset+fillet/2])
	place_cylinder()
    cylinder(d=zip_tie,h=total_height);

    translate([0,0,wire_y/2+base-offset])
	place_cylinder()
    wire();

    translate([0,0,-flange/2-wire_y/2-1])
	place_cylinder()
    wire();
}

module wire() {
    hull()
    dirror(x)
    translate([wire_x/2-wire_y/2,0])
    cylinder(d=wire_y,h=total_height);
}
