extrusion_width=1.6;
wall=extrusion_width;
overlap=wall*2;
gap=0.5;

battery_x=200;
battery_y=80;
battery_z=30;

shell_y=140;

pad=0.1;
padd=pad*2;


$fn=90;

translate([0,-battery_y/2,0])
cube([battery_x,battery_y,battery_z-wall*1.5-gap]);
sides();
grips();

module sides() {
    side();
    mirror([0,1,0])
    side();
}

module grips() {
    grip();
    mirror([0,1,0])
    grip();
}

module side() {
    translate([0,-battery_y/2,0])
    scale([1,(shell_y-wall*2-battery_y)/battery_z/2,1])
    intersection() {
        rotate([0,90,0])
        cylinder(d=battery_z*2-wall*3-gap*2,h=battery_x);
        translate([-pad,-battery_y,0])
        cube([battery_x,battery_y,battery_z]);
    }
}

module grip() {
    translate([0,shell_y/2-wall*1.5-gap,0])
    rotate([0,90,0])
    difference() {
        cylinder(d=wall*3+gap*2,h=battery_x);
        translate([0,0,-pad])
        cylinder(d=wall+gap*2,h=battery_x+padd);
    }
}


