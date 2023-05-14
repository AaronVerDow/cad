in=25.4;
wood=in/2;
$fn=200;
zero=0.01;

use <joints.scad>;

pan_x=30*in;
pan_y=18*in;
pan_z=30;

pan_gap=10;

window=635;

box_x=pan_x+wood*2+pan_gap*2;
box_y=pan_y+wood*2+pan_gap*2;
box_z=window;

tower_max=70*in;

post=3*in;

tower_z=tower_max-box_z;

levels=3;

level=tower_z/levels;

post_offset=post/2+wood;

mid_split=level/2;

red=[post_offset,box_y/2,0];
red_z=tower_max-level;

orange=[post_offset,post_offset,0];
orange_z=tower_max-level;

yellow=[box_x-post_offset,post_offset,0];
yellow_z=tower_max;

green_z=tower_max-level*2;
green=[box_x-post_offset,box_y/2,0];

cube([box_x,box_y,box_z]);

color("red")
translate(red)
cylinder(d=post,h=red_z);

*color("orange")
translate(orange)
cylinder(d=post,h=orange_z);

*color("yellow")
translate(yellow)
cylinder(d=post,h=yellow_z);

color("green")
translate(green)
cylinder(d=post,h=green_z);

color("blue")
translate([box_x/2,box_y/2,box_z+level])
cylinder(d=post,h=level*3);


module wood() {
	linear_extrude(height=wood)
	children();
}

corner=post/2+wood;

module level(x=box_x/2+post/2,y=box_y/2+post/2) {
	offset(post/2)
	offset(-post/2)
	hull() {
		square([x,zero]);
		square([zero,y]);
		translate([box_x/2,box_y/2])
		circle(d=post);
	}
}

module other() {
	translate([0,0,orange_z])
	wood()
	level();

	mirror([1,0])
	translate([-box_x,0,yellow_z])
	wood()
	level();

	mirror([0,1])
	translate([0,-box_y,red_z])
	wood()
	level();

	mirror([0,1])
	mirror([1,0])
	translate([-box_x,-box_y,yellow_z])
	wood()
	level();
}


module shelf(z) {
	translate([post_offset,post_offset,z])
	wood()
	offset(corner)
	square([box_x/2-post_offset,box_y-post_offset*2]);
}

shelf(red_z);

translate([box_x,0])
mirror([1,0])
shelf(red_z-level);

translate([box_x,0])
mirror([1,0])
shelf(yellow_z);

top=box_y*.66;

translate([box_x/2,box_y/2,yellow_z+level])
wood()
circle(d=top);
