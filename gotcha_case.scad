gotcha_d=11;
gotcha_r=gotcha_d/2;
gotcha_h=34.5;
gotcha_h_diff=gotcha_h-gotcha_d;

open_angle=9;

side_d=200;
side_r=side_d/2;
$fn=90;
pad=0.1;
padd=pad*2;
wall=4;

key_d=5.5;
key_r=key_d/2;

h=0.8;

module half_side(opening=0, extra=0, padding=0) {

    rotate([0,0,opening]) {
        translate([0,gotcha_h_diff+gotcha_r+key_r+wall/2])
        circle(d=key_d+extra);
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
            circle(d=side_d-extra);

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

module three_d(){
    linear_extrude(height=h)
    whole();
}
three_d();
