use <joints.scad>;
in=25.4;
zero=0.001;
pad=0.1;

bit=in/4;

beam_h=3.5*in;
beam_w=1.5*in;


overhang=5*in;  // how far back from beam

gap=4*in; // how far apart the weights should be

rope=5; // how thick the rope is

beam_pulley=8; // how far the center of rope is from base of beam

back_pulley=1.5*in+rope; // diameter of back pulley to center of rope

pulley_hole=bit*1.1;

wood=in/2;

adj=overhang;
opp=beam_h/2+beam_pulley+back_pulley/2;

angle=atan(opp/adj);

brace=overhang;
brace_over_pulley=wood;
slot=brace/3;


module place_pulley() {
    translate([overhang,-back_pulley/2-beam_pulley])
    children();
}

module hanger() {
    difference() {
        hull() {
            square([zero,beam_h]);
            place_pulley()
            circle(d=back_pulley);
        }
        place_pulley()
        circle(d=pulley_hole);
        slot();
    }
}

module hanger_3d() {
    linear_extrude(height=wood)
    hanger();
}

translate([0,0,gap-wood])
hanger_3d();
hanger_3d();

module dirror_y(y=0) {
    children();
    translate([0,y])
    mirror([0,1])
    children();
}
module dirror_x(x=0) {
    children();
    translate([x,0])
    mirror([1,0])
    children();
}

module brace() {
    square([brace,gap-wood*2],center=true);
    square([slot,gap],center=true);
}

color("cyan")
place_pulley()
rotate([0,0,-angle])
translate([brace_over_pulley-brace/2,0,gap/2])
rotate([90,0])
linear_extrude(height=wood,center=true)
brace();
module slot() {
    place_pulley()
    rotate([0,0,180-angle])
    translate([brace/2-slot/2-brace_over_pulley,-wood/2])
    dirror_x(slot)
    dirror_y(wood)
    negative_slot(wood,slot,bit);
}
