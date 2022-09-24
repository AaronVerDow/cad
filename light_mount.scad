socket=50;
flange=60;
offset=80;

flat_width=flange*1.3;
flat_height=flat_width;

wall=3;
slope=6;
total_height=flat_height*2+wall;

fillet=6;

base=1;

zero=0.001;
pad=0.1;
$fn=200;

screw=4.5;

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

module dirror() {
	children();
	mirror([0,1])
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
	dirror()
	hull() {
		fillet(slope);
		fillet(flat_height);
		fillet(flat_height,offset+flange/2);
		fillet(0,offset+flange/2-fillet);
		fillet(0,offset-fillet);
	}
	place_cylinder()
	cylinder(d=socket,h=total_height);

	dirror()
	place_cylinder()
	cylinder(d=flange+pad*2,h=flat_height);

	dirror()
	translate([0,flat_height/2+wall/2,-pad])	
	cylinder(d=screw,h=base+pad*2);
}
