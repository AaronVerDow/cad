bolt=11.5;
bolt_h=4;
hole=6.5;

od=40;

fingers=3;
finger=15;

finger_ring=od/2-finger/3;

pad=0.1;

base=0.6;
$fn=180;


difference() {
    cylinder(d2=bolt,d1=od,h=bolt_h+base);
    translate([0,0,base])
    cylinder(d=bolt,h=bolt_h+pad*2,$fn=6);

    for(z=[0:360/fingers:359])
    rotate([0,0,z])
    translate([finger_ring,0,base])
    cylinder(d=finger,h=bolt_h+pad*2);

    translate([0,0,-pad])
    cylinder(d=hole,h=base+pad*2);
}

