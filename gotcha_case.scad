// diameter of rounded bottom of gotcha case inside the groove
gotcha_d=10.5;

// height of gotcha inside groove
gotcha_h=37;

// angle to open the case for printing
open_angle=9;

// diameter of circle that defines the curve for the sides
// without this the sides will bow out from the gotcha
side_d=200;
pad=0.1;

// how wide the case is outside the actual gotacha
wall=4;
// I made a mistake so divide by two to get the thickness of one side

// thickness of wall of locking mechanism
lock=wall/2/3;

// hole inside of lock (for keyring)
key_d=6+lock*2;

// extra diameter of hole for lock
lock_forgiveness=0.2;

// height of case, thickness of groove
h=1.6;

// extra height of locking mechanism
lock_extra=h*3/2;

// how smooth are circles
$fn=90;

// outer diameter of flattening circle
// bigger makes less pronounced angle
flatten_outer_d=key_d+wall+gotcha_d;

// math
key_r=key_d/2;
padd=pad*2;
side_r=side_d/2;
gotcha_r=gotcha_d/2;
gotcha_h_diff=gotcha_h-gotcha_d;

module key(opening=0, extra=0, padding=0) {
        key_placement(opening, extra, padding)
        circle(d=key_d+extra);
}

module key_placement(opening=0, extra=0, padding=0) {
        rotate([0,0,opening])
        translate([0,gotcha_h_diff+gotcha_r+key_r+wall/2])
        children();
}

module half_side(opening=0, extra=0, padding=0) {
    key(opening, extra, padding);
    difference() {
        hull() {
            key(opening, extra, padding);
            if (extra > 0) {
                rotate([0,0,opening])
                intersection() {
                    translate([0,gotcha_h_diff])
                    circle(d=gotcha_d+extra);

                    translate([-gotcha_d,gotcha_h-gotcha_d])
                    square([gotcha_d,gotcha_d]);
                }
            }
        }
        rotate([0,0,opening])
        //take half
        translate([padding,-gotcha_r-extra-pad])
        square([side_r+extra+pad,gotcha_h+padd+extra*2]);
    }
    rotate([0,0,opening]) {
        difference() {
            hull() {
                //top
                translate([0,gotcha_h_diff])
                circle(d=gotcha_d+extra);

                // bottom
                circle(d=gotcha_d+extra);
            }
            //side
            o=gotcha_h_diff/2;
            h=side_r+gotcha_r;
            angle=asin(o/h);
            rotate([0,0,-angle])
            translate([-side_r-gotcha_r,0,0])
            circle(d=side_d-extra,$fn=200);

            //take half
            translate([padding,-gotcha_r-extra-pad])
            square([side_r+extra+pad,gotcha_h+padd+extra*2]);
        }
    }
}

module side() {
    difference() {
        half_side(open_angle, wall);
        half_side(open_angle, 0, pad);
    }
}

module whole() {
    side();
    mirror([1,0])
    side();
}

module flatten_key() {
    key_placement(open_angle)
    intersection() {
        translate([0,0,h/2])
        cylinder(d1=key_d+wall,d2=flatten_outer_d,h=h/2+pad);
        translate([-flatten_outer_d+key_r+wall/2+pad,-flatten_outer_d/2,h/2-pad])
        cube([flatten_outer_d,flatten_outer_d,h]);
    }
}

module flatten_keys() {
    flatten_key();
    mirror([1,0,0])
    flatten_key();
}

module flatten_keys_reverse() {
    flatten_key();
    translate([0,0,h])
    mirror([0,0,1])
    mirror([1,0,0])
    flatten_key();
}

module lock_positive(height=h+lock_extra) {
    key_placement(open_angle)
    difference() {
        cylinder(r=key_r,h=height);
        translate([0,0,-pad])
        cylinder(r=key_r-lock,h=height+padd);
        translate([-key_r-lock,0,height])
        rotate([0,atan(h/2/(key_d+lock*2)),0])
        cylinder(r=key_d*3,h=h);
    }
}

module lock_negative() {
    key_placement(-open_angle)
    translate([0,0,-pad])
    cylinder(r=key_r+lock+lock_forgiveness,h=h+padd);
}

module three_d(){
    difference() {
        linear_extrude(height=h)
        whole();
    }
}

module thick() {
    lock_positive();
    three_d();
}

module flat_flexible() {
    lock_positive(h/2+lock_extra);
    difference() {
        three_d();
        flatten_keys();
    }
}

module flat_flexible_reversed() {
    lock_positive(h/2+lock_extra);
    difference() {
        three_d();
        flatten_keys_reverse();
    }
}

module all() {
    thick();
    translate([gotcha_h,0,0])
    flat_flexible();
    translate([gotcha_h*2,0,0])
    flat_flexible_reversed();
}

display="";
if (display == "") all();
if (display == "gotcha_case_thick_flexible.stl") thick();
if (display == "gotcha_case_flat.stl") flat_flexible();
if (display == "gotcha_case_support_required.stl") flat_flexible_reversed();
