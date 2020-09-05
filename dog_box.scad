// this file must be downloaded and placed in the same directory
use <joints.scad>;
in=25.4;

// size of intended cargo
bag_y=26*in;
bag_x=12*in;
bag_z=8*in;

// how thick the wood is.  I keep this a little large or the slots will be too tight
wood=1/2*in;

// thickness of wood around edges and joints
wall=0.75*in;

// outer size of box
box_x=bag_x+wood*2;
box_y=bag_y+wood*2;
box_z=8*in;

// comment out for a normal box
onewheel=false;

// wheel size 
onewheel_d=10.5*in;
onewheel_h=7*in;

// board size
onewheel_x=22*in;
onewheel_y=2.5*in;
onewheel_z=8*in;

// how far to slide in from center
onewheel_offset=-2.5*in;


// meta variable used in other places
bit=0.25*in;

// how far apart to space parts in cutsheet
cutgap=2*in;

// add holes for screwing in joints
joint_holes=0;
//joint_holes=bit;

// diameter of cuts in corners of joints
// zero to disable
ear=bit;

// more aggressive corner cuts
ear_extra=0;

// extra wood below bottom
// this is a must have for cargo nets
skirt=wall;

// diameter of mounting bolt holes
grom_bolt=10;

// placement of bolts within mounting pattern
// these will be mirrored across x axis
grom_x=[160,110,160,110];
grom_y=[0,57,225,282];

// move mounting pattern back on y axis
// multiple points can be defined
grom_overhang=[65,30];

// gap between joints
pintail_gap=bit/4;

// used to cleanup previews, should not impact actual part
pad=0.1;

// size of circles in the mesh pattern
pattern_hole=1.5*in;

// how far apart the circles are
pattern_gap=2.75*in;

// defines max size of cutsheet so anchors can be placed
cutsheet_x=box_x+box_z*2+skirt*2+cutgap*4;
cutsheet_y=box_y+box_z+skirt+cutgap*3;

// how many pins between side and base
side_base_pins=2;

module dirror_x(x=0) {
    children();
    translate([x,0,0])
    mirror([1,0,0])
    children();
}

module dirror_y(y=0) {
    children();
    translate([0,y,0])
    mirror([0,1,0])
    children();
}

// simple 3d model for preview
module onewheel() {
    #translate([0,0,onewheel_z/2+wood]) {
        cylinder(d=onewheel_d,h=onewheel_h,center=true);
        cube([onewheel_x,onewheel_y,onewheel_z],center=true);
    }
}

// extrude 2d drawings for preview
module wood(padding=0) {
    translate([0,0,-padding])
    linear_extrude(height=wood+padding*2)
    children();
}

// RENDER stl
// RENDER png
// PREVIEW
// RENDER scad
module assembled() {
    if(onewheel)
    translate([0,onewheel_offset,wall])
    onewheel();

    color("lime")
    wood()
    base();

    color("blue")
    dirror_x()
    translate([-box_x/2,0,box_z/2])
    rotate([90,0,90])
    wood()
    side();

    color("magenta")
    translate([0,box_y/2,box_z/2])
    rotate([90,0,0])
    wood()
    back();

    color("red")
    translate([0,wood-box_y/2,box_z/2])
    rotate([90,0,0])
    wood()
    front();

}

module cutsheet_corner() {
    square([cutgap,bit*1.1]);
    square([bit*1.1,cutgap]);
}

// RENDER svg
module cutsheet_drill() {
    translate([0,0,2])
    color("red")
    cutsheet(display="drill");
}

// RENDER svg
module cutsheet_inside() {
    translate([0,0,1])
    color("blue")
    cutsheet(display="inside");
}

// RENDER svg
module cutsheet_outside() {
    color("lime")
    cutsheet(display="outside");
}

// RENDER svg
// RENDER dxf
// RENDER png --camera=0,0,0,0,0,0,0
// PREVIEW
// RENDER scad
module cutsheet(display="") {
    translate([cutgap,cutgap]) {
        base_cutsheet(display)
        front_cutsheet(display);
        translate([box_x+cutgap,0])
        side_cutsheet(display)
        back_cutsheet(display);
        translate([box_x+box_z+skirt+cutgap*2,0])
        side_cutsheet(display);
    }
    color("white")
    dirror_x(cutsheet_x)
    dirror_y(cutsheet_y)
    cutsheet_corner();

    //translate([0,0,-1])
    //#square([in*12*4,in*12*4]);
}

module base_cutsheet(display="") {
    translate([box_x/2,box_y/2])
    base(display);
    translate([0,box_y+cutgap,0])
    children();
}

module side_cutsheet(display="") {
    translate([box_z/2,box_y/2])
    rotate([0,0,90])
    side(display);
    translate([0,box_y+cutgap,0])
    children();
}

module front_cutsheet(display="") {
    translate([box_x/2,box_z/2])
    front(display);
    translate([0,box_z+cutgap,0])
    children();
}

module back_cutsheet(display="") {
    translate([box_x/2,box_z/2+skirt])
    back(display);
    translate([0,box_z+cutgap+skirt,0])
    children();
}

module base_drill() {
    for(y=grom_overhang)
    translate([0,y-box_y/2])
    grom_plate();
}

module base_outside() {
    difference() {
        square([box_x,box_y],center=true);

        dirror_y()
        translate([box_x/2,-box_y/2-pad,0])
        rotate([0,0,90])
        negative_pins(box_x,wood+pad,2,pintail_gap,joint_holes,ear,ear_extra);

        dirror_x()
        translate([-box_x/2-pad,-box_y/2,0])
        negative_pins(box_y,wood+pad,2,pintail_gap,joint_holes,ear,ear_extra);
    }
}

module base(display="") {
    if(!display)
    color("lime")
    difference() {
        base_outside();
        base_drill();
    }

    if(display=="drill")
    base_drill();

    if(display=="outside")
    base_outside();
}

module side_outside() {
    difference() {
        square([box_y,box_z+skirt],center=true);

        translate([-box_y/2-pad,-box_z/2+skirt/2])
        negative_pins(box_z,wood+pad,2,pintail_gap,joint_holes,ear,ear_extra);

        translate([box_y/2-wood,-box_z/2-skirt/2])
        translate([wood,0])
        mirror([1,0,0])
        negative_pins(box_z+skirt,wood+pad,2,pintail_gap,joint_holes,ear,ear_extra);

        if(onewheel)
        translate([onewheel_offset-onewheel_y/2,skirt/2-box_z/2+wood+wall])
        square([onewheel_y,onewheel_z]);
    }
}

module side(display="") {
    translate([0,-skirt/2]) {
        if(!display)
        color("blue")
        difference() {
            side_outside();
            side_inside();
        }
        if(display=="inside")
        side_inside();
        if(display=="outside")
        side_outside();
    }
}

module side_inside() {
    translate([box_y/2,-box_z/2+skirt/2,0])
    rotate([0,0,90])
    dirror_x(wood)
    negative_tails(box_y,wood,side_base_pins,pintail_gap,joint_holes,ear,ear_extra);

    translate([0,skirt/2+wood/2])
    intersection() {
        difference() {
            square([box_y-wood*2-wall*2,box_z-wall*2-wood],center=true);
            if(onewheel)
            translate([onewheel_offset,0])
            square([onewheel_y+wall*2,box_z],center=true);
        }
        pattern();
    }
}

module end_pattern() {
    translate([0,wood/2]) 
    intersection() {
        square([box_x-wall*2-wood*2, box_z-wood-wall*2],center=true);
        pattern();
    }
}

module front_outside() {
    difference() {
        square([box_x,box_z],center=true);
        end_holes();

        dirror_x()
        translate([-box_x/2-pad,-box_z/2])
        negative_tails(box_z,wood+pad,2,pintail_gap,joint_holes,ear,ear_extra);
    }
}

module front(display="") {
    if(!display)
    color("red")
    difference() {
        front_outside();
        end_pattern();
    }
    if(display=="inside")
    end_pattern();
    if(display=="outside")
    front_outside();
}


module end_holes() {
    translate([box_x/2,-box_z/2])
    rotate([0,0,90])
    negative_tails(box_x,wood,2,pintail_gap,joint_holes,ear,ear_extra);
}

module back_outside() {
    difference() {
        translate([0,-skirt/2])
        square([box_x,box_z+skirt],center=true);

        dirror_x()
        translate([-box_x/2-pad,-box_z/2-skirt]) 
        negative_tails(box_z+skirt,wood+pad,2,pintail_gap,joint_holes,ear,ear_extra);
    }
}

module back_capture() {
    // fix dog bones because back is captured but front isn't
    
    // i'll pay for this later
    translate([box_x/2,-box_z/2])
    rotate([0,0,90]) 
    translate([wood,0])
    mirror([1,0])
    negative_tails(box_x,wood,2,pintail_gap,joint_holes,ear,ear_extra);
}

module back(display="") {
    if(!display)
    color("magenta")
    difference() {
        back_outside();
        end_holes();
        back_capture();
        end_pattern();
    }
    if(display=="inside") {
        end_holes();
        back_capture();
        end_pattern();
    }

    if(display=="outside")
    back_outside();
}

module pattern() {
    pattern_max=box_x+box_y;
    translate([-pattern_gap/2,0])
    dirror_y()
    dirror_x() {
        for(x=[0:pattern_gap:pattern_max])
        for(y=[0:pattern_gap:pattern_max])
        translate([x,y])
        circle(d=pattern_hole);

        for(x=[pattern_gap/2:pattern_gap:pattern_max])
        for(y=[pattern_gap/2:pattern_gap:pattern_max])
        translate([x,y])
        circle(d=pattern_hole);
    }
}

module grom_plate() {
    for(i=[0:1:3])
    dirror_x()
    translate([grom_x[i]/2,grom_y[i]])
    circle(d=grom_bolt);
}

//assembled();
cutsheet();
