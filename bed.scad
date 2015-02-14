$fn=140;
bottom_d=55;
bottom_r=bottom_d/2;
top_d=30;
top_r=top_d/2;
hole_d=19;
hole_r=hole_d/2;
hole_h=25;
main_h=hole_h+5;
pad=0.1;

difference(){
    cylinder(h=main_h,r2=top_r,r1=bottom_r);
    translate([0,0,main_h-hole_h+pad])
    #cylinder(h=hole_h,r=hole_r);
}
