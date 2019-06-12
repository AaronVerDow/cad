translate([-10,-2,-1])
import("amazon_fire_phone_case_v2.stl");

y=142;
x=69;
z=x/2+7;
z_x=5;
$fn=90;
edge=5;

d=7;

wall=1.4;

module bar(l,d) {
    translate([0,l/2,0])
    rotate([90,0,0])
    cylinder(d=d,h=l);
}

module part(extra=0, pad=0) {
    translate([0,0,-d/2])
    hull() {
       translate([d/2+edge,0,0])
       bar(y+pad*2,d+extra); 
       translate([x-d/2-edge,0,0])
       bar(y+pad*2,d+extra); 

       translate([x/2-z_x,0,-z])
       bar(y+pad*2,d+extra); 
   }

}

difference() {
    part();
    part(-wall,10);
}
