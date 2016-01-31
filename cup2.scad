$fn=120;
pad=0.1;
padd=pad*2;
screw_d=7;
screw_r=screw_d/2;
screw_head_d=13;
screw_head_r=screw_head_d/2;
screw_head2_d=screw_head_d;
screw_head2_r=screw_head2_d/2;
screw_wall=4;

flange_d1=20;
flange_r1=flange_d1/2;
flange_d2=10;
flange_r2=flange_d2/2;
flange_d=2;

bike_h=40;
bike_d=9;

cup_wall= 10;
cup_h_offset=80;
cup_h=60;
cup_outer_h=cup_h+cup_wall;
cup_d=83;
cup_r=cup_d/2;
cup_outer_d=cup_d+cup_wall*2;
cup_outer_r=cup_outer_d/2;
cup_d_offset=-4;

between_screws=55;
screw_from_top=20;

bike_w=between_screws*2;
seat_angle=-15;

corner_clip=20;
straight_clip=30;
slice_angle=20;

idontwannatrig=40;
clip=7;
height_to_bolts=-12;

module screw_hole() {
        cylinder(r=screw_r,h=bike_d+padd);
        translate([0,0,screw_wall+pad])
        cylinder(r1=screw_head_r,r2=screw_head2_r,h=bike_d-screw_wall+pad,$fn=6);
        //translate([0,0,bike_d+pad])
        //cylinder(r=flange_r1,h=cup_d);
        //translate([0,0,bike_d-flange_d+pad])
        //cylinder(r2=flange_r1,r1=flange_r2,h=flange_d+pad);
}

difference() {
    union() {
        cube([bike_w,bike_h,bike_d]);
        translate([0,bike_h/2,0])
        cylinder(r=bike_h/2,h=bike_d);
        translate([bike_w,bike_h/2,0])
        cylinder(r=bike_h/2,h=bike_d);
        translate([bike_w/2,0,cup_outer_r+bike_d+cup_d_offset])
        rotate([0,0,seat_angle])
        rotate([90,180,0])
        translate([0,0,height_to_bolts])
        difference() {
            union() {
                cylinder(r=cup_outer_r, h=cup_outer_h);
                translate([-cup_outer_r,0,0])
                cube([cup_outer_d,cup_d_offset+cup_outer_r,cup_outer_h]);
                translate([-cup_outer_r,cup_outer_r+cup_d_offset,-idontwannatrig])
                cube([cup_outer_d,bike_d,cup_outer_h+idontwannatrig]);
            }
            translate([0,0,-pad])
            cylinder(r=cup_r, h=cup_h+pad);
            translate([-cup_r-cup_wall,-cup_d-cup_wall+clip,-pad])
            cube([cup_d+cup_wall*2,cup_r,cup_h+cup_wall+padd]);
            translate([-cup_r-cup_wall-pad,cup_outer_r+cup_d_offset+cup_wall,cup_h+cup_wall-corner_clip])
            rotate([slice_angle+90,0,0])
            cube([cup_d+cup_wall*2+padd,cup_d*2,cup_d*2]);
            translate([-cup_r-cup_wall-pad,cup_outer_r+cup_d_offset+cup_wall+pad,cup_h+cup_wall-straight_clip])
            rotate([90,0,0])
            cube([cup_d+cup_wall*2+padd,cup_d*2,cup_d*2]);
        }
    }
    translate([bike_w/2,bike_h-screw_from_top,-pad]) {
        screw_hole();
        translate([between_screws,0,0])
        screw_hole();
        translate([-between_screws,0,0])
        screw_hole();
    }
    translate([0,bike_h,-pad])
    cube([bike_w,bike_h,bike_d+padd]);
}
