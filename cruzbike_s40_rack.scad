in=25.4;
wood=in/2;

box_width=180;
box_depth=400;
wing_depth=350;

bike_width=120;

top=[0,0];
back=[180,-200];
front=[-100,-200];

dots=[
	top,
	//back,
	front
];

box_x_offset=100;
box_y_offset=40;

pad=0.1;
wing_gap=1;

module base() {
	difference() {
		hull() {
			translate([0,-bike_width/2-wood])
			square([box_depth,bike_width+wood*2]);

			translate([0,-box_width/2-wood])
			square([wing_depth+wing_gap,box_width+wood*2]);
		}
		dirror_y()
		translate([0,box_width/2])
		square([wing_depth+wing_gap,wood+pad]);
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

dot=40;
bolt=10;

wing_h=150;
wing_corner=30;

wing_wall=in;
side_wall=wing_wall;
dot_wall=80;

module wing() {
	difference() {
		wing_body();
		intersection() {
			offset(-wing_wall)
			wing_body();
			translate([wing_depth/2,wing_h/2])
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
translate([box_x_offset+box_depth-wing_depth,box_width/2+wood,box_y_offset])
rotate([90,0])
wood()
wing();

fang=box_width-bike_width-wood*2;

module side() {
	module positive() {
		hull() {
			place_dots()
			circle(d=dot);
			translate([box_x_offset,box_y_offset-fang])
			square([box_depth,wood+fang]);
		}
	}


	difference() {
		positive();
		intersection() {
			difference() {
				offset(-side_wall)
				positive();
				place_dots()
				circle(d=dot_wall);

				translate([box_x_offset,box_y_offset])
				rotate([0,0,-15])
				translate([-1000,-500])
				square([1000,1000]);
			}
			translate([0,20])
			pattern();
		}
		place_dots()
		circle(d=10);
	}
}

module dirror_x(x=0) {
	translate([x,0])
	mirror([1,1])
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
