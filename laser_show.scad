shaft=3.1;
shaft_h=12;
motor_shaft_h=7.5;
shaft_od=14;
arm_d=10;
arm=30;
arms=3;
pad=0.1;

$fn=90;

difference() {
    union() {
        translate([0,0,shaft_h-shaft_od/2])
        sphere(d=shaft_od);
        cylinder(d=shaft_od,h=shaft_h-shaft_od/2);
        for(angle=[0:360/arms:360]) {
            rotate([0,0,angle])
            hull() {
                translate([arm,0,0])
                difference() {
                    sphere(d=arm_d);
                    translate([0,0,-arm_d])
                    cylinder(d=arm_d,h=arm_d);
                }
                cylinder(d1=8,d2=0.2,h=shaft_h-1);
            }
        }
    }
    translate([0,0,shaft_h-motor_shaft_h+pad])
    cylinder(d=shaft,h=motor_shaft_h);

    translate([0,0,-shaft_h])
    cylinder(d=shaft_od,h=shaft_h);
}
