//$fn=260;
//$fn=65;
bolt=7;
bolt_gap=200;
bolt_r=3;

top_angle=45;
bottom_angle=top_angle;

layer_height=0.4;

front_offset=50;
front=40;
top_offset=bolt_gap/2+front/2;
bottom_offset=bolt_gap/2-front/2;

one_x=-50;
one_y=160;

two_x=45;
two_y=83;

three_x=45;
three_y=45;

four_x=0;
four_y=0;

light_bolt=6;
light_bolt_gap=10;

cheater=30;
cheater_h=10;

w=45;
w_r=w/2;


pad=0.1;
padd=pad*2;

led_strip=8;
led_strips=4;

bar_cut=10;
bar_h=led_strip*2;
bar_r=5;

bolt_angle=3;

max_w=174;

bolt_max_h=21;
bolt_h=bar_h*2;
bolt_corner=bolt_max_h-bolt_h;

rot_bolt=6;
rot_bolt_head=11;
rot_d2=w-bar_cut*2;
rot_d1=rot_bolt_head;
rot_h=bar_h-4;

led_h=2.5;
top_wall=2.4;
top_r=8;

light=136;
lip=4;
outer_light=light+30;
light_h=50;
lip_h=13;
thin_wall=3;
big_cavity=outer_light-thin_wall*2;
inner_lip=light+lip*2-7*2;
ring_gap=1;
ring_h=4;

// extra pushing down on the light
ring_grip=3;

ring_bolt=3;
ring_bolts=6;
trim_angle=7;
rotator_offset=13;

top_overlap = 3;

support=1;

lock=11;
lock_h=5;

rot_nut=12.5;
rot_nut_h=3;

notch_x=5;
notch_y=10.5;
notch_z=3.5;

filament=1.2;

top_extra_h=(max_w-outer_light)/2;

module old_bar_node() {
    minkowski() {
        cylinder(r=w_r-bar_cut-1,h=bar_h-bar_cut);
        cylinder(r1=bar_cut-bar_r+1,r2=1,h=bar_cut-bar_r);
    }
    
}
module inner_bar_node() {
    cylinder(d=led_strip*led_strips,h=led_strip*2);
}


module bar_node() {
    inner_bar_node();
}

module bolt_hole() {
    translate([0,0,-pad])
    cylinder(d=bolt,h=bolt_max_h+padd);
    translate([0,0,bolt_h-pad])
    cylinder(d1=w-bolt_corner*4,d2=w-bolt_corner*2,h=bolt_corner+padd);
}

module bolt_assembly() {
    //difference() {
        difference() {
            minkowski() {
                translate([0,0,bolt_h])
                cylinder(d1=w-bolt_r*2,d2=w-bolt_corner*2,h=bolt_corner-bolt_r);
                sphere(r=bolt_r);
            }
            bolt_hole();
        }
        difference() {
            cylinder(d=w,h=bolt_h);
            bolt_hole();
        }
    //}
}

module lock_negative() {
    translate([0,0,-pad])
    cylinder(d=lock,h=lock_h+pad);
    //translate([0,0,lock_h-pad])
    //cylinder(d1=lock,d2=0,h=lock/2);

    translate([one_x,one_y,cheater_h-pad])
    cylinder(d=lock,h=lock_h+pad);
}


module top_bar_node() {
    minkowski() {
        translate([0,0,-top_r])
        cylinder(d=led_strip*led_strips+led_h*2+top_wall*2-top_r*2,h=led_strip*2+led_h+top_wall+top_extra_h);
        sphere(r=top_r);
    }
}

module negative_bar_node() {
    minkowski() {
        translate([0,0,-top_r-led_h-top_wall])
        cylinder(d=led_strip*led_strips+led_h*2-top_r*2,h=led_strip*2+led_h*2+top_wall);
        sphere(r=top_r);
    }
}


module top_bar_assembly() {
    difference() {
        union() {
            hull() {
                translate([four_x,four_y,0])
                top_bar_node();
                translate([two_x,two_y,0])
                top_bar_node();
            }
            hull() {
                translate([two_x,two_y,0])
                top_bar_node();
                translate([one_x,one_y,0])
                top_bar_node();
            }
        }
        hull() {
            translate([four_x,four_y,0])
            negative_bar_node();
            translate([two_x,two_y,0])
            negative_bar_node();
        }
        hull() {
            translate([two_x,two_y,0])
            negative_bar_node();
            translate([one_x,one_y,0])
            negative_bar_node();
        }
        translate([0,0,led_h+top_wall])
        bolt_hole();
        translate([one_x,one_y,led_h+top_wall])
        bolt_hole();
        translate([-500,-500,-50-top_overlap])
        cube([1000,1000,50,]);
    }
    difference() {
        union() {
            translate([0,0,led_strip*2])
            cylinder(d=bolt+top_wall*2,h=led_h);
            translate([one_x,one_y,led_strip*2])
            cylinder(d=bolt+top_wall*2,h=led_h);
        }
        translate([0,0,led_h+top_wall])
        bolt_hole();
        translate([one_x,one_y,led_h+top_wall])
        bolt_hole();
    }
}


module inner_bar_assembly() {
    difference() {
        union() {
            hull() {
                translate([four_x,four_y,0])
                inner_bar_node();
                translate([two_x,two_y,0])
                inner_bar_node();
            }
            hull() {
                translate([two_x,two_y,0])
                inner_bar_node();
                translate([one_x,one_y,0])
                inner_bar_node();
            }
            translate([two_x,two_y,0])
            grooves_positive();
        }
        //rotator divot
        translate([two_x,two_y,bar_h-rot_h+pad])
        cylinder(d=rot_d1,h=rot_h);
        //rotator hole
        translate([two_x,two_y,-rot_h-layer_height])
        #cylinder(d=rot_bolt,h=bar_h+padd);
        bolt_hole();
        translate([one_x,one_y,0])
        bolt_hole();
        cheater_negative();
        lock_negative();
    }
}

module cheater_negative() {
    translate([one_x,one_y,-pad]){
        hull() {
            cylinder(h=cheater_h+pad,d=cheater);
            translate([-cheater*2,-cheater*2,0])
            cylinder(h=cheater_h+pad,d=cheater*2);
        }
    }
}

module sides() {
    rotate([90,0,-90]) {
        inner_bar_assembly();
        #top_bar_assembly();
    }
    translate([max_w,0,0])
    mirror([0,1,0])
    rotate([90,0,90]) {
        inner_bar_assembly();
        #top_bar_assembly();
    }
}


module ring_bolts() {
    for(ring_angle=[360/ring_bolts/2:360/ring_bolts:360+360/ring_bolts/2]) {
        rotate([0,0,ring_angle])
        translate([light/2+lip+ring_bolt/2+1,0,0])
        cylinder(d=ring_bolt,h=lip_h);
    }
}

rot_nut_shell=25;

module light_holder() {
    difference() {
        union() {
            //main body
            cylinder(d=outer_light,h=light_h);

            //curved shell
            translate([0,0,light_h])
            scale([1,1,2])
            rotate_extrude(convexity = 10)
            translate([light/2+(outer_light-light)/4,0,0])
            circle(d=(outer_light-light)/2);

            mirror([1,0,0])
            rot_node();

            rot_node();
        }
        //small cylinder
        translate([0,0,-pad])
        cylinder(d=light+lip*2,h=light_h+padd);

        //big cylinder
        difference() {
            translate([0,0,-pad])
            cylinder(d=big_cavity,h=light_h-lip_h+pad);

            translate([-max_w/2-pad,0,light_h-rotator_offset])
            rotate([0,90,0])
            cylinder(d=rot_nut_shell,h=max_w);
        }

        translate([0,0,light_h-lip_h-pad])
        ring_bolts();

        //angle cut
        translate([0,outer_light/2,0])
        rotate([-trim_angle,0,0])
        translate([-outer_light,-outer_light*2,-light_h])
        cube([outer_light*2,outer_light*2,light_h]);

        //rot bolts

        mirror([1,0,0])
        rot_bolt_negative();
        rot_bolt_negative();
    }
}

module rot_bolt_negative() {
    translate([-max_w/2-pad,0,light_h-rotator_offset])
    rotate([0,90,0])
    cylinder(d=rot_bolt,h=max_w-light);
    translate([-max_w/2+rot_nut_h,0,light_h-rotator_offset])
    rotate([0,90,0])
    cylinder(d=rot_nut,h=max_w-light,$fn=6);
}

groove=3;
groove_l=(led_strip*led_strips)/2;
grooves=20;

module grooves_positive() {
    difference() {
        intersection() {
            grooves(grooves/2);
            translate([0,0,-groove])
            cylinder(d=led_strip*led_strips,h=groove*2);
        }
        translate([0,0,-groove])
        cylinder(d=groove_l+groove,h=groove*2);
    }
}

module grooves(n=grooves) {
    for(i=[0:360/n:359]) {
        rotate([0,90,i])
        translate([0,0,groove_l/2])
        cylinder(d=groove,h=groove_l);
    }
}

module rot_node() {
    translate([-max_w/2,0,light_h-rotator_offset])
    rotate([0,90,0])
    difference() {
        cylinder(d=led_strip*led_strips,h=led_strip*2);
        grooves();
    }

    translate([-max_w/2,-filament/2,light_h+1.9])
    cube([led_strip*2-4,filament,rotator_offset]);
}

module ring() {
    color("cyan")
    translate([0,0,light_h-ring_h-lip_h])
    difference() {
        union() {
            cylinder(d=big_cavity-ring_gap*2,h=ring_h);
            translate([0,0,ring_h])
            cylinder(d=light,h=ring_grip);
        }
        translate([0,0,-pad])
        cylinder(d=inner_lip,h=ring_h+ring_grip+padd);
        translate([0,0,-pad])
        ring_bolts();
        translate([inner_lip/2-1,-notch_y/2,-pad])
        cube([notch_x+1,notch_y,ring_h+padd]);
        translate([-max_w/2-pad,0,light_h-rotator_offset-(light_h-ring_h-lip_h)])
        rotate([0,90,0])
        cylinder(d=rot_nut_shell,h=max_w);
    }
}


module assembled() {
    translate([max_w/2,-two_x-rotator_offset,two_y])
    rotate([90,0,0])
    translate([0,0,-light_h]) {
        light_holder();
        ring();
    }
    color("lime")
    sides();
}

module full_bar_node() {
    difference() {
        minkowski() {
            bar_node();
            sphere(bar_r);
        }
        translate([0,0,-bar_r*2])
        cylinder(d=w*2,h=bar_r*2);
    }
}

$fn=90;
display="";
if (display == "") assembled();
if (display == "grom_light_holder.stl") {
    $fn=300;
    rotate([180,0,0])
    light_holder();
}
if (display == "grom_inner_bar.stl") rotate([180,0,0]) inner_bar_assembly();
if (display == "grom_light_ring.stl") ring();
if (display == "grom_outer_bar.stl") {
    $fn=300;
    rotate([180,0,0])
    top_bar_assembly();
}
