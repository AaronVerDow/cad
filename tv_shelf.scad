tv_mount_x=200;
tv_mount_y=200;
use <joints.scad>;

in=25.4;

wood=in/2;

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

mount_to_tv_base=100;
shelf_to_tv=150;

shelf_offset=mount_to_tv_base+shelf_to_tv;

shelf_x=600;
shelf_y=250;
shelf_z=200;

center_screws=6;

pad=0.1;

module tv_placement() {
    translate([-tv_mount_x/2,0])
    dirror(y=tv_mount_y)
    dirror(x=tv_mount_x)
    children();
}

pintail_gap=in/8;
pintail_ear=bit;
pintail_holes=bit/2;
x_pins=4;
y_pins=1;

module positive() {
	difference() {
	    hull() {
		//translate([-tv_mount_x/2,0])
		//diror(x=tv_mount_x)
		//circle(d=wall);
		translate([-shelf_x/2,-shelf_z-shelf_offset])
		square([shelf_x,shelf_z]);
		    hull()
		    tv_placement()
		    circle(d=wall);
	    }
		translate([shelf_x/2,-shelf_offset-shelf_y-pad])
		rotate([0,0,90])
		negative_tails(shelf_x,wood+pad,x_pins,pintail_gap,pintail_holes,pintail_ear);

		translate([shelf_x/2,-shelf_offset-wood])
		rotate([0,0,90])
		dirror(x=wood)
		negative_tails(shelf_x,wood,x_pins,pintail_gap,pintail_holes,pintail_ear);

		translate([-shelf_x/2-pad,-shelf_offset-shelf_z])
		dirror(x=shelf_x+pad*2)
		negative_tails(shelf_z,wood+pad,y_pins,pintail_gap,pintail_holes,pintail_ear);
	}
}

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

module inside_profile() {
    tv_placement()
    circle(d=tv_screw);
    for(y=[0:tv_mount_y/center_screws:tv_mount_y+5]) {
        translate([0,y])
        slide();
    }
}

module back_2d() {
    color("lime")
    translate([0,0,-1])
    outside_profile();

    color("blue")
    pocket();

    translate([0,0,1])
    color("magenta")
    inside_profile();

}

module wood(height=wood) {
	linear_extrude(height=height)
	children();
}

module back_3d() {
	difference() {
		wood()
		positive();
		translate([0,0,-wood/2])
		wood()
		pocket();
		wood(wood+pad*2)
		inside_profile();
	}
}

module shelf_x() {
	difference() {
		square([shelf_x,shelf_y]);
		translate([shelf_x,-pad])
		rotate([0,0,90])
		negative_pins(shelf_x,wood+pad,x_pins,pintail_gap,pintail_holes,pintail_ear);
	}
}

module shelf_y() {
	difference() {
		square([shelf_z,shelf_y]);
		translate([shelf_z,0])
		rotate([0,0,90])
		negative_pins(shelf_z,wood+pad,y_pins,pintail_gap,pintail_holes,pintail_ear);
	}
}

module assembled() {
	color("tan")
	back_3d();
	
	color("peru")
	translate([-shelf_x/2,-shelf_offset])
	dirror(y=-shelf_z)
	rotate([90,0])
	wood()
	shelf_x();

	color("chocolate")
	translate([shelf_x/2,-shelf_offset])
	dirror(x=-shelf_x)
	rotate([90,0,-90])
	wood()
	shelf_y();
}

//!back_3d();
assembled();
