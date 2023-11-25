in=25.4;
pad=0.1;
// small bedroom tv
// tv_mount_x=100;
// tv_mount_y=tv_mount_x;
// top_screw=275;

// new bedroom TV
hole_gaps=1.5*in;
slide=1*in; // how long the striaght part is
slide_hole=40;  // how big the bottom part is
ramp=slide_hole/8;  // increase for less steam ramp

corner=10;  // smooth outside corners

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

// RENDER svg
module bedroom() {
	tv_mount_x=400;
	tv_mount_y=300;
	hanger(
		tv_mount_x=tv_mount_x,
		tv_mount_y=tv_mount_y,
		top_screw=400,
		bottom_screw=-tv_mount_y/3,
		center_screws=5
	);
}

// RENDER svg
module kitchen() {
	tv_mount_x=600;
	tv_mount_y=400;
	panel_x=600-60*2;
	panel_y=50+wall;
	panel_corner=corner*2;

	vent_offset=27;
	vent_x=170+wall;
	vent_y=290;
	vent_corner=50;

	difference() {
		hanger(
			tv_mount_x=tv_mount_x,
			tv_mount_y=tv_mount_y,
			top_screw=tv_mount_y/2+85,
			bottom_screw=panel_y-tv_mount_y/2+wall,
			center_screws=3
		) {
			translate([-panel_x/2,-tv_mount_y/2-wall-pad])
			offset(panel_corner)
			offset(-panel_corner)
			square([panel_x,panel_y+pad]);

			translate([-tv_mount_x/2-wall-vent_corner,tv_mount_y/2-vent_y-vent_offset])
			offset(vent_corner)
			offset(-vent_corner)
			square([vent_x+vent_corner,vent_y]);
		}
	}
}

kitchen();

// sloppy modularization
module hanger(tv_mount_x, tv_mount_y, top_screw, bottom_screw, center_screws) {
	screw_gap=(top_screw-bottom_screw)/center_screws;
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
		offset(corner)
		offset(-corner)
		difference() {
			positive();
			children();
	    	}
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

	module inkscape() {
	    difference() {
		outside_profile()
		children();
		place_slides()
		slide();

		difference() {
		    pocket();
		    tv_placement()
		    circle(d=tv_screw);

		}
	    }
	}


	inkscape()
	children();
	//assembled();
}
