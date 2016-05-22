rod=19;
screw=4;
screw_h=17;
rod_h=143;
pad=0.1;

mouse_ear=60;
layer_h=0.6;
$fn=190;

difference() {
    union() {
        cylinder(d=rod,h=rod_h);
        cylinder(d=mouse_ear,h=layer_h);
    }
    translate([0,0,-pad])
    cylinder(d=screw,h=screw_h+pad);
    translate([0,0,rod_h-screw_h])
    cylinder(d=screw,h=screw_h+pad);
}
