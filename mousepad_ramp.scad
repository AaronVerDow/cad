base=0.2;
grip=20;
ramp=40;
ramp_h=5.5;
w=180;
ramp_base=[w,ramp,base];
ramp_top=[w,0.1,base];
grip_cube=[w,grip+ramp,base];
pad=0.1;

difference() {
    hull() {
        cube(ramp_base);
        translate([0,0,ramp_h])
        cube(ramp_top);
    }
    translate([-pad,0,0])
    scale([1,0.4,1])
    rotate([0,90,0])
    cylinder(r=ramp_h,h=w+pad*2);
}

translate([0,-grip,0])
cube(grip_cube);
