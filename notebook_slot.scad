slot_x=75;
slot_y=8;
slot_z=25;
slot_wall=1;

back_z=110;
lip=back_z/2;

slot_offset=10;

pad=0.1;

slots=4;

// distance from top
screws=[10,30,50];

screw=3.5;

module slot() {
    difference() {
        translate([0,0,slot_z/2+slot_wall/2])
        cube([slot_x+slot_wall*2,slot_y+slot_wall*2,slot_z+slot_wall],center=true);
        translate([0,0,slot_z/2+slot_wall])
        cube([slot_x,slot_y,slot_z+pad],center=true);
    }
    translate([-slot_wall-slot_x/2,slot_y/2])
    cube([slot_x+slot_wall*2,slot_wall,lip]);
}


for(n=[0:1:(slots-1)])
translate([0,slot_y/2+slot_wall+slot_wall*n+slot_y*n,-slot_offset*n])
slot();


difference() {
    translate([-slot_wall-slot_x/2,0])
    cube([slot_x+slot_wall*2,slot_wall,back_z]);
    screw(10);
    screw(lip-10);
}
module screw(z) {
    translate([0,-pad,back_z-z])
    rotate([-90,0,0])
    cylinder(d=screw,h=slot_wall+pad*2,$fn=6);
}


