$fn=60;
bolt=10;
bolt_gap=200;
bolt_r=5;

top_angle=45;
bottom_angle=top_angle;

front_offset=50;
front=40;
top_offset=bolt_gap/2+front/2;
bottom_offset=bolt_gap/2-front/2;

light_bolt=6;
light_bolt_gap=10;

w=70;
w_r=w/2;

bolt_max_h=20;
bolt_h=10;
bolt_corner=bolt_max_h-bolt_h;

pad=0.1;
padd=pad*2;

bar_cut=10;
bar_h=14;
bar_r=5;

module bar_node() {
    minkowski() {
        cylinder(r=w_r-bar_cut-1,h=bar_h-bar_cut);
        cylinder(r1=bar_cut-bar_r+1,r2=1,h=bar_cut-bar_r);
    }
}

module bolt_assembly() {
    difference() {
        minkowski() {
            difference() {
                union() {
                    translate([0,0,bolt_h])
                    cylinder(d1=w-bolt_r*2,d2=w-bolt_corner*2,h=bolt_corner-bolt_r);
                    cylinder(d=w-bolt_r*2,h=bolt_h);
                }
                translate([0,0,bolt_h-pad])
                cylinder(d1=w-bolt_corner*4+bolt_r*2,d2=w-bolt_corner*2+bolt_r*2,h=bolt_corner+padd);
            }
            sphere(r=bolt_r);
        }
        translate([0,0,-pad])
        cylinder(d=bolt,h=bolt_max_h+padd);
    }
}

module old_bar() {
    difference() {
        minkowski() {
            minkowski() {
                translate([-w/2+bar_cut+1,0,0])
                cube([w-bar_cut*2-2,bolt_gap,bar_h-bar_cut]);
                cylinder(r1=bar_cut-bar_r+1,r2=1,h=bar_cut-bar_r);
            }
            sphere(r=bar_r);
        }
        translate([-w,-bolt_gap/2,-bar_r*2])
        cube([w*2,bolt_gap*2,bar_r*2]);
        translate([0,0,-pad])
        cylinder(d=w-bolt_corner*2,h=bar_h+padd);
        translate([0,bolt_gap,-pad])
        cylinder(d=w-bolt_corner*2,h=bar_h+padd);
    }
}
module old_and_busted() {
    rotate([0,0,-bottom_angle])
    bar_assembly();
    translate([0,bolt_gap,0])
    rotate([0,0,180+top_angle])
    bar_assembly();
    translate([front_offset,0,0])
    bar_assembly();
}

bolt_assembly();
translate([0,bolt_gap,0])
bolt_assembly();

module bar_assembly() {
    difference() {
        minkowski() {
            union() {
                hull() {
                    bar_node();
                    translate([front_offset,bottom_offset,0])
                    bar_node();
                }
                hull() {
                    translate([front_offset,top_offset,0])
                    bar_node();
                    translate([0,bolt_gap,0])
                    bar_node();
                }
                hull() {
                    translate([front_offset,top_offset,0])
                    bar_node();
                    translate([front_offset,bottom_offset,0])
                    bar_node();
                }
            }
            sphere(r=bar_r);
        }
        translate([0,0,-pad])
        cylinder(d=w-bolt_corner*2,h=bar_h+padd);
        translate([0,bolt_gap,-pad])
        cylinder(d=w-bolt_corner*2,h=bar_h+padd);
    }
}

bar_assembly();
