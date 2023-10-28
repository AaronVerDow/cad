small_bolt=4;
large_bolt=14;
pad=0.1;

large_bolt_offset=[20,0];
bar_offset=[-5,5];

support_width=10;
large_wall=4;
large_od=large_bolt+large_wall*2;

large_grip=4;
screw_length=30;
screw_head=8;
lip=screw_head/2;

bar=35;

width=50;
$fn=90;
zero=0.001;

module positive() {
	translate(bar_offset)
	cylinder(d=bar,h=width);
	hull() {
		translate(bar_offset)
		cylinder(d=bar,h=support_width);
		translate(large_bolt_offset)
		cylinder(d=large_od,h=support_width);
	}
	translate([0,0,-large_grip])
	translate(large_bolt_offset)
	cylinder(d=large_bolt,h=large_grip+pad);
}

difference() {
	positive();
	translate([0,0,-pad])
	cylinder(d=small_bolt,h=width+pad*2);

	hull() {
		translate([0,0,screw_length])
		cylinder(d=screw_head,h=zero);
		translate(bar_offset)
		translate([0,0,width+pad])
		cylinder(d=bar-lip*2,h=zero);
	}
}


