batt_x=140;
batt_y=68;
batt_z=25;
$fn=90;

max_y=130;

pad=0.1;
padd=pad*2;

outer=max_y;
outer_offset=0;
outer_scale=0.52;
wall=3;

big_hole=max_y-20;

screw=3;
screw_offset=(max_y-batt_y)/4;
nut=6;
nut_h=1.5;

module screw_assembly() {
    cylinder(h=wall+padd,d=screw);
    translate([0,0,wall-nut_h+pad])
    cylinder(h=nut_h+pad,d=nut,$fn=6);
}

difference() {
    translate([0,0,-outer_offset])
    scale([1,1,outer_scale])
    rotate([0,90,0])
    cylinder(h=batt_x,d=outer,$fn=200);
    translate([-pad,-batt_y/2,-pad])
    cube([batt_x+padd,batt_y,batt_z+pad]);
    translate([-batt_x/2,-outer,-outer*2])
    cube([batt_x*2,outer*2,outer*2]);

    translate([-batt_x/2,-outer,batt_z+wall])
    cube([batt_x*2,outer*2,outer*2]);

    translate([batt_x/2,0,-pad])
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
