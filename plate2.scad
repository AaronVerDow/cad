filament=1.2;
layers=0.4;
in=25.4;
plate_y=6*in;
plate_y=158;
//plate_x=12*in;
$fn=200;

screw_cover=layers*4;
screw_grip=layers*4;
below_plate=10;

wall=filament*2;
grip=wall;
lip=1.3;
backing=wall;

screw_gap_x=7*in;
screw_gap_y=4.75*in;
screw=6.5;
screw_head=screw;
screw_head_h=0;


hole_x=295;
hole_y=144;
hole_d=1*in;
hole_r=hole_d/2;

cover=(plate_y-hole_y)/2;

//foce a uniform border
plate_x=cover*2+hole_x;

total_h=grip+lip+backing;

outer_wall=wall;
pad=0.1;
padd=pad*2;

plate_d=hole_d+cover/2+outer_wall*2;
plate_r=plate_d/2;
joint_buffer=4;
joint=(plate_y-hole_y)/2+joint_buffer*2;
module positive() {
    difference() {
        union() {
            translate([plate_r,plate_r,0])
            minkowski() {
                cube([plate_x-plate_d,plate_y-plate_d,total_h/2]);
                cylinder(d=plate_d+outer_wall*2,h=total_h/2);
            }
        }
        plate();
        screws();
        center_hole();
        half();
    }
    supports();
}
module half() {
    translate([plate_x/2,-plate_y/2,-plate_y/2])
    cube([plate_x,plate_y*2,plate_y*2]);
}
module supports() {
    difference() {
        union() {
            support(plate_y*7/8);
            support(plate_y/2);
            support(plate_y/8);
        }
        half();
    }
}
module support(y) {
    sup=plate_y/2;
    translate([plate_x/2,y,0])
    rotate([0,45,0])
    translate([-sup/2,-filament/2,-sup/2])
    cube([sup,filament,sup]);
}

module plate() {
    translate([plate_r,plate_r,backing])
    minkowski() {
        cube([plate_x-plate_d,plate_y-plate_d,lip/2]);
        cylinder(d=plate_d,h=lip/2);
    }
}
module center_hole() {
    translate([-hole_x/2+plate_x/2,-hole_y/2+plate_y/2,backing])
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

rotate([0,90,0])
positive();
