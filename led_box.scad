//$fn=50;
box_x=150;
box_z=210;
box_y=80;

peak_d=10;
peak=box_x/3;

layer_h=0.8;
filament=1.2;
wall=filament*3;
pad=0.1;
padd=pad*2;

button=30;

mount_x=40;
mount_y=15;

screw=5;
screw_slide=15;

wall_r=17;
wall_d=wall_r*2;

//top variables
overhang=mount_y;
top_h=4;
gap=2;
lock=25;
fuck_this_is_a_lot_of_math=overhang;
clip=4;

zip=4;
zip_h=15;

lip_grip=4;
lip_grip_h=4;
lip_x=70;
lip_y=lip_grip+wall;
lip_z=lip_grip_h+wall*2;


module one_mesh() {
    for(i=[0:filament*3:box_x*2]) {
        translate([i,0,0])
        cube([filament,box_x*2,layer_h]);
    }
}


module combo_mesh() {
    translate([box_x/2,box_y/2,0])
    rotate([0,0,45])
    translate([-box_x,-box_x,0]) {
        one_mesh();
        translate([box_x*2,0,layer_h])
        rotate([0,0,90])
        one_mesh();
    }
}

module mc(x,z) {
    translate([x,-pad,z])
    rotate([-90,0,0])
    cylinder(d=screw,h=mount_y+padd);
}

module screw_slide() {
    hull() {
        mc(screw/2+wall,0);
        mc(mount_x-screw/2-wall,0);
        mc(mount_x/2,mount_x/2-wall*2);
    }
    hull() {
        mc(mount_x/2,0);
        mc(mount_x/2,mount_x/2-wall*2+screw_slide);
    }
    hull() {
        translate([mount_x/2,-pad,mount_x/2-wall*2+screw_slide])
        rotate([-90,0,0])
        cylinder(d=mount_x-wall*2,h=mount_y+pad-wall);
        translate([wall,-pad,0])
        cube([mount_x-wall*2,mount_y+pad-wall,1]);
    }
}

module zip_tie(z) {
    translate([-pad,-pad,-zip_h/2+z])
    cube([mount_x+padd,zip+pad,zip_h]);
}

module mount() {
    translate([box_x/2-mount_x/2,box_y,0])
    difference() {
        union() {
            cube([mount_x,mount_y,box_z]);
            translate([mount_x/2,0,box_z])
            rotate([-90,0,0])
            cylinder(d=mount_x,h=mount_y);
        }
        screw_slide();
        translate([0,0,box_z-mount_x/2+wall/2-screw_slide])
        screw_slide();
        translate([0,0,(box_z-mount_x/2+wall/2-screw_slide)/2])
        screw_slide();
        zip_tie(box_z/4);
        zip_tie(box_z/4*3);
    }
}

module top() {
    color("lime")
    translate([0,0,box_z-overhang])
    difference() {
        union() {
            difference() {
                union() {
                    hull() {
                        top_shape();
                        translate([0,0,top_h])
                        top_shape();
                    }
                }
                translate([0,0,-pad])
                scale([1,2,1])
                top_shape();
            }
            difference() {
                intersection() {
                    top_shape();
                    difference() {
                        translate([wall_r+gap/2,wall_r+gap/2,-pad])
                        minkowski() {
                            cube([box_x-wall_d-gap,box_y-wall_d-gap,box_z+peak*2]);
                            cylinder(r=wall_r-wall,h=wall_d);
                        }
                        translate([wall_r+gap/2,wall_r+gap/2,-pad])
                        minkowski() {
                            cube([box_x-wall_d-gap,box_y-wall_d-gap,box_z+peak*2]);
                            cylinder(r=wall_r-wall-wall,h=wall_d);
                        }
                    }
                }
                translate([0,0,-lock])
                top_shape();
            }
        }
        translate([-overhang-pad, -overhang-pad, -pad])
        cube([box_x+overhang*2+padd,box_y+overhang*2+padd,top_h+pad]);
    }
}
module top_shape() {
    hull() {
        translate([-overhang, -overhang,0])
        cube([box_x+overhang*2,box_y+overhang*2,pad]);
        translate([box_x/2,-overhang,peak+fuck_this_is_a_lot_of_math])
        rotate([-90,0,0])
        cylinder(d=wall_d,h=box_y+overhang*2);
    }
}

module body_positive() {
    minkowski() {
        cube([box_x-wall_d,box_y-wall_d,box_z-wall_d]);
        cylinder(r=wall_r,h=wall_d);
    }
}

power_wire=10;

module bottom_mesh() {
    difference() {
        union() {
            translate([wall_r,wall_r,0])
            intersection() {
                body_positive();
                combo_mesh();
            }
            translate([box_x/2,box_y/2,0])
            cylinder(d=power_wire+filament*2,h=layer_h*2);
        }
        translate([box_x/2,box_y/2,-pad])
        cylinder(d=power_wire,h=layer_h*2+padd);
    }
}

module body() {
    difference() {
        union() {
            hull() {
                translate([wall_r,wall_r,0])
                body_positive();
                translate([box_x/2,0,box_z+peak])
                rotate([-90,0,0])
                cylinder(d=wall_d,h=box_y);
            }
        }
        translate([wall_r,wall_r,-pad])
        minkowski() {
            cube([box_x-wall_d,box_y-wall_d,box_z+peak*2]);
            cylinder(r=wall_r-wall,h=wall_d);
        }
        translate([box_x/2,-pad,box_z+button/2])
        rotate([-90,0,0])
        cylinder(d=button,h=wall+padd);
    }
    lip();
    mount();
    bottom_mesh();
}

module lip() {
    translate([box_x/2-lip_x/2,box_y-wall-lip_y,0]) {
        difference() {
            cube([lip_x,lip_y,lip_z]);
            translate([-pad,lip_y-lip_grip,lip_z-lip_grip_h])
            cube([lip_x+padd,lip_grip+pad,lip_grip_h+pad]);
        }
    }
}

top();
body();
