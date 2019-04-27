$fn=200;
big_fn=500;
wall=1.6;

base_wall=1.2;
in=25.4;

bag_size=36*in;

bag_gap=wall;
pi=3.14;
max_d=bag_size/pi+wall*2+bag_gap*2;
max_d=280-wall;
h=max_d;

can_d=max_d-wall*2-bag_gap*2;
ideal_bag_size=can_d*pi;
echo("Ideal bag size: (mm)");
echo(ideal_bag_size);
echo("Ideal bag size: (in)");
echo(ideal_bag_size/in);
echo("Maximum diameter");
echo(max_d);

// grocery bag is 36in

base_d=can_d-30;

pad=0.1;

lip_h=30;
points=6;

handle_d=120;
handle_r=handle_d/2;
handle_h=15;
handle_wall=wall*2;

grip_offset=00;
cut_top=handle_d/2-grip_offset-handle_h;

handle_location=200;
screw=3.5;

module fancy_body() {
        hull() {
            translate([0,0,h-lip_h])
            cylinder(d=can_d,h=lip_h,$fn=big_fn);
            cylinder(d=base_d,h=base_wall,$fn=points);
        }
}

module fancy_can() {
    difference() {
        fancy_body();
        hull() {
            translate([0,0,h-lip_h])
            translate([0,0,-pad])
            cylinder(d=can_d-wall*2,h=lip_h+pad*2);
            translate([0,0,base_wall])
            cylinder(d=base_d-wall*2,h=base_wall,$fn=points);
        }
    }
}

module can() {
    difference() {
        cylinder(d2=can_d,d1=base_d,h=h-lip_h);
        difference() {
            cylinder(d2=can_d-wall*2,d1=base_d-wall*2,h=h-lip_h);
            cylinder(d=can_d+pad*2,h=base_wall);
        }
    }
    translate([0,0,h-lip_h])
    difference() {
        cylinder(d=can_d,h=lip_h);
        translate([0,0,-pad])
        cylinder(d=can_d-wall*2,h=lip_h+pad*2);
    }
}

module lip() {
    difference() {
        cylinder(d=max_d,h=lip_h+base_wall+bag_gap);
        translate([0,0,base_wall])
        cylinder(d=max_d-wall*2,h=lip_h+base_wall+bag_gap);
        translate([0,0,-pad])
        cylinder(d=max_d-wall*4-bag_gap*2-pad,h=lip_h+base_wall+bag_gap);
    }
}

module handle() {
    difference() {
        translate([0,-can_d/2+7,handle_location])
        rotate([90,0,0])
        color("DimGray")
        long_handle();
        fancy_body();
    }
}

module handles() {
    handle();
    mirror([0,1,0])
    handle();
}

module assembled() {
    handles();
    fancy_can();
    color("DimGray")
    translate([0,0,h+wall])
    rotate([180,0,10])
    lip();
}

module handle_profile() {
    difference() {
        translate([0,-handle_h*4])
        square([handle_r,handle_h*5]);
        hull() {
            translate([handle_r,0])
            circle(r=handle_h-handle_wall);
            translate([handle_r,-handle_h*5])
            circle(r=handle_h-handle_wall);
        }
    }
}

module grip_corner() {
    translate([-handle_d/2+handle_h*2-handle_wall,0,-handle_h*4-pad*3])
    cylinder(r=handle_h-handle_wall,h=handle_h*5+pad*6);
}

module grip_corners() {
    hull() {
        grip_corner();
        mirror([1,0,0])
        grip_corner();
    }
}

module handle_screw() {
    rotate([0,0,15])
    translate([handle_d/2-handle_h-screw/2,0,-handle_h*4-pad])
    cylinder(d=screw,h=handle_h*5+pad-wall);
}

module handle_screws() {
    handle_screw();
    mirror([1,0,0])
    handle_screw();
}

module handle_to_print() {
    rotate([90,0,0])
    translate([0,can_d/2+7,-handle_location])
    handle();
}

module long_handle() {
    difference() {
        rotate_extrude()
        handle_profile();
        translate([-handle_d/2,handle_d/2-cut_top,-handle_h*4-pad*2])
        cube([handle_d,handle_d,handle_h*5+pad*4]);
        handle_screws();
        difference() {
            // hole in center
            translate([0,0,-handle_h*4-pad])
            cylinder(d=handle_d-handle_h*2,h=handle_h*5+pad*2);
            translate([0,grip_offset,0])
            difference() {
                // leave half
                translate([-handle_d/2,0,-handle_h*4-pad*2])
                cube([handle_d,handle_d,handle_h*5+pad*4]);
                intersection() {
                    // finger grip
                    hull() {
                        translate([-handle_d/2,0,0])
                        rotate([0,90,0])
                        cylinder(r=handle_h-handle_wall,h=handle_d);
                        translate([-handle_d/2,0,-handle_h*5])
                        rotate([0,90,0])
                        cylinder(r=handle_h-handle_wall,h=handle_d);
                    }
                    grip_corners();
                }
            }
        }
    }
}

display="";
if (display == "") assembled();
if (display == "trash_can.stl") fancy_can();
if (display == "trash_can_lip.stl") lip();
if (display == "trash_can_handle.stl") handle_to_print();
