motor=42.5;
corner=12.5;
band=11.5;
wall=3;
screw=4;
pad=0.1;
padd=pad*2;


difference() {
    union() {
        hull() {
            translate([corner/2,0,0])
            cube([motor+wall*2-corner,band,motor+wall]);
            cube([motor+wall*2,band,motor+wall-corner/2]);
        }
        translate([-band/2,0,0])
        cube([motor+wall*2+band,band,wall]);
        translate([-band/2,band/2,0])
        cylinder(h=wall,d=band);
        translate([motor+wall*2+band/2,band/2,0])
        cylinder(h=wall,d=band);
    }
    translate([wall,-pad,-pad])
    hull() {
        cube([motor,band+padd,motor-corner/2+pad]);
        translate([corner/2,0,0])
        cube([motor-corner,band+padd,motor+pad]);
    }
    translate([-band/2,band/2,-pad])
    cylinder(d=screw,h=wall+padd);
    translate([motor+wall*2+band/2,band/2,-pad])
    cylinder(d=screw,h=wall+padd);
}
