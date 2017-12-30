$fn=90;
x=19.5;
y=12;
round_x=10;

z=11;

screw=5;
screw_h=8;
screw_h_z=5;

pad=0.1;
padd=pad*2;

fudge=1.5;

difference() {
    hull() {
        translate([x/2,0,z-y/2+fudge])
        sphere(d=y);
        translate([round_x/2,0,0])
        difference() {
            hull() {
                translate([x-round_x,0,0])
                scale([round_x/y,1,1])
                sphere(d=y);
                scale([round_x/y,1,1])
                sphere(d=y);
            }
            translate([-x/2,-y,-y])
            cube([x*2,y*2,y]);
        }
    }
    
    translate([x/2,0,-pad])
    cylinder(d=screw,h=z+padd);

    translate([x/2,0,z-screw_h_z])
    #cylinder(d=screw_h,h=screw_h_z);
    translate([x/2,0,z-screw_h_z])
    cylinder(d=screw_h,h=z);
}
