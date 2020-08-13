chain_od=35;

pad=0.1;
mate_gap=0.5;

gap=20;

// radius of corner
slide_r=3;

// thickness of slide
slide_h=slide_r+1;


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

module base_positive() {
    translate([0,0,-slide_h+slide_r])
    difference() {
        minkowski() {
            hull() {
                translate([gap,0])
                cylinder(d=chain_od-slide_r*2,h=slide_h-slide_r);
                cylinder(d=rope_od-slide_r*2,h=slide_h-slide_r);
            }
            sphere(r=slide_r);
        }
        translate([-rope_od,-chain_od/2-rope_od/2,slide_h-slide_r])
        cube([rope_od+chain_od+gap,chain_od+rope_od,slide_r*2]);
    }
    cylinder(d=rope_id,h=height);
    translate([gap,0])
    cylinder(d=chain_id,h=height);

    shoulder();
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

color("lime") translate([0,0,-height]) base();

top();


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
                    }
                    sphere(r=slide_r);
                }
                translate([-top_od,-top_od,-slide_r*2])
                cube([top_od*2+gap,top_od*2,slide_r*2]);
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
}
