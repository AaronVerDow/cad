extrusion_width=1.22;
layer_height=0.4;
wall=extrusion_width;
base=layer_height*3;
corner=2;
x=203;
y=130;
z=80;
handle=x/2;
handle_h=20;
pad=0.1;
$fn=100;

difference() {
    translate([corner,corner,pad/2])
    minkowski() {
        cube([x-corner*2,y-corner*2,z-pad]);
        cylinder(r=corner,h=pad);
    }
    translate([corner,corner,pad/2+base])
    minkowski() {
        cube([x-corner*2,y-corner*2,z-base+pad]);
        cylinder(r=corner-wall,h=pad);
    }

    hull() {
        translate([(x-handle)/2+handle_h,0,z])
        rotate([-90,0,0])
        translate([0,0,-wall/2])
        cylinder(r=handle_h,h=wall*2);

        translate([(x-handle)/2+handle-handle_h,0,z])
        rotate([-90,0,0])
        translate([0,0,-wall/2])
        cylinder(r=handle_h,h=wall*2);
    }
}
