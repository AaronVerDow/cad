in=25.4;
pad=0.1;
zero=0.001;

post_x=in;
post_y=(sqrt(3)/2)*post_x;
post_corner=0.1;

segments=4; // how many segments to preview in assembled mode

text_size=1*in;
increment=1*in; // what increment should be measured.  Use this to change to metric

arm_y=5; // thickness of arm holding numbers
arm_z=arm_y;
arm_x=text_size*1.8+post_x/2;

printable_height=180; // largest axis for 3D printer

lock_depth=20; // how long interlocking pieces should be
lock_wall=2; // thickness of locking wall

increments_per_segment=floor((printable_height-lock_depth)/increment);
segment_height=increments_per_segment*increment;

flake_radius=arm_x; // radius of snowflake topper

gap=0.2; // extra space for smoother interlocking pieces

base=100; // roughly base radius
base_h=3; // base height

spike_tip=1;

spike_base=3;
spike_height=100;


explode=0; // seperate assembled pieces

// RENDER stl
module topper() {
    translate([0,0,flake_radius])
    rotate([90,0])
    snowflake();
    difference() {
        post();
        cylinder(d=post_x*2,h=segment_height);
    }
}

module post_profile() {
    hull() {
        translate([post_x/2,0])
        circle(d=post_corner);
        translate([-post_x/2,0])
        circle(d=post_corner);
        translate([0,-post_y])
        circle(d=post_corner);
    }
}

module post_negative() {
        translate([0,0,pad+segment_height-lock_depth-1-arm_z])
        linear_extrude(height=lock_depth+pad+1)
        offset(gap-lock_wall)
        post_profile();
}

module post() {
    translate([0,0,-arm_z])
    linear_extrude(height=segment_height)
    post_profile();

    translate([0,0,-lock_depth])
    linear_extrude(height=lock_depth)
    offset(-lock_wall)
    post_profile();
}

module segment(start=0) {
    translate([0,0,start*(increment+explode)]) {
        post();
        difference() {
            translate([0,0,-start*increment])
            for(i=[start:1:start+increments_per_segment-1]) {
                arm(i);
            }
            post_negative();
        }
    }
}

module assembled() {
    color("blue")
    translate([0,0,segments*(increment+explode)*increments_per_segment])
    topper();

    segments();

    translate([0,0,-increments_per_segment*explode])
    color("blue")
    base();
}

module segments() {
    for(s=[0:1:segments-1])
    if(s%2==0) {
        color("cyan")
        segment(s*increments_per_segment);
    } else {
        segment(s*increments_per_segment);
    }
}
module printable_segment(n) {
    rotate([-90,0])
    segment(n*increments_per_segment);
}

module arm(i) {
    if(i>0)
    translate([0,0,i*increment])
    if ( i%2 == 0 ) {
        right_arm(i);
    } else {
        left_arm(i);
    }
}

module right_arm(i) {
    arm_bar();
    translate([arm_x,0])
    arm_text(i, "right");
}

module arm_text(text, side) {
    rotate([90,0])
    linear_extrude(height=arm_y)
    text(str(text), font="Ubuntu:style=bold",size=text_size,halign=side);
}

module arm_bar() {
    translate([0,-arm_y,-arm_z])
    difference() {
        cube([arm_x+arm_z,arm_y,arm_z]);
        // translate([arm_x+arm_z,-pad]) rotate([-90,0]) cylinder(r=arm_z,h=arm_y+pad*2); # circle tip
    
        translate([arm_x,-pad])
        rotate([0,45,0])
        cube([arm_z*2,arm_y+pad*2,arm_z*5]); // fix with trig later
    }
}


module left_arm(i) {
    mirror([1,0])
    arm_bar();
    translate([-arm_x,0])
    arm_text(i, "left");
}

// RENDER stl
module base() {
    difference() {
        union() {
            translate([0,0,-base_h])
            linear_extrude(height=base_h)
            offset(base/2)
            post_profile();
            hull() {
                linear_extrude(height=zero)
                offset(spike_base)
                post_profile();

                translate([0,-post_y/2,-spike_height])
                linear_extrude(height=zero)
                circle(d=zero);
            }
        }
        post();
    }
}


module snowflake() {

    // copied from thingiverse

    // snowflake 3
    // @author Ilya Protasov

    /* TODO
    ? fix central figure for branch_count
    ? hole hanger type
    */

    /* [Base] */
    height = arm_y;
    radius = flake_radius;
    hanger_type = "none";// [ring, slot ,none]
    // only for slot hanger type
    slot_rounded = true;

    /* [Extended coefficients] */
    // coefficient of radius for central (main) branch thickness
    central_thickness_coef = 0.125; // [0:0.001:0.300]
    central_branch_start_coef = 0.25; // [0:0.001:1]

    middle_branch_start_coef = 0.5; // [0:0.001:1]
    middle_branch_length_coef = 0.3; // [0:0.001:1]
    middle_thickness_coef = 0.100; // [0:0.001:0.300]

    outer_branch_start_coef = 0.8; // [0:0.001:1]
    outer_branch_length_coef = 0.2; // [0:0.001:1]
    outer_thickness_coef = 0.100; // [0:0.001:0.300]

    // (for ring type hanger only)
    ring_inner_radius_coef = 0.065; // [0:0.001:0.300]
    // difference between outer and inner radius (for ring type hanger only)
    ring_thick_coef = 0.080; // [0:0.001:0.300]

    slot_start_coef = 0.95; // [0:0.01:1.000]
    // slot thickness coeficient from snowflake height
    slot_thick_coef = 0.100; // [0:0.001:2.200]
    // slot height coeficient from snowflake height
    slot_height_coef = 0.300; // [0:0.001:0.500]
    // change it only if slot intersects main sub branches
    slot_length_coef = 1.010; // [1.010:0.001:5.000]

    /* [Quality ] */
    //count of segments in arcs https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/Other_Language_Features#$fa,_$fs_and_$fn
    $fn = 24; 

    /* [Hidden]  */
    branch_count = 6;

    thickMain = radius * central_thickness_coef;
    middleThick = radius * middle_thickness_coef;
    outerThick = radius * outer_thickness_coef;

    module branchMain() {
        centralAngle = 120;//360 / branch_count * 2;
        lenHex = radius * central_branch_start_coef;
        middleStart = radius * middle_branch_start_coef;
        outerStart = radius * outer_branch_start_coef;
        
        //central hexagon
        translate([0, lenHex, 0]) rotate([0, 0, centralAngle]) branch2(thickMain, lenHex);
        
        //central branch
        translate([0, lenHex, 0]) branch2(thickMain, radius-lenHex);
        
        //middle branchs
        translate([0, middleStart, 0]) rotate([0, 0, 60]) branch2(middleThick, radius * middle_branch_length_coef);
        translate([0, middleStart, 0]) rotate([0, 0, -60]) branch2(middleThick, radius * middle_branch_length_coef);
        
        //outer branchs
        translate([0, outerStart, 0]) rotate([0, 0, 60]) branch2(outerThick, radius * outer_branch_length_coef);
        translate([0, outerStart, 0]) rotate([0, 0, -60]) branch2(outerThick, radius * outer_branch_length_coef);
    }

    module branch2(thick, length) {
        translate([-thick/2, 0, 0]) cube([thick, length, height], false);
        translate([0, length, 0]) cylinder(height, thick/2, thick/2, false);
    }

    module ring(height, outerR, innerR) {
        difference() {
            cylinder(height, outerR, outerR, true);
            cylinder(height * 2, innerR, innerR, true);
        }
    }

    module slot(length, thick, height, rounded = true) {
        if (rounded) {
            rotate([0, 90, 0]) {
                translate([0, thick/2 - height/2, 0]) 
                    cylinder(length, height/2, height/2, true);
                translate([0, -thick/2 + height/2, 0]) 
                    cylinder(length, height/2, height/2, true);
            }
        }
        
        cube([length,
              thick - height * (rounded ? 1 : 0), 
              height], true);
            
    }

    module snowflake3(branchCount) {
        angle = 360 / branchCount;
        ringInnerRadius = radius * ring_inner_radius_coef;
        ringThick = radius * ring_thick_coef;
        difference() {
            union() {
                for (i=[0:branchCount-1]) {
                    rotate([0, 0, i * angle]) branchMain();
                }
            }        
            if (hanger_type == "slot") {
                translate([0, radius * slot_start_coef, height/2])
                    slot(radius * central_thickness_coef * slot_length_coef,
                        radius * slot_thick_coef, 
                        height * slot_height_coef,
                        rounded = slot_rounded);
                }
        }
        if (hanger_type == "ring") {
            translate([0, radius + ringInnerRadius + ringThick, height/2])
                ring(height = height, 
                     outerR = ringInnerRadius + ringThick,
                     innerR = ringInnerRadius );
        }
        
            
    }

    color("DeepSkyBlue") snowflake3(branch_count);
}

// RENDER stl
module s0() {
    printable_segment(0);
}

// RENDER stl
module s1() {
    printable_segment(1);
}

// RENDER stl
module s2() {
    printable_segment(2);
}

// RENDER stl
module s3() {
    printable_segment(3);
}

// RENDER stl
module s4() {
    printable_segment(4);
}

// RENDER stl
module s5() {
    printable_segment(5);
}

// RENDER stl
module s6() {
    printable_segment(6);
}

assembled();
