ring=35; // diameter of ring grip

od=100; // outer diameter of mount

channel=ring*0.30; // how deep the channel is

wall=3; // space between rings

height=wall*3+ring*2;


$fn=90;

id=od-channel*2-wall*2;

screw=5;
screw_height=50;
screw_head=id*0.75;
pad=0.1;


difference() {
    rotate_extrude()
    difference() {
        square([od/2,height]);
        translate([od/2-channel+ring/2,ring/2+wall])
        circle(d=ring);

        translate([od/2-channel+ring/2,ring/2+wall*2+ring])
        circle(d=ring);
    }


    translate([0,0,-pad])
    cylinder(d=screw,h=height+pad*2);

    translate([0,0,screw_height])
    cylinder(d1=screw_head,d2=id,h=height-screw_height+pad);
}
