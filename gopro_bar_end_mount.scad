od=28;

mount_od=15.3;
mount_width=2.93;
mount_gap=3.5;

channel=mount_width*2+mount_gap;


// how far the mount is from screw center
flat=8;

// width of solid portion of base
// adjust for how much of base has solid square, not clipped corners
flat_base_depth=channel;

// total width of base
// adjust for clearance of base side
flat_depth=22/2+channel/2;

width=11;

mount_base=24;
// wall=flat-mount_od/2;
wall=(mount_base-mount_od)/2;

pad=0.1;

screw=4.5;

screw_head=10.5;
screw_head_depth=2.0+2.5;

tip=mount_od+wall*2;
// tip_gap=mount_width/4;
tip_gap=0;


inner_gap=0.5;

zero=0.01;

middle=mount_gap;
slide_angle=4;
elephants_foot=0.5;

$fn=200;

knife=1;
squish=2;

outer_knife=od/2-squish-knife/2;
inner_knife=screw/2+squish*2+knife/2;

// bar preview
//#circle(d=22.5);

module knife_point() {
	translate([0,0,-squish])
	cylinder(d1=knife,d2=knife+squish*2,h=squish);
}

for(i=[0:360/6:359])
rotate([0,0,i])
hull() {
	translate([0,inner_knife])
	knife_point();
	translate([0,outer_knife])
	knife_point();
}

module dirror_x() {
	children();
	mirror([1,0])
	children();
}

module donut() {
	difference() {
		translate([0,0,width+channel-wall])
		rotate_extrude()
		translate([mount_od/2,0])
		circle(r=wall);
		base_negative();
	}

	dirror_x()
	translate([mount_od/2,0,width+channel-wall])
	rotate([-90,0])
	cylinder(r=wall,h=flat);
}

module mount() {
	translate([0,0,width])
	cylinder(d=mount_od,h=channel+pad);
}

module tip() {
	translate([0,0,width+channel])
	sphere(d=mount_od+wall*2);
}

module positive() {
	hull() {
		cylinder(d=od,h=zero);
		donut();
	}
}


module old_positive() {
	hull() {
		cylinder(d1=od,d2=mount_od+wall*2,h=width+channel);
		translate([-mount_base/2,flat-zero,width+channel-flat_base_depth])
		cube([mount_base,zero,flat_base_depth]);
		tip();
	}
}

// RENDER stl
module endcap() {
	difference() {
		tip();
		translate([0,0,width+channel-tip])
		cube([od,od,tip*2],center=true);
		screw();
	}
}


// RENDER stl
module middle() {
	module positive() {
		cylinder(d=mount_od-inner_gap,h=middle);
		translate([-mount_od/2+inner_gap/2,0])
		cube([mount_od-inner_gap,flat-inner_gap,middle]);
	}
	difference() {
		positive();
		screw(inner_gap);
		translate([0,screw/2,middle])
		rotate([-slide_angle,0])
		translate([-mount_od/2,0,0])
		cube([mount_od,flat*2,middle]);
	}
}


// color("cyan") translate([0,0,width+mount_width]) middle();
// endcap();

module screw(extra=0) {
	translate([0,0,-pad])
	cylinder(d=screw+extra,h=width+channel+tip+pad);
	translate([0,0,width+channel+tip/2-screw_head_depth])
	cylinder(d=screw_head,h=screw_head_depth+pad);
}

module base_negative() {
	translate([-od/2,flat,width+channel-flat_depth])
	cube([od,width,od]);
}

// RENDER stl
module base() {
	difference() {
		positive();
		hull() {
			mount();
			translate([0,od])
			mount();
		}

		base_negative();

		screw();

		translate([0,0,width+channel+tip-tip_gap])
		cube([od,od,tip*2],center=true);
	}
}

base();
