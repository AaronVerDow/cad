$fn=120;
pad=0.1;
top_w=85;
bottom_w=70;
height=120;
delta=(top_w-bottom_w)/2;
angle=atan(delta/height);
hole_w=30;
hole_d=9;
hole_r=hole_d/2;
bolt_grip=40;

head_d=17;
head_r=head_d/2;

translate([0,0,height])
rotate([180,0,0])
difference(){
	cube([top_w,top_w,height]);

	translate([0,0,height])
	rotate([180+angle,0,0])
	cube([top_w+pad,top_w+pad,height*2]);

	translate([0,0,height])
	rotate([0,180-angle,0])
	cube([top_w+pad,top_w+pad,height*2]);

	translate([top_w,0,-pad])
	rotate([0,0,45])
	cube([top_w*2,top_w*2,height+2*pad]);
	
	translate([hole_w,hole_w,-pad])
	cylinder(r=hole_r,h=height+2*pad);

	translate([hole_w,hole_w,-pad])
	cylinder(r=head_r,h=height+2*pad-bolt_grip);
}
