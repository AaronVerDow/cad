wall=8;
$fn=200;
filament=1.6;
total_h=wall*3+10;
truck_x=19;
truck_y=18.5;
truck_round=4.7;
truck_x_sub=truck_x-truck_round;
// how far bolt is from truck
truck_l=20;
truck_total_x=truck_x+wall*2;
truck_total_y=truck_y+wall*2;
truck_total_x_sub=truck_x_sub+wall;
motor_mount=25;
motor=53;
motor_wall=filament*2;
motor_shaft=12;
angle=35;
angle=65;
pad=0.1;
padd=pad*2;
screw=5;
motor_h=20;
//how tall what the motor bolts to is
motor_mount_wall=5;
motor_total=motor+motor_wall*2;
belt=43.5;
slide=5;
//truck_bolt=48;
//truck_bolt_offset=4;
//truck_bolt_side_offset=4;
bolt=10;
bolt_head=16.5;
bolt_head_h=3;
bolt_delta=0;
gap=2;
truck_small=15;

wire_angle=45-90;

wires=22;
wire_h=5;


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
                // grips truck
                translate([-(truck_x-truck_round)/2,0,0])
                scale([(truck_round+wall)*2/truck_total_x,1,1])
                cylinder(h=total_h,d=truck_total_y);
                // square
                translate([-(truck_x-truck_round)/2,-truck_total_y/2,0])
                cube([truck_total_x_sub,truck_total_y,total_h]);
                //cylinder(h=total_h,d=truck_total);
                // holds bolt for truck
                translate([truck_l,-truck_total_y/2+bolt_delta/2,total_h/2])
                rotate([-90,0,0])
                cylinder(d=total_h,h=truck_total_y-bolt_delta);
                // square end of holding bolt
                translate([truck_l,-truck_total_y/2+bolt_delta/2,total_h/2])
                cube([total_h/2,truck_total_y-bolt_delta,total_h/2]);
                rotate([0,0,angle])
                // motor hole
                hull() {
                    translate([-belt,0,total_h-motor_h])
                    cylinder(h=motor_h,d=motor_total);
                    translate([-belt-slide,0,total_h-motor_h])
                    cylinder(h=motor_h,d=motor_total);
                }
            }
        }
        // profile of truck
        translate([-(truck_x-truck_round)/2,0,-pad])
        scale([truck_round/truck_y*2,1,1])
        cylinder(h=total_h+padd,d=truck_y);
        // square of above
        translate([-(truck_x-truck_round)/2,-truck_y/2,-pad])
        cube([truck_x_sub,truck_y,total_h+padd]);
        // notch 
        difference() {
            translate([0,-truck_small/2,-pad])
            cube([truck_l*2,truck_small,total_h+padd]);
            translate([truck_l-bolt/2,-truck_y/2,(total_h-bolt)/2])
            cube([bolt+truck_l,truck_y,total_h]);
        }
        // more notch
        translate([0,-truck_small/2,-(total_h-bolt)/2])
        difference() {
            cube([truck_l+bolt/2,truck_small,total_h]);
            translate([truck_l,0,(total_h-bolt)+bolt/2])
            cube([bolt/2,truck_small,bolt/2]);
        }
        hull() {
            cylinder(h=total_h+padd,d=gap);
            //cylinder(h=total_h+padd,d=truck);
            translate([truck_l*2,0,0])
            cylinder(h=total_h+padd,d=gap);
        }
        rotate([0,0,angle])
        translate([-belt,0,0])
        motor_negative();

        //translate([truck_bolt/2-truck_bolt_offset,0,truck_bolt_side_offset-truck_bolt/2])
        //rotate([-90,0,0])
        //cylinder(h=wall*2,d=truck_bolt);

        translate([truck_l,-truck_total_y/2-truck_total_y,total_h/2])
        rotate([-90,0,0])
        cylinder(d=bolt,h=truck_total_y*2+pad);

        translate([truck_l,-truck_total_y*2.5+bolt_head_h,total_h/2])
        rotate([-90,90,0])
        cylinder(d=bolt_head,h=truck_total_y*2+pad,$fn=6);

        rotate([0,0,angle])
        translate([-belt,0,motor_h-wire_h])
        rotate([0,-90,-wire_angle])
        cylinder(d=wires, h=motor);
    }
}
rotate([180,0,0])
mount();
