in=25.4;
pad=0.1;
zero=0.001;

roof_lip_corner=40;
roof_lip_height=15;
roof_lip_width=10;
roof_lip_r=4;

wink_x=705;
wink_y=40;
wink_z=65;

wall=3;
top_wall=1.5;
top_edge=0.2;

roof_opening=720;

roof_straight=20;

//translate([r,0])

pivot_wall=5;
pivot_x=(roof_opening-wink_x)/2-pivot_wall;
base_x=wall+roof_lip_width+pivot_x;
base_z=wall;

ramp_angle=10;

pivot_y=37;
pivot_z=wink_z/2+1;

base_y_offset=roof_lip_width+pivot_y-20;
base_y=roof_straight+base_y_offset;



bolt_head=38;

bolt=7;
bolt_wall=(bolt_head-bolt)/2;

bolt_head_h=base_x+pad+pivot_x;
bolt_head2=bolt_head*2.5;

$fn=90;

module stay_in_circle() {
    hull() {
        hull() {
            translate([roof_lip_corner,0,wall])
            cylinder(r=roof_lip_corner+roof_lip_width,h=zero);
            translate([roof_lip_corner,pivot_y*1.5,-pivot_z-bolt_head/2])
            cylinder(r=roof_lip_corner+roof_lip_width,h=zero);
        }
        translate([roof_lip_corner,-roof_lip_corner,-60])
        cylinder(r=roof_lip_corner+roof_lip_width,h=100);
    }
}


module roof_negative() {
        minkowski() {
            translate([-roof_lip_r-pad-roof_lip_width,wall+roof_lip_r])
            square([roof_lip_width+pad,roof_lip_height-roof_lip_r*2]);
            circle(r=roof_lip_r);
        }
}

module roof_profile() {
	difference() {
        translate([-roof_lip_width,0])
		square([roof_lip_width+wall,roof_lip_height+wall*2]);
        roof_negative();
	}
}

//!roof_profile();

module extrude_roof() {
	r=roof_lip_corner+roof_lip_width;
	h=roof_lip_height+wall*2;
	translate([roof_lip_corner,0])
	intersection() {
		rotate_extrude()
		translate([-roof_lip_corner,0])
        children();
		translate([-r,0,-pad])
		cube([r+pad,r+pad,h+pad*2]);
	}

	rotate([90,0])
	linear_extrude(height=roof_straight)
    children();
}

module roof() {
    extrude_roof()
    roof_profile();
}

module roof_channel() {
    extrude_roof()
    roof_negative();
}

module place_pivot() {
	translate([pivot_x,pivot_y,-pivot_z])
	rotate([0,90])
	children();
}

module mount() {
    intersection() {
        hull() {
            translate([-roof_lip_width,base_y_offset-base_y])
            cube([base_x,base_y,zero]);
            translate([-roof_lip_width,base_y_offset-base_y,roof_lip_height+wall*2])
            cube([roof_lip_width+wall,base_y,zero]);
            place_pivot()
            cylinder(d=bolt+bolt_wall*2,h=pivot_wall);
        }
        stay_in_circle();
    }
}

module body() {
	roof();
	difference() {
		mount();
		place_pivot()
		mirror([0,0,1])
		cylinder(d1=bolt_head,d2=bolt_head2,h=bolt_head_h);
        roof_channel();
	}
}

difference() {
	body();


bolt_head=35;

	place_pivot()
	translate([0,0,-pad])
	cylinder(d=bolt,h=pivot_wall+pad*2);
    //translate([-roof_lip_width-wall,-roof_straight-pad])
    //#cube([roof_lip_width+pad,roof_straight+roof_lip_corner,roof_lip_height]);
	translate([0,0,roof_lip_height+wall*1.5+top_wall])
	cube([roof_lip_corner*4,roof_lip_corner*4,wall],center=true);
	//translate([0,0,roof_lip_height+wall*1.5+top_wall])
	translate([0,-roof_straight,wall+roof_lip_height+top_edge])
	rotate([ramp_angle,0])
	translate([0,0,wall/2])
	cube([roof_lip_corner*4,roof_lip_corner*4,wall],center=true);
}
