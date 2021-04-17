use <vescher.scad>;
use <joints.scad>;
in=25.4;
total_h=1900;


wood=in/2;
caster=2.4*in*2;
caster_h=3.2*in;
caster_plate=2.87*in;
caster_offset=caster_plate/2+wood;
caster_clearance=caster_offset+caster/2+10;

rolling_clearance=15;

rack=35*in;
base=caster_h+wood-rolling_clearance;
lip=base;


depth=500;

// gap for back of cabinet
bench_gap=4*in;


//wood=in/4*3;
width=487+wood*2;

bench_h=base+rack+lip;
shelves=[
    base-wood,
    bench_h,
    total_h-wood
];

side_wall=3*in;

rack_wall=0;

top_back=16*in;

rail_y=1.55*in;
rail_x=0.68*in;
rail_wall=in/8;
rail_inset=in;


translate([-240,30,bench_h+wood])
import("The_Wedge.stl");

echo(bench=bench_h);
hand_x=110;
hand_y=35;
hand_wall=50;
hand_holes=0;

// rack_standards
// https://en.wikipedia.org/wiki/19-inch_rack#/media/File:Server_rack_rail_dimensions.svg
u=1.75*in;
u_hole_gap=0.625*in;
u_hole=in/16*3;

module hand() {
    hull()
    dirror_x()
    translate([(hand_x-hand_y)/2,0])
    circle(d=hand_y);
}

module u_holes(us=1) {
    for (n=[0:1:us-1]) {
        for (x=[0:u_hole_gap:u]) {
            translate([x-u_hole_gap+u/2+u*n,0,0])
            circle(d=u_hole);
        }
    }
}

//!side();
module side() {
    difference() {
        walled_vescher([depth,total_h]) {
            for(z=shelves)
            translate([0,-side_wall+z])
            square([depth,side_wall*2+wood]);
            square([rack_wall,base+rack+lip]);
            if(hand_holes)
            offset(side_wall)
            hands();
        }
        dirror_x(depth)
        square([caster_clearance,base-wood]);

        if(hand_holes)
        hands();
        
        dirror_x(depth)
        translate([rail_inset+rail_y/2,base])
        rotate([0,0,90])
        u_holes(20);

        // bench joint
        translate([0,bench_h+wood])
        rotate([0,0,-90])
        dirror_x(wood)
        negative_tails(depth-bench_gap,wood,width_pins,pintail_gap,pintail_hole,pintail_ear);

        // top pins
        translate([0,total_h])
        rotate([0,0,-90])
        negative_tails(depth,wood,width_pins,pintail_gap,pintail_hole,pintail_ear);

        // back pins
        translate([depth,total_h-top_back])
        mirror([1,0])
        negative_tails(top_back,wood,width_pins,pintail_gap,pintail_hole,pintail_ear);

        // not sure if this is right
        translate([0,bench_h-lip-lip/4+wood]) {
            negative_tails(lip*3/2,wood,1,pintail_gap,0,pintail_ear);
            translate([depth-bench_gap-wood,0])
            dirror_x(wood)
            negative_tails(lip*3/2,wood,1,pintail_gap,0,pintail_ear);
        }

        translate([0,total_h-lip-lip/4]) 
        negative_tails(lip*3/2,wood,1,pintail_gap,0,pintail_ear);

        //translate([0,base]) rotate([0,0,-90]) negative_tails(depth,wood,width_pins,pintail_gap,pintail_hole,pintail_ear);
        
        // base pins
        translate([caster_clearance,base])
        rotate([0,0,-90])
        dirror_x(wood)
        negative_tails(depth-caster_clearance*2,wood,base_side_pins,pintail_gap,pintail_hole,pintail_ear);

        // bottom pins
        translate([depth-caster_clearance,0])
        rotate([0,0,90])
        negative_tails(depth-caster_clearance*2,wood,bottom_side_pins,pintail_gap,pintail_hole,pintail_ear);

        // clip for base
        dirror_x(depth)
        translate([0,base-wood-pad])
        mirror([0,1])
        rotate([0,0,-90])
        negative_slot(caster_clearance,wood+pad,pintail_ear);

    }
}

module hands() {
    dirror_x(depth)
    translate([hand_x/2+hand_wall,base+rack+lip-hand_y/2-hand_wall])
    hand();
}

module wood(height=wood) {
    linear_extrude(height=height)
    children();
}

module dirror_y(y=0) {
    children();
    translate([0,y])
    mirror([0,1])
    children();
}


module dirror_x(x=0) {
    children();
    translate([x,0])
    mirror([1,0])
    children();
}

module base_front() {
    difference() {
        square([width-caster_clearance*2,base]);

        dirror_y(base)
        translate([width-caster_clearance*2,-pad])
        rotate([0,0,90])
        negative_pins(width-caster_clearance*2,wood+pad,caster_pins,pintail_gap,pintail_hole,pintail_ear);

        dirror_x(width-caster_clearance*2)
        translate([-pad,-pad])
        square([wood+pad,base+pad*2]);
    }
}

bottom_side_pins=1;

module bottom() {
    difference() {
        square([width,depth]);
        dirror_x(width)
        dirror_y(depth)
        square([caster_clearance,caster_clearance]);

        dirror_y(depth)
        translate([width-caster_clearance,0])
        rotate([0,0,90])
        negative_tails(width-caster_clearance*2,wood,caster_pins,pintail_gap,pintail_hole,pintail_ear);

        // side joint
        dirror_x(width)
        translate([0,caster_clearance])
        negative_pins(depth-caster_clearance*2,wood,bottom_side_pins,pintail_gap,pintail_hole,pintail_ear);

        brace_tails();
    }
}


color("red")
wood()
bottom();

color("lime")
dirror_y(depth)
translate([caster_clearance,depth])
rotate([90,0,00])
wood()
base_front();


color("lime")
dirror_x(width)
rotate([90,0,90])
wood()
side();

dirror_y(depth)
color("blue")
translate([0,depth-caster_clearance])
rotate([90,0,00])
wood()
x_brace(); 

color("magenta")
dirror_x(width)
translate([caster_clearance,0])
rotate([90,0,90])
wood()
y_brace();

color("blue")
translate([0,depth,total_h-top_back])
rotate([90,0,0])
wood()
top_back();

color("red")
translate([0,0,shelves[2]])
wood()
top();

// https://www.asus.com/Displays-Desktops/Monitors/All-series/VT168H/techspec/
monitor=[377.8,44,235.9];

monitor_h=total_h-top_back+100;
echo(monitor=monitor_h);
color("gray")
translate([width/2,depth-monitor[1]/2-wood,monitor_h])
cube(monitor,center=true);

translate([0,depth-bench_gap,bench_h-lip+wood])
rotate([90,0])
wood()
lip();

translate([0,wood,bench_h-lip+wood])
rotate([90,0])
wood()
lip();

translate([0,wood,total_h-lip])
rotate([90,0])
wood()
lip();

bit=in/4;

width_pins=3;
pintail_gap=bit/8;
pintail_hole=bit*1.1;
pintail_ear=bit;
pad=0.1;

module lip() {
    difference() {
        square([width,lip]);

        translate([wood,lip])
        rotate([0,0,-90])
        negative_tails(width-wood*2,wood,width_pins,pintail_gap,pintail_hole,pintail_ear);

        dirror_x(width)
        translate([0,-lip/4])
        negative_pins(lip*3/2,wood,1,pintail_gap,pintail_hole,pintail_ear);
    }
}

module top() {
    difference() {
        walled_vescher([width,depth]);

        dirror_y(depth)
        translate([wood,depth+pad])
        rotate([0,0,-90])
        negative_pins(width-wood*2,wood+pad,width_pins,pintail_gap,pintail_hole,pintail_ear);

        dirror_x(width)
        negative_pins(depth,wood,width_pins,pintail_gap,pintail_hole,pintail_ear);
    }
}


zero=0.01;


module caster() {
    translate([0,0,-caster_h])
    hull() {
        translate([0,0,caster_h-zero/2])
        cube([caster_plate,caster_plate,zero],center=true);
        cylinder(d=caster,h=zero);
    }
}


module walled_vescher(box,wall=side_wall) {
    difference() {
        square(box);
        translate(box/2)
        double_vescher(box)
        translate(-box/2) {
            children();
            difference() {
                square(box);
                offset(-side_wall)
                square(box);
            }
        }
    }
}


dirror_x(width)
dirror_y(depth)
translate([wood,rail_inset,base])
color("dimgray")
linear_extrude(height=rack)
rail();
module rail() {
    intersection() {
        difference() {
            offset(in/4)
            offset(-in/4)
            square([rail_x,rail_y]*2);
            offset(-in/8)
            offset(in/4)
            offset(-in/4)
            square([rail_x,rail_y]*2);
        }
        square([rail_x,rail_y]);
    }

}


color("red")
translate([0,0,shelves[0]])
wood()
base();

color("red")
translate([0,0,bench_h])
wood()
bench();

*dirror_x(width)
dirror_y(depth)
translate([caster_offset,caster_offset,base-wood])
caster();

module bench() {
    difference() {
        //walled_vescher([width,depth-bench_gap]);
        square([width,depth-bench_gap]);

        dirror_y(depth-bench_gap)
        translate([wood,depth-bench_gap+pad])
        rotate([0,0,-90])
        negative_pins(width-wood*2,wood+pad,width_pins,pintail_gap,pintail_hole,pintail_ear);

        dirror_x(width)
        negative_pins(depth-bench_gap,wood,width_pins,pintail_gap,0,pintail_ear);
    }
}

//!x_brace();
module x_brace() {
    difference() {
        translate([wood,0])
        square([width-wood*2,base]);
        
        dirror_y(base)
        translate([0,base+pad])
        rotate([0,0,-90])
        negative_pins(width,wood+pad,width_pins,pintail_gap,0,pintail_ear);

        dirror_x(width)
        translate([caster_clearance,-pad])
        dirror_x(wood)
        negative_slot(base/2+pad,wood,pintail_ear);
    }
}

//!y_brace();
module y_brace() {
    difference() {
        square([depth,base]);

        dirror_y(base)
        translate([0,base+pad])
        rotate([0,0,-90])
        negative_pins(depth,wood+pad,width_pins,pintail_gap,0,pintail_ear);

        translate([0,base])
        mirror([0,1])
        dirror_x(depth)
        translate([caster_clearance,-pad])
        dirror_x(wood)
        negative_slot(base/2+pad,wood,pintail_ear);
    
        dirror_x(depth)
        translate([wood/2,base/2])
        circle(d=pintail_hole);
    }
}

module shelf() {
    difference() {
        square([width,depth]);
    }
}

caster_pins=2;
base_side_pins=1;

module base() {
    difference() {
        shelf();
        dirror_y(depth)
        translate([width-caster_clearance,0])
        rotate([0,0,90])
        negative_tails(width-caster_clearance*2,wood,caster_pins,pintail_gap,pintail_hole,pintail_ear);
  
        brace_tails();

        // side joint
        dirror_x(width)
        translate([0,caster_clearance])
        negative_pins(depth-caster_clearance*2,wood,base_side_pins,pintail_gap,0,pintail_ear);
    }
}

module brace_tails() {

    // brace
    dirror_y(depth)
    translate([0,caster_clearance+wood])
    rotate([0,0,-90])
    dirror_x(wood)
    negative_tails(width,wood,width_pins,pintail_gap,pintail_hole,pintail_ear);

    dirror_x(width)
    translate([caster_clearance,0])
    dirror_x(wood)
    negative_tails(depth,wood+pad,width_pins,pintail_gap,pintail_hole,pintail_ear);
}

//!base();

module top_back() {
    difference() {
        walled_vescher([width,top_back]);

        translate([wood,top_back])
        rotate([0,0,-90])
        negative_tails(width-wood*2,wood,width_pins,pintail_gap,pintail_hole,pintail_ear);

        dirror_x(width)
        negative_pins(top_back,wood,width_pins,pintail_gap,pintail_hole,pintail_ear);
    }
}

// RENDER stl
module nope() {
    echo(0);
}
