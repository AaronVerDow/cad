in_d=8;
in_r=in_d/2;
in_h=7;
out_d=22;
out_r=out_d/2;
out_h=in_h;
shoulder_d=15;
shoulder_r=shoulder_d/2;
shoulder_h=2.5;
base_d=110;
base_r=base_d/2;
spool_r=170;
base_h=3;

sat_d=12;
sat_r=sat_d/2;
sat_h=40;
guide_d=6;
guide_r=guide_d/2;
guide_h=12;

pin_d=3;
pin_r=pin_d/2;
pin_h=base_h+shoulder_h+in_h;

screw_r1=5/2;
screw_r2=9/2;
$fn=90;

display=30;
spool_base_h=5;
spool_center_h=90;
spool_center_d=51.5;
spool_center_r=spool_center_d/2;

module base() {
difference() {
    union(){
        hull(){
            cylinder(r=base_r,h=base_h);
            translate([spool_r,0,0])
            cylinder(r=sat_r,h=base_h);
        }
        translate([0,0,base_h])
        cylinder(r=shoulder_r,h=shoulder_h);
        translate([0,0,shoulder_h+base_h])
        cylinder(r=in_r,h=in_h);
    }
    cylinder(r=pin_r,h=pin_h);
    translate([base_r+screw_r1,0,0])
    cylinder(r1=screw_r1,r2=screw_r2,h=base_h);
    translate([spool_r-sat_d-sat_r,0,0])
    cylinder(r1=screw_r1,r2=screw_r2,h=base_h);
}
difference() {
    translate([spool_r,0,0])
    cylinder(r=sat_r,h=sat_h);
    hull() {
        translate([spool_r,-sat_d,sat_h-sat_r])
        rotate([-90,0,0])
        cylinder(r=guide_r,h=sat_d*2);
        translate([spool_r,-sat_d,sat_h-sat_r-guide_h])
        rotate([-90,0,0])
        cylinder(r=guide_r,h=sat_d*2);
    }
}
}

module spool() {
translate([0,0,display]){
    difference() {
        union() {
            cylinder(r=base_r,h=spool_base_h);
            cylinder(r=spool_center_r,h=spool_center_h);
        }
    #cylinder(r=out_r,h=out_h);
    translate([0,0,out_h])
    #cylinder(r1=out_r,r2=0.1,h=out_r);
    }
}
}
spool();
