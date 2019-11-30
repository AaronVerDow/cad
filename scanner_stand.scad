height=80;
width=210;
depth=height/2+95;

x=210;
y=95;
z=80;

wall=1.8;
pad=0.1;
$fn=200;

module old() {
    module body() {
        cylinder(d=height,h=width);
        translate([0,-height/2,])
        cube([depth-height/2,height,width]);
    }

    difference() {
        body();
        hull() { 
            translate([0,0,-pad])
            cylinder(d=height-wall*2,h=width+pad*2);
            translate([depth,0,-pad])
            cylinder(d=height-wall*2,h=width+pad*2);
        }
    }
}

rotate([0,-90,0])
difference() {
    cube([x,y,z]);
    translate([-pad,0,z/2])
    rotate([0,90,0])
    cylinder(d=z-wall*4,h=x+pad*2);
}
