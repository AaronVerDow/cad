in=25.4;
// small bedroom tv
// tv_mount_x=100;
// tv_mount_y=tv_mount_x;
// top_screw=275;

// new bedroom TV
tv_mount_x=400;
tv_mount_y=300;
top_screw=tv_mount_y/2+250;
hole_gaps=1.5*in;
slide=1*in; // how long the striaght part is
slide_hole=40;  // how big the bottom part is
ramp=slide_hole/8;  // increase for less steam ramp



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

center_screws=5;
bottom_screw=-tv_mount_y/3;
screw_gap=(top_screw-bottom_screw)/center_screws;

module slide() {
    hull() {
        circle(d=bit);
        translate([0,-slide])
        circle(d=bit);
    }
    hull() {
        translate([0,-slide])
        circle(d=bit);
        translate([0,-slide-slide_hole/2-ramp])
        circle(d=slide_hole);
    }
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
