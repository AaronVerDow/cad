$fn=120;
max_d=15;
max_r=max_d/2;
bolt_d=5;
bolt_r=bolt_d/2;
flat_d=22;
flat_r=flat_d/2;
min_h=2.5;
max_h=2.5;
pad=0.1;
padd=pad*2;


difference() {
    cylinder(r=max_r,h=max_h);
    translate([0,0,-pad])
    cylinder(r=bolt_r,h=max_h+padd);
}
