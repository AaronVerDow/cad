truck=28;
truck_bolt=5.5;
truck_bolts=6;
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

extra_rotation=4+360/truck_bolts/2;

h=4;
$fn=90;
pad=0.1;
padd=pad*2;

between=34;

module plate() {
    difference() {
        hull() {
            circle(d=outer_truck);
            translate([belt,0])
            circle(d=outer_motor);
        }
        circle(d=truck);
        rotate([0,0,extra_rotation])
        for(i=[0:360/truck_bolts:359]) {
            for(j=[0:360/truck_bolts/between/2:360/truck_bolts/2]) {
                rotate([0,0,i+j])
                translate([truck_bolts_d/2,0])
                circle(d=truck_bolt);
            }
        }
        translate([belt,0,0]) {
            circle(d=shaft);
            for(i=[0:360/motor_bolts:359]) {
                rotate([0,0,i])
                translate([motor_bolts_d/2,0])
                circle(d=motor_bolt);
            }
        }
    }
}


module plate_3d() {
    linear_extrude(height=h)
    plate();
}

module inches() {
    scale(1/25.4)
    plate();
}


display="";
if (display == "") plate();
if (display == "skateboard_plate.stl") plate_3d();
if (display == "skateboard_plate_mm.dxf") plate();
if (display == "skateboard_plate_in.dxf") inches();
