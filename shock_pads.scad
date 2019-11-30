$fn=90;
pad=0.1;
pad_x=56;
pad_y=79;
pad_z=5;
r=5;
d=r*2;

inner_pad=[pad_x-d,pad_y-d,pad_z-pad];
screw=6;
screw_x=41;
screw_y=64;

module screw(x,y) {
    translate([x+(pad_x-screw_x)/2,y+(pad_y-screw_y)/2,-pad])
    cylinder(d=screw,h=pad_z+pad*2);
}

module y_screws(y) {
    screw(0,y);
    screw(screw_x,y);
}

module screws() {
    y_screws(0);
    y_screws(screw_y);
}

module pad() {
    translate([r,r,pad/2])
    minkowski() {
        cube(inner_pad);
        cylinder(d=d,h=pad);
    }
}

difference() {
    pad();
    screws();
}
