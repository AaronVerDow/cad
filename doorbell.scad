body_x=30.5;
body_y=56.5;
body_z=12.3;
wall=3;
button=22;
button_offset=15;
screw=3;
screw_head=6;
screw_wall=2;
body_r=3;
pad=0.1;
padd=pad*2;
$fn=120;

difference() {
    minkowski() {
        hull() {
            cube([body_x,body_y,body_z]);
            translate([body_x/2,body_y+screw_head,0])
            cylinder(d=screw_head,h=screw_wall);
        }
        sphere(r=body_r);
    }
    translate([-body_r*2,-body_r*2,-body_z])
    cube([body_x*2,body_y*2,body_z]);
    translate([0,0,-pad]) {
        cube([body_x,body_y,body_z+pad]);
        translate([body_x/2,body_y+screw_head,0])
        cylinder(d=screw,h=body_z);
        translate([body_x/2,body_y+screw_head,screw_wall])
        cylinder(d=screw_head,h=body_z);
    }
    translate([body_x/2,body_y-button_offset,body_z-pad])
    cylinder(d1=button,d2=button+body_r*2,h=body_r+padd);
}
