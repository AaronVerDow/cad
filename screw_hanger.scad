screw=7; // key hangers
screw=6; // bow hanger
screw_head=10.5; // key hangers
screw_head=9.5; //bow hanger
screw_head_h=(screw_head-screw)/2;
filament=1.2;
wall=filament*2; // key hanger
wall=filament; // bow hanger

body=screw+wall*2;

layer_h=0.4;
head_d=3; 
head_r=head_d/2;
head_h=1;

height=33;
height=40;
height=17;
height=58;


base=20;
base_r=(base-body)/2;
base_h=layer_h*2;
total_base_h=base_h+base_r;

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
                translate([body/2,0,0])
                circle(d=head_d);
            }
            translate([0,0,head_r])
            cylinder(h=head_r*1.5,d=body);
        }
        base();
    }
    translate([0,0,-pad])
    cylinder(h=height+padd,d=screw);
    translate([0,0,-pad])
    cylinder(d=screw_head,h=head_h+pad);
    translate([0,0,head_h])
    cylinder(h=screw_head_h+pad,d2=screw,d1=screw_head);
}

module base() {
    translate([0,0,height-total_base_h])
    rotate_extrude(angle=360, convexity=2)
    difference() {
        square([base/2,total_base_h]);
        translate([base/2,0])
        circle(base_r);
    }
}
