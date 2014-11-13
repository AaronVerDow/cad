$fn=120;
monitor_mount_large=100;
monitor_mount_small=75;
pad=0.1;
2pad=pad*2;
//main_l=130;
main_l=120;
main_w=main_l;
//main_h=10;
main_h=6;

water_gap=0.6;

delta=2;
hypot=sqrt((2*delta)*(2*delta)+(main_h+2pad)*(main_h+2pad));
angle=atan(2*delta/(main_h+2pad));

trim_h=hypot;
trim_w=sin(angle)*(main_h+2pad);

tooth=main_l/3;
tooth_r=main_l/3/2;

bridge=50;
bridge_offset=main_l/2-bridge;

bolt_d=5;
bolt_r=bolt_d/2;

bolt_head_d=10;
bolt_head_r=bolt_head_d/2;
bolt_head_h=3.5;

strut_d=8.5;
strut_r=strut_d/2;

strut_head_d=18;
strut_head_r=strut_head_d/2;
strut_head_h=3.5;

strut_w_offset=38;
strut_l_offset=32;
//strut_l_offset=13;

tab_d=16;
tab_r=tab_d/2;

tab_offset=1;

tab_d_offset=5;

module mount() {
module bolt_hole() {
	cylinder(r=bolt_r,h=main_h+2pad);
	cylinder(r=bolt_head_r,h=bolt_head_h);
}
module strut_hole() {
	cylinder(r=strut_r,h=main_h+2pad);
	cylinder(r=strut_head_r,h=strut_head_h);
}
module pattern(spacing) {
	translate([-spacing/2,-spacing/2,]) {
		bolt_hole();
		translate([spacing,0,0])
		bolt_hole();
		translate([0,spacing,0])
		bolt_hole();
		translate([spacing,spacing,0])
		bolt_hole();
	}
}

module main_body() {
	translate([delta/2,0,main_h/2])
	cube([main_l+delta,main_w+delta*2,main_h],center=true);
}


//rotate([180,0,0])
intersection() {
	translate([-bridge_offset+tab_d_offset,tooth_r-delta-tab_offset,0])
	rotate([-angle,0,0])
	translate([0,tab_r,0])
	cylinder(r=tab_r,h=main_h*3);
	main_body();
}

intersection() {
	translate([-bridge_offset+tab_d_offset,-tooth_r+delta+tab_offset,0])
	rotate([angle,0,0])
	translate([0,-tab_r,0])
	cylinder(r=tab_r,h=main_h*3);
	main_body();
}

difference() {
	main_body();

	//y+ inner tab
	translate([main_l/2-tooth/2-tab_d_offset,tooth/2-delta+tab_offset,0])
	rotate([-angle,0,0])
	translate([0,-tab_r,-main_h*2])
	cylinder(r=tab_r,h=main_h*5);
	//y- inner tab
	translate([main_l/2-tooth/2-tab_d_offset,-tooth/2+delta-tab_offset,0])
	rotate([angle,0,0])
	translate([0,tab_r,-main_h*2])
	cylinder(r=tab_r,h=main_h*5);
	//y+ outer tab
	translate([main_l/2-tooth/2-tab_d_offset,main_w/2+delta-tab_offset,0])
	rotate([angle,0,0])
	translate([0,tab_r,-main_h*2])
	cylinder(r=tab_r,h=main_h*5);
	//y- outer tab
	translate([main_l/2-tooth/2-tab_d_offset,-main_w/2-delta+tab_offset,0])
	rotate([-angle,0,0])
	translate([0,-tab_r,-main_h*2])
	cylinder(r=tab_r,h=main_h*5);

	translate([0,0,-pad]) {
		//bolt holes
		pattern(monitor_mount_small);
		pattern(monitor_mount_large);
		//center strut hole
		translate([-main_l/2+(bridge-tooth_r)/2,0,0])
		strut_hole();
		translate([-main_l/2+strut_l_offset,strut_w_offset,0])
		strut_hole();
		translate([+main_l/2-strut_l_offset,strut_w_offset,0])
		strut_hole();
		translate([-main_l/2+strut_l_offset,-strut_w_offset,0])
		strut_hole();
		translate([+main_l/2-strut_l_offset,-strut_w_offset,0])
		strut_hole();
		//center circle
		translate([-bridge_offset,0,0])
		cylinder(r1=tooth_r-delta,r2=tooth_r+delta,h=main_h+2pad);
		//main center cutaway
		translate([-bridge_offset,-tooth/2+delta,0])
		cube([main_l/2+pad+delta+bridge_offset,tooth-delta*2,main_h+2pad]);
		//end circle, +y
		translate([main_l/2-tooth/2,tooth/2-pad,0]) {
			difference() {
				translate([0,-delta,0])
				cube([tooth/2+pad+delta,tooth+2pad+delta*2,main_h+2pad]);
				translate([0,tooth/2,0])
				cylinder(r1=tooth_r+delta,r2=tooth_r-delta,h=main_h+2pad);
			}
		}
		//inside angle, +y
		translate([main_l/2-tooth/2+pad,tooth/2-delta,0])
		rotate([0,0,180])
		rotate([angle,0,0])
		cube([main_l/2-tooth/2+pad+bridge_offset,trim_w,trim_h]);
		//end circle, -y
		translate([main_l/2-tooth/2,-tooth-tooth/2-pad,0]) {
			difference() {
				translate([0,-delta,0])
				cube([tooth/2+pad+delta,tooth+2pad+delta*2,main_h+2pad]);
				translate([0,tooth/2,0])
				cylinder(r1=tooth_r+delta,r2=tooth_r-delta,h=main_h+2pad);
			}
		}
		//inside angle, -y
		translate([-bridge_offset,-tooth/2+delta,0])
		rotate([angle,0,0])
		cube([main_l/2-tooth/2+pad+bridge_offset,trim_w,trim_h]);
		//outside angle +y
		translate([-main_l/2-pad,main_w/2+delta,0])
		rotate([angle,0,0])
		cube([main_l-tooth/2+2pad,trim_w,trim_h]);
		//outside angle -y
		translate([main_l/2-tooth/2+pad,-main_w/2-delta,0])
		rotate([0,0,180])
		rotate([angle,0,0])
		cube([main_l-tooth/2+2pad,trim_w,trim_h]);
		//back angle
		translate([-main_l/2,-main_w/2-delta-pad,0])
		rotate([0,0,90])
		rotate([angle,0,0])
		cube([main_l+2*delta+2pad,trim_w,trim_h]);
	}
}
}
module spacer() {
color("Violet")
difference() {
	translate([delta/2,0,water_gap/2])
	cube([main_l+delta,main_w+delta*2,water_gap],center=true);
	translate([0,0,-pad]) {
		translate([-bridge_offset,0,0])
		cylinder(r=tooth_r-delta,h=water_gap+2pad);
		//main center cutaway
		translate([-bridge_offset,-tooth/2+delta,0])
		cube([main_l/2+pad+delta+bridge_offset,tooth-delta*2,water_gap+2pad]);
		//end circle, -y
		translate([main_l/2-tooth/2,-tooth-tooth/2-pad,0]) {
			difference() {
				translate([0,-delta,0])
				cube([tooth/2+pad+delta,tooth+2pad+delta*2,water_gap+2pad]);
				translate([0,tooth/2,0])
				cylinder(r=tooth_r+delta,h=water_gap+2pad);
			}
		}
		//end circle, +y
		translate([main_l/2-tooth/2,tooth/2-pad,0]) {
			difference() {
				translate([0,-delta,0])
				cube([tooth/2+pad+delta,tooth+2pad+delta*2,water_gap+2pad]);
				translate([0,tooth/2,0])
				cylinder(r=tooth_r+delta,h=water_gap+2pad);
			}
		}
	}
}
}
count=4;
spacer_count=count-1;
module mounts() {
	for (i=[1:count]) {
		translate([0,0,i*(main_h+water_gap)])
		mount();
	}
}
module spacers() {
	for (i=[1:spacer_count]) {
		translate([0,0,i*(main_h+water_gap)])
		spacer();
	}
}
translate([0,0,-water_gap]) {
//	mounts();
	//spacers();
}

mount();
