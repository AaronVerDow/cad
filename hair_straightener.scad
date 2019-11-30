width=40;

top_x=10;
bottom_x=30;

height=50;

pad=0.1;

lip=10;
lip_wall=1;

divot=12;

divot_angle=atan((bottom_x-top_x)/2/height);

on_switch=10;

screw=5;
led=10;
led_h=20;

module body() {
    hull() {
        cube([bottom_x,width,pad]);
        translate([bottom_x/2-top_x/2,0,height])
        cube([top_x,width,pad]);
    }

    translate([-lip,0,0])
    hull() {
        cube([bottom_x+lip*2,lip_wall,pad]);
        translate([bottom_x/2-top_x/2,0,height])
        cube([top_x+lip*2,lip_wall,pad]);
    }
}

difference() {
    body();

    translate([bottom_x,width/2,0])
    rotate([0,-divot_angle,0])
    translate([0,0,on_switch])
    cylinder(d=divot,h=height*2);

    translate([bottom_x/2,0,height/2])
    rotate([-90,0,0])
    cylinder(d=screw,h=width);

    translate([bottom_x/2,0,height/2])
    rotate([-90,0,0])
    cylinder(d=led,h=width/2);
}
