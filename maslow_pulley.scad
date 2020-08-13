in=25.4;
rail_x=150;
rail_y=1.5*in;
rail_z=3.5*in;

rail_angle=15;

rope=6;


pulley_od=13.5;
pulley_id=10;

pulley_bolt=4;
pulley_h=7.5;

screw=5.5;
screw_head=10;


guide=pulley_od+rope*2;
guide_h=5;

mount_wall=3;
mount_x=80;
mount_y=rail_y+mount_wall*2;
mount_z=rail_z/2;
mount_front_z=mount_wall;
pad=0.1;

// how high the rope is on the rail
rope_h=20;
// how far rope is from rail
rope_offset=1;

$fn=90;

function segment_radius(height, chord) = (height/2)+(chord*chord)/(8*height);

module assembled() {
    color("tan")
    place_rail()
    rail();

    color("white")
    rope();

    color("gray")
    place_pulley()
    pulley();

    part();

}

module carve_rope(z=0) {
    place_pulley(z)
    translate([-mount_x*1.5,pulley_h/2,pulley_h/2])
    rotate([0,90])
    cylinder(d=pulley_h,mount_x*3);
    
}

part();

swing=10;


module screw() {
    cylinder(d=screw,h=mount_wall*3,center=true);
    translate([0,0,-guide-mount_wall*1.2])
    cylinder(d=screw_head,h=guide);

}
module part() {
    difference() {
        positive();

        translate([0,-pulley_h/2,-1])
        rail();

        hull(){
            carve_rope();
            translate([0,0,guide])
            carve_rope();
        }

        hull(){
            carve_rope(-90-swing);
            translate([-guide,0,0])
            carve_rope(-90-swing);
        }
        
        place_pulley()
        cylinder(d=pulley_od+rope,h=pulley_h);

        // bolt hole
        place_pulley() cylinder(d=pulley_bolt,h=pulley_h*4,center=true);

        place_rail() rail(pad);

        place_rail()
        translate([mount_x/5,rail_y/2])
        screw();

        place_rail()
        translate([mount_x/5*4,rail_y/2])
        screw();

        place_rail()
        translate([mount_x/2,rail_y,mount_z/2])
        rotate([90,0,0])
        screw();

        //place_rail() translate([0,rail_y/2+6,mount_z/2+6]) rotate([0,90,0]) screw();
    }
}

module rail(padding=0) {
    cube([rail_x,rail_y+padding,rail_z]);
}

module rope(d=rope) {
    translate([-pulley_od/2,-rope/2-rope_offset])
    rotate([0,90])
    cylinder(d=d,rail_x);
}

module place_rail() {
    rotate([-rail_angle,0])
    translate([0,0,-rope_h])
    children();
}

module positive() {
    hull() {
        place_pulley()
        guide();
        place_rail()
        mount();
    }
}

module place_pulley(z=0) {
    translate([-pulley_od/2,pulley_h/2-rope/2-rope_offset,-pulley_id/2-rope/2])
    rotate([90,z,0])
    children();
}

module pulley() {
    r = segment_radius((pulley_od-pulley_id)/2,pulley_h);
    rotate_extrude()
    difference() {
        translate([pulley_bolt/2,0])
        square([pulley_od/2-pulley_bolt/2,pulley_h]);
        translate([r+pulley_id/2,pulley_h/2])
        circle(r=r);
    }
}

module guide() {
    translate([0,0,-guide_h])
    cylinder(d=guide,h=guide_h);
    translate([0,0,pulley_h])
    cylinder(d=guide,h=guide_h);
}

module mount() {
    translate([-mount_wall,-mount_wall,-mount_wall])
    cube([mount_x,mount_wall,mount_front_z]);
    translate([-mount_wall,mount_y-mount_wall*2,-mount_wall])
    cube([mount_x,mount_wall,mount_z]);
}

assembled();
part();
//pulley();
//guide();
