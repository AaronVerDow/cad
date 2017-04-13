bolt=10;
bolt_gap=51;
bolt_wall=10;
bolt_total=bolt+bolt_wall*2;
bolt_to_wall=40;
thick=4;
pad=0.1;
padd=pad*2;

screw=6;
screw_wall=5;
screw_total=screw_wall*2+screw;
screw_gap=20;
screws=2;

r=12;
$fn=60;


difference() {
    hull() {
        hull() {
            translate([0,0,screws*screw_gap])
            rotate([-90,0,0])
            cylinder(h=thick,d=screw_total);
            translate([-bolt_total/2,0,0])
            cube([bolt_total,thick,thick]);
        }
        hull() {
            translate([0,bolt_to_wall+bolt_gap,0])
            cylinder(h=thick,d=bolt_total);
            translate([-bolt_total/2,0,0])
            cube([bolt_total,thick,thick]);
        }
    }
    for(z=[screw_gap:screw_gap:screw_gap*screws]) { 
        translate([0,-pad,z])
        rotate([-90,0,0])
        cylinder(h=thick+padd,d=screw);
    }
    translate([0,bolt_to_wall,-pad])
    cylinder(h=thick+padd,d=bolt+padd);
    translate([0,bolt_to_wall+bolt_gap,-pad])
    cylinder(h=thick+padd,d=bolt+padd);

    translate([-bolt_total/2,thick+r,thick+r])
    minkowski() {
        cube([bolt_total,bolt_total+bolt_to_wall+bolt_gap,screws*screw_gap+screw_total]);
        rotate([0,90,0])
        cylinder(r=r,h=padd);
    }
}
