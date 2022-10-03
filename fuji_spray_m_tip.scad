include<threads.scad>;
cap_od=39;
cap_pitch=1.5;
cap_length=9;
cap_grip=4;
wall=1.3;
id=cap_od-cap_pitch*2-wall*2;
pad=0.1;

nozzle_pitch=1;
//nozzle_od=11+nozzle_pitch*2;
nozzle_od=11+nozzle_pitch; // wtf I don't know how to reverse this
nozzle_length=13;
nozzle_grip=7;

cap_offset=10;

stick=4;

stick_h=cap_od-cap_pitch*2;

$fn=90;

screw=4.5;
screw_head=10;
screw_grip=5;

module dirror_y() {
	children();
	mirror([0,1])
	children();
}

translate([0,0,cap_offset])
difference() {
	union() {
		metric_thread(diameter=cap_od,pitch=cap_pitch,length=cap_grip);
		cylinder(d=cap_od-cap_pitch*2,h=cap_length);
	}
	translate([0,0,-pad])
	cylinder(d=id,h=cap_length+pad*2);
}

module place_stick() {
	translate([nozzle_od/2+stick/2,stick_h/2,cap_offset/2])
	rotate([90,0])
	children();
}

lip_od=cap_od;
lip=(lip_od-id)/2;
difference() {
	union() {
		cylinder(d=id,h=nozzle_length);
		translate([0,0,cap_offset-lip])
		cylinder(d2=lip_od,d1=id,h=lip);
		place_stick() {
			cylinder(d=stick+wall*2,h=stick_h);
			translate([-stick/2-wall,-cap_offset/2])
			cube([stick+wall*2,cap_offset/2,stick_h]);
		}
	}
	translate([0,0,-pad])
	metric_thread(diameter=nozzle_od,pitch=nozzle_pitch,length=nozzle_length+pad*2);
	translate([0,0,nozzle_grip])
	cylinder(d=nozzle_od+0.1,h=nozzle_length);

	place_stick()
	translate([0,0,-pad])
	cylinder(d=stick,h=cap_od+pad*2);

	dirror_y()
	translate([0,nozzle_od/2+(id-nozzle_od)/4]) {
		translate([0,0,-pad])
		cylinder(d=screw,h=nozzle_length+pad*2);
		translate([0,0,screw_grip])
		cylinder(d=screw_head,h=nozzle_length+pad*2);
	}
}
