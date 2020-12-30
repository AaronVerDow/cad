chain_od=35;

pad=0.1;
mate_gap=0.5;

gap=20;

// radius of corner
slide_r=3;

// thickness of slide
slide_h=slide_r+0.1;


chain_id=7;

sprocket_h=3.5;

height=10;

shoulder=11;
shoulder_h=(height-sprocket_h)/2;

rope_id=8;

screw=3.5;

top_od=20;
top_h=slide_h;
rope_od=top_od;


screw_wall=1;
$fn=90;

module seed() {
    translate([gap,0])
    cylinder(d=chain_od-slide_r*2,h=slide_h-slide_r);
    cylinder(d=rope_od-slide_r*2,h=slide_h-slide_r);
}

module base_positive() {
    translate([0,0,-slide_h+slide_r])
    difference() {
        minkowski() {
            hull() {
                seed();
            }
            sphere(r=slide_r);
        }
        translate([-rope_od,-chain_od/2-rope_od/2,slide_h-slide_r])
        cube([rope_od+chain_od+gap+guide_offset,chain_od+rope_od+guide_offset,slide_r*2]);
    }
    cylinder(d=rope_id,h=height);
    translate([gap,0])
    cylinder(d=chain_id,h=height);

    shoulder();
}

guide_r=slide_h/2;
guide_id=height;
guide_h=gap; //rope_od/2+chain_od/2+gap;
guide_od=guide_id+guide_r*4;
guide_offset=chain_od/2+guide_od/2;
guide_x=-guide_h/2+guide_r+gap/2;

//seed();
//base();
top();

module hull_extrude(h) {
    hull() {
        children();
        translate([0,0,h])
        children();
    }
}

module z_dupe(h) {
    children();
    translate([0,0,h])
    children();
}

module guide() {
    translate([guide_x,guide_offset,-height/2])
    rotate([0,90]) {
        z_dupe(guide_h-guide_r*2)
        rotate_extrude()
        translate([guide_od/2-guide_r,0])
        circle(r=guide_r);

        difference() {
            cylinder(d=guide_od,h=guide_h-guide_r*2);
            translate([0,0,-pad])
            cylinder(d=guide_id,h=guide_h+pad*2);
        }
    }
}


module shoulder() {
    translate([gap,0])
    intersection() {
        cylinder(d=shoulder,h=shoulder_h);
        translate([(chain_id-screw)/2,0])
        cylinder(d=shoulder,h=shoulder_h);
    }
}


// RENDER stl
module base() {
    difference() {
        base_positive();
        screw();
        screw(gap);
    }
}

module screw(x=0) {
    translate([x,0,-slide_h+screw_wall])
    cylinder(d=screw,h=height+slide_h);
}

color("purple") translate([0,0,-height]) base();
//top();

//base();




// RENDER stl
module top() {
    difference() {
        union() {
            difference() {
                minkowski() {
                    hull() {
                        cylinder(d=top_od-slide_r*2,h=top_h-slide_r);
                        translate([gap,0])
                        cylinder(d=top_od-slide_r*2,h=top_h-slide_r);
                        translate([guide_x+guide_h/4,0])
                        cube([guide_h/2-guide_r*2,guide_offset,slide_h-slide_r]);
                    }
                    sphere(r=slide_r);
                }
                translate([-top_od,-top_od,-slide_r*2])
                cube([top_od*2+gap+guide_offset,top_od*2+guide_offset,slide_r*2]);
            }
            translate([0,0,-shoulder_h])
            difference() {
                shoulder();
                translate([gap,0,-pad])
                cylinder(d=chain_id+mate_gap,h=shoulder_h+pad*2);
            } 
        }
        screw();
        screw(gap);
    }
    //minkowski() { 
        //sphere(r=slide_r);
    //}
    guide();
}
