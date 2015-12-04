pad=0.1;
padd=pad*2;
screw_d=5;
screw_r=screw_d/2;
screw_head_d=12;
screw_head_r=screw_head_d/2;
screw_wall=4;

bike_w=200;
bike_h=60;
bike_d=20;

cup_wall= 10;
cup_h_offset=80;
cup_h=100;
cup_outer_h=cup_h+cup_wall;
cup_d=90;
cup_r=cup_d/2;
cup_outer_d=cup_d+cup_wall*2;
cup_outer_r=cup_outer_d/2;
cup_d_offset=20;

between_screws=80;
screw_from_top=20;

seat_angle=-15;

idontwannatrig=40;

module screw_hole() {
        cylinder(r=screw_r,h=bike_d+padd);
        translate([0,0,screw_wall+pad])
        cylinder(r=screw_head_r,h=bike_d-screw_wall+pad);
}

difference() {
    union() {
        cube([bike_w,bike_h,bike_d]);
        translate([bike_w/2,0,cup_outer_r+bike_d+cup_d_offset])
        rotate([0,0,seat_angle])
        rotate([90,180,0])
        difference() {
            union() {
                cylinder(r=cup_outer_r, h=cup_outer_h);
                translate([-cup_outer_r,0.0])
                cube([cup_outer_d,bike_d+cup_d_offset+cup_outer_r,cup_outer_h]);
                translate([-cup_outer_r,cup_outer_r+bike_d,-idontwannatrig])
                cube([cup_outer_d,bike_d,cup_outer_h+idontwannatrig]);
            }
            translate([0,0,-pad])
            cylinder(r=cup_r, h=cup_h+pad);
        }
    }
    translate([bike_w/2,bike_h-screw_from_top,-pad]) {
        screw_hole();
        translate([between_screws,0,0])
        screw_hole();
        translate([-between_screws,0,0])
        screw_hole();
    }
}
