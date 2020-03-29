tv_mount_x=200;
tv_mount_y=200;

in=25.4;

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

bit=0.125*in;

tv_screw=0.25*in;
soundbar_screw=bit;
tv_screw_head=20;
soundbar_x=23.125*in;
soundbar_mount_x=2.9375*in;

soundbar_offset=11*in;

hole_gaps=1.5*in;
slide=0.5*in;
slide_hole=3/8*in;

pocket=0.75*in;

module tv_placement() {
    translate([-tv_mount_x/2,0])
    dirror(y=tv_mount_y)
    dirror(x=tv_mount_x)
    children();
}

module soundbar_placement() {
    translate([-soundbar_x/2,-soundbar_offset])
    dirror(x=soundbar_x) {
        translate([-soundbar_mount_x/2,0])
        dirror(x=soundbar_mount_x)
        children();
        children();
    }
}

module positive() {
    hull() {
        soundbar_placement()
        circle(d=wall);
        translate([-tv_mount_x/2,0])
        dirror(x=tv_mount_x)
        circle(d=wall);
    }
    hull()
    tv_placement()
    circle(d=wall);
}

center_screws=6;

module slide() {
    hull() {
        circle(d=bit);
        translate([0,-slide])
        circle(d=bit);
    }
    translate([0,-slide])
    circle(d=slide_hole);
}

module anchor() {
	padding=0.25*in;
	color("red")
	//bottom left
	//translate([-soundbar_x/2-wall/2-soundbar_mount_x/2-padding,-soundbar_offset-wall/2-padding])
	translate([-soundbar_x/2-wall/2-soundbar_mount_x/2-padding,tv_mount_y+wall/2+padding])
	circle(d=10);
}

module outside_profile() {
    positive();
}

module pocket() {
    tv_placement()
    circle(d=pocket);
    translate([-soundbar_x/2,-soundbar_offset])
    dirror(x=soundbar_x)
    circle(d=pocket);
}

module inside_profile() {
    soundbar_placement()
    circle(d=soundbar_screw);
    tv_placement()
    circle(d=tv_screw);
    for(y=[0:tv_mount_y/center_screws:tv_mount_y+5]) {
        translate([0,y])
        slide();
    }
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

anchor();

display="";
if (display=="") assembled();
if (display=="tv_soundbar_outside_profile.svg") outside_profile();
if (display=="tv_soundbar_pocket.svg") pocket();
if (display=="tv_soundbar_inside_profile.svg") inside_profile();
