handle=90;
handle_gap=50;
groove=10;
groove_depth=groove/2-2.5;
seam=groove*0.6;
from_wall=110;

end=10;
wall=2.0;

overall=from_wall+handle_gap+end;

$fn=300;

angle=10;
pad=0.1;
padd=pad*2;

base=3;

screw=5;
screw_head=8;

module body() {
    difference() {
        cylinder(d=handle,h=overall);
        difference() {
            translate([0,0,base])
            cylinder(d=handle-wall*2,h=overall+padd);
            grooves(wall);
        }
        translate([-overall,0,0])
        rotate([0,40,0])
        cylinder(d=handle,h=overall*2);
    }
}

module screw() {
    translate([0,0,-pad])
    cylinder(d=screw,h=base+padd);
    translate([0,0,base-(screw_head-screw)/2-pad])
    cylinder(d1=screw-padd,d2=screw_head+padd,h=(screw_head-screw)/2+padd);
}

module screws() {
    screw();
    for(i=[0:360/4:359]){
        rotate([0,0,i])
        translate([handle/6*2,0,0])
        screw();
    }
}

module groove() {
    rotate([0,-angle,0])
    rotate_extrude()
    translate([handle/2+groove/2,0])
    hull() {
        circle(d=groove);
        translate([0,seam])
        circle(d=1);
    }
}

module grooves(extra=0) {
    translate([-groove_depth-extra,0,from_wall]) {
        groove();
        translate([0,0,handle_gap])
        mirror([0,0,1])
        groove();
    }
}


module assembled() {
    difference() {
        body();
        grooves();
        screws();
    }
}
assembled();
