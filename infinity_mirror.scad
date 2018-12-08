in=25.4;
glass_x=28*in;
glass_y=28*in;
glass_z=0.25*in;

lip=0.5*in;

mirror_gap=0.75*in;
plywood_h=0.75*in;

table_x=30*in;
table_y=30*in;

table_z=glass_z*2+mirror_gap;
pad=0.1;
padd=pad*2;

module glass(pad=0) {
    translate([(table_x-glass_x)/2,(table_y-glass_y)/2,-pad])
    cube([glass_x,glass_y,glass_z+pad]);
}

module bottom_glass() {
    glass(pad);
}

module hole() {
    translate([(table_x-glass_x)/2+lip,(table_y-glass_y)/2+lip,-pad])
    cube([glass_x-lip*2,glass_y-lip*2,table_z+padd]);
}

module top_glass() {
    translate([0,0,table_z])
    mirror([0,0,1])
    glass(pad);
}

module solid() {
    difference() {
        cube([table_x,table_y,table_z]);
        bottom_glass();
        top_glass();
        hole();
    }
}

solid();
