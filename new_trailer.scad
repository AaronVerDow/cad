in=25.4;
ft=12*in;
frame_x=40*in;
frame_y=42*in;
frame_bow=20*in;
frame_beam=40*in;  // top beam
bow_angle=atan(frame_bow/(frame_x/2));
bow_beam=(frame_x/2)/cos(bow_angle);

use <joints.scad>;

$fn=90;

function segment_radius(height, chord) = (height/2)+(chord*chord)/(8*height);

fender_x=7.5*in; // website
fender_h=4*in; // height from top surface of frame
fender_y=18*in; // lenght of fender across top surface of frame
fender_d=segment_radius(fender_h,fender_y)*2;


box_x=frame_x+3*in;
box_y=80*in;
box_h=24*in;
base_wood=0.75*in;
side_wood=0.5*in;

axle=frame_beam/2;

frame_width=1.25*in; //guess
frame_height=4*in; //guess
frame_gauge=in/8;  // website

box_under=frame_height/2;

// https://mechanicalelements.com/trailer-axle-position/
// weight in lbs

total_weight=500;
target_tongue_load=0.15;

wheel=21*in; //random amazon product review
wheel_w=4.8*in;  // probably wrong
wheel_h=6.5*in;  // def wrong

FA=(1-target_tongue_load)*total_weight;
L6=11*ft;
WF=197; // website
L4=8.5*ft; // guess
WD=total_weight-WF; // max load

L5=(FA*L6-WF*L4)/WD;

box_center=L6+axle-L5;

pad=0.1;

tongue_width=4*in;
color("silver")
translate([-tongue_width/2,box_center,-tongue_width])
cube([tongue_width,L4,tongue_width]);


bike_gap=10*in;

kayak_x=31*in;
kayak_y=10*ft;
kayak_z=12*in;
//translate([-kayak_x/2,-kayak_y/2]) #cube([kayak_x,kayak_y,kayak_z]);


module kayaks() {
    dirror_x()
    translate([-box_x/2,0])
    rotate([0,-45])
    translate([kayak_x/2,box_center])
    rotate([0,0,180])
    translate([0,-5*in,0])
    scale([56,39,28])
    import("KAYAK_BUENO.stl");
}

module bike() {
    height=3*in;
    translate([0,height/2,-40])
    rotate([90,0,0])
    linear_extrude(height=height)
    import("radrunner.svg");
}

module bikes() {
    translate([0,box_center,base_wood])
    rotate([0,0,90]) {

        translate([0,-bike_gap/2])
        bike();
        translate([0,bike_gap/2])
        rotate([0,0,180])
        bike();
    }
}


module frame_profile() {
    difference() {
        square([frame_width,frame_height],center=true);
        translate([-frame_gauge,0])
        square([frame_width,frame_height-frame_gauge*2],center=true);
    }
}

module dirror_y(y=0) {
    children();
    translate([0,y])
    mirror([0,1,0])
    children();
}

module dirror_x(x=0) {
    children();
    translate([x,0])
    mirror([1,0,0])
    children();
}

module frame_rail(l) {
    color("silver")
    rotate([90,0,-90])
    translate([0,0,-l/2])
    linear_extrude(height=l)
    frame_profile();
}

module frame() {

    dirror_y(frame_beam)
    translate([0,frame_width/2])
    frame_rail(frame_x);

    dirror_x()
    translate([frame_x/2-frame_width/2,frame_y/2])
    rotate([0,0,90])
    frame_rail(frame_y);

    dirror_x()
    translate([frame_x/2,frame_y])
    rotate([0,0,bow_angle])
    translate([-frame_width/2,bow_beam/2])
    rotate([0,0,90])
    frame_rail(bow_beam);

    color("#333333")
    dirror_x()
    translate([frame_x/2+fender_x/2,axle,-wheel_h])
    rotate([0,90]) {
        cylinder(d=wheel,h=wheel_w,center=true);
    }

    color("silver")
    dirror_x()
    translate([frame_x/2+fender_x/2,axle,fender_h+frame_height/2-fender_d/2])
    rotate([0,90])
    difference() {
        cylinder(d=fender_d,h=fender_x,center=true);
        cylinder(d=fender_d-frame_gauge*2,h=fender_x+pad*2,center=true);
        translate([fender_h+frame_height/2,0])
        cube([fender_d,fender_d,fender_x+pad*2],center=true);
    }
}

pintail_gap=in/8;
pintail_ear=in/4;
end_pins=4;
side_pins=6;
box_pins=3;
base_pin_extra=2.5*in;


base_x=box_x+base_pin_extra*2;
base_y=box_y+base_pin_extra*2;

module base() {
    color("tan")
    translate([0,box_center])
    linear_extrude(height=base_wood)
    translate([-base_x/2,-base_y/2])
    difference() {
        square([base_x,base_y]);

        dirror_y(base_y)
        translate([base_x,-pad])
        rotate([0,0,90])
        negative_pins(base_x,side_wood+pad+base_pin_extra,end_pins,pintail_gap,0,pintail_ear);

        dirror_x(base_x)
        negative_pins(base_y,side_wood+pad+base_pin_extra,side_pins,pintail_gap,0,pintail_ear);
    }
}

side_pin_extra=0.5*in;
side_h=box_h+base_wood+box_under;
side_x=box_y+side_pin_extra*2;
box_edge=box_h+box_under+base_wood;

pattern_wall=3*in;

module strap_holes(x,wall=0) {
        dirror_x(x)
        translate([x/3,bottom_strap,0])
        offset(wall)
        strap_hole();

        dirror_x(x)
        translate([x/3,top_strap,0])
        offset(wall)
        strap_hole();
}

module side() {
    difference() {
        square([side_x,box_edge]);
        dirror_x(side_x)
        negative_pins(box_edge,side_wood+pad+side_pin_extra,box_pins,pintail_gap,0,pintail_ear);

        dirror_x(side_x)
        strap(bottom_strap);

        dirror_x(side_x)
        strap(top_strap);

        intersection() {
            translate([box_y/2,0])
            pattern();
            difference() {
                translate([pattern_wall,pattern_wall+box_under+base_wood])
                square([box_y-pattern_wall*2,box_h-pattern_wall*2]);
                strap_holes(box_y,pattern_wall);
            }
        }

        //translate([base_pin_extra/2,0])
        strap_holes(box_y);

    }
}

end_x=box_x+side_pin_extra*2;

strap=2.2*in;
strap_inset=side_pin_extra+0;
strap_thick=in/16;
top_strap=box_edge/7*6;
bottom_strap=box_edge/7*2;

module strap_hole() {
    square([strap,strap],center=true);
}

module strap(z=0) {
    translate([0,z-strap/2])
    square([strap_inset,strap]);
}

module strap_preview(z=0) {
    color("yellow")
    translate([0,box_center,z-box_under]) {
        difference() { 
            cube([box_x+strap_thick*2,box_y+strap_thick*2,strap],center=true);
            cube([box_x,box_y,strap+pad*2],center=true);
            cube([box_x+strap_thick*4,base_y/3,strap+pad*2],center=true);
            cube([end_x/3,box_y+strap_thick*4,strap+pad*2],center=true);
        }
        difference() { 
            cube([box_x-side_wood*2,box_y/3-side_wood*2,strap],center=true);
            cube([box_x-side_wood*2-strap_thick*2,box_y-side_wood*2-strap_thick*2,strap+pad*2],center=true);
        }
        difference() { 
            cube([end_x/3,box_y-side_wood*2,strap],center=true);
            cube([end_x,box_y-side_wood*2-strap_thick*2,strap+pad*2],center=true);
        }
    }
}



module end() {
    difference() {
        square([end_x,box_edge]);
        dirror_x(end_x)
        negative_tails(box_edge,side_wood+pad+side_pin_extra,box_pins,pintail_gap,0,pintail_ear);
        
        dirror_x(end_x)
        strap(bottom_strap);

        dirror_x(end_x)
        strap(top_strap);
    
        strap_holes(end_x);

        intersection() {
            translate([box_x/2,0])
            pattern();
            difference() {
                translate([pattern_wall,pattern_wall+box_under+base_wood])
                square([box_x-pattern_wall*2,box_h-pattern_wall*2]);
                strap_holes(end_x,pattern_wall);
            }
        }

    }
}

module box() {
    strap_preview(bottom_strap);
    strap_preview(top_strap);
    color("sienna")
    dirror_x()
    translate([-box_x/2,box_center,-box_under])
    rotate([90,0,90])
    translate([-side_x/2,0])
    linear_extrude(height=side_wood)
    side();

    color("chocolate")
    translate([0,box_center+box_y/2,-box_under])
    dirror_y(-box_y)
    rotate([90,0])
    translate([-end_x/2,0])
    linear_extrude(height=side_wood)
    end();
} 

pattern_hole=2*in;
pattern_gap=4.5*in;
pattern_fn=8;

module pattern() {
    pattern_max=box_x+box_y;
    translate([-pattern_gap/2,0])
    dirror_y()
    dirror_x() {
        for(x=[0:pattern_gap:pattern_max])
        for(y=[0:pattern_gap:pattern_max])
        translate([x,y])
        circle(d=pattern_hole,$fn=pattern_fn);

        for(x=[pattern_gap/2:pattern_gap:pattern_max])
        for(y=[pattern_gap/2:pattern_gap:pattern_max])
        translate([x,y])
        circle(d=pattern_hole,$fn=pattern_fn);
    }
}

lock_x=2.5*in;
lock_y=0.5*in;
module lock() {
    square([lock_x,lock_y],center=true);
}

plywood_x=4*ft;
plywood_y=8*ft;
plywood_z=8*in;

module plywood_stack() {
    translate([-plywood_x/2,box_center-plywood_y/2])
    cube([plywood_x,plywood_y,plywood_z]);
}

//plywood_stack();

translate([0,0,-frame_height/2])
frame();
//bikes();
//kayaks();

box();

base();
