extra=8;
base=90;
base_h=40;
pad=0.1;
padd=pad*2;
in=25.4;
felt=1.6*in;
felt_h=1;
from_edge=3;

dip=22;
dip_h=7;
dip_offset=21;
screw_h=12;
big_d2=16;
big_d1=big_d2-4;
small_d2=11;
small_d1=small_d2-4;
big_offset=37;

small_gap=45;
small_offset=30;


module top() {
    difference() {
        cube([base,base,pad]);
        translate([base+extra,0,0])
        rotate([0,0,45])
        translate([0,-base/2,-pad])
        cube([base*2,base*2,pad*3]);
    }
}

module positive() {
    hull() {
        top();
        translate([felt/2+from_edge,felt/2+from_edge,-base_h])
        cylinder(d=felt,h=felt_h);
    }
    // big screw
    translate([big_offset,big_offset,0])
    cylinder(d2=big_d1,d1=big_d2,h=screw_h);

    translate([small_offset,small_offset,0])
    rotate([0,0,45]) {
        translate([0,-small_gap/2,0])
        cylinder(d1=small_d2,d2=small_d1,h=screw_h);
        translate([0,small_gap/2,0])
        cylinder(d1=small_d2,d2=small_d1,h=screw_h);
    }
}

difference() {
    positive();
    translate([dip_offset,dip_offset,-dip_h+pad])
    cylinder(d=dip,h=dip_h+pad);
}
