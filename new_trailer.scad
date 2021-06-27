in=25.4;
ft=12*in;
frame_x=1015;
frame_y=923;
frame_beam=866;  // top beam
point=1761; //back of trailer to point
frame_bow=point-frame_beam;
bow_angle=atan(frame_bow/(frame_x/2));
bow_beam=(frame_x/2)/cos(bow_angle);

tip_beam=1489;

use <joints.scad>;

$fn=90;

function segment_radius(height, chord) = (height/2)+(chord*chord)/(8*height);

fender_x=185; 
fender_h=108; // height from top surface of frame
fender_y=500; // lenght of fender across top surface of frame
fender_d=segment_radius(fender_h,fender_y)*2;

axle=frame_beam/2; // confirmed with measurements

box_x=frame_x+1.5*in;
box_y=1650;
echo(box_y=box_y);
box_h=400;

base_wood=0.75*in;
side_wood=0.5*in;


cross_frame_width=40;
side_frame_width=36;
tip_frame_width=43;
frame_width=side_frame_width;
frame_height=86;
frame_gauge=3;


// https://mechanicalelements.com/trailer-axle-position/
// weight in lbs

total_weight=600;
target_tongue_load=0.15;

wheel=510;
wheel_w=120;
frame_surface=490; // distance from ground to surface of frame bed
wheel_h=frame_surface-frame_height/2-wheel/2;

FA=(1-target_tongue_load)*total_weight;
L6=11*ft;
WF=197; // website
L4=8.5*ft; // guess
WD=total_weight-WF; // max load

L5=(FA*L6-WF*L4)/WD;

box_center=L6+axle-L5;

pad=0.1;

tongue_width=50;
tongue_height=77;
tongue_depth=2430;



bike_gap=10*in;

kayak_x=31*in;
kayak_y=10*ft;
kayak_z=12*in;
//translate([-kayak_x/2,-kayak_y/2]) #cube([kayak_x,kayak_y,kayak_z]);

spike_x=8*in;
spike_y=side_wood*1.2;
spike_z=frame_height;
spike_square=base_wood*2;
spike_round=2*in;
spike_tip=spike_x/2;

end_spike_gap=box_x/2;

axle_w=37;

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

module frame_profile(width=side_frame_width) {
    difference() {
        square([width,frame_height],center=true);
        translate([-frame_gauge,0])
        square([width,frame_height-frame_gauge*2],center=true);
    }
}

module frame_rail(l,width=side_frame_width) {
    color("silver")
    rotate([90,0,-90])
    translate([0,0,-l/2])
    linear_extrude(height=l)
    frame_profile(width);
}

module screws() {
    outer_side_holes=669;
    inner_side_holes=498;
    side_holes_from_edge=19;
    side_holes_from_back=97;
    frame_hole=10;

    beam_holes=812;
    beam_holes_from_back=21.5;
    dirror_y(frame_beam)
    dirror_x()
    translate([beam_holes/2,beam_holes_from_back])
    circle(d=frame_hole);

    tip_bolt=1519;
    tip_bolt_d=35;
    translate([0,tip_bolt])
    circle(d=tip_bolt_d);

    translate([0,outer_side_holes/2+side_holes_from_back,0]) {
        dirror_x()
        dirror_y()
        translate([frame_x/2-side_holes_from_edge,inner_side_holes/2,0])
        circle(d=frame_hole);

        dirror_x()
        dirror_y()
        translate([frame_x/2-side_holes_from_edge,outer_side_holes/2,0])
        circle(d=frame_hole);
    }

    center_holes_from_back=25;
    center_holes=76;

    dirror_y(frame_beam)
    translate([0,center_holes_from_back]) {
        circle(d=frame_hole);
        dirror_x()
        translate([center_holes/2,0])
        circle(d=frame_hole);
    }

    
}


module frame() {

    color("blue")
    translate([0,0,frame_height/2])
    screws();

    dirror_y(frame_beam)
    translate([0,cross_frame_width/2])
    frame_rail(frame_x,cross_frame_width);

    dirror_x()
    translate([frame_x/2-frame_width/2,frame_y/2])
    rotate([0,0,90])
    frame_rail(frame_y);

    dirror_x()
    translate([frame_x/2,frame_y])
    rotate([0,0,90-bow_angle])
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
    translate([0,axle,-wheel_h])
    cube([frame_x+fender_x,axle_w,axle_w],center=true);

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
    
    color("silver")
    translate([-tongue_width/2,tip_beam,-tongue_height/2])
    cube([tongue_width,tongue_depth,tongue_height]);

    translate([0,tip_frame_width/2+tip_beam,0])
    frame_rail(300,tip_frame_width);
}

pintail_gap=in/8;
pintail_ear=in/4;
end_pins=4;
side_pins=6;
box_pins=3;


base_x=48*in;
base_pin_extra=(48*in-box_x)/2;
base_y=box_y+base_pin_extra*2;

echo(base_y=base_y);

overhang=base_y/2-box_center;
echo(overhang=overhang);


//top=frame_x-frame_width*3;
//top=box_h;
top=base_y/3;
top_cutout=box_x-(base_x-box_x);

top_spike=100;
top_spike_h=2*in;

top_spike_side_gap=base_y/8;
top_spike_end_gap=base_x/2;

module base() {
    color("tan")
    translate([0,box_center])
    linear_extrude(height=base_wood)
    translate([-base_x/2,-base_y/2])
    difference() {
        square([base_x,base_y]);
        dirror_x(base_x)
        translate([base_x/2-frame_x/2-fender_x,base_y/2-fender_y/2-box_center+axle])
        square([fender_x,fender_y]);
        translate([base_x/2,base_y/2-box_center])
        screws();
    }
}

side_pin_extra=1*in;
side_h=box_h;
side_x=box_y+side_pin_extra*2;
box_edge=box_h;

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

side_spike_back=(box_y/2-box_center+axle-fender_y/2)/2;

side_spikes=[side_spike_back, box_y-side_spike_back, box_y/2+200];


module side_top_spikes(x=0) {
    translate([side_x/2+x,0])
    dirror_x()
    translate([top_spike_side_gap/2,box_h])
    top_spike();
}

module side() {
    difference() {
        union() {
            square([side_x,box_edge]);
            for(x=side_spikes)
            translate([x,0])
            spike();
            side_top_spikes();
            side_top_spikes(base_y/3);
            side_top_spikes(-base_y/3);
            
        }
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
                translate([pattern_wall,pattern_wall])
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
    translate([0,box_center,z+base_wood]) {
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

module top_spike() {
    translate([-top_spike/2,0])
    square([top_spike,top_spike_h]);
}


module end() {
    difference() {
        union() {
            square([end_x,box_edge]);
            translate([end_x/2,0])
            dirror_x()
            translate([end_spike_gap/2,0])
            spike();
            translate([end_x/2-top_spike_end_gap/2,box_h])
            dirror_x(top_spike_end_gap)
            top_spike();
        }
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
                translate([pattern_wall,pattern_wall])
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
    translate([-box_x/2,box_center,base_wood])
    rotate([90,0,90])
    translate([-side_x/2,0])
    linear_extrude(height=side_wood)
    side();

    color("chocolate")
    translate([0,box_center+box_y/2,base_wood])
    dirror_y(-box_y)
    rotate([90,0])
    translate([-end_x/2,0])
    linear_extrude(height=side_wood)
    end();
} 

spike_hole=in/2;

module spike() {
    extra=5*in;
    mirror([0,1])
    difference() {
        offset(spike_round)
        offset(-spike_round)
        hull() {
            translate([-spike_x/2,-extra])
            square([spike_x,spike_square+extra]);
            translate([-spike_tip/2,0])
            square([spike_tip,spike_z]);
        }
        translate([-spike_x,-extra*2])
        square([spike_x*2,extra*2]);
        translate([0,spike_z/2])
        circle(d=spike_hole);
    }
}
//spike();

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


translate([0,0,-frame_height/2])
frame();
*plywood_stack();
//bikes();
//kayaks();

box();

base();

module top_spike_slot() {
    square([top_spike,side_wood],center=true);
}


module top_3d(pos=1,stack=0) {
    translate([-base_x/2,box_center-base_y/2+base_y-base_y/3*pos,box_h+base_wood+side_wood*stack])
    linear_extrude(height=side_wood)
    top();
}

module fully_covered() {
    color("blue")
    top_3d(3);
    color("lime")
    top_3d(2);
    color("red")
    top_3d();
}

module stacked() {
    color("red")
    top_3d(1,0);
    color("lime")
    top_3d(1,1);
    color("blue")
    top_3d(1,2);
}
*stacked();
*fully_covered();



module top_spike_slots() {
        translate([base_x/2,0])
        dirror_x()
        dirror_y(top)
        translate([top_spike_end_gap/2,base_pin_extra+side_wood/2])
        top_spike_slot();

        translate([0,top/2])
        dirror_x(base_x)
        dirror_y()
        translate([base_pin_extra+side_wood/2,top_spike_side_gap/2])
        rotate([0,0,90])
        top_spike_slot();
}

*top_3d();
module top(cut=1) {
    difference() {
        square([base_x,top]);

        if(cut)
        translate([base_x/2,0])
        circle(d=top_cutout);

        top_spike_slots();
        intersection() {
            difference() {
                offset(-pattern_wall)
                square([base_x,top]);
                offset(pattern_wall)
                top_spike_slots();

                if(cut)
                translate([base_x/2,0])
                circle(d=top_cutout+pattern_wall*2);
            }
            pattern();
        }
    }
}

// RENDER stl
module nothing() {
    echo("nope");
}
