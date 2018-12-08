d=150;
r=d/2;
h=130;
base_wall=0.8;
wall=1.2;
walll=wall*2;
pad=0.1;
padd=pad*2;
base=40;
side=30;
top=20;
$fn=200;

module body(wall=0) {
    translate([0,-base,0])
    hull() {
        sphere(d=d+wall*2);
        translate([0,0,h])
        sphere(d=d+wall*2);
    }
}

module top_cut() {
    translate([-r,-r-d+base+top,-pad-r])
    cube([d,r,h+d+padd]);
}

module base_cut() {
    translate([-r,0,-pad-r])
    cube([d,r,h+d+padd]);
}

module base_cut() {
    translate([-r,0,-pad-r])
    cube([d,r,h+d+padd]);
}
module side_cut() {
    translate([-side,-r-base,-r-pad])
    cube([d,d,h+d+padd]);
}
module all() {
    difference() {
        body();
        body(-wall);
        base_cut();
        side_cut();
        top_cut();
    }

    difference() {
        intersection() {
            translate([-r,-base_wall,-r])
            cube([d,base_wall,h+d]);
            body();
        }
        side_cut();
    }
}

rotate([-90,0,0])
all();
