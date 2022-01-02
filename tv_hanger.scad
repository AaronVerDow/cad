tv_mount_x=100;
tv_mount_y=tv_mount_x;

in=25.4;

$fn=300;

module dirror(x=0,y=0) {
    children();
    if(x)
    translate([x,0])
    mirror([1,0])
    children();
    if(y)
    translate([0,y])
    mirror([0,1])
    children();
}

wall=2*in;

bit=0.15*in;

tv_screw=0.25*in;
tv_screw_head=20;


hole_gaps=1.5*in;
slide=0.5*in;
slide_hole=3/8*in;

pocket=0.75*in;

module tv_placement() {
    translate([-tv_mount_x/2,-tv_mount_y/2])
    dirror(y=tv_mount_y)
    dirror(x=tv_mount_x)
    children();
}

module positive() {
    hull() {
        tv_placement()
        circle(d=wall);
        place_slides()
        circle(d=wall);
    }
}

center_screws=8;
top_screw=275;
bottom_screw=0;
screw_gap=(top_screw-bottom_screw)/center_screws;

module slide() {
    hull() {
        circle(d=bit);
        translate([0,-slide])
        circle(d=bit);
    }
    translate([0,-slide])
    circle(d=slide_hole);
}

module outside_profile() {
    positive();
}

module pocket() {
    tv_placement()
    circle(d=pocket);
}

module place_slides() {
    for(y=[bottom_screw:screw_gap:top_screw])
    translate([0,y])
    children();

}
module inside_profile() {
    tv_placement()
    circle(d=tv_screw);
    place_slides()
    slide();
}

module assembled() {
    color("lime")
    translate([0,0,-1])
    outside_profile();

    color("blue")
    pocket();

    translate([0,0,1])
    color("magenta")
    inside_profile();

}

// RENDER svg
module inkscape() {
    
    difference() {
        outside_profile();
        place_slides()
        slide();

        difference() {
            pocket();
            tv_placement()
            circle(d=tv_screw);

        }
    }
}


inkscape();
//assembled();
