max_w=140;
max_l=60;
max_h=50;
corner=20;
pad=0.1;
padd=pad*2;
bolt=9;
bolt_h=max_l;
bolt_offset=30;
$fn=60;

difference() {
    translate([corner/2-max_h/2,0,corner/2])
    rotate([0,90,0])
    minkowski() {
        difference() {
            scale([max_l*2/max_w,1,1])
            cylinder(d=max_w-corner,h=max_h-corner);
            translate([0,-max_w/2,0])
            cube([max_w+padd,max_w+padd,max_h+padd]);
        }
        sphere(d=corner);
    }
    translate([0,bolt_offset,-pad])
    cylinder(d=bolt,h=bolt_h);
    translate([0,-bolt_offset,-pad])
    cylinder(d=bolt,h=bolt_h);
    translate([0,0,-pad])
    cylinder(d=bolt,h=bolt_h);
}
