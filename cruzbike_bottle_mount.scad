$fn=90;
bolt_gap=65;
bolt=6.5;

seat_bolt=35;
bottle_bolt=35;
seat_to_pivot=30;
bottle_to_pivot=30;
angle=45;

wall=5;

od=bolt+wall*2;
pad=0.1;

bolt_head=16;
bolt_head_height=50;
bolt_head_d2=bolt_head+bolt_head_height/2;

collision_offset=bolt_head;

manifold=0.1;

module place_bolts() {
	children();
	translate([bolt_gap,0])
	children();
}

module positive() {
	hull()
	positive_unhulled();
}

module positive_unhulled() {
	hull()
	place_bolts()
	cylinder(d=od+manifold,h=seat_bolt);

	
	color("lime")
	place_bottle()
	hull()
	place_bolts()
	cylinder(d=od+manifold,h=bottle_bolt);
}

module place_bottle() {
	translate([collision_offset,0,seat_to_pivot])
	rotate([angle,0])
	translate([0,0,bottle_to_pivot-bottle_bolt])
	children();
}

bolt_extra=100;

module bolts(height,head_height,extra=0) {
	place_bolts()
	translate([0,0,-pad])
	cylinder(d=bolt,h=seat_bolt+pad*2+extra);

	place_bolts()
	translate([0,0,head_height])
	cylinder(d1=bolt_head,d2=bolt_head_d2,h=bolt_head_height);
}

module assembled() {
	difference() {
		positive();

		bolts(seat_bolt,seat_bolt,bolt_extra);

		place_bottle()
		translate([0,0,bottle_bolt+pad])
		mirror([0,0,1])
		bolts(bottle_bolt,bottle_bolt,bolt_extra);
	}
}


assembled();
translate([0,bolt_head*1.5])
mirror([0,1])
assembled();
