in=25.4;
wood=in/2;
$fn=200;

use <joints.scad>;

pan_x=30*in;
pan_y=18*in;
pan_z=30;

pan_gap=10;

window=750;

top_lip=40+wood;

box_x=pan_x+wood*2+pan_gap*2;
box_y=pan_y+wood*2+pan_gap*2;
box_z=window+top_lip;

steps=4;
step_ratio=1;

step_z=box_z/(steps*2-1)*2;
step_x=step_z*step_ratio;
step_y=box_y/2;

step_overhang_x=0;
step_overhang_y=wood*2;


total_step_x=step_x*(steps-1);
module dirror_x(x=0) {
    children();
    translate([x,0])
    mirror([1,0,0])
    children();
}

module dirror_y(y=0) {
    children();
    translate([0,y])
    mirror([0,1,0])
    children();
}

module wood(height=wood) {
    linear_extrude(height=height)
    children();
}

x_pins=2;
y_pins=3;
x_pins_total=290;
z_pins=4;
bit=in/4;
pintail_ear=bit;
pintail_holes=bit;
pintail_gap=in/8;
pad=0.1;

//RENDER svg
module floor() {
	difference() {
		square([box_x,box_y]);

		translate([box_x/2,box_y/2])
		circle(d=box_y*1.1);

		dirror_x(box_x)
		dirror_y(box_y)
		translate([x_pins_total,-pad])
		rotate([0,0,90])
		negative_pins(x_pins_total,wood+pad,x_pins,pintail_gap,0,pintail_ear);

		dirror_x(box_x)
		translate([-pad,0])
		negative_pins(box_y,wood+pad,y_pins,pintail_gap,0,pintail_ear);
		
	}
}

module roof() {
	floor();
}

//RENDER svg
module end() {
	module edge() {
		negative_tails(box_y,wood+pad,y_pins,pintail_gap,pintail_holes,pintail_ear);
	}
	difference() {
		square([box_z,box_y]);

		dirror_y(box_y)
		translate([box_z,-pad])
		rotate([0,0,90])
		negative_pins(box_z,wood+pad,z_pins,pintail_gap,pintail_holes,pintail_ear);


		edge();
		translate([window,0])
		dirror_x(wood)
		edge();

		mirror([1,0,0])
		rotate([0,0,90])
		arch(box_y,box_z);
	}
}

//RENDER svg
module back() {

	module edge() {
		dirror_y(box_x)
		negative_tails(x_pins_total,wood,x_pins,pintail_gap,pintail_holes,pintail_ear);
	}
    difference() {
        square([box_x,box_z]);


	translate([box_x,0])
	rotate([0,0,90])
	edge();

	translate([box_x,window])
	rotate([0,0,90])
	dirror_x(wood)
	edge();


	dirror_x(box_x)
	negative_tails(box_z,wood,z_pins,pintail_gap,pintail_holes,pintail_ear);
	arch(box_x,box_z);

    }
}

module front_etching() {
    back_etching();
}

module end_etching() {
	mirror([0,1,0])
    rotate([0,0,-90])
    back_etching();
}

module steps_etching() {
    back_etching();
}

module door_space() {
	translate([box_x/2,pattern_wall])
	square([box_x/2-pattern_wall*2,fence_h+fence-pattern_wall+door_gap]);
}

//RENDER svg
module door() {
	difference() {
		offset(-door_gap)
		door_space();
		intersection() {
			offset(-door_gap-pattern_wall)
			door_space();
			pattern();
		}
	}
}

//RENDER svg
module front() {
	difference() {
		back();
		//front_negative();
		door_space();

	}
	// middle piece
	translate([box_x/2-pattern_wall,0])
	square([pattern_wall,fence_h+fence]);

	translate([box_x-pattern_wall*2,0])
	square([pattern_wall,fence_h+fence]);
}

door_y=box_z*0.6;
door_x=door_y*0.7;
door_lip=wood*2;
door_gap=in/4;
step_display_gap=30;
door_window=door_x*0.6;
door_window_line=wood;

line=bit;
door_plank=(door_x+line)/7;
window_trim=wood;

wall=100;
fence=100;
fence_h=wall*2.5;

wood_pan_gap=in/4;
pan_corner=in;

handle_x=50;
handle_y=150;

handle_gap_x=box_y*0.8;
handle_gap_y=box_y*0.5;


//RENDER svg
module pan() {
	module handle() {
		translate([0,-handle_y/2+handle_x/2])
		hull() {
			circle(d=handle_x);
			translate([0,handle_y-handle_x])
			circle(d=handle_x);
		}
	}
	difference() {
		offset(pan_corner)
		offset(-wood-wood_pan_gap-pan_corner)
		square([box_x,box_y]);
		
		translate([box_x/2-handle_gap_x/2,box_y/2])
		dirror_x(handle_gap_x)
		handle();

		*translate([box_x/2,box_y/2-handle_gap_y/2])
		dirror_y(handle_gap_y)
		rotate([0,0,90])
		handle();
	}
}

module front_negative() {
	arch(box_x,box_z);
	translate([box_x,0])
	mirror([1,0])
	translate([wall,wall])
	square([(box_x-fence*3)/2,fence_h+pad]);
}


//pattern_hole=1.5*in;
//pattern_gap=2.75*in;
pattern_hole=2.5*in;
pattern_gap=pattern_hole+1.5*in;
pattern_fn=4;
pattern_wall=50;

module pattern(pattern_max=800) {
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

module arch(x,y) {
	y2=y-(x-wall*2)/2-wall;
	difference() {
		union() {
			translate([x/2,y2])
			difference() {
				circle(d=x-wall*2);
				translate([-x/2,-x-pad])
				square([x,x]);
			}
			translate([wall,wall+fence_h])
			square([x-wall*2,y2-wall-fence_h]);
			*intersection() {
				translate([wall,wall])
				square([x-wall*2,y2-wall]);
				pattern();
			}
		}
		translate([0,fence_h])
		square([x,fence]);
		
		// middle piece
		//translate([x/2-fence/2,0])
		//square([fence,fence_h]);
	}
	intersection() {
		translate([pattern_wall,pattern_wall])
		square([x-pattern_wall*2,fence_h+fence-pattern_wall*2]);
		translate([box_x/2,(fence_h+fence)/2])
		pattern();
	}

}



spine=step_x/2+wood/2;
spine_gap=spine-wood*2;

module assembled() {
    color("cyan")
    wood()
    floor();

    color("cyan")
    translate([0,0,window])
    wood()
    roof();

    dirror_x(box_x)
    translate([wood,0])
    rotate([0,-90,0])
    wood()
    end();

    translate([0,box_y])
    rotate([90,0])
    wood()
    back();

    translate([0,wood])
    rotate([90,0])
    wood()
    front();

    translate([0,wood])
    rotate([90,0])
    wood()
    door();

    rotate([0,0,-90])
    translate([80,0])
    steps_assembled();

	color("blue")
	translate([0,0,wood])
	rotate([0,-pan_angle])
	wood()
	pan();

	color("blue")
	translate([0,0,window+wood])
	rotate([0,-pan_angle])
	wood()
	pan();
}

pan_angle=0;

steps_z=step_z*(steps-1);

step_angle=atan(step_x/step_z);
steps_z_inner=steps_z-step_x/2-wood/2-spine/sin(step_angle);

steps_back_pins=3;

//RENDER svg
module steps_back() {
	difference() {
		translate([wood,-spine_gap/2-wood])
		square([steps_z-wood*2,spine_gap+wood*2]);


		dirror_y()
		translate([wood,spine_gap/2+wood+pad])
		rotate([0,0,-90])
		negative_pins(steps_z-wood*2,wood+pad,z_pins,pintail_gap,0,pintail_ear);
	}
}

steps_back_inner_pins=2;

//RENDER svg
module steps_back_inner() {
	difference() {
		translate([wood,-spine_gap/2-wood])
		square([steps_z_inner-wood,spine_gap+wood*2]);
		dirror_y()
		translate([0,spine_gap/2+wood+pad])
		rotate([0,0,-90])
		negative_pins(steps_z_inner,wood+pad,steps_back_inner_pins,pintail_gap,0,pintail_ear);
	}
}

steps_front=step_z-step_x/2-wood/2;
steps_front_pins=1;

//RENDER svg
module steps_front() {
	difference() {
		translate([wood,-spine_gap/2-wood])
		square([steps_front-wood,spine_gap+wood*2]);
		dirror_y()
		translate([0,spine_gap/2+wood+pad])
		rotate([0,0,-90])
		negative_pins(steps_front,wood+pad,steps_front_pins,pintail_gap,0,pintail_ear);
	}
}

function c(x)=sqrt(x*x+x*x);
step_splash_x=c(step_x/2-wood/2);

//RENDER svg
module step_splash() {
	difference() {
		translate([0,-spine_gap/2-wood])
		square([step_splash_x,spine_gap+wood*2]);

		dirror_y()
		translate([0,spine_gap/2+wood+pad,0])
		rotate([0,0,-90])
		negative_pins(step_splash_x,wood+pad,step_pins,pintail_gap,0,pintail_ear);
	}
}

step_lower_splash_x=c(step_x/2-wood/2);

//RENDER svg
module step_lower_splash() {
	difference() {
		translate([0,-spine_gap/2-wood])
		square([c(step_x/2-wood/2),spine_gap+wood*2]);

		dirror_y()
		translate([0,spine_gap/2+wood+pad,0])
		rotate([0,0,-90])
		negative_pins(step_lower_splash_x,wood+pad,step_pins,pintail_gap,0,pintail_ear);
	}
}

module steps_assembled() {
	color("blue")
	translate([0,-spine_gap/2])
	dirror_y(spine_gap)
	rotate([90,0])
	wood()
	steps();

	color("cyan")
	translate([0,0,-wood])
	place_steps()
	wood()
	step_surface();

	color("cyan")
	wood()
	step_base();

	color("cyan")
	translate([step_x*(steps-2),0])
	wood()
	step_base();

	translate([wood,0])
	rotate([0,-90,0])
	wood()
	steps_back();

	translate([spine,0])
	rotate([0,-90,0])
	wood()
	steps_back_inner();

	translate([step_x*(steps-2)+spine,0])
	rotate([0,-90,0])
	wood()
	steps_front();

	//color("magenta")
	place_steps()
	translate([spine,0,steps_front-step_z])
	//translate([step_x*(steps-2)+spine,0,steps_front])
	rotate([0,-45,0])
	wood()
	step_splash();

	place_steps(2)
	translate([spine,0,steps_front-step_z])
	//translate([step_x*(steps-2)+spine,0,steps_front])
	rotate([0,90-step_angle,0])
	translate([0,0,-wood])
	wood()
	step_lower_splash();
}

//RENDER svg
module step_base() {
	difference() {
		translate([0,-step_y/2-step_overhang_y,0])
		square([spine,step_y+step_overhang_y*2]);
		dirror_y()
		translate([0,spine/2,0])
		dirror_y(-wood)
		rotate([0,0,-90])
		negative_tails(spine,wood+pad,step_pins,pintail_gap,0,pintail_ear);
	}
}

//RENDER svg
module step_side() {
	hull() {
		translate([-step_x/2,0])
		square([step_x,wood]);

		translate([-spine/2,0])
		square([spine,(step_x-spine)/2]);
	}
	
}

step_pins=1;

module steps_negative(i=(steps-1)) {
    if (i>0) {
	translate([step_x*i-step_x,step_z+pad])
	rotate([0,0,-90])
	negative_pins(step_x+step_overhang_x,wood+pad,step_pins,pintail_gap,0,pintail_ear);

	translate([step_x*i-wood,pad-wood])
	square([wood+pad,step_z]);
        translate([0,step_z])
        steps_negative(i-1);
    }
}

// RENDER svg
module steps() {
	module negative() {
		for(i=[1:1:steps-1])
		translate([step_x*(steps-1-i),step_z*i+pad])
		rotate([0,0,-90])
		negative_pins(step_x+step_overhang_x,wood+pad,step_pins,pintail_gap,0,pintail_ear);

		translate([-pad,wood])	
		negative_tails(steps_z-wood*2,wood+pad,z_pins,pintail_gap,0,pintail_ear);

		translate([spine+pad,0])
		mirror([1,0])
		negative_tails(steps_z_inner,wood+pad,steps_back_inner_pins,pintail_gap,0,pintail_ear);

		translate([step_x*(steps-2)+step_x/2+wood/2+pad,0])
		mirror([1,0])
		negative_tails(steps_front,wood+pad,steps_front_pins,pintail_gap,0,pintail_ear);

		for(i=[1:1:steps-1])
		translate([step_x*(steps-i),step_z*i+pad-wood])
		rotate([0,0,90+45])
		translate([-pad,0])
		negative_tails(step_splash_x,wood+pad,step_pins,pintail_gap,0,pintail_ear);

		for(i=[2:1:steps-1])
		translate([step_x*(steps-i)-step_x/2+wood/2,step_z*i-step_x/2-wood/2])
		rotate([0,0,-90-45])
		translate([-pad,0])
		negative_tails(step_lower_splash_x,wood+pad,step_pins,pintail_gap,0,pintail_ear);


		translate([0,-pad])
		mirror([0,1])
		rotate([0,0,-90])
		negative_pins(spine,wood+pad,step_pins,pintail_gap,0,pintail_ear);

		translate([step_x*2,-pad])
		mirror([0,1])
		rotate([0,0,-90])
		negative_pins(spine,wood+pad,step_pins,pintail_gap,0,pintail_ear);
	}
	difference() {
		translate([step_x*(steps-2),0])
		step_support();

		translate([0,step_z*(steps-1)])
		rotate([0,0,-atan(step_z/step_x)])
		translate([0,-spine*2])
		square([(step_x)*(steps-1),spine]);

		negative();
	}
	
	difference() {
		square([spine,step_z*(steps-1)]);
		negative();
	}

	difference() {
		intersection() {
			translate([0,step_z*(steps-1)])
			rotate([0,0,-atan(step_z/step_x)])
			translate([0,-spine])
			square([(step_x+step_z)*(steps-1),spine]);

			square([step_x*(steps-1),step_z*(steps-1)]);
		}
		translate([step_x*(steps-2)+spine,0])
		square([step_x-spine,step_z]);
		negative();
	}
}

module step_support(i=(steps-1)) {
    if (i>0) {
	//square([step_x,step_z]); 
	square([spine,step_z]);

	difference() {
		hull() {
			translate([0,step_z-wood])
			square([step_x,wood]);
			translate([0,step_z-step_x])
			square([wood,step_x]);
		}
	}

        translate([-step_x,step_z])
        step_support(i-1);
    }
}


module old_steps() {
	difference() {
		steps_positive();
		steps_negative();
	}
}

module steps_positive(i=(steps-1)) {
    if (i>0) {
	square([step_x*i,step_z]); 
        translate([0,step_z])
        steps_positive(i-1);
    }
}

module place_steps(start=1) {
    translate([step_x*(steps-1),0])
    for(i=[start:1:(steps-1)]) {
        translate([-step_x*i,0,step_z*i])
        children();
    }
}

//RENDER svg
module step_surface() {
	difference() {
		translate([0,-step_y/2-step_overhang_y])
		square([step_x+step_overhang_x,step_y+step_overhang_y*2]);

		dirror_y()
		translate([0,spine_gap/2+wood,0])
		rotate([0,0,-90])
		dirror_x(wood)
		negative_tails(step_x+step_overhang_x,wood+pad,step_pins,pintail_gap,0,pintail_ear);
	}
}

//RENDER svg
module step_face() {
	square([step_z,step_y]);
}
cutsheet_gap=100;

module cutsheet() {
	front();
	translate([0,box_z+cutsheet_gap])
	back();

	translate([box_x+cutsheet_gap,0]) {
		end();
		translate([0,box_y+cutsheet_gap])
		end();
		translate([box_z+cutsheet_gap,0]) {
			steps();
		}
	}
}

//cutsheet();
assembled();
