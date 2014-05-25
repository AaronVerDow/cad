$fn=45;
h=1;
max_l=225;
max_w=225;
pad=0.1;
padd=pad*2;

screw_l=209;
screw_w=209;

screw_d=3;
screw_r=screw_d/2;

projection()
difference() {
    cube([max_l,max_w,h]);
    translate([0,0,-pad]) {
        translate([(max_l-screw_l)/2,(max_w-screw_w)/2,0])
        cylinder(r=screw_r,h=h+padd);
        translate([(max_l-screw_l)/2+screw_l,(max_w-screw_w)/2,0])
        cylinder(r=screw_r,h=h+padd);
        translate([(max_l-screw_l)/2+screw_l,(max_w-screw_w)/2+screw_w,0])
        cylinder(r=screw_r,h=h+padd);
        translate([(max_l-screw_l)/2,(max_w-screw_w)/2+screw_w,0])
        cylinder(r=screw_r,h=h+padd);
    }
}
