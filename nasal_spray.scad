wall=1.2;
base=0.4*2;
h=62;
od=31;
id=16;
pad=0.1;
padd=pad*2;

difference() {
    cylinder(d=od,h=h);
    translate([0,0,-pad])
    cylinder(d=id,h=h+padd);
    translate([0,0,base])
    cylinder(d=od-wall*2,h=h);
}
