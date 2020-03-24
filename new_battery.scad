wall=1.6;

batt_z = 40;
batt_x = 200;
batt_y = 80;

shell_x = batt_x;
shell_y = 150;
shell_z = batt_z + wall;


grip=1;
clearance=2;


gap=wall+0.5;
side_y = (batt_y-shell_y)/2;
side_z = batt_z+wall-clearance-wall-grip/2;

shell_z_line = batt_z-grip*2-clearance-gap/2-wall;

module side(x,y) {
    translate([0,-batt_y/2,0])
    scale([1,side_y/shell_z_line,1])
    rotate([0,90,0])
    cylinder(d=shell_z_line*2,h=shell_x);
}

module sides() {
    side();
    mirror([0,1,0])
    side();
}

module shell(extra, padding) {
    difference() {
        union() {
            translate([0,-batt_y/2,0])
            cube([batt_x,batt_y,shell_z_line]);
            sides();
        }
        cube([shell_x,shell_y,shell_z]);
    }
}

shell();
