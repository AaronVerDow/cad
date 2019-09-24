gotcha_d=11;
gotcha_r=gotcha_d/2;
gotcha_h=37;
gotcha_h_diff=gotcha_h-gotcha_d;

open_angle=9;

side_d=300;
side_r=side_d/2;
$fn=90;
pad=0.1;
padd=pad*2;
wall=2*2;

key_d=6;
key_r=key_d/2;

lock=wall/2/3;
lock_forgiveness=0.2;
lock_extra=0.5;

h=1.6;

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
    outer_d=key_d+wall+gotcha_d*2;
    key_placement(open_angle)
    intersection() {
        translate([0,0,h/2])
        cylinder(d1=key_d+wall,d2=outer_d,h=h/2+pad);
        translate([-outer_d+key_r+wall/2+pad,-outer_d/2,h/2-pad])
        cube([outer_d,outer_d,h]);
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

module lock_positive() {
    key_placement(open_angle)
    difference() {
        cylinder(r=key_r+lock,h=h+lock_extra);
        translate([0,0,-pad])
        cylinder(r=key_r,h=h+lock_extra+padd);
        translate([-key_r-lock,0,h+lock_extra])
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
    lock_positive();
    difference() {
        linear_extrude(height=h)
        whole();
        flatten_keys_reverse();
        lock_negative();
    }
}
three_d();
