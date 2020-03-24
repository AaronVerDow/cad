center=40;

center_gap=1;

wall=3;

pad=0.1;
padd=pad*2;
water=10;

top=150;
top_r=top/2;

top_base=center+center_gap*2+wall*2;
top_base_r=top_base/2;

trim_from_bottom=top_r-sqrt(top_r*top_r-top_base_r*top_base_r);

top_fn=90;
top_h=top-trim_from_bottom;

pivot_h=top_h-center/2-wall;

water_angle=45;
water_holes=3;

rifles=9;
rifle=2;
rifle_twist=150;
$fn=90;

top_water=10;

bottom=top;
bottom_h=60;
bottom_wall=10;

in=25.4;

pump_h=30;
pump_d=50;

pump=[47,43,pump_h];

arch_w=40;
arch_h=bottom_h-bottom_wall*2;
arch_point=1;
arches=6;

module arch_2d() {
    difference() {
        hull() {
            circle(d=arch_w);
            translate([0,arch_h-arch_w/4*3,0])
            circle(d=arch_w);
            translate([0,arch_h-arch_point/2,0])
            circle(d=arch_point);
        }
        translate([-arch_w,-arch_w*2])
        square([arch_w*2,arch_w*2]);
    }
}

module arch(angle=0) {
    translate([0,0,bottom_wall])
    rotate([90,0,angle])
    linear_extrude(height=bottom)
    arch_2d();
}

module arches() {
    for(a=[0:360/arches:359]) {
        arch(a);
    }
}



module bottom() {
    difference() {
        cylinder(d=bottom,h=bottom_h);
        translate([0,0,-bottom_wall])
        cylinder(d=bottom-bottom_wall*2,h=bottom_h);
        arches();
    }
    translate([0,0,bottom_h])
    pivot();
}

bottom();

module top_negative() {
        // cut off bottom
        translate([0,0,-top/2])
        cylinder(d=top,h=top/2);


        // pivot hole
        translate([0,0,-pad])
        pivot_positive();

        translate([0,0,-center/2])
        reverse_rifling();
        
        cylinder(d=top_water,h=top+top_water);
}

module top() {
    difference() {
        translate([0,0,top/2-trim_from_bottom])
        sphere(d=top,$fn=top_fn);
        top_negative();
    }
}

module pivot() {
    difference() {
        intersection() {
            pivot_positive();
            cylinder(d=center-center_gap*2,h=top);
        }
        water();
        rifling(-center_gap);
    }
}

module pivot_positive() {
    translate([0,0,pivot_h])
    sphere(d=center);
    cylinder(d=center,h=pivot_h);
}


module water() {
    translate([0,0,-pad])
    cylinder(d=water,h=pivot_h+pad);
    translate([0,0,pivot_h])
    for(z=[0:360/water_holes:359]) {
        rotate([0,water_angle,z])
        cylinder(d=water,h=center);
    }
}

module rifling(offset=0) {
    for(r=[0:360/rifles:359]) {
        rotate([0,0,r])
        rifle(offset);
    }
}

module rifle(offset=0) {
    translate([0,0,-pad])
    linear_extrude(height=pivot_h+center/2, twist=rifle_twist)
    translate([center/2+offset,0])
    circle(d=rifle);
}

module reverse_rifling(offset=0) {
    mirror([1,0,0])
    rifling(offset);
}

module assembled() {
    top();
    pivot();
}
