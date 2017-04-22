wall=8;
$fn=90;
total_h=wall*2.5;
truck=21;
truck_l=40;
truck_total=truck+wall*2;
motor_mount=25;
motor=53;
motor_wall=0;
motor_shaft=15;
angle=60;
pad=0.1;
padd=pad*2;
screw=5;
motor_h=4;
motor_mount_wall=4;
motor_total=motor+motor_wall*2;
belt=47.5;
slide=4;
truck_bolt=48;
truck_bolt_offset=4;
truck_bolt_side_offset=4;
bolt=10;
bolt_head=15;
bolt_head_h=wall/2;
bolt_delta=8;



module motor_negative() {
    rotate([0,0,90]) {
        hull() {
            translate([motor_mount/2,0,-pad])
            cylinder(h=total_h+padd,d=screw);
            translate([motor_mount/2,slide,-pad])
            cylinder(h=total_h+padd,d=screw);
        }
        hull() {
            translate([-motor_mount/2,0,-pad])
            cylinder(h=total_h+padd,d=screw);
            translate([-motor_mount/2,slide,-pad])
            cylinder(h=total_h+padd,d=screw);
        }
        hull() {
            translate([0,motor_mount/2,-pad])
            cylinder(h=total_h+padd,d=screw);
            translate([0,motor_mount/2+slide,-pad])
            cylinder(h=total_h+padd,d=screw);
        }
        hull() {
            translate([0,-motor_mount/2,-pad])
            cylinder(h=total_h+padd,d=screw);
            translate([0,-motor_mount/2+slide,-pad])
            cylinder(h=total_h+padd,d=screw);
        }
        hull() {
            translate([0,0,-pad])
            cylinder(h=total_h+padd,d=motor_shaft);
            translate([0,slide,-pad])
            cylinder(h=total_h+padd,d=motor_shaft);
        }

        hull() { 
            translate([0,0,-pad])
            cylinder(h=total_h+pad-motor_mount_wall,d=motor);
            translate([0,slide,-pad])
            cylinder(h=total_h+pad-motor_mount_wall,d=motor);
        }
        //cylinder(h=total_h+pad-motor_mount_wall,d2=motor,d1=motor+(total_h+pad-motor_mount_wall)*2);
    }
}
//motor_negative();

module mount() {
    difference() {
        union() {
            hull() {
                cylinder(h=total_h,d=truck_total);
                translate([truck_l,-truck_total/2+bolt_delta/2,total_h/2])
                rotate([-90,0,0])
                cylinder(d=total_h,h=truck_total-bolt_delta);
                rotate([0,0,angle])
                translate([-belt,0,total_h-motor_h])
                cylinder(h=motor_h,d=motor_total);
            }
        }
        translate([0,0,-pad])
        hull() {
            cylinder(h=total_h+padd,d=truck);
            translate([truck_l*2,0,0])
            cylinder(h=total_h+padd,d=truck-bolt_delta*2);
        }
        rotate([0,0,angle])
        translate([-belt,0,0])
        motor_negative();

        //translate([truck_bolt/2-truck_bolt_offset,0,truck_bolt_side_offset-truck_bolt/2])
        //rotate([-90,0,0])
        //cylinder(h=wall*2,d=truck_bolt);

        translate([truck_l,-truck_total/2-truck_total,total_h/2])
        rotate([-90,0,0])
        cylinder(d=bolt,h=truck_total*2+pad);

        translate([truck_l,-truck_total*2.5+bolt_head_h,total_h/2])
        rotate([-90,0,0])
        cylinder(d=bolt_head,h=truck_total*2+pad,$fn=6);
    }
}
mount();
