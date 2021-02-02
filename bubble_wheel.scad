od=190;
shaft=7;
shaft_wall=3;
shaft_od=shaft+shaft_wall*2;
shaft_h=15;

screw=2.7;

bubble=40;
ring=5;
ring_od=bubble+ring*2;
ring_h=2;


groove=0.7;
groove_h=groove;
groove_gap=2;

support=4;
support_h=1;
pad=0.1;

bubbles=1;

knife=ring_h-groove_h;
knife_side=sqrt(knife/2);

function groove_count(d)=floor(3.141*d/(groove_gap+groove));



$fn=90;

module knife() {
    translate([0,0,ring_h/2])
    rotate_extrude()
    translate([ring_od/2-ring,0])
    difference() {
        rotate([0,0,45])
        square([knife_side,knife_side],center=true);
        translate([0,-knife/2])
        square([knife,knife]);
    }

}


module positive() {
    cylinder(d=shaft_od,h=shaft_h);

    bubbles() cylinder(d=ring_od,h=ring_h);

    bubbles() 
    bubble(-1)
    support();
}

bubbles() knife();

module lazy_support() {
    hull() {
        cylinder(d=shaft_od,h=ring_h);
        cylinder(d=shaft_od,h=ring_h);
        //cylinder(d=ring_od,h=ring_h);
    }
}

drip_w=30;

drip_offset=0;

drip_h=30;
drip_thick=drip_h/2;
drip_point=2;


module point() {
    cylinder(d=drip_point,h=support_h);
}

module dirror_y() {
    children();
    mirror([0,1])
    children();
}

module support() {
    translate([0,-support/2])
    cube([od/2-ring,support,support_h]);

    dirror_y()
    translate([drip_offset,0])
    hull() {
        translate([0,-drip_w/2])
        point();

        translate([drip_h,0])
        point();

        translate([drip_h-drip_thick,0])
        point();
    }
}

module bubble(r=1) {
    translate([(od/2-ring_od/2)*r,0])
    children();
}
module bubbles() {
    for(z=[0:360/bubbles:359])
    rotate([0,0,z])
    bubble()
    children();
}

module groove(d) {
    for(z=[0:360/groove_count(d):359])
    rotate([0,0,z])
    translate([0,-groove/2,-pad])
    cube([d/2+pad,groove,groove_h+pad]);
}


screw_h=6;

module negative() {
    translate([0,0,-pad])
    cylinder(d=shaft,h=shaft_h+pad*2);
    bubbles()
    translate([0,0,-pad])
    cylinder(d=bubble,h=ring_h+pad*2);

    bubbles()
    grooves(ring_od);
    translate([0,0,screw_h])
    rotate([90,0,0])
    cylinder(d=screw,h=shaft_od*2,center=true);
}

module grooves(d) {
    groove(d);

    rotate([0,0,180/groove_count(d)])
    translate([0,0,ring_h])
    mirror([0,0,1])
    groove(d);
    
}


module assembled(){
    difference() {
        positive();
        negative();

    }
}

assembled();
