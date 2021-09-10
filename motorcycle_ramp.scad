in=25.4;
ft=12*in;

use <joints.scad>;

width=6*in;
length=6*ft;

gate=500;

ramp_angle=asin(gate/length);

base_wood=0.75*in;
side_wood=base_wood;



module dirror_x(x=0) {
    children();
    translate([x,0])
    mirror([1,0])
    children();
    
}

hole=1.5*in;


bottom_extra=1.5*in;
top_extra=0.5*in;
side=5*in;


side_angle=asin((side-bottom_extra-top_extra)/length);
side_length=cos(side_angle)*length;

//display_angle=0;
//display_angle=ramp_angle;
display_angle=-side_angle;

flat=bottom_extra/tan(ramp_angle);


// this isn't right but it's close enough
thickest=(side-bottom_extra)/cos(ramp_angle);

ground_wall=0*in;
top_wall=0*in;

joint=length-top_wall-ground_wall;

module base_positive() {
    translate([side_wood,0])
    square([width,length]);
    translate([0,ground_wall])
    square([width+side_wood*2,joint]);
}


pins=10;
pintail_gap=in/16;
bit=in/4;
pintail_ear=bit;

hole_x=side/2-10;
hole_y=310;


module base() {
    difference() {
        base_positive();
        dirror_x(width+side_wood*2)
        translate([0,ground_wall])
        negative_pins(joint,side_wood,pins,pintail_gap,0,pintail_ear);
    }
}

module assembled() {
    color("lime")
    rotate([display_angle,0])
    translate([0,0,-base_wood])
    linear_extrude(height=base_wood)
    translate([-width/2-side_wood,0])
    base();

    rotate([display_angle,0])
    dirror_x()
    translate([width/2,0])
    rotate([0,90])
    linear_extrude(height=side_wood)
    side();
}

assembled();

//side();

tooth=5*in;

thin=(side-bottom_extra)/cos(ramp_angle);
module side() {
    difference() {
        hull() {
            rotate([0,0,side_angle])
            translate([-top_extra,0])
            square([side,side_length]);


            translate([0,length])
            rotate([0,0,-ramp_angle])
            translate([-thin,0])
            square([thin,flat]);
            
        }

        x=side*2;

        // gate
        translate([0,length])
        rotate([0,0,-ramp_angle])
        difference() {
            square([x,side_length]);
            translate([0,flat/2])
            square([x,tooth]);
        }

        // ground slice
        rotate([0,0,side_angle-ramp_angle])
        square([x,side_length]);

        translate([0,ground_wall])
        negative_tails(joint,side_wood,pins,pintail_gap,0,pintail_ear);

        pivot=(side-top_extra)/sin(ramp_angle);
        rotate([0,0,side_angle-ramp_angle])
        translate([0,pivot])
        rotate([0,0,90+ramp_angle/2-side_angle])
        translate([0,40])
        circle(d=hole);
    }
}


module bleh_side() {

    cut=cos(ramp_angle)*below;
    flat=cut/sin(ramp_angle);

    //flat=5*in;

    extra=cos(ramp_angle)*flat;


    above=1.5*in;
    below=2*in;
    side=above+base_wood+below;

    dirror_x()
    translate([-width/2,0])
    rotate([display_angle,0])
    rotate([0,-90])
    translate([-below-base_wood,0])
    linear_extrude(height=side_wood)
    side();

    module side() {
        difference() {
            square([side,length+extra]);
            translate([below+base_wood,0])
            rotate([0,0,ramp_angle])
            translate([-side,0])
            square([side,length]);

            translate([below,length])
            rotate([0,0,ramp_angle])
            translate([-side,0])
            square([side,length]);
        }
    }
}

module triangle() {
    lip=3*in;
    spine_angle=45;
    spine=tan(spine_angle)/(width/2);
    side_below=(width/2)/cos(spine_angle);
    side=side_below+lip;


    dirror_x()
    translate([width/2,0])
    rotate([ramp_angle,0,0])
    rotate([0,-spine_angle,0])
    translate([-side_below,0])
    linear_extrude(height=base_wood)
    square([side,length]);
}
