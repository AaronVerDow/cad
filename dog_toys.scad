outer_d2=290;
outer_d1=outer_d2-20;
outer_h=150;

gun_d=110;
gun_h=210;

gun_offset=gun_d/5;

wall=1.8;
walll=wall*2;

base=1.2;
pad=0.1;

$fn=300;

angle=3;
gun_angle=3;

module outer(extra_side=0, extra_base=0, pad=0) {
    difference() {
        cylinder(d1=outer_d1+extra_side,d2=outer_d2+extra_side,h=outer_h+pad);
        cylinder(d=outer_d2+extra_side,h=extra_base);
    }
}

module gun(extra_side=0, extra_base=0, pad=0) {
    translate([-gun_d/2+outer_d2/2+gun_offset,0,-pad*2+extra_base])
    cylinder(d=gun_d+extra_side,h=gun_h+pad*4-extra_base);
}

difference() {
    outer();
    outer(extra_side=-walll,extra_base=base,pad=pad);
    gun(pad=pad);
    translate([outer_d2/2,0,outer_h])
    rotate([0,-angle,0])
    translate([-outer_d2/2,0,0])
    cylinder(d=outer_d2*2,h=outer_h);
}


difference() {
    union() {
        intersection() {
            gun();
            outer();
        }
        intersection() {
            gun(extra_base=outer_h);
            translate([0,0,-pad])
            cylinder(d=outer_d2,h=gun_h+pad*2);
        }
    }
    gun(extra_side=-walll,pad=pad);
    translate([outer_d2/2+gun_offset,0,gun_h])
    rotate([0,-gun_angle,0])
    translate([-gun_d/2,0,0])
    cylinder(d=gun_d*2,h=gun_h);
}
