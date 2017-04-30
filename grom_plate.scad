plate_bolt=5.5;
plate_wall=8;
plate_walll=plate_wall*2;
plate_outer=plate_bolt+plate_walll;
plate_head=14;
plate_h=plate_wall;

mount_bolt=10;
mount_wall=10;
mount_walll=mount_wall*2;
mount_outer=mount_bolt+mount_walll;

plate_x_gap=-180;
plate_y_gap=80;
pad=0.1;
padd=pad*2;
thread_pad=2;
mount_h=plate_bolt+thread_pad*2;

mount_x=-mount_h/2;
mount_y=0;
mount_z=0;

fudge_left=50;
fudge_right=50;
plate_bolt_h=mount_outer/2;


module plate_mount() {
    hull() {
        cylinder(d=plate_outer,h=plate_h);
        translate([0,plate_y_gap,0])
        cylinder(d=plate_outer,h=plate_h);
    }
}

module mount_positive() {
    translate([mount_x,mount_y,mount_z])
    translate([0,plate_y_gap,-mount_outer/2+plate_h])
    rotate([0,90,0])
    cylinder(d=mount_outer,h=mount_h+(plate_outer-mount_h)/2);
}

module mount_negative() {
    translate([mount_x,mount_y,mount_z])
    translate([0,plate_y_gap,-mount_outer/2+plate_h])
    rotate([0,90,0])
        //cylinder(d=mount_bolt,h=mount_h+padd+fudge_right+fudge_left);
        //translate([0,0,fudge_right+mount_h])
        //cylinder(d1=mount_outer,d2=mount_outer+fudge_left*2+plate_y_gap*2,h=fudge_left);
        translate([0,0,-plate_outer/2+pad+(plate_outer-mount_h)/2+mount_h/2])
        #cylinder(d2=mount_outer,d1=mount_outer+fudge_right*2+plate_y_gap*2,h=pad+(plate_outer-mount_h)/2);
}

module plate_to_shadow() {
    hull() {
        shadow();
        plate_mount();
    }
}

module shadow() {
    translate([mount_x,-mount_outer/2+plate_y_gap+mount_y,0])
    cube([mount_h,mount_outer/2,plate_h]);
}


module shadow_to_mount() {
    hull() {
        mount_positive();
        difference() {
            plate_to_shadow();
            translate([mount_x+mount_h/2+fudge_left,-plate_outer,-pad])
            cube([1000,1000,50]);
        }
    }
}

module plate_bolt() {
    translate([0,0,mount_z-mount_outer]) {
        cylinder(d=plate_bolt,h=plate_h+padd+mount_outer-mount_z);
        translate([0,0,-plate_h-pad])
        //cylinder(d2=plate_head,d1=plate_head+plate_h+mount_outer-mount_z,h=plate_h+mount_outer-mount_z);
        cylinder(d=plate_head,h=plate_h+mount_outer-mount_z);
    }
}

module plate_negative() {
    translate([0,0,-pad]) {
        translate([0,0,-plate_bolt_h+plate_h+pad])
        cylinder(d=plate_bolt,h=plate_bolt_h+pad);
        translate([0,plate_y_gap,-plate_bolt_h+plate_h+pad])
        cylinder(d=plate_bolt,h=plate_bolt_h+pad);
    }
}

module assembled() {
    difference() {
        union() {
            plate_to_shadow();
            shadow_to_mount();
        }
        mount_negative();
        plate_negative();
    }
}

assembled();
