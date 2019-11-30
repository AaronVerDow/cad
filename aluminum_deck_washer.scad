$fn=90;
screw=6;
to_wall=5;
od=to_wall*2+screw;
height=5.3;
pad=0.1;

difference() {
    cylinder(d=od,h=height);
    translate([0,0,-pad])
    cylinder(d=screw,h=height+pad*2);
}
