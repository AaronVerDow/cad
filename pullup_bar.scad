x=4+5/8;

y=46;
d=1.5;
angle=35;
gap=6;

slot_min=5;
slot_max=y;
offset=0.7;
$fn=90;

module slot(h,w,a) {
    translate([x/2+w,h]) {
        rotate([0,0,a])
        hull() {
            circle(d=d);
            translate([0,x])
            circle(d=d);
        }
    }
}

difference() {
    square([x,y]);
    translate([0,gap])
    for(i=[slot_min:gap*2:slot_max]) {
        slot(i,-offset,angle);
    }
    for(i=[slot_min:gap*2:slot_max]) {
        slot(i,offset,-angle);
    }
}
