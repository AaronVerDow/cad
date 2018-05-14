bolt=12;
bolt_head=20;
bolt_grip=20;

bolt_gap=60;

felt=80;
felt_h=2;

x=150;
y=130;
z=90;

base=10;

corner=30;

pad=0.1;

module bolt() {
    translate([x/2,y/2,-pad]) {
        translate([0,0,bolt_grip])
        cylinder(d=bolt_head,h=z);
        cylinder(d=bolt,h=z);
        translate([0,0,bolt_grip-(bolt_head-bolt)/2])
        cylinder(d1=bolt,d2=bolt_head,h=(bolt_head-bolt)/2);
    }
}

difference() {
    hull() {
        translate([x/2,y/2,z])
        cylinder(d=felt,h=felt_h);
        translate([corner/2,corner/2,0])
        minkowski() {
            cube([x-corner,y-corner,base/2]);
            cylinder(d=corner,h=base/2);
        }
    }
    translate([x/2,y/2,z])
    cylinder(d=felt,h=felt_h+pad);
    translate([0,-bolt_gap/2,0])
    #bolt();
    translate([0,bolt_gap/2,0])
    #bolt();
}
