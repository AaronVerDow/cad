wall=1.2;
z=170;
x=275;
y=wall;
main=[x,y,z];

bed_d=280;
bed_h=300;

$fn=90;

base_x=250;
base_y=40;
base_z=0.8;

base_y_offset=3;

base=[base_x,base_y,base_z];

center_y=100;
gap=0.5;

intersection() {
    cylinder(d=bed_d,h=bed_h);
    union() {
        translate([-x/2,-gap-wall,0])
        cube(main);
        translate([-base_x/2,base_y_offset,0])
        cube(base);
        hull() {
            cube([wall,center_y,wall]);
            cube([wall,wall,z/3*2]);
        }
        thing();
        mirror([1,0,0])
        thing();
    }
}


module thing() {
    hull() {
        translate([base_x/2,0,0])
        cube([wall,wall,z/3*2]);
        intersection() {
            cylinder(d=bed_d,h=bed_h);
            translate([base_x/2,0,0])
            cube([wall,center_y,wall]);
        }
    }
}
