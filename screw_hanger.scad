screw=7;
screw_head=10.5;
screw_head_h=(screw_head-screw)/2;
filament=1.2;
wall=filament*2;

body=screw+wall*2;

head_d=4;
head_r=head_d/2;

height=33;
height=40;
height=17;

$fn=90;
pad=0.1;
padd=pad*2;

mirror([0,0,1])
difference() {
    union() {
        translate([0,0,head_r])
        cylinder(h=height-head_r,d=body);
        hull() {
            translate([0,0,head_d/2])
            rotate_extrude(angle=360, convexity=2) {
                translate([body/2-1,0,0])
                circle(d=head_d);
            }
            translate([0,0,head_r])
            cylinder(h=head_r*1.5,d=body);
        }
    }
    translate([0,0,-pad])
    cylinder(h=height+padd,d=screw);
    translate([0,0,-pad])
    cylinder(h=screw_head_h+padd,d2=screw,d1=screw_head);
}
