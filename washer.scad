$fn=120;
id=10;
filament=1.08;
rings=4;
od=id+filament*rings*2;
filament_h=1;
h=6*filament_h;

pad=0.1;
padd=pad*2;

difference() {
    cylinder(h=h,d=od);
    translate([0,0,-pad])
    cylinder(h=h+padd,d=id);
}
