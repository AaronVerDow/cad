//fiat

groove=12;
groove_h=47;
// how wide the stand is
stand=28;

// flat section at top of the stand
platform=73;
// rounded part
cup_w=38;
cup_h=17*2;
// bottom groove in jack stand
bottom_groove=10;

pad=0.1;
padd=pad*2;

wall=6;
walll=wall*2;
$fn=200;
layer_h=0.4;
mouse_ears_wall=50;


//accord

groove=12;
groove_h=22; // to rest
groove_h=38; // to clear
// how wide the stand is
stand=38;

// flat section at top of the stand
platform=73;
// rounded part
cup_w=38;
cup_h=17*2;
// bottom groove in jack stand
bottom_groove=10;

pad=0.1;
padd=pad*2;

wall=6;
walll=wall*2;
$fn=200;
layer_h=0.4;
mouse_ears_wall=50;


module positive() {
    difference() {
        union() {
            //inner round
            scale([1,1,cup_h/cup_w])
            rotate([0,90,0])
            cylinder(d=cup_w,h=stand);

            //sides
            translate([-wall,0,0])
            rotate([0,90,0])
            cylinder(d2=platform,d1=platform-walll,h=wall);

            //sides
            translate([stand,0,0])
            rotate([0,90,0])
            cylinder(d1=platform,d2=platform-walll,h=wall);
        }
        // cut circle in half
        translate([-pad-wall,-platform/2,pad])
        cube([stand+walll+padd,platform,cup_w]);
    }
    // box
    translate([-wall,-platform/2,0])
    cube([stand+walll,platform,groove_h-cup_h/2-bottom_groove/2]);
}

module all() {
    difference() {
        positive();
        translate([-pad-wall,-groove/2,-cup_h/2-bottom_groove/2])
        cube([stand+walll+padd,groove,groove_h+pad]);
    }
    //raft();
}

module raft() {
    translate([-wall,-platform/2,groove_h-cup_h/2-bottom_groove/2])
    minkowski() {
        cylinder(d=mouse_ears_wall,h=layer_h/2);
        cube([stand+walll,platform,layer_h/2]);
    }
}
rotate([180,0,0])
all();
