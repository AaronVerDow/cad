// https://github.com/nophead/NopSCADlib
include <NopSCADlib/core.scad>;
include <NopSCADlib/vitamins/sk_brackets.scad>;
include <NopSCADlib/vitamins/rod.scad>;
include <NopSCADlib/vitamins/kp_pillow_blocks.scad>;
include <NopSCADlib/vitamins/scs_bearing_blocks.scad>;
include <NopSCADlib/vitamins/leadnuts.scad>;

use <maslow_ingot_mount.scad>;
use <../hose_couplers.scad>;

show_threads=false; // shows the lead screw or not, no impact on output 
base=500; // diameter of sled

in=25.4;


router=92;
router_body_h=130;
chuck=40;
chuck_h=30;
bit=in/4;
bit_h=30;
cap=110;
cap_h=50;

router_to_sled=21.75;


window=120; // meticulous Z

function chord(h,r) = sqrt(8*h*(r-h/2));

sk=SK8;
pillow=KP08_18;
scs=SCS8UU;
scs_gap=103; // meticulous Z
rod_gap=160; // meticulous Z
sled_x=rod_gap+scs[4];
sled_y=scs_gap+scs[5];

max_travel=100;
travel=sin($t*360)*max_travel/2;


zero=0.0001;

box_wood=in/4;
base_wood=box_wood;

wood=in/2;
sled_wood=wood;

box_h=1.5*in-base_wood;


dust_wood=in/2;
dust=160;
dust_max=chord(base/2-window/2-dust_wood,base/2);
dust_x=dust_max/2+window/2;

tower_wood=in/2;
tower=base/2-tower_wood-sk[2]-scs[2]-sled_wood-router/2-router_to_sled;
tower_h=355; // meticulous Z
tower_x=chord(tower,base/2);

tower_top=dust+dust_wood*2;

hb=base/2+window/2+box_wood+30;

// angle brace 
ab_adj=base-tower-tower_wood;
ab_opp=tower_x/2;
ab_dlt=atan(ab_opp/ab_adj);
ab=sqrt((ab_adj*ab_adj)+(ab_opp*ab_opp));
ab_x_offset=20;
ab_less=40;

//sk_bracket(SK8);

rod_h=300; // meticulous Z
rod=8;

bracket_gap=rod_h-20;
pillow_gap=rod_h/5*4;

ring_top=122;
ring_side=[115.655,43.679];
ring_side_angle=60;
support_h=70;
support=40;


dust_tower=tower-(base-dust_max)/2;
dust_angle=atan(dust_tower/tower_h);
outlet_wood=in/4;

outlet_x=dust+dust_wood*2;
outlet_y=125;

support_wood=in/2;
support_w=support*3;
support_brace=100;
support_brace_ramp=support_brace/2;


show_labels=false;

module assembled() {
    weights();

    place_outlet() {
        outlet_magnets();
        outlet_3d();
        label("outlet");
    }

    ring();

    place_supports() support_and_brace();

    router();

    place_rails() rails();

    top_3d();
    base_3d();
    tower_3d();

    angle_brace_3d();

    horizontal_brace_3d();

    dust_3d();

    place_sled() sled_3d();
}

//rotate([0,0,$t*360])
assembled();

module label(text) {
    if(show_labels)
    text(text,valign="center",halign="center");
}

module weights() {
    dirror_x()
    translate([-dust/2-dust_wood,tower-base/2,0])
    rotate([0,0,180])
    ingot_assembled();
}

module place_outlet() {
    translate([0,outlet_wood-dust_max/2])
    rotate([90-dust_angle,0])
    translate([0,outlet_y/2,outlet_wood]) 
    children();
}

module outlet_3d() {
    color("tan")
    translate([0,0,-outlet_wood])
    linear_extrude(height=outlet_wood)
    outlet();
}

// RENDER scad
module outlet() {
    difference() {
        square([outlet_x,outlet_y],center=true);
        circle(d=4*in);
    }
}

module outlet_magnets() {
    color("maroon")
    my_z();
}

module ring() {
    color("dimgray")
    translate([-29.5,5.9,support_h-24])
    import("Ring.stl");
}

module support() {
    square([support,support_h],center=true);
    translate([0,box_h/2-support_h/2])
    square([support_w,box_h-box_wood],center=true);
}

module support_brace() {
    hull() {
        square([zero,support_h]);
        square([support_brace_ramp,box_h]);
    }
    square([support_brace,box_h-box_wood]);
}

module support_and_brace() {
    color("saddlebrown")
    rotate([90,0])
    linear_extrude(height=support_wood)
    support();

    color("sienna")
    translate([-support_wood/2,0,-support_h/2])
    rotate([90,0,90])
    linear_extrude(height=support_wood)
    support_brace();
}

module place_supports() {
    translate([0,support_wood+ring_top,support_h/2])
    children();

    dirror_x()
    translate(-ring_side)
    rotate([0,0,180-ring_side_angle])
    translate([0,support_wood,support_h/2])
    children();
}

module dirror_y() {
    children();
    mirror([0,1])
    children();
}

module router() {
    translate([0,0,tower_h/2-sled_y/2+box_h/2-20+travel]) {
        color("orangered")
        translate([0,0,router_body_h])
        cylinder(d=cap,h=cap_h);

        color("gray")
        cylinder(d=router,h=router_body_h);

        color("silver")
        translate([0,0,-chuck_h])
        cylinder(d=chuck,h=chuck_h,$fn=6);

        color("rosybrown")
        translate([0,0,-chuck_h-bit_h])
        cylinder(d=bit,h=bit_h);
    }
}

module rails() {

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



module sled_3d() {
    color("tan")
    translate([0,0,-sled_wood])
    linear_extrude(height=sled_wood)
    sled();

    // https://www.thingiverse.com/thing:4390396/files
    CE3_y=60;
    CE3_z=33.8;
    color("maroon")
    translate([0,sled_y/2,CE3_z])
    rotate([90,0,0])
    import("CE3_Part_1.stl");

    color("maroon")
    translate([0,sled_y/2,CE3_z+60])
    rotate([90,0,0])
    import("CE3_Part_2.stl");

    dirror_y()
    dirror_x()
    translate([rod_gap/2,-scs_gap/2,-sled_wood-scs[2]])
    rotate([-90,0,0])
    scs_bearing_block(scs);

    color("gold")
    translate([0,21-sled_y/2,-sled_wood-sk[2]-scs[2]+pillow[2]])
    rotate([90,45,0])
    leadnut(LSN8x2);

    translate([0,-sled_y/2,-sled_wood])
    rotate([-90,0,0])
    color("maroon")
    import("lead_screw_nut_block.stl"); // https://www.thingiverse.com/thing:4050066
}

module place_sled() {
    place_rails()
    translate([0,-travel,sk[2]+scs[2]+sled_wood])
    children();
}

module sled() {
    square([sled_x,sled_y],center=true);
}


module place_rails() {
    translate([0,tower-base/2+tower_wood,box_h+(tower_h-box_h)/2])
    rotate([-90,0,0])
    children();
}

module base() {
    difference() {
        circle(d=base);
        circle(d=window);
    }
}

module top() {
    difference() {
        circle(d=base);
        circle(d=window);
        translate([0,tower/2-base/2])
        square([base,tower],center=true);

    }
}

module top_3d() {
    color("tan")
    translate([0,0,box_h-box_wood])
    linear_extrude(height=box_wood)
    top();
}

module base_3d() {
    //translate([0,0,-base_wood])
    //linear_extrude(height=base_wood)
    //base();

    color("white")
    rotate_extrude()
    difference() {
        hull() {
            translate([base/2-base_wood,0])
            circle(base_wood);
            translate([window/2+base_wood,0])
            circle(base_wood);
        }
        square([base,base_wood*2]);
    }
}

module tower_3d() {
    color("bisque")
    translate([0,tower_wood-base/2+tower,tower_h/2])
    rotate([90,0])
    linear_extrude(height=tower_wood)
    tower();
}

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

module horizontal_brace_3d() {
    color("chocolate")
    translate([0,hb-base/2,box_h/2])
    rotate([90,0])
    linear_extrude(height=box_wood)
    horizontal_brace();
} 

module angle_brace() {
    square([ab-ab_less,box_h],center=true);
}

module dirror_x() {
    children();
    mirror([1,0])
    children();
}

module angle_brace_3d() {
    color("chocolate")
    dirror_x()
    translate([0,base/2])
    rotate([0,0,ab_dlt-90])
    translate([ab/2,ab_x_offset,box_h/2])
    rotate([90,0])
    linear_extrude(height=box_wood)
    angle_brace();
}


module dust_3d() {
    color("sienna")
    dirror_x()
    translate([dust/2,dust_x/2-dust_max/2,box_h/2])
    rotate([90,0,90])
    linear_extrude(height=dust_wood)
    dust();
}

// RENDER scad
module dust() {
    translate([tower-tower/2,0])
    square([dust_x-tower,box_h],center=true);

    hull() {
        translate([dust_tower-dust_x/2+tower_wood/2,tower_h/2-box_h/2])
        square([tower_wood,tower_h],center=true);

        translate([dust_tower/2-dust_x/2,-box_h/2])
        square([dust_tower,zero],center=true);
    }
}


ingot_height=40;
ingot_angle=15;
ingot_top_x=35;
ingot_top_y=99;

ingot_tree=65;
ingot_tree_h=8;
ingot_tree_w=10;

ingot_base_x = ingot_height*tan(ingot_angle)*2+ingot_top_x;
ingot_base_y = ingot_height*tan(ingot_angle)*2+ingot_top_y;

echo("base");
echo(ingot_base_x);
echo(ingot_base_y);


// how high the actual part is
grip_h=17;

pad=0.1;
bolt=6;

big_fn=400;

bolt_head=11;
bolt_head_h=1;
bolt_head_taper=3;

maslow_support=dust+dust_wood*2;
strap=3;
wall=strap;

module ingot(pad=0) {
    slice=0.0001;
    hull() {
        translate([0,0,-pad/2])
        cube([ingot_base_x,ingot_base_y,slice+pad],center=true);
        translate([0,0,ingot_height])
        cube([ingot_top_x,ingot_top_y,slice],center=true);
    }
}


module trim() {
    intersection() {
        cylinder(d=base,h=tower_h,$fn=big_fn);
        children();
    }
}

module place_corner() {
    rotate([0,0,180])
    translate([maslow_support/2,base/2-tower,0])
    children();
}

module placed_ingot_vertical() {
    translate([ingot_base_x/2+wall,ingot_base_y/2+wall,-pad])
    color("gray")
    ingot();
}

module placed_ingot_horizontal() {
    color("gray")
    translate([ingot_base_y/2,ingot_base_x/2])
    rotate([0,0,90])
    ingot();
}


module place_ingot() {
    angle=-45;
    hyp = ingot_base_x/2;
    x = cos(angle)*hyp;
    y = sin(angle)*hyp;

    color("gray")
    translate([x,-y])
    rotate([0,0,angle])
    translate([0,ingot_base_y/2])
    children();
}

module blank() {
    intersection() {
        place_corner()
        translate([0,0,-pad])
        cylinder(d=base,h=tower_h+pad*2,$fn=big_fn);
        cube([base,base,grip_h]);
    }
    intersection() {
        minkowski() {
            place_ingot()
            ingot();
            cylinder(r=strap,h=0.1);
        }
        cube([base,base,grip_h]);
    }
}

module bolt() {
    translate([0,0,-pad])
    cylinder(d=bolt,h=grip_h+pad*2);

    hull() {
        translate([0,0,grip_h-bolt_head_h])
        cylinder(d=bolt_head,h=bolt_head_h+pad);
        translate([0,0,grip_h-bolt_head_taper])
        cylinder(d=bolt,h=bolt_head_taper);
    }
}

module bolts() {
    n=13;
    translate([n,n])
    bolt();
    translate([n,75])
    bolt();
    translate([90,n])
    bolt();
}

module part() {
    color("maroon")
    difference() {
        blank();
        place_ingot()
        ingot(pad);
        place_ingot()
        ingot_tree(pad*2);
        bolts();
    }
}

module ingot_tree(pad=0) {
    translate([0,0,ingot_tree_h/2-pad/2])
    cube([ingot_base_x+ingot_tree_w*2,ingot_tree,ingot_tree_h+pad],center=true);
}

module ingot_assembled() {
    place_ingot() { ingot(); ingot_tree(); }
    part();
}
