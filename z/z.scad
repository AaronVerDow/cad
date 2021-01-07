base=500;

// https://www.thingiverse.com/thing:4390396/files
// import("CE3_Part_1.stl");
// import("CE3_Part_2.stl");
window=120;

function chord(h,r) = sqrt(8*h*(r-h/2));


in=25.4;

zero=0.0001;

box_wood=in/4;
base_wood=box_wood;

wood=in/2;

box_h=1.5*in;


dust_wood=in/2;
dust=window;
dust_max=chord(base/2-window/2-dust_wood,base/2);
dust_x=dust_max/2+window/2;

tower=120;
tower_h=250;
tower_wood=in/2;
tower_x=chord(tower,base/2);

tower_top=dust+dust_wood*2;

$fn=200;

hb=base/2+window/2+box_wood+30;

// angle brace 
ab_adj=base-tower-tower_wood;
ab_opp=tower_x/2;
ab_dlt=atan(ab_opp/ab_adj);
ab=sqrt((ab_adj*ab_adj)+(ab_opp*ab_opp));

// https://github.com/nophead/NopSCADlib
// SK bracket
// SCS bearing blocks
include <NopSCADlib/core.scad>;
include <NopSCADlib/vitamins/sk_brackets.scad>;
include <NopSCADlib/vitamins/rod.scad>;
include <NopSCADlib/vitamins/kp_pillow_blocks.scad>;

//sk_bracket(SK8);

rod_h=200;
rod=8;
rod_gap=120;

bracket_gap=rod_h/3*2;
pillow_gap=rod_h/5*4;

ring_top=122;
ring_side=[115.655,43.679];
ring_side_angle=60;
support_h=70;
support=40;

color("dimgray")
translate([-29.5,5.9,support_h-24])
import("Ring.stl");

support_wood=in/2;
support_w=support*3;

module support() {
    square([support,support_h],center=true);
    translate([0,box_h/2-support_h/2])
    square([support_w,box_h],center=true);
}

support_brace=100;
support_brace_ramp=support_brace/2;

module support_brace() {
    hull() {
        square([zero,support_h]);
        square([support_brace_ramp,box_h]);
    }
    square([support_brace,box_h]);
}

module support_and_brace() {
    color("blue")
    rotate([90,0])
    linear_extrude(height=support_wood)
    support();

    color("red")
    translate([-support_wood/2,0,-support_h/2])
    rotate([90,0,90])
    linear_extrude(height=support_wood)
    support_brace();
}


translate([0,support_wood+ring_top,support_h/2])
support_and_brace();

dirror_x()
translate(-ring_side)
rotate([0,0,180-ring_side_angle])
translate([0,support_wood,support_h/2])
support_and_brace();

module dirror_y() {
    children();
    mirror([0,1])
    children();
}

module rails() {
    sk=SK8;
    pillow=KP08_18;
    dirror_x()
    dirror_y()
    translate([rod_gap/2,bracket_gap/2,sk[2]])
    rotate([90,0])
    sk_bracket(sk);

    dirror_y()
    translate([0,pillow_gap/2,pillow[2]])
    rotate([90,0])
    kp_pillow_block(pillow);

    translate([0,0,pillow[2]])
    rotate([90,0,0])
    leadscrew(rod,rod_h,8,4);

    dirror_x()
    translate([rod_gap/2,0,sk[2]])
    rotate([90,0,0])
    rod(rod,rod_h);

}

translate([0,tower-base/2+tower_wood,box_h+(tower_h-box_h)/2])
rotate([-90,0,0])
rails();

module base() {
    difference() {
        circle(d=base);
        circle(d=window);
    }
}

module box_top() {
    difference() {
        circle(d=base);
        circle(d=window);
        translate([0,tower/2-base/2])
        square([dust,tower],center=true);
    }
}

#translate([0,0,box_h-box_wood])
linear_extrude(height=box_wood)
box_top();

color("white")
linear_extrude(height=base_wood)
base();


color("purple")
translate([0,tower_wood-base/2+tower,tower_h/2])
rotate([90,0])
linear_extrude(height=tower_wood)
tower();


module tower() {
    difference() {
        hull() {
            translate([0,box_h/2-tower_h/2])
            square([tower_x,box_h],center=true);
            square([tower_top,tower_h],center=true);
        }
        translate([0,box_h/2-tower_h/2])
        square([dust,box_h],center=true);
    }
}



module horizontal_brace() {
    square([chord(hb,base/2),box_h],center=true);
}

color("lime")
translate([0,hb-base/2,box_h/2])
rotate([90,0])
linear_extrude(height=box_wood)
horizontal_brace();

module angle_brace() {
    square([ab-ab_less,box_h],center=true);
}

module dirror_x() {
    children();
    mirror([1,0])
    children();
}

ab_x_offset=20;
ab_less=40;

color("lime")
dirror_x()
translate([0,base/2])
rotate([0,0,ab_dlt-90])
translate([ab/2,ab_x_offset,box_h/2])
rotate([90,0])
linear_extrude(height=box_wood)
angle_brace();


color("green")
dirror_x()
translate([window/2,dust_x/2-dust_max/2,box_h/2])
rotate([90,0,90])
linear_extrude(height=dust_wood)
dust();

dust_tower=tower-(base-dust_max)/2;

module dust() {
    square([dust_x,box_h],center=true);

    hull() {
        translate([dust_tower-dust_x/2+tower_wood/2,tower_h/2-box_h/2])
        square([tower_wood,tower_h],center=true);

        translate([dust_tower/2-dust_x/2,0])
        square([dust_tower,box_h],center=true);
    }
}
