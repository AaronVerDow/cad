fins=22.8;
sides=3;
bolt=4;
pillar=10;
side=43.5;
fan=fins;
fan_bolt_side=24;
fan_bolt=3;
fan_box=30.5;
fans=3;
air_into_fin=2;
h=36; //bottom of fins to top of groove
groove=12.4;
groove_h=4.5;
outer_r=sqrt(3)*side/3;
echo(outer_r);
pad=0.1;
padd=pad*2;
fin_to_fan=3;
shoulder=16.4;
shoulder_top=4;
shoulder_bottom=6;
$fn=90;

module base() {
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
    translate([0,0,fan_box/2])
    rotate([90,0,0])
    cylinder(d=fan,h=side/2);

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
translate([0,0,-h-groove_h])
color("cyan")
difference() {
    base();
    for(a=[0:360/sides:359]) {
        rotate([0,0,a])
        air();
    }
    for(a=[0:360/sides:(360/sides*fans)-1]) {
        rotate([0,0,a])
        fan();
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
    }
}


module top() {
    rotate([0,0,90])
    difference() {
        hull() {
            for(a=[0:360/sides:359]) {
                rotate([0,0,a])
                translate([outer_r,0,0])
                cylinder(d=pillar,h=groove_h);
            }
        }
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

translate([0,0,30])
color("lime")
top();

toptop();
