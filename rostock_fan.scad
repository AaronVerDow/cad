$fn=120;
main_x=206;
main_y=114;
main_z=8;
pad=0.1;
padd=pad*2;


fan_bolt_d=4;
fan_air_d=114;
fan_mount=105;

wall=5;

power_x=28;
power_y=49;

d=40;

hole_d=4.5;
hole_r=hole_d/2;

bolt_d=6;
bolt_x=185;
bolt_y=50;

fan_wire_d=12;

power_hole_head_d=15;
power_hole_head_grip=3;

module power_hole(x,y) {
	translate([x-power_x/2,y-power_y/2,-pad]) 
	cube([power_x,power_y,main_z+padd]);

	translate([x-d/2,y,-pad]) {
        cylinder(h=main_z+padd,r=hole_r);
        cylinder(h=main_z+pad-power_hole_head_grip,d=power_hole_head_d);
    }

	translate([x+d/2,y,-pad]) {
        cylinder(h=main_z+padd,r=hole_r);
        cylinder(h=main_z+pad-power_hole_head_grip,d=power_hole_head_d);
    }
}

fan_bolt_head_d=10;
fan_bolt_head_grip=3;

module fan_screw_hole(x,y) {
	translate([x*fan_mount/2,y*fan_mount/2,-pad])
	cylinder(d=fan_bolt_d,h=main_z+padd);
	translate([x*fan_mount/2,y*fan_mount/2,-pad])
	cylinder(d=fan_bolt_head_d,h=main_z-fan_bolt_head_grip+pad);
}

module fan_air_hole(x,y) {
	translate([x,y,-pad])
	intersection() {
		cylinder(d=fan_air_d,h=main_z+padd);
		cube([main_x-wall*2,main_y-wall*2,main_z*2+padd*2], center=true);
	}
}

module fan_holes(x,y) {
	translate([x,y,0]) {
		fan_air_hole(0,0);
		fan_screw_hole(1,1);
		fan_screw_hole(-1,1);
		fan_screw_hole(1,-1);
		fan_screw_hole(-1,-1);
	}
}

module bolt_hole(x,y) {
	translate([x*bolt_x/2,y*bolt_y/2,-pad])
	cylinder(d=bolt_d,h=main_z+padd);
}

module bolt_holes() {
	translate([main_x/2,main_y/2,0]){
		bolt_hole(1,1);
		bolt_hole(-1,1);
		bolt_hole(1,-1);
		bolt_hole(-1,-1);
	}
}
module fan_wire(x,y) {
	translate([x,y,-pad])
	cylinder(d=fan_wire_d,h=main_z+padd);
}

taper=5;

difference() {
    intersection() {
        translate([taper,0,0])
        minkowski() {
            cube([main_x-taper*2,main_y,pad]);
            cylinder(r1=taper,r2=0,h=main_z-pad);
        }
        cube([main_x,main_y,main_z]);
    }
	fan_holes(main_x/2-22,main_y/2);
	bolt_holes();
	power_hole(main_x-37,main_y/2);
	fan_wire(main_x-61,16);
}

