pipe=22;

$fn=90;

hole=15;

length=200;

wall=5;
base_wall=wall*1;

mirror_h=7;

grip_z=2;
grip_y=2;
pad=0.1;

module body() {

    translate([0,length])
    cylinder(d=pipe+wall*2,h=wall);

    intersection() {
        translate([0,length])
        hull() {
            cylinder(d=pipe+wall*2,h=wall);
            rotate([0,0,41])
            translate([-pipe*2,0])
            cylinder(d=pipe+wall*2,h=wall);
        }
        translate([pipe*2,length])
        cube([pipe*4,pipe*4,wall*3],center=true);
    } 
    

    translate([-wall/2,0])
    cube([wall,length,wall]);
}
difference() {
    body();
    translate([0,length,-pad])
    hull() {
        cylinder(d=pipe,h=wall+pad*2);
        rotate([0,0,41])
        translate([-pipe*2,0])
        cylinder(d=pipe,h=wall+pad*2);
    }
}

cylinder(d=hole+base_wall*2,h=wall);

intersection() {
    cylinder(d=hole,h=wall+mirror_h);
    translate([0,-grip_y])
    cylinder(d=hole,h=wall+mirror_h);
}

translate([0,0,wall+mirror_h])
cylinder(d=hole,h=grip_z);

