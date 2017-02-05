shaft=3.4;
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

shaft_od=17;
magnet=11.5;
shaft_h=7;
magnet_h=3.3;
module magnet() {
    difference() {
        cylinder(d=shaft_od,h=shaft_h);
        translate([0,0,-pad])
        cylinder(d=shaft,h=shaft_h+pad*2);
        translate([0,0,-pad])
        cylinder(d=magnet,h=magnet_h+pad);
        translate([0,0,magnet_h+screw/2])
        rotate([0,90,0])
        #cylinder(d=screw,h=shaft_od);
    }
}

magnet();

motor=43.5;
motor_h=30;
motor_wall=7;
motor_top=motor+motor_wall*2;
motor_base=motor+motor_wall*2+50;
total_h=100;

screw=3;
screw_h=10;
screw_gap=25;

wire=4;
wire_h=13.5;

laser=12.5;
laser_h=50;
laser_wall=2.4;
laser_od=laser+laser_wall*2;
laser_screw=10;
laser_screws=3;
laser_screw_head=8;
offset=34;

button=12.5;
button_od=14.5;
button_od2=38.5;
button_wall=2.4;
button_h=10;
button_z=20;
button_nut=20;
button_nut2=66;
button_angle=45;

base_r=10;
base=60+base_r*2;
base_h=50+base_r;
base_wall=1.2*3;

axle_offset=10;

outlet_x=49;
outlet_y=29;
outlet_screw_gap=40;

root_trim=10;

module root() {
    difference() {
        cube([base-base_r*2,base-base_r*2,base_h-base_r-root_trim]);
        translate([0,0,base_h-base_r-root_trim])
        rotate([0,50,0])
        cube([base-base_r*2,base-base_r*2,base_h-base_r]);
    }
}

module base() {
    difference() {
        union() {
            //cylinder(d2=motor_top,d1=motor_base,h=total_h);
            hull() {
                cylinder(d=motor_top,h=total_h);
                translate([-base/2+base_r+axle_offset,-base/2+base_r,0])
                minkowski() {
                    root();
                    sphere(r=base_r);
                }
            }
            for(angle=[-offset*2:offset:offset*2]){
                rotate([0,0,angle])
                translate([motor/2+laser/2,0,total_h-laser_h])
                cylinder(d=laser_od,h=laser_h);
            }
        }
        hull() {
            cylinder(d=motor,h=total_h-motor_h);
            translate([-base/2+base_r+axle_offset,-base/2+base_r,0])
            minkowski() {
                root();
                sphere(r=base_r-base_wall);
            }
        }

        translate([-base,-base,-base_r*2])
        cube([base*2,base*2,base_r*2]);

        translate([0,0,-pad])
        cylinder(d=motor,h=total_h+pad*2);

        translate([0,screw_gap,total_h-screw_h])
        cylinder(d=screw,h=screw_h+pad);
        translate([0,-screw_gap,total_h-screw_h])
        cylinder(d=screw,h=screw_h+pad);

        for(angle=[-offset:offset:offset]){
            rotate([0,0,angle]){
                //translate([motor/2+laser+laser_wall*1.5,0,total_h-(laser_screw*laser_screws)+laser_screw/2])
                //rotate([0,90,0])
                //cylinder(d1=laser_screw_head,d2=laser_screw_head+30,h=base);
            }
        }
        for(angle=[-offset*2:offset:offset*2]){
            rotate([0,0,angle]){
                translate([motor/2+laser/2,0,-pad])
                cylinder(d=laser,h=total_h+pad*2);
                for(z=[laser_screw/2:laser_screw:laser_screw*laser_screws-1+laser_screw/2]) {
                    translate([motor/2+laser/2,0,total_h-z])
                    rotate([0,90,0])
                    cylinder(d=screw,h=base);
                }
            }
        }
        translate([-motor/2,0,-pad])
        scale([0.7,1,1])
        cylinder(d=11,h=total_h+pad*2);

        translate([-base/2+axle_offset-pad,0,(base_h-base_r)/2]) {
            translate([0,-outlet_x/2,-outlet_y/2])
            cube([base_wall+pad*2,outlet_x,outlet_y]);
            translate([0,0,outlet_screw_gap/2])
            rotate([0,90,0])
            cylinder(d=screw,h=base_wall+pad*2);
            translate([0,0,-outlet_screw_gap/2])
            rotate([0,90,0])
            cylinder(d=screw,h=base_wall+pad*2);
        }

    }
    translate([axle_offset,0,0]) {
        translate([-base/2+base_r,-base/2+base_r,0])
        cylinder(r=base_r,h=base_wall);
        translate([-base/2+base_r,base/2-base_r,0])
        cylinder(r=base_r,h=base_wall);
        translate([base/2-base_r,-base/2+base_r,0])
        cylinder(r=base_r,h=base_wall);
        translate([base/2-base_r,base/2-base_r,0])
        cylinder(r=base_r,h=base_wall);
    }
}
