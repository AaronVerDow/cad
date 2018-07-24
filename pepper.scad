filament=1.2;
wall=filament*4;
$fn=50;

display="";

//cap
top_wall=3;
shaft=7;
knob=22;
knob_h=29;
knob_lip=26.5;
knob_lip_h=4.5;
//cap

knob_lock=knob_lip; 
knob_lock_w=8.5; 

// body
top_hole=knob_lip;
silo=36;
top_hole_h=(silo-top_hole)/2;
silo_h=110;
grinder=39.8;
grinder_h=34;
chute=42;
chute_h=3;
flair_h=19;
// body


grinder_lock=42; 
grinder_lock_w=12.5; 
//grinder_h=34(grinder_lock-grinder)/2;

grinder_h=37;

base_h=flair_h+chute_h+grinder_h+silo_h;
profile_d=base_h*4;
profile_r=profile_d/2;
base_min=silo+wall*2;
base_max=100;


cap=base_min+6;
cap_offset=6;
shaft_wall=2;
shaft_h=cap-cap_offset-shaft_wall;
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
    translate([0,0,cap/2-cap_offset])
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
    cylinder(d=shaft,h=shaft_h+pad);
}
module knob() {
    translate([0,0,knob_lip_h-pad]) {
        cylinder(d=knob,h=knob_h+pad);
        locks(knob_lock, knob_lock_w, knob_h, 3);
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
    }
}


module silo() {
    intersection() {
        rotate_extrude()
        base_profile(-wall);
        translate([0,0,flair_h+chute_h+grinder_h-pad])
        cylinder(d2=top_hole, d1=top_hole+silo_h*2,h=silo_h+padd);
    }
}

module grinder() {
    translate([0,0,flair_h+chute_h-pad]) {
        cylinder(d=grinder,h=grinder_h+padd);
        locks(grinder_lock, grinder_lock_w, grinder_h, 2);
    }
}

module chute() {
    translate([0,0,-pad])
    cylinder(d=chute,h=flair_h+chute_h+pad);
    translate([0,0,-pad])
    intersection() {
        rotate_extrude()
        base_profile(-wall);
        cylinder(d2=chute, d1=chute+flair_h*2,h=flair_h);
    }
}

module base_profile(diff=0) {
    difference() {
        square([base_max/2,base_h]);
        translate([profile_r+base_min/2+diff,base_h/2])
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

module base_to_print() {
    $fn=200;
    rotate([0,180,0])
    base();
}

module cap_to_print() {
    $fn=200;
    cap();
}

if (display == "") assembled();
if (display == "pepper_base.stl") base_to_print();
if (display == "pepper_cap.stl") cap_to_print();
