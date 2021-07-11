ruler_thickness=3;
ruler_height=41;
in=25.4;
bit=in/4;
hole=in/8;
length=60;

wall=2;
$fn=200;

// RENDER stl
module end() {
    difference() {
        cube([length+wall,ruler_height+wall*2,ruler_thickness+wall]);
        translate([wall,wall,-wall])
        cube([length+wall,ruler_height,ruler_thickness+wall]);
    }

    translate([wall,wall-bit/2,-hole])
    cylinder(d=bit,h=wall+ruler_thickness+hole);
}

tip=0.01;
point=bit*1.3;
end=3;
inset=1;

pad=0.1;

// RENDER stl
module point() {
    difference() {
        union() {
            difference() {
                cylinder(d=length,h=ruler_thickness);
                translate([-length/2,bit/2,-pad])
                cube([length,length,ruler_thickness+pad*2]);
            }
            cylinder(d=bit,h=ruler_thickness+hole);
        }

        translate([0,-point/2,-pad])
        hull() {
            translate([0,point,0])
            cylinder(d=tip,h=inset);
            cylinder(d=end,h=inset);
        }
    }

}

translate([0,length/2])
end();
point();
