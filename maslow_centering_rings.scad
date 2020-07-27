router=92;
ring=209;
ring_grip=10;
space=(ring-router)/2;
ring_h=3;
base=2;
wall=2;
$fn=200;

module profile() {
    translate([ring/2-wall,0])
    square([wall,base+ring_h]);
    translate([router/2,0])
    square([space+ring_grip,base]);
}

rotate_extrude(angle=30)
profile();
