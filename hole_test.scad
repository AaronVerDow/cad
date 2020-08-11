use <joints.scad>;

in=25.4;


module dirror_x(x=0) {
    children();
    translate([x,0])
    mirror([1,0])
    children();
}

// RENDER svg
// RENDER dxf
module hole() {
    dirror_x(in/2)
    negative_tails(6*in,in/2,1,0,0,0.25*in,0);
}

hole();
