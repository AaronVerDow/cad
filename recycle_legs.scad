top=45;
base=top/3*2;
h=140;
$fn=150;

grip=20;
slider_gap=2;
cap=5;
wall=2.4;
walll=wall*2;
pad=0.1;
padd=pad*2;
screw=3.5;

difference() {
    cylinder(d1=top,d2=base,h=h);
    difference() {
        translate([0,0,-pad])
        cylinder(d1=top-walll,d2=base-walll,h=h+padd);
        cylinder(d=top,h=grip);
        translate([0,0,h-cap-slider_gap])
        cylinder(d=top,h=cap);
    }
    translate([0,0,-pad])
    cylinder(d=screw,h=grip+padd);
}
