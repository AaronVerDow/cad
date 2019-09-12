fins=23.2;
sides=3;
bolt=4;
pillar=10;
side=43.5;
fan=fins;
fan_bolt_side=24;
fan_bolt=3;
fan_box=30.5;
fans=3;
air_into_fin=6;

shoulder_bottom=6.8;
fins_h=26.2;
bottom_to_fins=1;

h=shoulder_bottom+fins_h+bottom_to_fins; //bottom of fins to top of groove
groove=12.4;
groove_h=6;
outer_r=sqrt(3)*side/3;
echo(outer_r);
pad=0.1;
padd=pad*2;
fin_to_fan=3;
shoulder=16.8;
shoulder_top=3.75;

lock=2.5;
lock_diff=0.5;
assembly_gap=30;

wires=15;
wires_offset=4;

$fn=90;

module base_positive() {
    rotate([0,0,90])
    difference() {
        hull() {
            for(a=[0:360/sides:359]) {
                rotate([0,0,a])
                translate([outer_r,0,0])
                cylinder(d=pillar,h=h);
            }
        }
        translate([0,0,-pad]) {
            cylinder(d=fins,h=h+pad-shoulder_bottom);
            cylinder(d=shoulder,h=h+padd);
            for(a=[0:360/sides:359]) {
                rotate([0,0,a])
                translate([outer_r,0,0])
                cylinder(d=bolt,h=h+padd);
            }
        }
    }
}

module air() {
    //translate([0,0,fan_box/2]) rotate([90,0,0]) cylinder(d=fan,h=side/2);

    translate([0,-fins/2+air_into_fin,fan_box/2])
    rotate([90,0,0])
    cylinder(d1=fan,d2=fan_box,h=fin_to_fan+pad+air_into_fin);
}
module fan() {
    translate([-fan_box/2,-side-fins/2-fin_to_fan,-pad])
    cube([fan_box,side,fan_box+pad]);

    translate([0,0,fan_box/2])
    rotate([90,0,0])
    for(a=[0:360/4:359]) {
        rotate([0,0,a])
        translate([fan_bolt_side/2,fan_bolt_side/2,fins/2-4])
        cylinder(d=fan_bolt,h=side);
    }
}

module base() {
    translate([0,0,-h-groove_h])
    color("cyan")
    difference() {
        base_positive();
        for(a=[0:360/sides:359]) {
            rotate([0,0,a])
            air();
        }
        for(a=[0:360/sides:(360/sides*fans)-1]) {
            rotate([0,0,a])
            fan();
        }
        translate([0,0,-pad])
        cylinder(d2=fins,d1=fins+bottom_to_fins*2+padd,h=bottom_to_fins+pad);
        //translate([0,0,-wires_offset]) rotate([90,0,0]) cylinder(d=wires,h=side);
    }
}


module toptop() {
    rotate([0,0,90])
    difference() {
        hull() {
            for(a=[0:360/sides:359]) {
                rotate([0,0,a])
                translate([outer_r,0,0])
                cylinder(d=pillar,h=shoulder_top);
            }
        }
        translate([0,0,-pad]) {
            cylinder(d=shoulder,h=h+padd);
            for(a=[0:360/sides:359]) {
                rotate([0,0,a])
                translate([outer_r,0,0])
                cylinder(d=bolt,h=h+padd);
            }
        }
        rotate([0,0,-90])
        tooth_lock();
    }
}

module top_positive() {
    hull() {
        for(a=[0:360/sides:359]) {
            rotate([0,0,a])
            translate([outer_r,0,0])
            cylinder(d=pillar,h=groove_h);
        }
    }
}


module top() {
    rotate([0,0,90])
    difference() {
        top_positive();
        translate([0,0,-pad]) {
            hull() {
                cylinder(d=groove,h=h+padd);
                translate([-side,0,0])
                cylinder(d=groove,h=h+padd);
            }
            for(a=[0:360/sides:359]) {
                rotate([0,0,a])
                translate([outer_r,0,0])
                cylinder(d=bolt,h=h+padd);
            }
        }
    }
}


module tooth() {
    rotate([0,0,90])
    difference() {
        intersection() {
            top_positive();
            hull() {
                cylinder(d=groove-lock_diff,h=h+padd);
                translate([-side,0,0])
                cylinder(d=groove-lock_diff,h=h+padd);
            }
        }
        translate([0,0,-pad])
        cylinder(d=groove+0.001,h=h+padd);
    }
    translate([0,0,groove_h])
    tooth_lock(lock_diff);

}


module tooth_lock(diff=0) {
    translate([0,-side/3.5,0])
    translate([-groove/2+diff,0,0])
    rotate([0,90,0])
    cylinder(d=lock-diff,h=groove-diff*2);
}


module assembled() {
    translate([0,0,-assembly_gap])
    base();

    translate([0,0,-groove_h])
    color("lime")
    top();

    translate([0,-assembly_gap,-groove_h-pad])
    color("magenta")
    tooth();

    translate([0,0,assembly_gap])
    toptop();
}

display="";
if (display == "") assembled();
if (display == "extruder_base.stl") rotate([180,0,0]) base();
if (display == "extruder_top.stl") top();
if (display == "extruder_tooth.stl") tooth();
if (display == "extruder_toptop.stl") rotate([180,0,0]) toptop();
