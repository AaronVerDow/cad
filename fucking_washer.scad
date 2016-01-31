$fn=120;
max_d=55;
max_r=max_d/2;
bolt_d=12;
bolt_r=bolt_d/2;
flat_d=22;
flat_r=flat_d/2;
min_h=2.5;
max_h=min_h+4;
pad=0.1;


difference() {
    cylinder(r=max_r,h=max_h);
    translate([0,0,min_h])
    cylinder(r1=flat_r,r2=max_r,h=max_h-min_h+pad);
    cylinder(r=bolt_r,h=max_h);

}
