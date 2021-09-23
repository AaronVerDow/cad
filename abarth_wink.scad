in=25.4;
pad=0.1;
zero=0.001;

roof_lip_corner=30;
roof_lip_height=12;
roof_lip_width=19;

wink_x=28*in;
wink_y=80;
wink_z=90;

wall=3;

roof_opening=28.5*in;

roof_straight=50;

//translate([r,0])

base_y_offset=roof_lip_width;
base_x=wall+roof_lip_width;
base_y=roof_straight+base_y_offset;
base_z=wall;


pivot_x=0;
pivot_y=0;
pivot_z=wink_z/2;

pivot_wall=wall;

bolt=7;
bolt_wall=12;

bolt_head=bolt+bolt_wall*1.5;

bolt_head_h=base_x+pad;
bolt_head2=bolt_head*7;

$fn=90;


module roof_profile() {
	translate([-roof_lip_width,0])
	difference() {
		square([roof_lip_width+wall,roof_lip_height+wall*2]);
		translate([-pad,wall])
		square([roof_lip_width+pad,roof_lip_height]);
	}
}

module roof() {
	r=roof_lip_corner+roof_lip_width;
	h=roof_lip_height+wall*2;
	translate([roof_lip_corner,0])
	intersection() {
		rotate_extrude()
		translate([-roof_lip_corner,0])
		roof_profile();
		translate([-r,0,-pad])
		cube([r+pad,r+pad,h+pad*2]);
	}

	rotate([90,0])
	linear_extrude(height=roof_straight)
	roof_profile();
}

module place_pivot() {
	translate([pivot_x,pivot_y,-pivot_z])
	rotate([0,90])
	children();
}

module mount() {
	hull() {
		translate([wall-base_x,base_y_offset-base_y])
		cube([base_x,base_y,base_z]);
		place_pivot()
		cylinder(d=bolt+bolt_wall*2,h=pivot_wall);
	}
}

module body() {
	roof();
	difference() {
		mount();
		mirror([1,0])
		place_pivot()
		cylinder(d1=bolt_head,d2=bolt_head2,h=bolt_head_h);
	}
}

difference() {
	body();
	place_pivot()
	translate([0,0,-pad])
	cylinder(d=bolt,h=pivot_wall+pad*2);
}
