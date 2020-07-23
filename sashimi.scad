$fn=45;
corner=2;
base_x=69;
base_y=42;
base_z=1.5;

led_x=50;
led_y=10;

led_angle=30;

led_offset=9;

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

module place_led(angle=0) {
        translate([0,-led_y/2+led_offset,0])
        rotate([angle,0,0])
        translate([-led_x/2,0,0])
        children();
}
pad=0.1;

module led() {
    hull() {
        place_led(led_angle)
        cube([led_x,led_y,pad]);
        place_led()
        cube([led_x,led_y,pad]);
    }
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
