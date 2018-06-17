filament=1.2;
wall=filament*2;
$fn=200;

//cap
top_wall=3;
shaft=7;
shaft_h=0;
knob=21.5;
knob_h=29;
knob_lip=26;
knob_lip_h=4;
//cap

knob_lock=knob_lip; 
knob_lock_w=8.5; 

// body
top_hole=knob_lip;
silo=38;
top_hole_h=(silo-top_hole)/2;
silo_h=110-top_hole_h;
grinder=silo;
grinder_h=34;
chute=41.5;
chute_h=10;
// body


grinder_lock=chute; 
grinder_lock_w=12.5; 

base_h=chute_h+grinder_h+silo_h+top_hole_h;
profile_d=base_h*4;
profile_r=profile_d/2;
base_min=silo+wall*2;
base_max=100;

cap=base_min+6;
cap_h=knob_lip_h+knob_h+shaft_h+top_wall;

extrusion_width=1.2;

pad=0.1;
padd=pad*2;

module locks(diameter, width, height, count) {
    for(i=[0:360/count:359]) {
        rotate([0,0,i])
        lock(diameter, width, height);
    }
}

module lock(diameter, width, height) {
    intersection() {
        cylinder(d=diameter, h=height);
        translate([0,-width/2,-pad])
        cube([diameter/2+pad,width,height+padd]);
    }
}

module cap_positive() {
    translate([0,0,cap/2-6])
    sphere(d=cap);
}
module cap() {
    difference() {
        //rotate_extrude()
        //cap_profile();
        cap_positive();
        shaft();
        knob();
        knob_lip();
        translate([0,0,-cap])
        cylinder(d=cap,h=cap);
    }
}

module shaft() {
    translate([0,0,-pad])
    cylinder(d=shaft,h=knob_lip_h+knob_h+shaft_h+pad);
}
module knob() {
    translate([0,0,knob_lip_h-pad]) {
        cylinder(d=knob,h=knob_h+pad);
        locks(knob_lock, knob_lock_w, grinder_h, 3);
    }
}
module knob_lip() {
    translate([0,0,-pad])
    cylinder(d=knob_lip,h=knob_lip_h+pad);
}

module base() {
    difference() {
        rotate_extrude()
        base_profile();
        chute();
        grinder();
        silo();
        top_hole();
    }
}

module top_hole() {
    translate([0,0,chute_h+grinder_h-pad+silo_h+pad])
    cylinder(d1=silo,d2=top_hole-padd,h=top_hole_h+pad);
}

module silo() {
    translate([0,0,chute_h+grinder_h-pad])
    cylinder(d=silo,h=silo_h+padd);
}

module grinder() {
    translate([0,0,chute_h-pad]) {
        cylinder(d=grinder,h=grinder_h+padd);
        locks(grinder_lock, grinder_lock_w, grinder_h, 2);
    }
}

module chute() {
    translate([0,0,-pad])
    cylinder(d=chute,h=chute_h+pad);
}

module base_profile() {
    difference() {
        square([base_max/2,base_h]);
        translate([profile_r+base_min/2,base_h/2])
        circle(d=profile_d);
    }
}

module cap_profile() {
    square([cap/2,cap_h]);
}

module assembled() {
    base();
    translate([0,0,base_h+50])
    cap();
}

assembled();
