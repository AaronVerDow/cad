include<threads.scad>;
use<knurledFinishLib_v2.scad>;
use<Thumb_Knob_Custom.scad>;


cup=140;
cup_h=200;
cup_wall=4;
cup_outer=cup+cup_wall*2;

in=25.4;
mount=1.5*in;

mount_gap=5*in;

mount_h=in/2;
pad=0.1;
$fn=90;

bolt=mount*0.8;
pitch=2;
threaded=mount_h+cup_wall*2;

flat=cup_outer*0.7;

bolt_gap=0.5;

// RENDER stl
module none() {
    echo(0);
}

module body() {
    hull() {
        cylinder(d=cup_outer,h=cup_h);
        translate([0,-flat/2,0])
        cube([cup_outer/2,flat,cup_h]);
    }

    place_mounts()
    cylinder(d=mount,h=mount_h);
}

difference() {
    body();
    translate([0,0,-pad])
    cylinder(d=cup,h=cup_h+pad*2);

    place_mounts()
    translate([0,0,-threaded+mount_h+pad])
    metric_thread(bolt,pitch,threaded,internal=true);

    translate([-cup-cup_wall+cup/2,cup_outer/2+pad])
    rotate([90,0])
    cylinder(d=(cup+cup_wall)*2,h=cup_outer+pad*2);
}

module place_mounts() {
    translate([cup_outer/2,0,-mount_gap/2+cup_h/2])
    rotate([0,90,0]) {
        translate([-mount_gap,0])
        children();
        children();
    }
}

display=2*in;

place_mounts()
translate([0,0,display]) {
    metric_thread(bolt-bolt_gap,pitch,mount_h);
    translate([0,0,mount_h])
    knob_hex();
}
