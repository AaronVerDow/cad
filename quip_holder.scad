shelf_y=85;
shelf_z=195;

shelf_wall=1;
shelf_x=300;
pad=0.1;

quip=16;
quip_h=190;
tip_wall=1; // wall for tip
quip_wall=3; // wall for side to side

quip_total=190;

aaa=11;
aaa_h=42.5;
aaa_grip=15;
aaa_angle=10;

brush_angle_start=21;
brush_angle=23;
brush_steps=0.1;
brush_axis=280;

big_fn=400;

module shelf() {
    translate([-shelf_x/2,-shelf_y])
    difference() {
        translate([0,0,-shelf_wall])
        cube([shelf_x,shelf_y+shelf_wall,shelf_z+shelf_wall*2]);
        translate([-pad*2,-pad,-pad])
        cube([shelf_x+pad*4,shelf_y+pad*2,shelf_z]);
    }
}

color("silver")
shelf();

module quip() {
    translate([0,-tip_wall-quip/2,quip/2+tip_wall])
    rotate([brush_angle_start,0])
    translate([0,-brush_axis,0])
    for(x=[0:brush_steps:brush_angle])
    rotate([x,0])
    translate([0,brush_axis])
    union() {
        sphere(d=quip);
        cylinder(d=quip,h=quip_h-quip/2);
    }
}

module negative() {
    quip();

    rotate([aaa_angle,0])
    translate([0,0,shelf_y-aaa_h+aaa_grip])
    cylinder(d=aaa,h=aaa_h);
}


module positive() {
    intersection() {
        rotate([0,90])
        cylinder(r=shelf_y,h=quip+quip_wall*2,$fn=big_fn,center=true);
        translate([-shelf_x/2,-shelf_y-pad])
        cube([shelf_x,shelf_y+pad,shelf_z]);
    }
}

module unit() {
    difference() {
        positive();
        negative();
    }
}


middle_gap=10;

// RENDER stl
module units() {
    unit();
    translate([quip+quip_wall*2,0])
    unit();
}

units();
