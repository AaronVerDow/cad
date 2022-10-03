spring=8;
spring_h=25;

knob_head=16;
knob=12.5;
knob_h=15;

od=33;
id=28;

h=7;
wall=1.5;
pad=0.1;


x=od+spring+knob_head+wall*4;
y=knob_head;
z=od+wall*2;

screw=4.5;

$fn=90;

module slot() {
	module place() {
		translate([od/2+wall,y+pad,z/2])
		rotate([90,0])
		children();
	}
	hull() {
		place()
		children();
		translate([0,0,od])
		place()
		children();
	}
	
}

difference() {
	cube([x,y,z]);
	
	slot()
	cylinder(d=od,h=h+pad);
	slot()
	cylinder(d=id,h=y+pad*2);

	translate([od+wall*3+spring/2+knob_head,y/2,z-spring_h])
	cylinder(d=spring,h=spring_h+pad);

	translate([od+wall*2+knob_head/2,y/2,z-knob_h])
	cylinder(d=knob,h=knob_h+pad);

	translate([od+wall*2+knob_head/2,y+pad,(z-knob_h)/2])
	rotate([90,0])
	cylinder(d=screw,h=y+pad*2);
}


