in=25.4;
whirlpool_x=(15+3/8)*in;
whirlpool_y=(13+3/4)*in;
whirlpool_z=(14.25)*in;

function segment_radius(height, chord) = (height/2)+(chord*chord)/(8*height);

counter_z=17.125*in;


balmuda_x=14.1*in;
balmuda_y=12.6*in;
balmuda_z=8.2*in;

balmuda_air_gap=3*in;

whirlpool_lift=counter_z-whirlpool_z;
balmuda_lift=counter_z-balmuda_z-balmuda_air_gap;

wood=in/2;

back_offset=2*in;
side_offset=3*in;
end_offset=1*in;
front_offset=2*in;
$fn=90;

whirlpool_foot=(1+3/8)*in;
whirlpool_back_foot=5/8*in;
whirlpool_foot_gap=9.25*in;
whirlpool_foot_to_front=1.75*in;
whirlpool_front_to_back_foot=10.25*in;
whirlpool_d=whirlpool_x;

balmuda_foot=in;
balmuda_foot_x=(12+5/16)*in;
balmuda_foot_y=(8+7/16)*in;


module place_balmuda() {
    translate([whirlpool_x,-balmuda_y,balmuda_lift])
    children();
}

module place_whirlpool() {
    translate([0,-whirlpool_y,whirlpool_lift])
    children();
}

module whirlpool() {
    square([whirlpool_x+wood,whirlpool_y]);
}

module balmuda() {
    square([balmuda_x,balmuda_y]);
}

module wood() {
    translate([0,0,-wood])
    linear_extrude(height=wood)
    children();
}

module assembled() {
    place_whirlpool()
    #cube([whirlpool_x,whirlpool_y,whirlpool_z]);
    place_balmuda()
    #cube([balmuda_x,balmuda_y,balmuda_z]);

    color("lime")
    place_whirlpool()
    wood()
    whirlpool();

    color("lime")
    place_balmuda()
    wood()
    balmuda();

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

    color("blue")
    translate([side_offset,-back_offset,0])
    rotate([90,0,-90])
    wood()
    whirlpool_end();

    color("blue")
    translate([whirlpool_x+balmuda_x-end_offset-wood,-back_offset,0])
    rotate([90,0,-90])
    wood()
    balmuda_end();
}

module back() {
    // y is z
    translate([side_offset,0,0])
    square([whirlpool_x-side_offset,whirlpool_lift]);
    translate([whirlpool_x,0])
    square([balmuda_x-end_offset,balmuda_lift]);
}


module middle() {
    // x is y
    // y is z
    r = segment_radius(front_offset,(whirlpool_lift-wood)*2);
    difference() {
        union() {
            square([balmuda_y,balmuda_lift]);
            square([whirlpool_y,whirlpool_lift]);
        }
        square([back_offset,whirlpool_lift-wood]);
        translate([r+whirlpool_y-front_offset,0])
        circle(r=r);
    }
}

module whirlpool_end() {
    // x is y
    // y is z
    r = segment_radius(front_offset,(whirlpool_lift-wood)*2);

    difference() {
        square([whirlpool_y-back_offset,whirlpool_lift]);
        translate([r+whirlpool_y-front_offset*2,0])
        circle(r=r);
    }
}

module balmuda_end() {
    // x is y
    // y is z
    r = segment_radius(balmuda_lift-wood,(balmuda_y-back_offset-wood)*2);
    
    difference() {
        square([balmuda_y-back_offset,balmuda_lift]);
        translate([balmuda_y-back_offset,balmuda_lift-wood-r])
        circle(r=r);
    }
    
}


assembled();
