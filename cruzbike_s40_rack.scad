in=25.4;
wood=in/2;
use <joints.scad>;


box_width=170;
box_depth=420;
wing_depth=420;

bike_width=85;

top=[0,0];
back=[200,-190];
front=[-40,-190];

bottle_x=00;
bottle_y=-150;

bottle_gap=65;

dirror_y()
translate([bottle_x,0,bottle_y-10])
translate([0,bike_width/2+wood])
rotate([-90,0])
import("BottleCage_extBottom.stl");

dots=[
	top,
	back,
	front,
	[bottle_x,bottle_y+bottle_gap/2],
	[bottle_x,bottle_y-bottle_gap/2]
];

slant_opp=-front[0]-top[0];
slant_adj=-front[1]+top[0];
slant=atan(slant_opp/slant_adj);

frame=40;

box_x_offset=230;
box_y_offset=20;

wing_gap=1;

big_fn=400;
curve=350;

fang_corner=20;

module base() {
	difference() {
		hull() {
			translate([0,-bike_width/2-wood])
			square([box_depth+bike_depth,bike_width+wood*2]);

			translate([0,-box_width/2-wood])
			square([wing_depth+wing_gap,box_width+wood*2]);
		}
		dirror_y()
		translate([0,box_width/2])
		square([wing_depth+wing_gap,wood+pad]);

		dirror_y()
		translate([0,-bike_width/2,0])
		rotate([0,0,-90])
		dirror_x(wood)
		#negative_tails(box_depth+bike_depth,wood,pins,pintail_gap,0,pintail_ear);
	}
}

module wood(height=wood) {
	linear_extrude(height=height)
	children();
}

module place_dots() {
	for(dot=dots)
	translate(dot)
	children();
}

//wood() base();

dot=box_y_offset*2+wood*2;
bolt=10;

wing_h=150;
wing_corner=30;

wing_wall=in;
side_wall=wing_wall;
dot_wall=dot;

module wing() {
	difference() {
		wing_body();
		intersection() {
			offset(-wing_wall)
			wing_body();
			translate([wing_depth/2+pattern_gap/2,wing_h/2])
			pattern();
		}
	}
}

module wing_body() {
	intersection() {
		square([wing_depth,wing_h]);
		translate([0,-wing_corner])
		offset(wing_corner)
		offset(-wing_corner)
		square([wing_depth,wing_h+wing_corner]);
	}
}

dirror_y()
color("cyan")
// cabinet hinge 
//translate([box_x_offset+box_depth-wing_depth,box_width/2+wood,box_y_offset])

translate([box_x_offset+box_depth-wing_depth,box_width/2,box_y_offset+wood])
rotate([80,0])
translate([0,0,-wood])
wood()
wing();

fang=box_width-bike_width-wood*2;

bike_depth=box_x_offset/2+dot/4;
trig=10;

module side() {

	hyp=curve+dot/2;
	opp=curve+fang-box_y_offset+back[1];
	adj=sqrt((hyp*hyp)-(opp*opp));
	angle=asin(opp/hyp);

	module fang(height=wood+fang) {
		translate([box_x_offset-bike_depth,box_y_offset-height+wood])
		square([box_depth+bike_depth,height]);
	}
	
	module slant() {
		translate([box_x_offset+box_depth,box_y_offset])
		rotate([0,0,-slant])
		translate([0,-fang*2])
		square([fang,fang*2]);
	}

	module positive() {
		difference() {
			fang(fang_corner);
			slant();
		}
		offset(fang_corner)
		offset(-fang_corner)
		difference() {
			hull() {
				place_dots()
				circle(d=dot);
				fang();
			}

			//translate([box_x_offset+box_depth,-curve+box_y_offset-fang])
			translate([back[0]+adj,-curve+box_y_offset-fang]) {
				hull() {
					translate([box_depth,0])
					circle(r=curve,$fn=big_fn);
					circle(r=curve,$fn=big_fn);
				}


				*color("lime")
				translate([-trig/2,0])
				#square([trig,opp]);

				*rotate([0,0,90-angle])
				translate([-trig/2,0])
				#square([trig,hyp]);
			}
			slant();
		}
	}


	difference() {
		positive();

		// enable pattern
		intersection() {
			difference() {
				offset(-side_wall)
				positive();
				place_dots()
				circle(d=dot_wall);

				// trim pattern
				*translate([box_x_offset,box_y_offset])
				rotate([0,0,-15])
				translate([-1000,-500])
				square([1000,1000]);
			}
			translate([39,23])
			pattern();
		}
		place_dots()
		circle(d=10);

		translate([box_x_offset-bike_depth,box_y_offset+wood+pad])
		rotate([0,0,-90])
		negative_pins(box_depth+bike_depth,wood+pad,pins,pintail_gap,0,pintail_ear);
	}
}

pins=4;
bit=in/4;
pintail_gap=0;
pintail_ear=bit;
pad=0.1;



module dirror_x(x=0) {
	translate([x,0])
	mirror([1,0])
	children();
	children();
}


module dirror_y(y=0) {
	translate([0,y])
	mirror([0,1])
	children();
	children();
}

color("lime")
dirror_y()
translate([0,bike_width/2+wood])
rotate([90,0])
wood()
side();

//translate([box_x_offset,-box_width/2,box_y_offset])
color("blue")
translate([box_depth+box_x_offset,0,box_y_offset])
rotate([0,0,180])
wood()
base();

pattern_hole=1.5*in;
pattern_gap=2.75*in;
pattern_fn=90;
pattern_wall=1*in;

module pattern(pattern_max=1000) {
    translate([-pattern_gap/2,0])
    dirror_y()
    dirror_x() {
        for(x=[0:pattern_gap:pattern_max])
        for(y=[0:pattern_gap:pattern_max])
        translate([x,y])
        circle(d=pattern_hole,$fn=pattern_fn);
                
        for(x=[pattern_gap/2:pattern_gap:pattern_max])
        for(y=[pattern_gap/2:pattern_gap:pattern_max])
        translate([x,y])
        circle(d=pattern_hole,$fn=pattern_fn);              
    }
}
