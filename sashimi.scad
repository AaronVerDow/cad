corner=3;
base_x=40;
base_y=30;
base_z=3;

led_x=30;
led_y=10;

led_angle=15;

led_offset=4;

wire_x=10;
wire_y=2;

wire_to_edge=3;


module body() {
    minkowski() {
        translate([0,0,-base_z/4*3])
        cube([base_x-corner*2,base_y-corner*2,base_z/2],center=true);
        cylinder(r=corner,h=base_z/2);
    }
}

module led() {
    translate([0,-led_y/2+led_offset,0])
    rotate([led_angle,0,0])
    translate([-led_x/2,0,-base_z])
    cube([led_x,led_y,base_z]);
}

module positive() {
    body();
    led();
}

difference() {
    positive();
    translate([0,base_y/2-wire_y/2-wire_to_edge,0])
    cube([wire_x,wire_y,base_z*3],center=true);
}
