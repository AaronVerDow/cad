ruler_thickness=3;
ruler_height=41.5;
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
        translate([hanger/2+wall,ruler_height/2,ruler_thickness-pad])
        cylinder(d=hanger,h=wall+pad*2);
    }

    translate([wall,wall-bit/2,-hole])
    cylinder(d=bit,h=wall+ruler_thickness+hole);
}

tip=0.01;
point=bit*1.3;
end=3;
inset=1;

pad=0.1;

vernier_gap=3;
vernier=vernier_gap-1/10;
text_gap=1.5;
scale_h=5;

text_size=vernier_gap;

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



module ruler(line, gap, count, height) {
    for(x=[0:gap:gap*count])
    translate([x,height/2])
    square([line, height],center=true);
}

zero=0.0001;

// test ruler
color("dimgray")
linear_extrude(zero)
*ruler(0.2, 1, 100, 5);


module vernier() {
    translate([0,-scale_h])
    ruler(0.2, vernier, 10, scale_h+pad);
    numbers=["", "1", "2", "3", "4", "5", "6", "7", "8", "9", "0"];

    for(n=[0:1:len(numbers)])
    translate([vernier*n,-scale_h-text_gap])
    text(numbers[n], valign="top", halign="center", size=text_size);
}

body=scale_h+text_gap*2+text_size;
scale_depth=0.9;
hanger=8;

// RENDER stl
module vernier_end() {
    translate([vernier*10,-bit/2,-hole])
    cylinder(d=bit,h=hole);
    difference() {
        translate([-vernier,-body])
        cube([vernier*14+hanger,body,ruler_thickness]);

        translate([0,0,ruler_thickness-scale_depth])
        linear_extrude(height=wall)
        vernier();

        translate([vernier*12+hanger/2,-body/2,-pad])
        cylinder(d=hanger,h=ruler_thickness+pad*2);
    }
}



translate([0,length/2])
end();


vernier_end();

*point();
