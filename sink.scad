$fn=120;
pad = 0.1;
max_d = 80;
max_r = max_d/2;
max_h = 2.5;
max_h_pad = max_h+2*pad;

small_d_t = 3;
small_r_t = small_d_t/2;
small_d_b = 8;
small_r_b = small_d_b/2;

from_edge = max_r - 20;

out_r = max_r-10;
in_r = 14;

count = 10;
circles = 3;

step = 360/count/2;

tab_top_d=14;
tab_top_r=tab_top_d/2;
tab_base_d=10;
tab_base_r=tab_base_d/2;
tab_h=8;

difference() {
	union() {
		cylinder(h=max_h,r=max_r);
		cylinder(h=tab_h,r2=tab_top_r,r1=tab_base_r);
	}
	translate([0,0,-pad]) {
		for (x=[0:circles-1]) {
			for (i=[1:count]) {
				rotate([0,0,360/count*i+step*x])
				translate([0,((out_r-in_r)/(circles-1))*x+in_r,0])
				cylinder(h=max_h_pad,r2=small_r_t,r1=small_r_b);
			}
		}
	}
}
