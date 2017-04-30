screw=5;
screw_head=9.5;
screw_head_h=(screw_head-screw)/2;
filament=1.2;
wall=filament*2;

body=screw+wall*2;

head_d=4;
head_r=head_d/2;

height=33;

$fn=90;
pad=0.1;
padd=pad*2;

mirror([0,0,1])
difference() {
    union() {
        cylinder(h=height,d=screw+wall);
        cylinder(h=screw_head_h,d2=screw+wall,d1=screw_head+wall);
    }
    translate([0,0,-pad])
    cylinder(h=height+padd,d=screw);
    translate([0,0,-pad])
    cylinder(h=screw_head_h+padd,d2=screw,d1=screw_head);
}
