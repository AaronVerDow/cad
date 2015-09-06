include <relativity.2014.03.scad>;
include <Libs.scad>;
y=81;
x=24;
z=22;
wall=2;
wall2=wall*2;
pad=0.1;
pad2=pad*2;
libHelp();
$fn=90;
r=2;

screw_d=4;
screw_r=screw_d/2;
screw_gap=63;

hole_r=z-wall;

module screw_hole() {
    cylinder(r=screw_r,h=wall+pad2);
}

module screw_holes() {
    translate([0,screw_gap/2,0])
    screw_hole();
    translate([0,-screw_gap/2,0])
    screw_hole();
}


difference () { 
    roundRect([x,y,z], round=r);
    translate([wall,wall,wall])
    scale([(x-wall2)/x,(y-wall2)/y,(z-wall+pad)/z])
    roundRect([x,y,z], round=r);
    translate([x/2,y/2,-pad])
    screw_holes(); 
    translate([-pad,y/2,z])
    rotate([0,90,0])
   cylinder(r=hole_r,h=wall+pad2);
    
}
