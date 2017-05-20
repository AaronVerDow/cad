wood=0.5;
l=24;
w=16;
h=10;

d=4;
r=d/2;
$fn=120;
wall=1;

pad=0.01;
padd=pad*2;

screw=0.25;

base();

module base() {
    difference() {
        cube([l,w,wood]);
        side_teeth();
        translate([l-wood,0,0])
        side_teeth();
        translate([0,w-wood,0])
        back_teeth();
    }
}

module lip() {
    translate([0,0,wood])
    difference() {
        cube([l,w,wood]);
        translate([wall,-pad,-pad])
        cube([l-wall*2,w-wall+pad,wood+padd]);
    }
}

module back_teeth() {
    translate([l/5,0,0])
    cube([l/5,wood,wood]);
    translate([l/5*3,0,0])
    cube([l/5,wood,wood]);
}

module side_teeth() {
    translate([0,w/5,0])
    cube([wood,w/5,wood]);
    translate([0,w/5*3,0])
    cube([wood,w/5,wood]);
}


module rounded() {
    difference() {
        color("lime")
        minkowski() {
            cube([l-d,w-d,wood/2]);
            cylinder(d=d,h=wood/2);
        }
        cylinder(d=screw,h=wood*2);
        translate([l-d,0,0])
        cylinder(d=screw,h=wood*2);
        translate([l-d,w-d,0])
        cylinder(d=screw,h=wood*2);
        translate([0,w-d,0])
        cylinder(d=screw,h=wood*2);
    }

    translate([0,0,wood*2])
    difference() {
        minkowski() {
            cube([l-d,w-d,wood/2]);
            cylinder(d=d,h=wood/2);
        }
        translate([0,-wall-r,-pad])
        minkowski() {
            cube([l-d,w-r+wall,wood/2+pad]);
            cylinder(d=d-wall*2,h=wood/2+pad);
        }

    }
}


module bad_leg() {
    translate([0,0,-h]) {
        difference() {
            cylinder(d=d,h=h);
            translate([0,0,-wood])
            cylinder(d=d-wall,h=h);
            translate([-r-pad,0,0])
            cube([d+padd,d+padd,h]);
            translate([0,-r-pad,0])
            cube([d+padd,d+padd,h]);
        }

        translate([-r+wood/2,0,0])
        cylinder(d=wood,h=h);
        translate([0,-r+wood/2,0])
        cylinder(d=wood,h=h);
    }
}
