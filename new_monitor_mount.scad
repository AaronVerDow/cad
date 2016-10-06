include <polyScrewThread_r1.scad>;
PI=3.141592;
$fn=35;

/* Example 01.
 * Just a 100mm long threaded rod.
 *
 * screw_thread(15,   // Outer diameter of the thread
 *               4,   // Step, traveling length per turn, also, tooth height, whatever...
 *              55,   // Degrees for the shape of the tooth 
 *                       (XY plane = 0, Z = 90, btw, 0 and 90 will/should not work...)
 *             100,   // Length (Z) of the tread
 *            PI/2,   // Resolution, one face each "PI/2" mm of the perimeter, 
 *               0);  // Countersink style:
 *                         -2 - Not even flat ends
 *                         -1 - Bottom (countersink'd and top flat)
 *                          0 - None (top and bottom flat)
 *                          1 - Top (bottom flat)
 *                          2 - Both (countersink'd)
 */
//screw_thread(60,4,55,15,PI/2,2);

pad=0.1;
padd=pad*2;
vesa=100;
outer_wall=10;
base_h=4;
screw_d=4.5;
screw_head=12;
screw_head_h=base_h/2+padd;
max_z=60;

peg_d=15;
peg_r=peg_d/2;

peg_wall=6;
peg_wall_d=peg_d+peg_wall*2;
peg_wall_r=peg_wall_d/2;

peg_h=(vesa-outer_wall*2)/3;
peg_y=vesa-peg_d;
peg_z=peg_wall_r+base_h;

gap=1;

corner=2.5;
cornerr=corner*2;

module base() {
    difference() {
        minkowski() {
            cylinder(r=outer_wall,h=base_h/2);
            cube([vesa,vesa,base_h/2]);
        }
        translate([0,0,-pad]) {
            cylinder(d=screw_d,h=base_h+padd);
            translate([0,0,base_h/2])
            cylinder(d=screw_head,h=screw_head_h);
            translate([vesa,0,0])
            cylinder(d=screw_d,h=base_h+padd);
            translate([vesa,0,base_h/2])
            cylinder(d=screw_head,h=screw_head_h);
            translate([vesa,vesa,0])
            cylinder(d=screw_d,h=base_h+padd);
            translate([0,vesa,0])
            cylinder(d=screw_d,h=base_h+padd);
        }
    }
}

//hook();


module hook() {
    translate([vesa/2-peg_h/2+corner,0,0])
    minkowski() {
        difference() {
            hull() {
                translate([0,peg_y,peg_z])
                rotate([0,90,0])
                cylinder(h=peg_h-cornerr,d=peg_wall_d-cornerr);

                translate([0,-outer_wall+corner,corner])
                cube([peg_h-cornerr,vesa+outer_wall*2-cornerr,base_h-corner]);
            }
            hull() {
                translate([-pad,peg_y,peg_z])
                rotate([0,90,0])
                cylinder(h=peg_h+padd*2,d=peg_d+cornerr);
                translate([-pad,peg_y+peg_h*2,peg_z])
                rotate([0,90,0])
                cylinder(h=peg_h+padd*2,d=peg_d+cornerr);
            }
        }
        sphere(r=corner);
    }
}

module peg() {
    translate([vesa/2-peg_h,peg_y,peg_z])
    rotate([0,90,0])
    cylinder(h=peg_h*2,d=peg_d-gap*2);

    translate([vesa/2-peg_h-peg_h/2+corner-gap,0,0])
    peg_side();
    translate([vesa/2+peg_h/2+corner+gap,0,0])
    peg_side();
}

module peg_side() {
    minkowski() {
        hull() {
            translate([0,peg_y,peg_z])
            rotate([0,90,0])
            cylinder(h=peg_h-cornerr,d=peg_wall_d-cornerr);

            translate([0,-outer_wall+corner,corner])
            cube([peg_h-cornerr,vesa+outer_wall*2-cornerr,base_h-corner]);
        }
        sphere(r=corner);
    }
}

//translate([0,0,peg_z*2])
//mirror([0,0,1]) {
    //hook();
    //base();
//}
hook();
base();
