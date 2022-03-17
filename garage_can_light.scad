use <joints.scad>;
in=25.4;
wood=in/2;
light=165;
zero=0.01;
pad=0.1;

box_x=240;
box_y=177;
light_x=90;

rafter=150;
cable_offset=rafter*0.5;

cable_x=20;
cable_y=cable_x*3;

pins=1;

bit=in/4;
pintail_gap=in/16;
pintail_holes=0;
pintail_ear=bit;

$fn=90;

module wood(height=wood) {
    linear_extrude(height=height)
    children();
}

module base() {
    difference() {
        square([box_x,box_y+wood*2]);
        translate([light_x,box_y/2+wood])
        circle(d=light);
        dirror_y(box_y+wood*2)
        translate([box_x,-pad])
        rotate([0,0,90])
        negative_pins(box_x,wood+pad,pins,pintail_gap,pintail_holes,pintail_ear);
    }
}

module side() {
    difference() {
        hull() {
            square([zero,rafter]);
            square([box_x,wood]);
        }
        translate([0,cable_offset])
        hull()
        dirror_y()
        translate([0,cable_y/2-cable_x])
        circle(d=cable_x*2);
        translate([box_x,-pad])
        rotate([0,0,90])
        negative_tails(box_x,wood+pad,pins,pintail_gap,pintail_holes,pintail_ear);
    }
}

module dirror_y(y=0) {
    children();
    translate([0,y])
    mirror([0,1])
    children();
}

module assembled() {
    color("cyan")
    wood()
    base();

    dirror_y(box_y+wood*2)
    translate([0,wood])
    rotate([90,0])
    wood()
    side();
}

gap=in;

module cutsheet() {
    translate([0,-box_y-wood*2-gap])
    base();

    side();

    translate([box_x,rafter+wood+gap*1.3])
    rotate([0,0,180])
    side();
}

module cutsheets() {
    for(x=[0:1:4])
    for(y=[0:1:4])
    translate([box_x*x+gap*x,(box_y+wood*4+rafter+wood+gap*2.3)*y])
    cutsheet();
}

cutsheets();
