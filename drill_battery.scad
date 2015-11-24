inner_x=20;
inner_y=12;
z=12;

$fn=45;

pole_x=4;
pole_y=6;
pole_diff=10;

center_x=3;
center_y=10;

pad=0.1;
padd=pad*2;
wire_d=4;
wire_r=wire_d/2;

difference() {
    cube([inner_x,inner_y,z]);
    translate([inner_x/2-(pole_diff+pole_x)/2,inner_y/2-pole_y/2,-pad]) {
        cube([pole_x,pole_y,z+padd]);
        translate([pole_diff,0,0])
        cube([pole_x,pole_y,z+padd]);
    }
    translate([inner_x/2-center_x/2,inner_y/2-center_y/2,-pad])
    cube([center_x,center_y,z+padd]);
    translate([-pad,inner_y/2,0])
    rotate([0,90,0])
    cylinder(r=wire_r,h=inner_x+padd);

    translate([-pad,inner_y/2,z])
    rotate([0,90,0])
    cylinder(r=wire_r,h=inner_x+padd);
}
