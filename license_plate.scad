filament=1.2;
layers=0.4;
in=25.4;
plate_y=6*in;
plate_y=158;
plate_x=12*in;
plate_r=1/2*in;
plate_d=plate_r*2;

screw_cover=layers*4;
screw_grip=layers*2;
below_plate=5;

screw_gap_x=7*in;
screw_gap_y=plate_y-1*in;
screw=6.5;
screw_head=screw;
screw_head_h=0;


hole_x=plate_x-1.5*in;
hole_y=plate_y-1.5*in;
hole_d=5;
hole_r=hole_d/2;

total_h=screw_cover+screw_grip+below_plate;

outer_wall=filament;
pad=0.1;
padd=pad*2;

joint_buffer=4;
joint=(plate_y-hole_y)/2+joint_buffer*2;
module positive() {
    difference() {
        translate([plate_r,plate_r,0])
        minkowski() {
            cube([plate_x-plate_d,plate_y-plate_d,total_h/2]);
            cylinder(d=plate_d+outer_wall*2,h=total_h/2);
        }
        translate([plate_r,plate_r,0])
        translate([0,0,-padd])
        minkowski() {
            cube([plate_x-plate_d,plate_y-plate_d,below_plate/2+pad]);
            cylinder(d=plate_d,h=below_plate/2+pad);
        }
        center_hole();
        screws();
    }
}

module center_hole() {
    translate([-hole_x/2+plate_x/2,-hole_y/2+plate_y/2,-pad])
    translate([hole_r,hole_r,0])
    minkowski() {
        cube([hole_x-hole_d,hole_y-hole_d,total_h/2+pad]);
        cylinder(d=hole_d,h=total_h/2+pad);
    }
}
module screws() {
    translate([0,-screw_gap_y/2+plate_y/2,0]) {
        screws_x();
        translate([0,screw_gap_y,0])
        screws_x();
    }
}
module screws_x() {
    translate([-screw_gap_x/2+plate_x/2,0,-pad]) {
        screw();
        translate([screw_gap_x,0,0])
        screw();
    }
}
module screw() {
    cylinder(d=screw,h=total_h+padd);
    translate([0,0,total_h-screw_head_h])
    cylinder(d1=screw-padd,d2=screw_head+padd,h=screw_head_h+padd);
}

module joint_x() {
    translate([-screw_gap_x/2+plate_x/2,0,0])
    hull() {
        joint();
        translate([screw_gap_x,0,0])
        joint();
    }
}
module joint() {
    translate([0,0,-pad])
    cylinder(d=joint,h=total_h+padd);
}

module side_grip() {
    translate([0,0,-padd])
    cylinder(d=joint,h=screw_grip+below_plate+padd);
}

module side_grip_x() {
    translate([-screw_gap_x/2+plate_x/2,0,0]) {
        hull() {
            side_grip();
            translate([-pad,0,0])
            side_grip();
        }
        translate([screw_gap_x,0,0])
        hull() {
            side_grip();
            translate([pad,0,0])
            side_grip();
        }
    }
}

module bar_negative() {
        difference() {
            joint_x();
            side_grip_x();
        }
}

module bars_negative() {
    translate([0,joint/2-joint_buffer,0])
    bar_negative();
    translate([0,plate_y-joint/2+joint_buffer,0])
    bar_negative();
}

module bars() {
    intersection() {
        positive();
        bars_negative();
    }
}

module sides() {
    difference() {
        positive();
        bars_negative();
    }
}
sides();
translate([0,0,20])
bars();
