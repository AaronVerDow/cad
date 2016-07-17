$fn=120;
metal_x=67.5;
metal_y=85;
metal_z=8.5;

corner=10;

wall=2;
clip=3;
clip_h=4;

total_x=metal_x+wall*2;


h=20;
base_h=5;
hull_h=h-base_h;

felt=2.5*25.4+2;
felt_h=1.5;
felt_wall=1;

pad=0.1;
padd=pad*2;


difference() {
    union() {
        hull() {
            translate([h/4,0,hull_h])
            minkowski() {
                cylinder(h=base_h/2,d=corner);
                cube([total_x-h/2,metal_y,base_h/2]);
            }
            translate([total_x/2,total_x/2-corner/2,0])
            cylinder(d=felt+felt_wall*2,h=hull_h);
        }

        translate([0,0,h])
        cube([wall,metal_y,metal_z]);
        translate([total_x-wall,0,h])
        cube([wall,metal_y,metal_z]);
        clip();
        translate([total_x,0,0])
        mirror([1,0,0])
        clip();
    }
    translate([total_x/2,total_x/2-corner/2,-pad])
    cylinder(h=felt_h+pad,d=felt);
}

module clip() {
    difference() {
        translate([0,0,metal_z+h])
        cube([wall+clip,metal_y,clip_h]);
        translate([wall+clip,-pad,metal_z+h])
        rotate([0,-45,0])
        cube([(wall+clip)*2,metal_y+padd,(clip+wall)*2]);
    }
}
