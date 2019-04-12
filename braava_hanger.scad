handle_z=30;
handle_x=80;
handle_y=7;

lip_z=3;
lip_x=handle_x;
lip_y=lip_z;

screw=5;
screw_h=20;
screw_head=10;

wall=1;
handle_gap=3;


base_z=handle_z+handle_gap+lip_z;
base_x=handle_x;
base_y=screw_head+wall*2;

gap_y=base_y+handle_y+lip_y;
gap_x=handle_x;
gap_z=lip_z;

base=[base_x,base_y,base_z];
lip_offset=[0,base_y+handle_y,0];
lip=[lip_x,lip_y,lip_z+gap_z];
gap=[gap_x,gap_y,gap_z];

pad=0.1;
screws=3;

no_supports=0.6;
$fn=90;

module screw(x=0) {
    translate([x,base_y/2,-pad]) {
        translate([0,0,base_z+pad-screw_h+no_supports])
        cylinder(d=screw,h=base_z+pad*2);
        cylinder(d=screw_head,h=base_z+pad-screw_h);
    }
}

module screws() {
    for(x=[base_x/screws/2:base_x/screws:base_x]) {
        screw(x);
    }
}

module base() {
    cube(base);
    cube(gap);
    translate(lip_offset)
    cube(lip);
}

difference() {
    base();
    screws();
}

