$fn=220;
id=42;
ir=id/2;
lip=0.7;
taper_h=4;
taper_d=41;
taper_r=taper_d/2;
inner_h=10-taper_h;
side_wall=0.8;
bottom_wall=0.6;
cap_h=bottom_wall;
total_h=inner_h+cap_h;
pad=0.1;
padd=pad*2;
hole_d=7;
hole_r=hole_d/2;
hole_offset=9;
holes=4;
angle=360/holes;


translate([0,0,total_h]) {
    difference() {
        cylinder(h=taper_h,r1=ir,r2=taper_r);
        cylinder(h=taper_h,r1=ir-side_wall,r2=taper_r-side_wall);
    }
}
difference() {
    union() {
        cylinder(h=total_h,r=ir);
        cylinder(h=cap_h,r=ir+lip);
    }
    translate([0,0,bottom_wall])
    cylinder(h=total_h-bottom_wall+pad,r=ir-side_wall);
    for(x=[0:holes-1]) {
        rotate([0,0,x*angle])
        translate([0,hole_offset,-pad])
        cylinder(h=bottom_wall+padd,r=hole_r);
    }
}
