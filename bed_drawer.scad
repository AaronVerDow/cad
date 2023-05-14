pad=0.1;
in=25.4;
zero=0.01;

wood=in/2;
bed_wood=wood;
// 2x4 actual dimensions
two=38;
four=90;


bed_x=1530;
bed_y=2030;
bed_z=12*in;
bed_r=5*in;

pillowboard_x=58*in;
pillowboard_y=4*in;
pillowboard_z=22*in;
pillowboard_depth=bed_wood+two;
pillowboard_border=in*3;

mattress_z=230;
mattress_r=2*in;

overhang=10*in;
back_overhang=0;

pillow_x=59*in;
pillow_z=20*in;
pillow_y=3*in;

pillow_angle=20;

headboard_z=pillow_z*0.8;
headboard_x=pillow_x-(pillow_z-headboard_z)*2;

wedge_x=60*in;
wedge_z=10*in;
wedge_y=6*in;
wedge_board_z=8*in;
wedge_board_x=wedge_x-100;

// s=o/h c=a/h t=o/a
wedge_angle=atan(wedge_y/wedge_z);

wedge_board_height=wedge_board_z/cos(wedge_angle);
wedge_board_offset=wood;

radiator_offset=pillowboard_y+wood+two;
radiator_x=1370;
radiator_y=290;
radiator_z=545;
radiator_legs=[100-bed_x/2,0,bed_x/2-100];

radiator_center=70;
radiator_center_h=530;
headboard_pivot=bed_z-bed_wood-two;

neato=120;

back_x=bed_x-overhang*2;
back_z=bed_z-neato;

leg_x=four+wood*2;

spine=3*in;
spines=6;

wheel_hole=5*in;
wheel_z=28;
wheel=in;
wheel_d=13;
caster_hole=4;
caster_gap=32;
caster_x=20.5;
caster_y=42;
caster_wall=in/16;

edge=2*in;
inner=bed_z;
total_leg_x=bed_x-overhang*2;

tip=two;
leg_y=bed_y-overhang-back_overhang;
leg_z=bed_z;

drawer_x_gap=wood*2;
drawer_top_gap=wood*2;
drawer_base_gap=wood*2;
drawer_x=bed_x-leg_x*2-drawer_x_gap-overhang*2;
drawer_z=bed_z-bed_wood-two-drawer_top_gap;

// t=o/a
leg_angle=atan(overhang/(bed_z-bed_wood-two));

// c=a/h
drawer_face=(drawer_z-drawer_base_gap)/cos(leg_angle);

leg_face=(bed_z-bed_wood-two)/cos(leg_angle);

pump_x=10*in;
pump_y=18*in;
pump_z=6*in;
pump_ramp=pump_x-four-wood;

leveler_gap=in/2;

spine_end=0;
spine_gap=(bed_y-four-spine_end*2)/(spines-1);

module rib(n=0) {
	dirror_x()
	translate([-bed_x/2+overhang+wood,four/2-two/2+spine_gap*n,two+leveler_gap])
	color("magenta")
	cube([four,two,bed_z-bed_wood-two*2-leveler_gap]);
}

module ribs() {
	rib();
	rib(3);
	rib(4);
}

module caster() {
	axle=wheel/2;

	translate([0,0,wheel_z]) {
		color("silver")
		translate([0,0,-caster_wall])
		linear_extrude(height=caster_wall)
		difference() {
			square([caster_x,caster_y],center=true);
			dirror_y()
			translate([0,caster_gap/2])
			circle(d=caster_hole);
		}

		color("silver")
		dirror_x()
		translate([-caster_x/2,0])
		hull() {
			translate([0,-caster_y/2,-caster_wall])
			cube([caster_wall,caster_y,caster_wall]);
			translate([0,0,-wheel_z+wheel/2])
			rotate([0,90,0])
			cylinder(d=axle,h=caster_wall);
		}

		translate([0,0,wheel/2-wheel_z])
		rotate([0,90])
		color("#555555")
		cylinder(d=wheel,h=wheel_d,center=true);
	}
}

module pump() {
	translate([0,-pump_y/2-pump_ramp,0])
	hull() {
		translate([pump_x-zero,pump_ramp])
		square([zero,pump_y]);
		square([leg_x,pump_y+pump_ramp*2]);
	}
}

// t=o/a
function leg_y(z)=bed_y-overhang+tan(leg_angle)*z-wood;

module drawer_side() {
	hull() {
		translate([drawer_z-wheel_z,0])
		square([zero,leg_y(drawer_z)]);
		square([zero,leg_y(wheel_z)]);
	}
}

module deep_drawer_side() {
	hull() {
		translate([drawer_z-drawer_base_gap,0])
		square([zero,leg_y(drawer_z)]);
		square([zero,leg_y(drawer_base_gap)]);
	}
}

module drawer_back() {
	square([drawer_x,drawer_z-wheel_z]);
}

module deep_drawer_back() {
	square([drawer_x,drawer_z-drawer_base_gap]);
}


module wheel_side() {
	square([wheel_hole+wood*2,wheel_z-drawer_base_gap+wood]);
}


module drawer() {
	translate([-drawer_x/2,0,wheel_z])
	wood()
	drawer_base();

	dirror_x()
	translate([drawer_x/2,0,wheel_z])
	rotate([0,-90])
	wood()
	drawer_side();

	translate([-drawer_x/2,wood,wheel_z])
	rotate([90,0])
	wood()
	drawer_back();

	translate([-drawer_x/2,leg_y(drawer_base_gap),drawer_base_gap])
	rotate([90-leg_angle,0])
	wood()
	square([drawer_x,drawer_face]);

	dirror_x()
	translate([drawer_x/2-caster_lane,caster_front])
	caster();

	dirror_x()
	translate([drawer_x/2-caster_lane*2,caster_back])
	caster();

	dirror_x()
	translate([drawer_x/2-caster_lane*3,caster_mid])
	caster();

	translate([0,(caster_mid-caster_front)/2+caster_front])
	caster();

	translate([0,(caster_mid-caster_back)/2+caster_back])
	caster();
}

caster_lane=caster_x*1.5;
caster_edge=caster_y;
caster_front=leg_y(wheel_z)-caster_edge;
caster_back=caster_edge;
caster_mid=(caster_back-caster_front)/2+caster_front;

module deep_drawer() {
	translate([-drawer_x/2,0,drawer_base_gap])
	wood()
	deep_drawer_base();

	dirror_x()
	translate([drawer_x/2,0,drawer_base_gap])
	rotate([0,-90])
	wood()
	deep_drawer_side();

	translate([-drawer_x/2,wood,drawer_base_gap])
	rotate([90,0])
	wood()
	deep_drawer_back();
	
	// middle
	translate([-drawer_x/2,middle_wheel+wheel_hole/2+wood/2,drawer_base_gap])
	rotate([90,0])
	wood()
	drawer_back();

	translate([-drawer_x/2,leg_y(drawer_base_gap),drawer_base_gap])
	rotate([90-leg_angle,0])
	wood()
	square([drawer_x,drawer_face]);

	color("cyan")
	translate([-drawer_x/2,0,wheel_z])
	wood()
	wheel_caps();

	color("magenta")
	translate([-drawer_x/2,0,drawer_base_gap])
	place_wheels() {
		rotate([90,0])
		wood()
		translate([-wood,0])
		wheel_side();

		translate([-wood,-wood])
		rotate([90,0,90])
		wood()
		wheel_side();

		translate([wheel_hole+wood,wheel_hole])
		rotate([90,0,180])
		wood()
		wheel_side();

		translate([wheel_hole+wood,wheel_hole+wood])
		rotate([90,0,270])
		wood()
		wheel_side();
	}
}

translate([0,wood+bed_x*0])
drawer();

middle_wheel=bed_y/2-wheel_hole/2;

module place_wheels() {
	dirror_x(drawer_x)
	translate([wood,leg_y(drawer_base_gap)-wheel_hole-wood])
	children();

	dirror_x(drawer_x)
	translate([drawer_x/4-wheel_hole/2,wood])
	children();

	//translate([drawer_x/2-wheel_hole/2,leg_y(drawer_base_gap)/2])
	translate([drawer_x/2-wheel_hole/2,middle_wheel])
	children();
}


module wheel_caps() {
	place_wheels()
	translate([-wood,-wood])
	square([wheel_hole+wood*2,wheel_hole+wood*2]);
}

module drawer_base() {
	difference() {
		square([drawer_x,leg_y(wheel_z)]);
	}
}

module deep_drawer_base() {
	difference() {
		square([drawer_x,leg_y(drawer_base_gap)]);
		place_wheels()
		square([wheel_hole,wheel_hole]);
	}
}

echo(leg_y(drawer_base_gap));

module back() {
	translate([-back_x/2,bed_z-back_z])
	square([back_x,back_z]);

	translate([-pillowboard_x/2+pillowboard_border,bed_z-pillowboard_depth])
	square([pillowboard_x-pillowboard_border*2,pillowboard_z-pillowboard_border]);
	
}

module wedge_leg() {
	
	difference() {
		intersection() {
			square([radiator_y,radiator_z+wedge_board_z]);
			hull() {
				square([radiator_y,radiator_z]);
				translate([0,radiator_z+wedge_z-zero])
				square([radiator_y-wedge_y,zero]);
			}
		}
		hull() {
			translate([radiator_y/2,radiator_center_h-radiator_center])
			circle(d=radiator_center);
			translate([radiator_y/2,-radiator_center])
			circle(d=radiator_center);
		}
	}
}

module radiator_headboard() {
	for(x=radiator_legs)
	translate([x,-radiator_y])
	rotate([90,0,90])
	wood()
	wedge_leg();

	translate([-wedge_board_x/2,0,radiator_z])
	rotate([90+wedge_angle,0])
	translate([0,wedge_board_offset])
	wood()
	square([wedge_board_x,wedge_board_height-wedge_board_offset]);
}

module wedge_profile() {
	hull() {
		square([wedge_z,zero]);
		translate([wedge_z,-wedge_y])
		square([zero,wedge_y]);
	}
}

module wedge() {
	translate([wedge_x/2,0,radiator_z])
	rotate([0,-90,0])
	linear_extrude(height=wedge_x)
	wedge_profile();
}


module old_headboard() {
	dirror_x()
	rotate_headboard()
	translate([overhang-bed_x/2+wood,-two,0])
	cube([four,two,headboard_z+bed_z]);

	rotate_headboard()
	translate([-headboard_x/2,wood,bed_z])
	rotate([90,0])
	wood()
	headboard();

	rotate_headboard()
	translate([0,wood,bed_z])
	translate([-pillow_x/2,0])
	#cube([pillow_x,pillow_y,pillow_z]);
}

module preview() {
	//#wedge();

	#translate([0,0,bed_z+pad])
	linear_extrude(height=mattress_z)
	bed();

	translate([-pillowboard_x/2,-pillowboard_y,bed_z-pillowboard_depth])
	#cube([pillowboard_x,pillowboard_y,pillowboard_z]);

	*#translate([-radiator_x/2,-radiator_y-radiator_offset])
	cube([radiator_x,radiator_y,radiator_z]);
}

module rotate_headboard() {
	translate([0,0,headboard_pivot])
	rotate([pillow_angle,0])
	translate([0,0,-headboard_pivot])
	children();
}

module headboard() {
	square([headboard_x,headboard_z]);
}

module corner(r) {
	offset(r*2)
	offset(-r*2)
	children();
}

module wood(w=wood) {
	linear_extrude(height=w)
	children();
}

module dirror_y(y=0) {
	children();
	translate([0,y])
	mirror([0,1])
	children();

}

module dirror_x(x=0) {
	children();
	translate([x,0])
	mirror([1,0])
	children();

}

module bed() {
	translate([-bed_x/2,0])
	corner(mattress_r)
	square([bed_x,bed_y]);
}

module leg_face() {
	square([leg_x,leg_face]);
}

module assembled() {
	ribs();

	color("cyan")
	dirror_x()
	translate([overhang-bed_x/2,bed_y-overhang])
	rotate([90-leg_angle,0])
	wood()
	leg_face();

	color("blue")
	translate([0,0,bed_z-bed_wood])
	wood(bed_wood)
	bed();

	color("gold")
	dirror_x()
	translate([bed_x/2-overhang-leg_x,back_overhang,bed_z])
	rotate([0,90])
	wood()
	leg_side();

	color("cyan")
	dirror_x()
	translate([bed_x/2-overhang-wood,back_overhang,bed_z])
	rotate([0,90])
	wood()
	outer_leg_side();

	color("red")
	//for(y=[back_overhang:spine_gap:bed_y-overhang])
	for(y=[spine_end+wood:spine_gap:bed_y-spine_end])
	translate([four-bed_x/2,y-wood,bed_z-bed_wood-two])
	spine();

	*color("magenta")
	dirror_x()
	translate([-bed_x/2,0,bed_z-two-bed_wood])
	cube([four,bed_y,two]);

	color("magenta")
	translate([0,0,bed_z-bed_wood-two])
	linear_extrude(height=two)
	dirror_x()
	intersection() {
		bed();
		translate([bed_x/2-four,-pad])
		square([four,bed_y+pad*2]);
	}


	*dirror_x()
	translate([bed_x/2,back_overhang,bed_z])
	rotate([-90,0,90])
	wood()
	side_edge();

	*dirror_y(bed_y)
	translate([0,0,bed_z])
	rotate([-90,0])
	wood()
	end_edge();
	
	translate([0,-pillowboard_y,0])
	rotate([90,0])
	wood()
	back();

	translate([0,-pillowboard_y,bed_z-pillowboard_depth+pillowboard_z-wood-pillowboard_border-shelf_z])
	wood()
	shelf();

	dirror_x()
	color("lime")
	translate([-bed_x/2+overhang+wood,-pillowboard_y-wood-two])
	cube([four,two,bed_z-pillowboard_depth+pillowboard_z-pillowboard_border-shelf_z-wood-four]);

	color("green")
	translate([pillowboard_border-pillowboard_x/2+wood,-pillowboard_y-wood-two,bed_z-pillowboard_depth+pillowboard_z-pillowboard_border-shelf_z-wood-four])
	cube([pillowboard_x-pillowboard_border*2-wood*2,two,four]);


	dirror_x()
	translate([bed_x/2-overhang-leg_x,pump_center,bed_z-bed_wood-two-pump_z])
	wood()
	pump();

	translate([0,-pillowboard_y-shelf_y+wood,bed_z-pillowboard_depth+pillowboard_z-pillowboard_border-backstop_z])
	rotate([90,0])
	wood()
	backstop();
		
	dirror_x()
	translate([pillowboard_x/2-pillowboard_border-wood,-pillowboard_y,bed_z+pillowboard_z-pillowboard_depth-pillowboard_border])
	rotate([-90,0,-90])
	wood()
	end_cap();
		
	dirror_x()
	translate([-wood/2,-pillowboard_y,bed_z+pillowboard_z-pillowboard_depth-pillowboard_border])
	rotate([-90,0,-90])
	wood()
	middle_cap();


	dirror_x()
	translate([overhang+wood-bed_x/2,-pillowboard_y-wood,leveler_gap])
	#cube([four,leveler,two]);
}

leveler=leg_y(0)+pillowboard_y+wood;

pump_center=bed_y/3;

shelf_z=1*in;
shelf_y=6*in;

module end_cap() {
	cap_z=bed_z+pillowboard_z-pillowboard_depth-pillowboard_border-radiator_z;
	cap_extra=cap_z/2;

	square([two+wood,pillowboard_z-pillowboard_border]);
	hull() {
		square([two+wood,cap_z]);

		translate([shelf_y,0])
		square([zero,backstop_z]);
	}
}

module middle_cap() {
	difference() {
		end_cap();
		translate([-pad,-pad])
		square([shelf_y+pad*2,shelf_z+pad]);
		square([two,four+shelf_z]);
	}
}

module shelf() {
	translate([pillowboard_border-pillowboard_x/2,-shelf_y])
	square([pillowboard_x-pillowboard_border*2,shelf_y]);
}

backstop_z=shelf_z*2+wood;


module backstop() {
	translate([-pillowboard_x/2+pillowboard_border,0])
	square([pillowboard_x-pillowboard_border*2,backstop_z]);
}

module pillowboard_base() {
	translate([-bed_x/2+overhang,0])
	square([bed_x-overhang*2,pillowboard_y]);
}

translate([0,-pillowboard_y,bed_z-pillowboard_depth-wood])
wood()
pillowboard_base();

*preview();

module end_edge() {
	hull() {
		translate([-total_leg_x/2,0])
		square([total_leg_x,edge]);
		translate([-tip-total_leg_x/2,0])
		square([total_leg_x+tip*2,bed_wood]);
	}
}

module side_edge() {
	hull() {
		square([leg_y,edge]);
		square([leg_y+tip,bed_wood]);
	}
}


module spine() {
	cube([bed_x-four*2,four,two]);
}

module plywood_spine() {
	translate([overhang-bed_x/2,0])
	square([bed_x-overhang*2,spine]);

	dirror_x()
	translate([bed_x/2-overhang-leg_x,0])
	square([leg_x,leg_z]);

	dirror_x()
	translate([bed_x/2-overhang-leg_x,0])
	hull() {
		square([leg_x,inner]);
		square([leg_x+overhang,edge]);
	}
}

module leg_side() {
	difference() {
		translate([0,-pillowboard_y-wood-two])
		hull() {
			translate([0,-back_overhang])
			square([edge,bed_y+pillowboard_y+wood+two]);
			square([inner,leg_y+pillowboard_y+wood+two]);
		}

		translate([-pad,-wood-pillowboard_y])
		square([pillowboard_depth+pad,pillowboard_y+wood]);
	}
}

module outer_leg_side() {
	difference() {
		leg_side();
		translate([-pad,pump_center-pump_y/2,0])
		square([pump_z+bed_wood+two+pad,pump_y]);
	}
}

assembled();
