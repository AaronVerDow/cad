$fn=90;
pole=12;
pole_h=20;
pole_taper=2;

strap_w=22;
strap_h=5;

base_h=7;
strap_wall=base_h;

pad=0.1;
padd=pad*2;

pin=2;

difference() {
    union() {
        cube([strap_w+strap_wall*2,strap_w/2+strap_wall+strap_h+strap_wall,base_h]);
        translate([strap_w/2+strap_wall,strap_w/2+strap_wall+strap_h+strap_wall,0]) {
            cylinder(d=strap_w+strap_wall*2,h=base_h);
            cylinder(d=pole,h=base_h+pole_h);
            translate([0,0,pole_h+base_h])
            cylinder(d1=pole,d2=pole-pole_taper*2,h=pole_taper);
        }
    }
    translate([strap_wall,strap_wall,-pad])
    cube([strap_w,strap_h,base_h+padd]);
    translate([strap_w/2+strap_wall,strap_w/2+strap_wall+strap_h+strap_wall,-pad])
    cylinder(d=pin,h=pole_h*2);
}
