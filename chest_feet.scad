$fn=90;
roller=[28,32,18];
x=0;
y=1;
z=2;

nail=8;
nail_offset=[33,30];

base_d=5;
base_x=40;
base_y=42;
base_offset=[-base_d/2,-base_y/2];
pad=0.1;

felt=38;
felt_h=roller[z]+3;
fudge=1.2;

roller2=25;

module roller() {
    translate([0,0,roller[z]/2-roller[x]/2]) {
        translate([0,-roller[y]/2,-pad])
        cube([roller[x],roller[y],roller[z]/2+pad]);
        translate([roller[x]/2,roller[y]/2,roller[z]/2])
        rotate([90,0,0])
        translate([0,0,(roller[y]-roller2)/2])
        cylinder(d=roller[x],h=roller2);
    }
}

module nails() {
    translate([nail_offset[x],nail_offset[y]/2,0])
    sphere(d=nail);
    translate([nail_offset[x],-nail_offset[y]/2,0])
    sphere(d=nail);
}

module positive() {
    hull() {
        //base
        translate([pad+base_d/2,-base_y/2+base_d/2,0])
        minkowski() {
            cube([base_x-base_d,base_y-base_d,pad]);
            cylinder(d=base_d,h=pad);
        }
        // felt
        translate([felt/2,0,felt_h])
        cylinder(d=felt,h=pad);
    }
}

rotate([0,180,0])
difference() {
    positive();
    roller();
    nails();
}
