$fn=200;
z=80;
pad=0.1;
padd=pad*2;


base_h=5;
base=70;

tip_h=z-20;
spoke_h=tip_h-5;
spoke=15;
tip=6.5;

lip=48;
lip_h=2.5;
screw=3;
screws=6;

center=40;
center_h=7;

screw_offset=60/2;

difference() {
    union() {
        translate([0,0,-base_h])
        cylinder(d2=base,d1=base-base_h,h=base_h);
        cylinder(d=spoke,h=spoke_h);
        cylinder(d=tip,h=tip_h);
    }
    translate([0,0,-lip_h])
    cylinder(d=lip,h=lip_h+pad);
    for(i=[0:360/screws:359]) {
        rotate([0,0,i])
        translate([screw_offset,0,-base_h-pad])
        cylinder(d=screw,h=base_h+padd);
    }
}
translate([0,0,-lip_h])
cylinder(d=center,h=center_h);
