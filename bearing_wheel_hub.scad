inner=7.6;
inner_h=2;
outer=12;
outer2=18;
outer_h=(14-7)/2;
screw=3.2;
total_h=inner_h+outer_h;
pad=0.1;
padd=pad*2;
$fn=90;

difference() {
    union() {
        translate([0,0,outer_h])
        cylinder(d=inner,h=inner_h);
        cylinder(d2=outer, d1=outer2, h=outer_h);
    }
    translate([0,0,-pad])
    cylinder(d=screw,h=total_h+padd);
}
