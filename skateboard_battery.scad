batt_x=140;
batt_y=68;
batt_z=27;
$fn=90;

max_y=130;

pad=0.1;
padd=pad*2;

outer=max_y;
outer_offset=0;
outer_scale=0.53;
wall=1.8;

big_hole=max_y-20;

screw=3;
screw_offset=(max_y-batt_y)/4;
nut=6;
nut_h=1.5;

screw_driver=12;

gap=wall;
batt_side_h=7;

support_d=80;
support_wall=wall;
support_extra=4;
support_h=batt_x/2+big_hole/2;

module support() {
    translate([0,support_d/2-wall/2,batt_z+wall])
    rotate([0,90,0])
    difference() {
        cylinder(d=support_d,h=support_h);
        translate([0,0,-pad])
        cylinder(d=support_d-support_wall*2,h=support_h+padd);
        translate([0,0,support_h])
        rotate([0,-4,0])
        translate([-support_d-support_extra,-support_d/2,-support_h/2*3])
        cube([support_d,support_d,support_h*2]);
        translate([-support_d/2,0,-support_h/2])
        cube([support_d,support_d,support_h*2]);

    }
}

//support();
//mirror([0,1,0])
//support();

module screw_assembly() {
    cylinder(h=wall+padd,d=screw);
    translate([0,0,wall*2])
    cylinder(h=batt_z+padd,d=screw_driver);
}

//rotate([0,-90,0])
difference() {
    translate([0,0,-outer_offset])
    scale([1,1,outer_scale])
    rotate([0,90,0])
    cylinder(h=batt_x,d=outer,$fn=200);

    // battery
    translate([-pad,-batt_y/2,-pad])
    cube([batt_x+padd,batt_y,batt_z+pad]);

    // disconnect
    translate([-pad,-batt_y/2-wall-pad,batt_side_h+wall])
    cube([batt_x+padd,batt_y+wall*2+padd,batt_z-batt_side_h-wall]);

    // flat bottom
    translate([-batt_x/2,-outer,-outer*2])
    cube([batt_x*2,outer*2,outer*2]);

    // flat top
    translate([-batt_x/2,-outer,batt_z+wall])
    cube([batt_x*2,outer*2,outer*2]);

    // big hole
    translate([batt_x/2,0,wall+batt_side_h])
    cylinder(h=batt_y+wall+padd,d=big_hole);

    difference() {
        translate([-pad,0,-outer_offset])
        scale([1,1,outer_scale])
        rotate([0,90,0])
        cylinder(h=batt_x+padd,d=outer-wall*2);
        translate([-pad,-batt_y/2-wall,0])
        cube([batt_x+padd,batt_y+wall*2,batt_z*2]);
        translate([-batt_x/2,-outer,-outer*2+wall])
        cube([batt_x*2,outer*2,outer*2]);
        translate([-batt_x/2,-outer,batt_z])
        cube([batt_x*2,outer*2,outer*2]);
    }
    
    translate([screw_offset,batt_y/2+screw_offset,-pad])
    screw_assembly();
    translate([screw_offset,-batt_y/2-screw_offset,-pad])
    screw_assembly();
    translate([batt_x-screw_offset,batt_y/2+screw_offset,-pad])
    screw_assembly();
    translate([batt_x-screw_offset,-batt_y/2-screw_offset,-pad])
    screw_assembly();
}

