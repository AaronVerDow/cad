$fn=120;
socket_od=38.5;
socket_or=socket_od/2;
socket_id=35.5;
socket_ir=socket_id/2;
socket_h=13.3;
pad=0.1;
2pad=pad*2;2pad=pad*2;

arm_x=150;
arm_y=16;
arm_z=socket_h;

center_od=60;
center_or=center_od/2;
center_id=35;
center_ir=center_id/2;
center_h=socket_h;

difference() {
	union() {
		cylinder(h=socket_h,r=socket_or);
		translate([0,-arm_y/2,0])
		cube([arm_x,arm_y,arm_z]);
		translate([arm_x,0,0]) {
			cylinder(h=center_h,r=center_or);
			//rotate([0,0,45])
			//cube([center_od,center_od,center_h]);
		}
	}
	translate([0,0,-pad]) {
		cylinder(h=socket_h+2pad,r=socket_ir);
		translate([arm_x,0,0])
		cylinder(h=socket_h+2pad,r=center_ir);
	}
}
