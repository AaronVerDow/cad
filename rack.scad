use <vescher.scad>;
in=25.4;
total_h=7*12*in;

rack=38*in;
base=75;

width=19*in;

depth=24*in;

lip=4*in;

//wood=in/4*3;
wood=in/2;

shelves=[
    base-wood,
    base+rack,
    total_h-wood
];

side_wall=3*in;

rack_wall=depth/2;

top_back=18*in;

castor_clearance=5*in;

translate([-240,30,base+rack+wood])
import("The_Wedge.stl");

module side() {
    walled_vescher([depth,total_h]) {
        for(z=shelves)
        translate([0,-side_wall+z])
        square([depth,side_wall*2+wood]);
        square([rack_wall,base+rack]);
    }
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


color("lime")
dirror_x(width)
rotate([90,0,90])
wood()
side();

dirror_y(depth)
color("blue")
translate([0,depth-castor_clearance])
rotate([90,0,00])
wood()
base_brace(); 

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

color("gray")
translate([width/2,depth-monitor[1]/2-wood,total_h-top_back+100])
cube(monitor,center=true);


dirror_y(depth)
translate([0,depth,base+rack-lip+wood])
rotate([90,0])
wood()
lip();

translate([0,wood,total_h-lip])
rotate([90,0])
wood()
lip();

module lip() {
    square([width,lip]);
}

module top() {
    walled_vescher([width,depth]);
}

module walled_vescher(box,wall=side_wall) {
    difference() {
        square(box);
        translate(box/2)
        vescher(box)
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



    color("red")
    translate([0,0,shelves[0]])
    wood()
    shelf();

    color("red")
    translate([0,0,shelves[1]])
    wood()
    bench();

module bench() {
    walled_vescher([width,depth]);
}


module base_brace() {
    square([width,base]);
}

module shelf() {
    square([width,depth]);
}

module top_back() {
    walled_vescher([width,top_back]);
}
