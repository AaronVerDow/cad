hook_height = 40;
support_thickness = 3;
hole_dia = 5;

hook_base = hook_height/3;
hole_distance = hook_height/2;
hook_thickness = hook_height/4;
support_width = hook_base*2;
corner = 6;
fillet=10;

//Circle Resolution
$fn = 50;

difference() {
    union() {
        fillet();
        base();
        hook();
    }
    trim_base();
}

module base() {
    difference() {
        minkowski() {
            linear_extrude(height = 0.1)
            hull(){
                translate([0,5,0])
                circle(r=support_width/2);
                translate([0,-hole_distance,0])
                circle(r=support_width/2);
            }
            sphere(r=support_thickness);
        }
        translate([0,-hole_distance,-0.1])
        cylinder(r=hole_dia/2,h=support_thickness+.2);
    }
}

module trim_base() {
    translate([-support_width,-hole_distance-support_width,-support_thickness*2])
    cube([support_width*2,5+hole_distance+support_width*2,support_thickness*2]);
}

module fillet() {
    translate([-corner/2,0,0])
    minkowski() {
        intersection() {
            basic_hook();
            base();
        }
        cylinder(d=fillet,r2=0.1,h=fillet/2);
    }
}

module hook() {
    translate([-corner/2,0,0])
    minkowski() {
        basic_hook();
        // can be slow to generate on older versions of openscad
        sphere(d=corner);

        // faster but uglier
        //cylinder(d1=corner,h=corner/2);
    }
}

module basic_hook() {
    translate([hook_thickness/2,0,0])
    rotate([0,-90,0])
    linear_extrude(height = hook_thickness-corner, convexity = 10)
    polygon([
        [hook_height*0.3,-1],
        [hook_height,-4],
        [hook_height,-1],
        [support_thickness-.1,(hook_base)],
        [support_thickness-.1,-(hook_base*0.5)]
    ]);
}

