shaft=3.1;
shaft_h=12;
motor_shaft_h=7.5;
shaft_od=14;
arm_d=10;
arm=30;
arms=3;
pad=0.1;

$fn=290;

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

motor=43.5;
motor_h=42;
motor_wall=7;
motor_top=motor+motor_wall*2;
motor_base=motor+motor_wall*2+50;
base_h=100;

screw=3;
screw_h=10;
screw_gap=25;

wire=4;
wire_h=13.5;

laser=12.5;
laser_h=50;
laser_wall=3;
laser_od=laser+laser_wall*2;
laser_screw=22;
offset=34;

button=12.5;
button_od=14.5;
button_od2=38.5;
button_wall=3;
button_h=10;
button_z=20;
button_nut=20;
button_nut2=66;
button_angle=45;

difference() {
    union() {
        cylinder(d2=motor_top,d1=motor_base,h=base_h);
        for(angle=[-offset*2:offset:offset*2]){
            rotate([0,0,angle])
            translate([motor/2+laser/2,0,base_h-laser_h])
            cylinder(d=laser_od,h=laser_h);
        }
    }
    for(angle=[-button_angle/2:button_angle:button_angle/2]) {
        rotate([0,0,angle])
        translate([-motor_base/2,0,button_z])
        rotate([0,90,0]){
            cylinder(d=button,h=motor_base/2);
            cylinder(d2=button_od,d1=button_od2,h=button_h);
            translate([0,0,button_h+button_wall])
            cylinder(d1=button_nut,d2=button_nut2,h=motor_base/3);
        }
    }

    translate([0,0,-pad])
    cylinder(d2=motor,d1=motor_base-motor_wall*2,h=base_h-motor_h+pad*2);

    translate([0,0,base_h-motor_h])
    cylinder(d=motor,h=motor_h+pad);

    translate([0,screw_gap,base_h-screw_h])
    cylinder(d=screw,h=screw_h+pad);
    translate([0,-screw_gap,base_h-screw_h])
    cylinder(d=screw,h=screw_h+pad);

    //hull() {
        //translate([0,0,base_h])
        //rotate([0,-90,0])
        //cylinder(d=wire,h=motor_base);
        //translate([0,0,base_h-wire_h])
        //rotate([0,-90,0])
        //cylinder(d=wire,h=motor_base);
    //}
    for(angle=[-offset*2:offset:offset*2]){
        rotate([0,0,angle]){
            translate([motor/2+laser/2,0,-pad])
            cylinder(d=laser,h=base_h+pad*2);
            translate([motor/2+laser/2,0,-pad])
            translate([laser/2,0,base_h-laser_screw])
            rotate([0,90,0])
            cylinder(d=screw,h=laser_wall+pad*2);
        }
    }
    translate([-motor/2,0,0])
    scale([0.7,1,1])
    cylinder(d=11,h=base_h+pad);


}
