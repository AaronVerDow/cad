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

onewheel_d=10*in;
onewheel_h=7*in;

onewheel_x=22*in;
onewheel_y=2*in;
onewheel_z=8*in;

bit=0.25*in;
cutgap=bit*3;

skirt=wall;

pintail_gap=bit/2;
pad=0.1;

pattern_hole=1.5*in;
pattern_gap=2.75*in;
pattern_max=box_x;

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

// RENDER svg
// RENDER png --camera=0,0,0,0,0,0,0
// PREVIEW
// RENDER scad
module cutsheet() {
    base_cutsheet()
    back_cutsheet()
    front_cutsheet()
    side_cutsheet()
    side_cutsheet();
}

module base_cutsheet() {
    base();
    translate([0,box_y+cutgap,0])
    children();
}

module side_cutsheet() {
    side();
    translate([0,box_z+cutgap+skirt,0])
    children();
}

module front_cutsheet() {
    front();
    translate([0,box_z+cutgap+skirt,0])
    children();
}

module back_cutsheet() {
    back();
    translate([0,box_z+cutgap+skirt,0])
    children();
}

module base() {
    color("lime")
    difference() {
        square([box_x,box_y],center=true);
        dirror_y()
        translate([box_x/2,-box_y/2-pad,0])
        rotate([0,0,90])
        negative_pins(box_x,wood+pad,2);
        dirror_x()
        translate([-box_x/2-pad,-box_y/2,0])
        negative_pins(box_y,wood+pad,2);
    }
}

module side() {
    color("blue")
    translate([0,-skirt/2])
    difference() {
        square([box_y,box_z+skirt],center=true);
        translate([box_y/2,-box_z/2+skirt/2,0])
        rotate([0,0,90]) {
            negative_tails(box_y,wood,2);
            tail_holes(box_y,wood,2,bit);
        }
        translate([-box_y/2-pad,-box_z/2+skirt/2]) {
            negative_pins(box_z,wood+pad,2);
            pin_holes(box_z,wood+pad,2,bit);
        }
        translate([box_y/2-wood,-box_z/2-skirt/2]) {
            negative_pins(box_z+skirt,wood+pad,2);
            pin_holes(box_z+skirt,wood+pad,2,bit);
        }
        translate([-onewheel_y/2,skirt/2-box_z/2+wood])
        square([onewheel_y,onewheel_z]);

        x=box_y/2-onewheel_y/2-wall*2-wood;
        dirror_x()
        translate([onewheel_y/2+wall+x/2,skirt/2+wood/2])
        intersection() {
            square([x,box_z-wall*2-wood],center=true);
            pattern();
        }
        
    }
}

module end_pattern() {
    translate([0,wood/2]) 
    intersection() {
        square([box_x-wall*2-wood*2, box_z-wood-wall*2],center=true);
        pattern();
    }
}

module front() {
    color("red")
    difference() {
        square([box_x,box_z],center=true);
        end_holes();
        dirror_x()
        translate([-box_x/2-pad,-box_z/2]) {
            negative_tails(box_z,wood+pad,2);
            tail_holes(box_z,wood+pad,2,bit);
        }
        end_pattern();
        
    }
}


module end_holes() {
    translate([box_x/2,-box_z/2])
    rotate([0,0,90]) {
        negative_tails(box_x,wood,2);
        tail_holes(box_x,wood,2,bit);
    }
}

module back() {
    color("magenta")
    difference() {
        translate([0,-skirt/2])
        square([box_x,box_z+skirt],center=true);
        end_holes();
        dirror_x()
        translate([box_x/2-wood,-box_z/2-skirt]) {
            negative_tails(box_z+skirt,wood+pad,2);
            tail_holes(box_z+skirt,wood+pad,2,bit);
        }
        end_pattern();
    }
}

module pintail_gaps(edge,depth,pins) {
    segments=pins*2+1;
    segment=edge/segments;

    for(y=[segment:segment:edge-1])
    translate([0,y-pintail_gap/2])
    square([depth,pintail_gap]);
}

module negative_pins(edge,depth,pins) {
    segments=pins*2+1;
    segment=edge/segments;

    for(y=[0:segment*2:edge])
    translate([0,y])
    square([depth,segment]);

    pintail_gaps(edge,depth,pins);

}

module pintail_test(count=2) {
    test=200;
    color("lime")
    negative_pins(test,wood,count);
    color("blue")
    negative_tails(test,wood,count);
    color("red")
    translate([0,0,1])
    pin_holes(test,wood,count,4);
}

module tail_holes(edge,depth,pins,hole) {
    segments=pins*2+1;
    segment=edge/segments;

    for(y=[segment/2:segment*2:edge])
    translate([depth/2,y])
    circle(d=hole);
}


module pin_holes(edge,depth,pins,hole) {
    segments=pins*2+1;
    segment=edge/segments;

    for(y=[segment*1.5:segment*2:edge])
    translate([depth/2,y])
    circle(d=hole);
}

module negative_tails(edge,depth,pins) {
    segments=pins*2+1;
    segment=edge/segments;

    for(y=[segment:segment*2:edge-1])
    translate([0,y])
    square([depth,segment]);
    pintail_gaps(edge,depth,pins);

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

assembled();
