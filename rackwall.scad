in=25.4;
height=1786;
depth=25*in;
width=25*in;

rack_thickness=2*in;

door_gap=in/2;
door_y=depth-rack_thickness*2-4*in;
door_z=height-6*in*2;

wood=18;

door_corner=4*in;

module wood() {
	linear_extrude(height=wood)
	children();
}

module top() {
	square([width+wood*2,depth]);
}

module base() {
	square([width+wood*2,depth]);
}

module right() {
	side();
}

module left() {
	side();
}

module side() {
	difference() {
		square([depth,height+wood*2]);
		translate([depth/2-door_y/2,height/2+wood-door_z/2])
		square([door_y,door_z]);
	}
}

translate([0,0,height+wood])
wood()
top();

wood()
base();

rotate([90,0,90])
wood()
left();

translate([width+wood,0])
rotate([90,0,90])
wood()
right();

cable_tray_x=2*in;
cable_tray_y=2*in;
cable_tray_z=39*in;

cable_gap=in;

*color("blue")
translate([wood,depth-rack_thickness-cable_gap-cable_tray_y,height-cable_tray_z])
cube([cable_tray_x,cable_tray_y,cable_tray_z]);
