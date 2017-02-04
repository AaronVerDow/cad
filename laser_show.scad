shaft=3.1;
shaft_h=12;
motor_shaft_h=7.5;
shaft_od=14;
arm_d=10;
arm=30;
arms=3;
pad=0.1;

$fn=90;

module spinner() {
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
}

motor=44.5;
motor_h=22;
motor_wall=7;
motor_top=motor+motor_wall*2;
motor_base=motor+motor_wall*2+50;
base_h=100;

screw=3;
screw_h=10;
screw_gap=25;

wire=4;
wire_h=13.5;

difference() {
    cylinder(d2=motor_top,d1=motor_base,h=base_h);
    translate([0,0,base_h-motor_h])
    cylinder(d=motor,h=motor_h+pad);

    translate([0,screw_gap,base_h-screw_h])
    cylinder(d=screw,h=screw_h+pad);
    translate([0,-screw_gap,base_h-screw_h])
    cylinder(d=screw,h=screw_h+pad);

    hull() {
        translate([0,0,base_h])
        rotate([0,-90,0])
        cylinder(d=wire,h=motor_base);
        translate([0,0,base_h-wire_h])
        rotate([0,-90,0])
        cylinder(d=wire,h=motor_base);
    }
}
