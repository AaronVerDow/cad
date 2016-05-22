shelf_x=24.5;
shelf_y=17.5;
keg=10;
keg_from_back=7;
keg_wall=2;
corner=2;
hole=0.25;
$fn=120;
drink=3;
spike=0.25;
spike_from_front=3;
spike_gap=6;

co2=6;
co2_from_side=13.5;
co2_from_back=8;

back_shelf=7;


difference() {
    translate([corner,corner])
    minkowski() {
        square([shelf_x-corner*2,shelf_y-corner*2]);
        circle(r=corner);
    }
    translate([shelf_x,0])
    for(y=[spike_from_front:spike_gap:spike_gap*3]) {
        for(x=[drink:drink:drink*2]) {
            //translate([-x,y])
            //spike();
        }
    }
    hull() {
        hull() {
            translate([keg/2+keg_wall,shelf_y-keg/2-keg_from_back])
            circle(d=keg);
            translate([keg/2+keg_wall,0])
            circle(d=keg);
        }   
        hull() {
            translate([co2_from_side,shelf_y-co2/2-co2_from_back])
            circle(d=co2);
            translate([co2_from_side,0])
            circle(d=co2);
        }
    }
    hull() {
        translate([corner+keg_wall,0])
        circle(r=corner);
        translate([shelf_x-corner-keg_wall,0])
        circle(r=corner);
        translate([corner+keg_wall,shelf_y-corner-back_shelf])
        #circle(r=corner);
        translate([shelf_x-corner-keg_wall,shelf_y-corner-back_shelf])
        circle(r=corner);
    }
}
module spike() {
    hull() {
        translate([0,-spike])
        circle(d=hole);
        translate([0,spike])
        circle(d=hole);
    }
}
