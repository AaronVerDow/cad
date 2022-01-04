post=26;
post_id=16;
pivot_h=17; // includes clearance

handle=23;
handle_length=100;

rocker_tip=10; // radius of rocker tip
rocker_h=7;
rocker_z=11; // how high up rocker is

rocker=27; // center of post to center of rocker_tip
rocker_base=post/2;

// rocker_inset=rocker_tip/2; // how far to pull in rocker from line between cetner of post and rocker tip

rocker_angle=40;  // degrees off line of lever

lever_width=15;
lever_height=13;
lever_length=90; // to outer edge of handle
lever_z=8;
pad=0.1;

post_h=lever_z+lever_height;

$fn=90;

module positive() {
    cylinder(d=post,h=post_h);

    translate([-lever_width/2,0,lever_z])
    cube([lever_width,lever_length,lever_height]);

    rotate([0,0,rocker_angle])
    translate([0,0,rocker_z])
    rocker();
}

module rocker() {
    hull() {
        translate([0,-rocker,0])
        cylinder(d=rocker_tip,h=rocker_h);

        translate([-post/2+rocker_base/2,0])
        cylinder(d=rocker_base,h=rocker_h);
    }
}
module negative() {
    translate([0,0,-pad])
    cylinder(d=post_id,h=pivot_h+pad);
}

difference() {
    positive();
    negative();
}
