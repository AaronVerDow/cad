$fn=200;

extrusion_width=1.6; // << Please adjust this for clean prints
wall=extrusion_width*1; // thickness of everything

layer_height=0.4; // used for first layer supports only
in=25.4; // used for conversion 

plate_y=158; // edge to edge of plate height


// top (face) of part
grip=wall; // thickness of edge that grips plate 
lip=1.6; // thickness of the outslide lip of plate
backing=wall; // thickness of holder backing
// bottom (backing) of part

total_h=grip+lip+backing;

screw_gap_x=7*in; // distance between screws, x
screw_gap_y=4.75*in; // distance between screws, y
screw=12; // diameter of screw holes

// big "hole" that lets you see the plate
hole_x=295;
hole_y=144;
hole_d=1*in;
hole_r=hole_d/2;

cover=(plate_y-hole_y)/2; // how much covers the edge of plate 
// quick hack to force uniform border
// x cover was too narrow, based on hole size instead of measurements
plate_x=cover*2+hole_x;

// pad negative space for clean differences
pad=0.1;
padd=pad*2;

// diameter of plate edge
plate_d=hole_d+cover/2+wall*2;
plate_r=plate_d/2;

// determines size of supports
sup_height=plate_y/4*3;
sup_width=plate_y/2;

//plate_holder();
for_printer();

support_gap=0.3;

module plate_holder() {
    difference() {
        positive();
        plate_slot(); // slot edges of plate slides into
        plate_hole(); // hole so you can see the plate
        screws();
        cut_in_half();
        filament_saver();
    }
}

module for_printer() {
    rotate([0,-90,0]) {
        plate_holder();
        supports();
    }
}

module positive() {
    translate([plate_r,plate_r,0])
    minkowski() {
        cube([plate_x-plate_d,plate_y-plate_d,total_h/2]);
        cylinder(d=plate_d+wall*2,h=total_h/2);
    }
}

module filament_saver() {
    translate([plate_x/4,plate_y/2,-pad])
    scale([(plate_x/2-cover*2)/screw_gap_x,(screw_gap_y-screw*2)/screw_gap_x,1])
    cylinder(d=screw_gap_x,h=backing+padd);
}

module cut_in_half() {
    translate([plate_x/2,-plate_y/2,-plate_y/2])
    cube([plate_x,plate_y*2,plate_y*2]);
}

module supports() {
    // vertical supports
    support(plate_y*9/10);
    support(plate_y/10);
    // first layer "mouse ear"
    translate([-wall,0,-sup_width-support_gap])
    cube([layer_height,plate_y,sup_width]);
}

module support(y) {
    hyp=sqrt(sup_height*sup_height+sup_width*sup_width);
    difference() {
        translate([-wall,y,-sup_width])
        rotate([0,atan(sup_height/sup_width),0])
        translate([-hyp,-extrusion_width/2,0])
        cube([hyp,extrusion_width,hyp]);
        translate([-plate_x/2,0,-support_gap])
        cube([plate_x,plate_y*2,plate_y*2]);
        translate([-plate_x-wall,0,-plate_y])
        cube([plate_x,plate_y*2,plate_y*2]);
    }
}

module plate_slot() {
    difference() {
        translate([plate_r,plate_r+wall,backing])
        minkowski() {
            cube([plate_x-plate_d,plate_y-plate_d-wall*2,lip/2]);
            cylinder(d=plate_d+wall*2,h=lip/2);
        }
        translate([-wall-pad,0,0])
        cube([wall+pad,plate_y,total_h]);
    }
}

module plate_hole() {
    translate([hole_r-hole_x/2+plate_x/2,hole_r-hole_y/2+plate_y/2,backing])
    minkowski() {
        cube([hole_x-hole_d,hole_y-hole_d,total_h/2+pad]);
        cylinder(d=hole_d,h=total_h/2+pad);
    }
}

module screws() {
    translate([0,-screw_gap_y/2+plate_y/2,0]) {
        screws_x(0);
        screws_x(screw_gap_y);
    }
}

module screws_x(y) {
    translate([-screw_gap_x/2+plate_x/2,y,0]) {
        screw(0,0);
        screw(screw_gap_x,0);
    }
}

module screw(x, y) {
    translate([x,y,-pad])
    cylinder(d=screw,h=total_h+padd);
}
