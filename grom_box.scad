use <joints.scad>;
in=25.4;
bag_y=16*in;
bag_x=18.5*in;
bag_z=10*in;

wood=1/2*in;

wall=0.75*in;

echo("vpr");
echo($vpr);
echo("vpt");
echo($vpt);
echo("vpd");
echo($vpd);
box_x=bag_x+wood*2;
box_y=bag_y+wood*2;
box_z=8*in;



onewheel_d=10.5*in;
onewheel_h=7*in;

onewheel_x=22*in;
onewheel_y=2.5*in;
onewheel_z=8*in;

onewheel_offset=-2.5*in;

grom_bolt=10;

bit=0.25*in;
cutgap=2*in;
joint_holes=0;

ear=bit;
ear_extra=0;

skirt=wall;

grom_x=[140,115,111];
grom_y=[0,104,131];


pintail_gap=bit/4;
pad=0.1;

pattern_hole=1.5*in;
pattern_gap=2.75*in;
pattern_max=box_x;

grom_overhang=[3*in,5*in,8*in];

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

module onewheel() {
    #translate([0,0,onewheel_z/2+wood]) {
        cylinder(d=onewheel_d,h=onewheel_h,center=true);
        cube([onewheel_x,onewheel_y,onewheel_z],center=true);
    }
}

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

cutsheet_x=box_x+box_z+skirt+cutgap*3;
cutsheet_y=box_y+box_z*2+skirt+cutgap*4;

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
// RENDER png --camera=0,0,0,0,0,0,0
// PREVIEW
// RENDER scad
module cutsheet(display="") {
    translate([cutgap,cutgap]) {
        base_cutsheet(display)
        back_cutsheet(display)
        front_cutsheet(display);
        translate([box_x+cutgap,0])
        side_cutsheet(display)
        side_cutsheet(display);
    }
    color("white")
    dirror_x(cutsheet_x)
    dirror_y(cutsheet_y)
    cutsheet_corner();
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
    translate([0,y-box_x/2])
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

side_base_pins=2;

module side_outside() {
    difference() {
        square([box_y,box_z+skirt],center=true);

        translate([-box_y/2-pad,-box_z/2+skirt/2])
        negative_pins(box_z,wood+pad,2,pintail_gap,joint_holes,ear,ear_extra);
        translate([box_y/2-wood,-box_z/2-skirt/2])
        translate([wood,0])
        mirror([1,0,0])
        negative_pins(box_z+skirt,wood+pad,2,pintail_gap,joint_holes,ear,ear_extra);
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


    // mirrored pattern
    //x=box_y/2-onewheel_y/2-wall*2-wood;
    //dirror_x()
    //translate([onewheel_y/2+wall+x/2,skirt/2+wood/2])
    //intersection() {
        //square([x,box_z-wall*2-wood],center=true);
        //pattern();
    //}

    translate([0,skirt/2+wood/2])
    intersection() {
        difference() {
            square([box_y-wood*2-wall*2,box_z-wall*2-wood],center=true);
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

module pintail_gaps(edge,depth,pins) {
    segments=pins*2+1;
    segment=edge/segments;

    for(y=[segment:segment:edge-1])
    translate([0,y-pintail_gap/2])
    square([depth,pintail_gap]);
}

module pattern() {
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
    for(i=[0:1:2])
    dirror_x()
    translate([grom_x[i]/2,grom_y[i]])
    circle(d=grom_bolt);
}
