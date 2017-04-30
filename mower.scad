// mb == mower_bolt
mb=9.5;
mb_h=20;
mb_base=27;
mb_head=27;
pad=0.1;
padd=pad*2;

one_x=0;
one_y=45;
two_x=43;
two_y=0;

module base_neg() {
    rotate([90,0,0]) {
        translate([one_x,one_y,-pad]) {
            cylinder(d=mb,h=mb_h+padd);
            translate([0,0,mb_h])
            cylinder(d=mb_head,h=mb_h+padd);
        }
        translate([two_x,two_y,-pad]) {
            cylinder(d=mb,h=mb_h+padd);
            translate([0,0,mb_h])
            cylinder(d=mb_head,h=mb_h+padd);
        }
    }
}
module base_pos() {
    rotate([90,0,0]) {
        translate([one_x,one_y,0])
        mb_pos();
        translate([two_x,two_y,0])
        mb_pos();
    }
}
module mb_pos() {
    cylinder(d1=mb_base,d2=mb_head,h=mb_h);
}


axle=16;
//ab = axle_bolt
ab=7;
ab_h=18;
ab_gap_x=30;
ab_gap_y=25;

a_x=45;
a_y=40;
a_h=ab_h;

difference() {
    union() {
    hull() {
        base_pos();
        translate([0,-a_y/2,-mb_base/2])
        translate([-a_x/2,-a_y/2,0])
        cube([a_x,a_y,a_h]);
    }
    }
    ab_neg();
    base_neg();
}


module ab_neg() {
    translate([0,-a_y/2,-mb_base/2])
    translate([0,-a_y/2-pad,0])
    rotate([-90,0,0])
    cylinder(h=a_y+padd,d=axle);
    //translate([-a_x/2-pad,-a_y/2-pad,-a_h])
    //cube([a_x+padd,a_y+padd,a_h]);
    translate([0,-a_y/2,-mb_base/2])
    translate([-ab_gap_x/2,-ab_gap_y/2,-pad]) {
        translate([ab_gap_x,ab_gap_y,0])
        cylinder(d=ab,h=ab_h+padd);
        translate([0,ab_gap_y,0])
        cylinder(d=ab,h=ab_h+padd);
        translate([ab_gap_x,0,0])
        cylinder(d=ab,h=ab_h+padd);
        cylinder(d=ab,h=ab_h+padd);

    }
}
