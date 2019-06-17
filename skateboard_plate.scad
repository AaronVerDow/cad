truck=28;
truck_bolt=5.5;
truck_bolts=12;
truck_bolts_d=40;

shaft=16;
motor_bolt=4.5;
motor_bolts=8;
motor_bolts_d=25;

belt=48.7;

wall=5;

//static wall
outer_motor=motor_bolts_d+motor_bolt+wall*2;
outer_truck=truck_bolts_d+truck_bolt+wall*2;

// match to gap
outer_motor=motor_bolts_d*2-shaft;
outer_truck=truck_bolts_d*2-truck;

h=4;
$fn=90;
pad=0.1;
padd=pad*2;

difference() {
    hull() {
        cylinder(d=outer_truck,h=h);
        translate([belt,0,0])
        cylinder(d=outer_motor,h=h);
    }
    translate([0,0,-pad]) {
        cylinder(d=truck,h=h+padd);
        rotate([0,0,360/truck_bolts/2])
        for(i=[0:360/truck_bolts:359]) {
            rotate([0,0,i])
            translate([truck_bolts_d/2,0,0])
            cylinder(d=truck_bolt,h=h+padd);
        }
        translate([belt,0,0]) {
            cylinder(d=shaft,h=h+padd);
            for(i=[0:360/motor_bolts:359]) {
                rotate([0,0,i])
                translate([motor_bolts_d/2,0,0])
                cylinder(d=motor_bolt,h=h+padd);
            }
        }
    }
}


