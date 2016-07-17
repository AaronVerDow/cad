$fn=120;
box_x=30;
box_y=40;
box_z=40;
clip=17;

wall=2;
walll=wall*2;

pad=0.1;
padd=pad*2;

angle=35;

lazy=3;
count=8;

module box() {
    difference() {
        cube([box_x,box_y,box_z]);
        intersection() {
            translate([wall,wall,wall])
            cube([box_x-walll,box_y-walll,box_z-wall+pad]);
            translate([0,box_y,box_y])
            rotate([0,90,0])
            cylinder(h=box_x,r=box_y-wall);
        }
        translate([-pad,0,box_z-clip])
        rotate([angle,0,0])
        cube([box_x+padd,box_y,box_z]);
        translate([-pad,-pad,-pad])
        cube([box_x+padd,lazy+pad,box_y+padd]);
    }
}
for(x=[0:box_x-wall:count*(box_x-wall)]) {
    translate([x,0,0])
    box();
}
