// https://github.com/nophead/NopSCADlib
include <NopSCADlib/core.scad>;
include <NopSCADlib/vitamins/sk_brackets.scad>;
include <NopSCADlib/vitamins/rod.scad>;
include <NopSCADlib/vitamins/kp_pillow_blocks.scad>;
include <NopSCADlib/vitamins/scs_bearing_blocks.scad>;
include <NopSCADlib/vitamins/leadnuts.scad>;

use <maslow_ingot_mount.scad>;
use <joints.scad>;
use <../hose_couplers.scad>;

in=25.4;
box_wood=in/4;
base_wood=box_wood;
box_h=1.5*in-base_wood;
show_threads=true; // shows the lead screw or not, no impact on output 
//base=500; // diameter of sled
base=450; // diameter of sled
top=base+box_h*2;;

//window=120; // meticulous Z
window=95; // meticulous Z
dust_wood=in/2;
top_window=window+dust_wood; 

//tower_h=355; // meticulous Z
tower_h=205; // meticulous Z
//rod_h=300; // meticulous Z
rod_h=tower_h; // meticulous Z
//scs_gap=103; // meticulous Z
scs_gap=90; // meticulous Z
//leadscrew_h=rod_h; //meticulous Z
leadscrew_h=120;
//dust=160; //meticulous Z 
dust=window; //meticulous Z 

bit=in/4;

router=92;
router_body_h=110;

bit_h=35;
chuck=24;
chuck_h=27;
cap=100;
cap_h=88;
spindle=20;
spindle_h=12;
collet=15;
collet_h=3;

beam_max=base/2-40;
beams=5;
beam_gap=(beam_max*2)/(beams-1);


router_to_sled=21.75;



function chord(h,r) = sqrt(8*h*(r-h/2));

sk=SK8;
pillow=KP08_18;
scs=SCS8UU;
rod_gap=160; // meticulous Z
sled_x=rod_gap+scs[4];
sled_y=scs_gap+scs[5];

max_travel=40;
travel=(sin($t*360)/2+0.5)*max_travel;


zero=0.0001;


wood=in/2;
sled_wood=wood;




tower_wood=in/2;
tower=base/2-tower_wood-sk[2]-scs[2]-sled_wood-router/2-router_to_sled;
tower_x=chord(tower,base/2);
tower_top_x=chord(tower+tower_wood,base/2);

tower_top=dust+dust_wood*2;

hb=base/2+window/2+box_wood+30;

// angle brace 
ab_adj=base-tower-tower_wood;
ab_opp=tower_x/2;
ab_dlt=atan(ab_opp/ab_adj);
ab=sqrt((ab_adj*ab_adj)+(ab_opp*ab_opp));
ab_x_offset=20;
ab_less=40;
ab_x=ab-ab_less;

//sk_bracket(SK8);

rod=8;

bracket_gap=rod_h-20;

ring_top=122;
ring_side=[115.655,43.679];
ring_side_angle=60;
support_h=75;
support=40;


outlet_wood=in/4;

outlet_x=dust+dust_wood*2;
outlet_y=112;

support_wood=in/2;
support_w=support*7;
support_brace=80;
support_brace_ramp=support_brace/2;

show_labels=false;

include_horizontal_brace=false;
include_angled_brace=false;
old_braces=false;

tower_dust_pins=2;
dust_box_pins=1;
dust_max=chord(top/2+dust/2+dust_wood/2,top/2);
dust_tower=dust_max/2-base/2+tower;
//dust_angle=atan((tower_h-box_h)/dust_tower);
dust_angle=75;
dust_tower_min=tower_wood*2;

dust_clip=sk[2]+scs[2];
outlet_adj=cos(dust_angle)*outlet_y;
outlet_opp=sin(dust_angle)*outlet_y;
ramp_adj=dust_clip+tower_wood;
chute_adj=ramp_adj+tower-outlet_adj;
chute_opp=outlet_opp-box_h;
ramp_angle=atan(chute_opp/chute_adj);
chute_angle=ramp_angle;
chute_hyp=chute_opp/sin(chute_angle);
ramp_opp=tan(ramp_angle)*ramp_adj;

module assembled(travel=max_travel/2) {
    weights();
    //rotate([0,0,-54]) translate([base/2-ingot_base_x/2+20,0]) color("gray") ingot();

    place_outlet() {
        outlet_magnets();
        outlet_3d();
        label("outlet");
    }

    ring();

    if(old_braces)
    place_supports() support_and_brace();

    place_router(travel) router();
    //place_router(0) router();
    //place_router(max_travel) router();

    place_rails() rails();

    top_3d();
    //base_3d();
    tower_3d();


    if(include_horizontal_brace)
    angle_brace_3d();

    if(include_horizontal_brace)
    horizontal_brace_3d();

    dust_3d();

    place_sled(travel) sled_3d();
    //place_sled(0) sled_3d();
    //place_sled(max_travel) sled_3d();

    z_bracket();
}

assembled(max_travel);

// ENDER gif
module spin() {
    rotate([0,0,$t*360])
    assembled();
}

skid_angle=55;
skid_grip=(base-top_window)/2-30;
skid_h=box_h;
skid_overhang=tan(skid_angle)*skid_h;
skid_wood=box_wood;
skid_offset=6;
skid_range=240;
skids=10;
skid_gap=skid_range/(skids-1);


module skids() {
    for(z=[0:skid_gap:skid_range])
    rotate([0,0,-30+z])
    translate([base/2,skid_wood/2])
    rotate([90,0])
    linear_extrude(height=skid_wood)
    skid();
}

// RENDER scad
module skid() {
    difference() {
        hull() {
            translate([-skid_grip,0])
            square([skid_grip+skid_offset,box_h]);
            translate([0,skid_h-zero])
            square([skid_overhang+skid_offset,zero]);
        }
        translate([-skid_grip,box_h])
        square([skid_grip,skid_h]);
    }
}

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

module outlet_3d() {
    color("tan")
    translate([0,0,-outlet_wood])
    linear_extrude(height=outlet_wood)
    outlet();
}

outlet_pins=2;
pintail_gap=in/64;
pintail_hole=in/8;
pintail_ear=bit;
pintail_extra=0;

module my_negative_tails(edge,depth,pins,hole=1) {
    negative_tails(edge,depth,pins,pintail_gap,pintail_hole*hole,pintail_ear,pintail_extra);
}

module my_negative_pins(edge,depth,pins,hole=1) {
    negative_pins(edge,depth,pins,pintail_gap,pintail_hole*hole,pintail_ear,pintail_extra);
}

module outlet() {
    difference() {
        square([outlet_x,outlet_y],center=true);
        circle(d=4*in);
        dirror_x()
        translate([-outlet_x/2-pad,-outlet_y/2])
        my_negative_tails(outlet_y,dust_wood+pad,outlet_pins);
    }
}

module outlet_magnets() {
    color("maroon")
    rotate([0,0,360/6])
    my_z();
}

module ring() {
    color("dimgray")
    translate([-29.5,5.9,support_h-24])
    import("Ring.stl");
}

module z_bracket() {
    color("dimgray")
    translate([0,tower-base/2,tower_h])
    rotate([180,0])
    translate([-20,2,2])
    import("Z-Axis Bracket.stl");
}

module support() {
    square([support,support_h],center=true);
    translate([0,box_h/2-support_h/2-box_wood/2])
    square([support_w,box_h-box_wood],center=true);
}

module support_brace() {
    hull() {
        square([zero,support_h]);
        square([support_brace_ramp,box_h]);
    }
    square([support_brace,box_h-box_wood]);
}

// RENDER scad
module support_and_brace() {
    translate([0,0,support_h/2])
    color("saddlebrown")
    rotate([90,0])
    linear_extrude(height=support_wood)
    support();

    color("sienna")
    translate([-support_wood/2,0,0])
    rotate([90,0,90])
    linear_extrude(height=support_wood)
    support_brace();

}

module support_and_brace_hole() {
    translate([support/2,-support_wood])
    rotate([0,0,90])
    dirror_y(support)
    dirror_x(support_wood)
    negative_slot(support,support_wood,pintail_ear,pintail_extra);

    
    translate([-support_wood/2,0])
    dirror_x(support_wood)
    negative_slot(support_brace_ramp,support_wood,pintail_ear,pintail_extra);

}

module place_supports() {
    translate([0,support_wood+ring_top,0])
    children();

    dirror_x()
    translate(-ring_side)
    rotate([0,0,180-ring_side_angle])
    translate([0,support_wood,0])
    children();
}

module place_router(travel=max_travel/2) {
    translate([0,0,travel+collet_h+chuck_h+spindle_h-base_wood])
    children();
}
// RENDER scad
module router() {
    color("orangered")
    translate([0,0,router_body_h])
    cylinder(d=cap,h=cap_h);

    color("gray")
    cylinder(d=router,h=router_body_h);
    lock=25;
    lock_h=11;

    color("gray")
    intersection() {
        translate([chuck/2+4,-lock/2,-lock_h])
        cube([router,lock,lock_h]);
        translate([0,0,-lock_h*2])
        cylinder(d=router-pad*2,h=router_body_h);
    }

    translate([0,0,-spindle_h])
    cylinder(d=spindle,h=spindle_h);

    color("silver")
    translate([0,0,-chuck_h-spindle_h])
    cylinder(d=chuck,h=chuck_h,$fn=6);


    color("black")
    translate([0,0,-collet_h-spindle_h-chuck_h])
    cylinder(d=collet,h=collet_h);

    color("rosybrown")
    translate([0,0,-collet_h-spindle_h-chuck_h-bit_h])
    cylinder(d=bit,h=bit_h);
}

leadscrew=8;
leadscrew_overhang=20;
pillow_gap=(leadscrew_h-leadscrew_overhang)/5*4;

// RENDER scad
module rails() {

    dirror_x()
    translate([rod_gap/2,bracket_gap/2,sk[2]])
    rotate([90,0])
    sk_bracket(sk);

    dirror_x()
    translate([rod_gap/2,-16,sk[2]])
    rotate([90,0])
    sk_bracket(sk);

    dirror_x()
    translate([rod_gap/2,0,sk[2]])
    rotate([90,0,0])
    rod(rod,rod_h);

    rail_center=box_h+(tower_h-box_h)/2;

    //translate([0,rail_center+leadscrew_h/2-tower_h-leadscrew_overhang,0]) {
    translate([0,leadscrew_h/2-tower_h/2,0]) {

        translate([0,-leadscrew_overhang,pillow[2]])
        rotate([90,0,0])
        leadscrew(leadscrew,leadscrew_h,8,4);

        dirror_y()
        translate([0,pillow_gap/2,pillow[2]])
        rotate([90,0])
        kp_pillow_block(pillow);
    }


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

module place_sled(travel=max_travel/2) {
    place_rails()
    //translate([0,0,travel+collet_h+chuck_h+spindle_h-base_wood])
    //translate([0,sled_y/2-collet_h-chuck_h-spindle_h,sk[2]+scs[2]+sled_wood])
    translate([0,tower_h/2-sled_y/2+base_wood/2-collet_h-chuck_h-spindle_h-travel,sk[2]+scs[2]+sled_wood])
    children();
}

module sled() {
    square([sled_x,sled_y],center=true);
}


module place_rails() {
    translate([0,tower-base/2+tower_wood,tower_h/2])
    rotate([-90,0,0])
    children();
}

module base() {
    difference() {
        circle(d=base);
        circle(d=window);
    }
}

tower_top_pins=4;

// RENDER scad
module top() {
    difference() {
        circle(d=top);
        circle(d=top_window);

        translate([-top_window/2,-top_window/2])
        square([top_window,beam_gap+top_window/2-box_wood/2]);

        translate([0,tower/2-base/2-(top-base)/2+tower_wood/2])
        square([top,tower+(top-base)+tower_wood],center=true);

        translate([0,dust_clip/2-base/2+tower+tower_wood-pad])
        square([dust+dust_wood*2,dust_clip+pad],center=true);

        if(include_horizontal_brace)
        translate([hb_x/2,hb-base/2-box_wood])
        rotate([0,0,90])
        dirror_x(box_wood) 
        my_negative_tails(hb_x,box_wood,hb_top_pins,0);

        if(include_angled_brace)
        place_angle_brace()
        translate([ab_x/2,-box_wood])
        rotate([0,0,90]) 
        dirror_x(box_wood) 
        my_negative_tails(ab_x,box_wood,ab_top_pins,0);

        if(old_braces)
        place_supports() support_and_brace_hole();
    
        difference() {
            beam_slot();
            translate([0,-top/4])
            square([dust,top/2],center=true);
        }

        dirror_x()
        translate([dust/2,beam_gap])
        dirror_x(dust_wood)
        my_negative_tails(dust_max/2-beam_gap,dust_wood,1);
    }
}

module cross() {
    children();
    rotate([0,0,90])
    children();
}

module beam_slot() {
    for(y=[-beam_max:beam_gap:beam_max])
    for(x=[-beam_max:beam_gap:beam_max])
    translate([x,y])
    cross()
    dirror_x()
    dirror_y()
    translate([-box_wood/2,-beam_pin/2])
    negative_slot(beam_pin,box_wood,pintail_ear,pintail_extra);
}

module place_angle_brace() {
    dirror_x()
    translate([0,base/2])
    rotate([0,0,ab_dlt-90])
    translate([ab/2,ab_x_offset,0])
    children();
}

module angle_brace_3d() {
    color("chocolate")
    place_angle_brace()
    translate([0,0,box_h/2])
    rotate([90,0])
    linear_extrude(height=box_wood)
    angle_brace();
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

module beam_3d(n=0,x=0) {
    translate([0,n])
    rotate([90,0])
    linear_extrude(height=box_wood,center=true)
    beam(n,x);
}

for(y=[-beam_max:beam_gap:beam_max])
beam_3d(y,0);

rotate([0,0,90])
for(x=[-beam_max:beam_gap:beam_max])
beam_3d(x,1);

beam_tail=beam_gap/3*2;
beam_pin=beam_gap-beam_tail;

module beam_base(n=0) {

    my_base=base/2+base_wood/2;
    b=chord(my_base+n,my_base);
    t=chord(top/2+n,top/2);
    hull() {
        translate([-b/2,0])
        square([b,zero]);

        translate([-t/2,box_h-box_wood])
        square([t,box_wood]);
    }

}

// RENDER scad
module beam(n=beam_gap,y=1) {

    difference() {
        beam_base(n);
        for(y=[-beam_max-beam_gap/2:beam_gap:beam_max+beam_gap])
        translate([-beam_tail/2+y,box_h+pad])
        rotate([0,0,-90])
        dirror_y(beam_tail)
        negative_slot(beam_tail,box_wood+pad,pintail_ear,pintail_extra);

        if(y) {
            if(n > -dust/2 && n < dust/2) {
                translate([beam_gap-top,-pad])
                square([top,box_h+pad*2]);

            }
            translate([tower-top-base/2+tower_wood,-pad])
            square([top,box_h+pad*2]);
        } else {
            if(n < beam_gap) {
                translate([-dust/2,-pad])
                square([dust,box_h+pad*2]);
            }
            if(n < -base/2+tower )
            translate([-top/2,-pad])
            square([top,box_h+pad*2]);

        }
    }
}

tower_ramp_hole=ramp_opp;

// RENDER scad
module tower() {
    difference() {
        hull() {
            translate([0,box_h/2-tower_h/2]) square([tower_x,box_h],center=true);
            translate([0,-tower_h/2])
            beam_base(tower+tower_wood*1.5);
            square([tower_top,tower_h],center=true);
        }

        translate([0,box_h/2-tower_h/2+tower_ramp_hole/2])
        square([dust+dust_wood*2,box_h+tower_ramp_hole],center=true);

        dirror_x()
        translate([dust/2,-tower_h/2+box_h+tower_ramp_hole])
        dirror_x(dust_wood)
        my_negative_tails(tower_h-box_h-tower_ramp_hole,dust_wood,tower_dust_pins);


    }
}

hb_x=chord(hb,base/2);
hb_top_pins=4;

// RENDER scad
module horizontal_brace() {
    difference() {
        
        square([hb_x,box_h],center=true);
        translate([-hb_x/2,box_h/2+pad])
        rotate([0,0,-90])
        my_negative_pins(hb_x,box_wood+pad,hb_top_pins,0);
    }
}

module horizontal_brace_3d() {
    color("chocolate")
    translate([0,hb-base/2,box_h/2])
    rotate([90,0])
    linear_extrude(height=box_wood)
    horizontal_brace();
} 

ab_top_pins=3;

// RENDER scad
module angle_brace() {
    difference() {
        square([ab_x,box_h],center=true);
        translate([-ab_x/2,box_h/2+pad])
        rotate([0,0,-90])
        my_negative_pins(ab_x,box_wood+pad,ab_top_pins,0);
    }
}


module dust_3d() {
    dirror_x()
    translate([dust/2+dust_wood/2,0,0])
    rotate([90,0,90]) {
        color("sienna")
        difference() {
            linear_extrude(height=dust_wood,center=true)
            dust();
            translate([0,0,-dust_wood])
            linear_extrude(height=dust_wood)
            ramp_slot();
        }

        color("cyan")
        translate([0,0,-dust-dust_wood])
        linear_extrude(height=dust+dust_wood)
        ramp_slot();
    }


}

module place_outlet() {
    translate([0,-base/2,0])
    rotate([dust_angle,0])
    translate([0,outlet_y/2,0]) 
    children();
}

module place_dust_outlet() {
    //translate([-dust_max/2,box_h])
    translate([-base/2,0])
    rotate([0,0,dust_angle-90])
    children();
}


// RENDER scad
module dust() {
    difference() {
        union() {
            difference() { 
                // base
                beam_base(dust/2+dust_wood/2);
                
                // minus tower
                translate([-top-base/2+tower,-pad])
                square([top,box_h+pad*2]);
            }
            difference() {
                hull() {
                    // min tower
                    translate([tower-base/2,tower_h/2])
                    square([dust_tower_min,tower_h],center=true);
                    
                    // outlet
                    place_dust_outlet()
                    square([zero,outlet_y]);

                    // ramped back if(0) difference() { beam_base(dust/2+dust_wood/2); translate([tower-base/2,-pad]) square([top,box_h+pad*2]); }
                }
                // space for ramp
                translate([tower-base/2,0])
                square([tower_wood+pad,box_h+tower_ramp_hole+pad]);
            }
            
            hull() {
                // ramp 
                translate([tower-base/2+dust_clip+tower_wood,box_h])
                rotate([0,0,180-ramp_angle])
                square([chute_hyp,zero]);

                // below tower
                translate([-base/2+tower_wood,0]) // this is wrong
                square([tower,zero]);
            }
            

        }

        place_dust_outlet()
        translate([-pad,0])
        my_negative_pins(outlet_y,outlet_wood+pad,outlet_pins,0);

        translate([pad-base/2+tower+tower_wood,box_h+tower_ramp_hole,0])
        mirror([1,0])
        my_negative_pins(tower_h-box_h-tower_ramp_hole,tower_wood+pad,tower_dust_pins,0);

        translate([beam_gap,box_h+pad])
        rotate([0,0,-90])
        my_negative_pins(dust_max/2-beam_gap,box_wood+pad,1,0);

        translate([-base/2+tower+tower_wood+dust_clip,box_h+pad-box_wood])
        square([base/2-tower+beam_gap+pad-tower_wood-dust_clip,box_wood+pad]);
    
    }
}

ramp_h=in/8;

module ramp_slot(){
    translate([tower-base/2+dust_clip+tower_wood,box_h])
    rotate([0,0,180-ramp_angle])
    translate([0,-pad])
    square([chute_hyp-outlet_wood,ramp_h+pad]);
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
    translate([0,0,-pad*1.5])
    place_ingot() { ingot(); ingot_tree(); }
    part();
}
