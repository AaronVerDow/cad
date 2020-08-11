in=25.4;
use <joints.scad>;
whirlpool_x=(15+3/8)*in;
whirlpool_y=(13+3/4)*in;
whirlpool_z=(14.25)*in;

function segment_radius(height, chord) = (height/2)+(chord*chord)/(8*height);

gap=in/16;

counter_z=17.125*in;


balmuda_x=14.1*in;
balmuda_y=12.6*in;
balmuda_z=8.2*in;

balmuda_air_gap=3*in;

whirlpool_lift=counter_z-whirlpool_z;
balmuda_lift=counter_z-balmuda_z-balmuda_air_gap;

wood=in/2;

whirlpool_foot=(1+3/8)*in;
whirlpool_back_foot=5/8*in;
whirlpool_foot_gap=9.25*in;
whirlpool_foot_to_front=1.75*in;
whirlpool_front_to_back_foot=10.25*in;
whirlpool_d=whirlpool_x;

whirlpool_back_offset=in;

balmuda_foot=in;
balmuda_foot_x=(12+5/16)*in;
balmuda_foot_y=(8+7/16)*in;
balmuda_foot_to_front=1.5*in;

back_offset=balmuda_y-balmuda_foot_y-balmuda_foot_to_front-balmuda_foot+wood;

balmuda_front_offset=balmuda_foot_to_front-balmuda_foot/2;

side_offset=whirlpool_back_offset;
end_offset=balmuda_x/2-balmuda_foot_x/2-balmuda_foot/2;
front_offset=1*in;
$fn=200;

whirlpool_front_offset=in;


pad=0.1;

explode=in*0;

module dirror_x(x=0) {
    children();
    translate([x,0])
    mirror([1,0,0])
    children();
}

module dirror_y(y=0) {
    children();
    translate([0,y])
    mirror([0,1,0])
    children();
}

module place_balmuda() {
    translate([whirlpool_x,-balmuda_y,balmuda_lift])
    children();
}

module place_whirlpool() {
    translate([0,-whirlpool_y,whirlpool_lift])
    children();
}

module whirlpool_circle() {
    translate([whirlpool_x/2,whirlpool_y-whirlpool_x/2])
    circle(d=whirlpool_x-whirlpool_back_offset*2);
}

module whirlpool() {
    difference() {
        union() {
            translate([side_offset,whirlpool_front_offset])
            square([whirlpool_x+wood-side_offset,whirlpool_y-back_offset-whirlpool_front_offset]);
            difference() {
                // main square
                // square([whirlpool_x+wood,whirlpool_y]);

                // cut corner
                // translate([0,whirlpool_y-whirlpool_x/2])
                // square([whirlpool_x/2,whirlpool_x/2]);
            }
            intersection() {
                // big circle
                hull() {
                    whirlpool_circle();
                    translate([0,-whirlpool_y])
                    whirlpool_circle();
                }

                // main square
                translate([0,whirlpool_front_offset])
                square([whirlpool_x+wood,whirlpool_y-whirlpool_front_offset]);
            }
        }
        translate([side_offset,whirlpool_front_offset])
        negative_tails(whirlpool_y-back_offset-whirlpool_front_offset,wood,2,gap);

        translate([whirlpool_x,whirlpool_front_offset])
        negative_tails(whirlpool_y-back_offset-whirlpool_front_offset,wood,2,gap);

        //translate([whirlpool_x/4,whirlpool_y-back_offset])
        //rotate([0,0,-90])
        //#negative_tails(whirlpool_x/2,wood,1,gap);

        translate([whirlpool_x,whirlpool_y-back_offset-wood-gap])
        square([wood,wood+gap]);

    }
}

module whirlpool_pocket() {
    // front feet
    dirror_x(whirlpool_x)
    translate([whirlpool_x/2-whirlpool_foot_gap/2,whirlpool_foot_to_front])
    circle(d=whirlpool_foot);

    // back foot
    translate([whirlpool_x/2,whirlpool_front_to_back_foot+whirlpool_foot_to_front])
    circle(d=whirlpool_back_foot);
}

module balmuda_feet() {
    translate([balmuda_x/2,balmuda_foot_y/2+balmuda_foot_to_front])
    dirror_x()dirror_y()
    translate([-balmuda_foot_x/2,-balmuda_foot_y/2])
    children();
}

module balmuda() {
    difference() {
        //square([balmuda_x,balmuda_y]);
        
        translate([0,balmuda_foot_to_front-balmuda_foot/2])
        square([balmuda_foot_x/2+balmuda_x/2+balmuda_foot/2,balmuda_foot_y+balmuda_foot]);
        //hull() {
            //balmuda_feet()
            //circle(d=balmuda_foot);
            //translate([0,balmuda_foot_to_front-balmuda_foot/2])
            //square([wood,balmuda_foot_y+balmuda_foot]);
        //}


        translate([0,balmuda_foot_to_front-balmuda_foot/2])
        negative_tails(balmuda_foot_y+balmuda_foot,wood,2,gap);

        translate([balmuda_x-end_offset-wood,balmuda_foot_to_front-balmuda_foot/2])
        negative_tails(balmuda_foot_y+balmuda_foot,wood+pad,2,gap);
    }
}

module balmuda_pocket() {
    balmuda_feet()
    circle(d=balmuda_foot);
}

module wood() {
    translate([0,0,-wood])
    linear_extrude(height=wood)
    children();
}

module mock_whirlpool() {
    translate([0,0,pad])
    cube([whirlpool_x,whirlpool_y-whirlpool_x/2,whirlpool_z]);
    difference(){
        translate([whirlpool_x/2,whirlpool_y-whirlpool_x/2-pad])
        cylinder(d=whirlpool_x,h=whirlpool_z-pad*2);
        translate([0,-whirlpool_x/2,-pad])
        cube([whirlpool_x,whirlpool_y,whirlpool_z+pad*2]);
    }
}

pocket_depth=in/8;

module pocket() {
    translate([0,0,-pocket_depth])
    linear_extrude(height=pocket_depth+pad)
    children();
}

module explode_up(n=1) {
    translate([0,0,explode*n])
    children();
}

module explode_left(n=1) {
    translate([-explode*n,0,0])
    children();
}

module explode_right(n=1) {
    translate([explode*n,0,0])
    children();
}

module explode_back(n=1) {
    translate([0,explode*n,0])
    children();
}


// PREVIEW
// RENDER scad
module assembled() {
    explode_up(2)
    explode_left(2)
    place_whirlpool()
    #mock_whirlpool();


    explode_up(2)
    explode_right(2)
    place_balmuda()
    #cube([balmuda_x,balmuda_y,balmuda_z]);

    explode_up()
    explode_left()
    color("lime")
    place_whirlpool()
    difference() {
        wood()
        whirlpool();
        pocket()
        whirlpool_pocket();
    }

    explode_up()
    explode_right()
    color("lime")
    place_balmuda()
    difference() {
        wood()
        balmuda();
        pocket()
        balmuda_pocket();
    }

    explode_back()
    color("red")
    translate([0,-wood-back_offset,0])
    rotate([90,0])
    wood()
    back();

    color("blue")
    translate([whirlpool_x,0,0])
    rotate([90,0,-90])
    wood()
    middle();

    explode_left(2)
    color("blue")
    translate([side_offset,-back_offset,0])
    rotate([90,0,-90])
    wood()
    whirlpool_end();

    explode_right(2)
    color("blue")
    translate([whirlpool_x+balmuda_x-end_offset-wood,-back_offset,0])
    rotate([90,0,-90])
    wood()
    balmuda_end();
}

module back() {
    // y is z
    difference() {
        union() {
            translate([side_offset+wood,0,0])
            square([whirlpool_x-side_offset-wood,whirlpool_lift-wood]);

            translate([whirlpool_x,0])
            square([balmuda_x-end_offset,balmuda_lift-wood]);
        }

        translate([whirlpool_x+balmuda_x-end_offset-wood,0])
        negative_pins(balmuda_lift-wood,wood,1,gap);
    }
}


module middle() {
    // x is y
    // y is z
    r = segment_radius(front_offset,(whirlpool_lift-wood)*2);
    difference() {
        union() {
            square([balmuda_y-balmuda_front_offset,balmuda_lift]);
            square([whirlpool_y-whirlpool_front_offset,whirlpool_lift]);
        }
        square([back_offset+wood,balmuda_lift]);
        translate([r+whirlpool_y-front_offset-whirlpool_front_offset,0])
        circle(r=r);

        translate([back_offset,whirlpool_lift])
        rotate([0,0,-90])
        negative_pins(whirlpool_y-back_offset-whirlpool_front_offset,wood,2,gap);

        translate([back_offset,balmuda_lift])
        rotate([0,0,-90])
        negative_pins(balmuda_foot_y+balmuda_foot,wood,2,gap);
    }
}


module whirlpool_end() {
    // x is y
    // y is z
    r = segment_radius(front_offset,(whirlpool_lift-wood)*2);

    difference() {
        square([whirlpool_y-back_offset-whirlpool_front_offset,whirlpool_lift]);

        translate([r+whirlpool_y-back_offset-whirlpool_front_offset-front_offset,0])
        circle(r=r);
        translate([0,whirlpool_lift])
        rotate([0,0,-90])
        negative_pins(whirlpool_y-back_offset-whirlpool_front_offset,wood,2,gap);
    }
}

module balmuda_end() {
    // x is y
    // y is z
    r = segment_radius(balmuda_lift-wood,(balmuda_y-back_offset-wood-balmuda_front_offset)*2);
    
    difference() {
        square([balmuda_y-back_offset-balmuda_front_offset,balmuda_lift]);
        translate([balmuda_y-back_offset-balmuda_front_offset,balmuda_lift-wood-r])
        circle(r=r);
        
        translate([0,balmuda_lift])
        rotate([0,0,-90])
        negative_pins(balmuda_foot_y+balmuda_foot,wood,2,gap);

        negative_tails(balmuda_lift-wood,wood,1,gap);
    }
    
}

bit=0.25*in;
anchor=in;

// things are getting sloppy

// RENDER svg
// RENDER dxf
// PREVIEW
// RENDER scad
module cutsheet(display="") {
    translate([-in,0])
    square([bit*1.1,anchor]);

    translate([-in,whirlpool_y+whirlpool_x+balmuda_x-2*in])
    square([bit*1.1,anchor]);

    if(!display) {
        cutgap=1*in;
        translate([0,whirlpool_x+balmuda_x+whirlpool_y])
        rotate([0,0,270])
        back();

        translate([whirlpool_lift,whirlpool_y+balmuda_x+cutgap])
        middle();

        translate([whirlpool_lift+whirlpool_y,whirlpool_y+balmuda_x+cutgap+balmuda_lift+whirlpool_lift+cutgap])
        rotate([0,0,180])
        whirlpool_end();

        translate([whirlpool_lift+in/2,whirlpool_y+balmuda_x+cutgap+balmuda_lift+cutgap])
        balmuda_end();
    }

    translate([-side_offset,in/2])
    if(display=="pocket") {
        whirlpool_pocket();
    } else {
        whirlpool();
    }
    translate([balmuda_y+balmuda_lift,whirlpool_y])
    rotate([0,0,90])
    if(display=="pocket") {
        balmuda_pocket();
    } else {
        balmuda();
    }
}

// RENDER svg
// RENDER dxf
module pockets() {
    cutsheet("pocket");
}
