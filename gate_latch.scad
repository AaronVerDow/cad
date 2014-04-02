$fn=180;
pad=0.1;
padd=pad*2;
bar_l=200;
bar_w=15;
bar_h=40;
pivot_gap=1;
pivot_d=20;
pivot_r=pivot_d/2;
screw_d=5;
screw_r=screw_d/2;

catch_plate_w=30;
catch_plate_d=15;
catch_plate_r=catch_plate_w/2;

catch_d=bar_h/2;
backboard=bar_h;
catch_arm_h=25;
catch_gap=50;

safety=11;

ramp_l=sqrt(2*((catch_d+catch_arm_h)*(catch_d+catch_arm_h)));

catch_plate_h=catch_d+backboard+catch_arm_h+catch_plate_r*2;
catch_plate_max_d=catch_arm_h+catch_plate_d+catch_d+catch_gap;

guide_w=30;
guide_t=10;
small_slot=9;
large_slot=13;
slot_d=8;
guide_d=36;
guide_h=150+guide_w;
center_h=40;
center_gap=2;

module guide() {
    translate([0,0,-guide_w/2])
    difference() {
        cube([guide_w,guide_t,guide_h]);
        translate([guide_w/2-small_slot/2,-pad,-pad])
        cube([small_slot,guide_t+padd,guide_h+padd]);
        translate([guide_w/2-large_slot/2,guide_t-slot_d+pad,-pad])
        cube([large_slot,slot_d+pad,guide_h+padd]);
    }
    translate([guide_w/2,0,guide_h-guide_w/2])
    rotate([-90,0,0])
    difference() {
        cylinder(r=guide_w/2,h=guide_t+guide_d);
        translate([0,0,-pad])
        cylinder(r=screw_r,h=guide_t+guide_d+padd);
    }
    translate([guide_w/2,0,-guide_w/2])
    rotate([-90,0,0])
    difference() {
        cylinder(r=guide_w/2,h=guide_t+guide_d);
        translate([0,0,-pad])
        cylinder(r=screw_r,h=guide_t+guide_d+padd);
    }
    translate([0,0,guide_h/2-guide_w/2-center_h/2])
    difference() {
        cube([guide_w,guide_t-center_gap,center_h]);
        translate([guide_w/2,-pad,center_h])
        rotate([-90,0,0]) {
            cylinder(r=small_slot/2,h=guide_t);
            translate([0,0,guide_t-slot_d])
            cylinder(r=large_slot/2,h=guide_t);
        }
        translate([guide_w/2,-pad,0])
        rotate([-90,0,0]){
            cylinder(r=small_slot/2,h=guide_t);
            translate([0,0,guide_t-slot_d])
            cylinder(r=large_slot/2,h=guide_t);
        }
    }
}

module bar() {
    difference() {
        union() {
            translate([bar_h/2,0,bar_h/2])
            rotate([-90,0,0])
            cylinder(r=bar_h/2,h=bar_w);
            translate([bar_h/2,0,bar_w])
            cube([bar_l,bar_w,bar_h-bar_w]);
            difference() {
                translate([bar_l+bar_h/2,0,bar_w])
                rotate([0,-90,0])
                cylinder(r=bar_w,h=bar_l);
                translate([bar_h/2-pad,-bar_w-pad,-pad])
                cube([bar_l+padd,bar_w+pad,bar_w*2+padd]);
            }
        }
        translate([bar_h/2,-pad,bar_h/2])
        rotate([-90,0,0])
        cylinder(r=pivot_r+pivot_gap,h=bar_w+padd);
    }
}

module pivot() {
    translate([bar_h/2,-pivot_gap,bar_h/2])
    rotate([-90,0,0]) 
    difference() {
        union() {
            cylinder(r=pivot_r,h=bar_w+pivot_gap*2);
            translate([0,0,-bar_w/2])
            cylinder(r=bar_h/2,h=bar_w/2);
        }
        translate([0,0,-bar_w/2-pad])
        cylinder(r=screw_r,h=bar_w/2+bar_w+pivot_gap*2+padd);
    }
}
module catch() {
    difference() {
        union() {
            translate([catch_plate_r,0,catch_plate_h-catch_plate_r])
            rotate([-90,0,0])
            cylinder(r=catch_plate_r,h=catch_plate_d);
            translate([catch_plate_r,0,-catch_plate_r])
            rotate([-90,0,0])
            cylinder(r=catch_plate_r,h=catch_plate_d);
            translate([0,0,-catch_plate_r])
            cube([catch_plate_w,catch_plate_d,catch_plate_h]);
        }
        translate([catch_plate_r,-pad,catch_plate_h-catch_plate_r])
        rotate([-90,0,0])
        cylinder(r=screw_r,h=catch_plate_d+padd);
        translate([catch_plate_r,-pad,-catch_plate_r])
        rotate([-90,0,0])
        cylinder(r=screw_r,h=catch_plate_d+padd);
    }
    translate([0,-catch_gap,0])
    cube([catch_plate_w,catch_gap,catch_arm_h]);
    difference() {
        translate([0,-catch_plate_max_d+catch_plate_d,0])
        rotate([-45,0,0])
        cube([catch_plate_w,ramp_l,ramp_l]);
        translate([-pad,-pad-catch_plate_max_d+catch_plate_d,-ramp_l])
        cube([catch_plate_w+padd,catch_plate_max_d+padd,ramp_l]);
        translate([-pad,-catch_gap,0])
        //this one is mess, don't care
        cube([catch_plate_w+padd,catch_plate_max_d+padd,ramp_l]);
        translate([-pad,-catch_plate_max_d+catch_plate_d,-pad])
        cube([catch_plate_w+padd,safety,safety+pad]);
    }
}

translate([-guide_w,-bar_w*2-pivot_gap,0])
guide();
translate([0,0,-catch_arm_h])
color("cyan")
catch();
translate([-bar_l/12*11,-bar_w-pivot_gap,0]) {
    color("lime")
    bar();
    color("magenta")
    pivot();
}
