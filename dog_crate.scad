in=25.4;
wood=in/2;
$fn=200;

use <joints.scad>;

pan_x=30*in;
pan_y=18*in;
pan_z=30;

pan_gap=10;

window=500;

top_lip=40;


box_x=pan_x+wood*2+pan_gap*2;
box_y=pan_y+wood*2+pan_gap*2;
box_z=window+top_lip;

steps=5;
step_ratio=1.5;

step_z=box_z/(steps*2-1)*2;
step_x=step_z*step_ratio;
step_y=box_y/2;

step_overhang_x=wood;
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

x_pins=4;
y_pins=3;
z_pins=3;
bit=in/4;
pintail_ear=bit;
pintail_holes=bit;
pintail_gap=in/8;
pad=0.1;

module floor() {
	difference() {
		square([box_x,box_y]);

		dirror_y(box_y)
		translate([box_x,-pad])
		rotate([0,0,90])
		negative_pins(box_x,wood+pad,x_pins,pintail_gap,0,pintail_ear);

		dirror_x(box_x)
		translate([-pad,0])
		negative_pins(box_y,wood+pad,y_pins,pintail_gap,0,pintail_ear);
		
	}
}

module roof() {
    //square([box_x,box_y]);
	floor();
}

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
	}
}


module back() {

	module edge() {
		negative_tails(box_x,wood,x_pins,pintail_gap,pintail_holes,pintail_ear);
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
    }
}

brick_z_lines=z_pins*2+1;
brick_y=box_z/brick_z_lines;
brick_x=brick_y*2.5;

module front_etching() {
	for(z=[brick_y:brick_y:box_z-1])
	translate([-pad,-line/2+z])
	square([box_x+pad*2,line]);

	for(z=[brick_y:brick_y*2:box_z-1])
	translate([box_x/2-(box_x+brick_x)/2,0])
	for(x=[0:brick_x:box_x+brick_x])
	translate([x,z])
	square([line,brick_y]);

	for(z=[0:brick_y*2:box_z-1])
	translate([box_x/2-(box_x+brick_x)/2,0])
	for(x=[0:brick_x:box_x+brick_x])
	translate([x+brick_x/2,z])
	square([line,brick_y]);

}


module front() {
    difference() {
        back();
        place_door()
        offset(door_gap)
        door_profile();
    }
}

door_y=box_z*0.7;
door_x=door_y*0.7;
door_lip=wood*2;
door_gap=in/8;
step_display_gap=30;
door_window=door_x*0.6;
door_window_line=wood;

module place_door() {
    translate([box_x/2-door_x/2,door_lip])
    children();
}

etching=in/8;
line=bit;
door_plank=(door_x+line)/7;
window_trim=wood;

module door_etching() {
	difference() {
		for(x=[0:door_plank:door_x+door_plank])
		translate([x-line,0])
		square([line,door_y]);
		translate([door_x/2,door_y-door_x/2])
		circle(d=door_window+window_trim*2);
	}
	translate([door_x/2,door_y-door_x/2])
	difference() {
		circle(d=door_window+window_trim*2);
		if(0)
		circle(d=door_window+window_trim*2);
	}

}

module door() {
    difference() {
        door_profile();
        translate([door_x/2,door_y-door_x/2])
        difference() {
            circle(d=door_window);
            square([door_window,door_window_line],center=true);
            rotate([0,0,90])
            square([door_window,door_window_line],center=true);
        }
    }
}


module door_profile() {
    translate([door_x/2,door_y-door_x/2])
    circle(d=door_x);
    square([door_x,door_y-door_x/2]);
}


module assembled() {
    color("lime")
    wood()
    floor();

    color("lime")
    translate([0,0,window])
    wood()
    roof();

    color("red")
    dirror_x(box_x)
    translate([wood,0])
    rotate([0,-90,0])
    wood()
    end();

    color("magenta")
    translate([0,box_y])
    rotate([90,0])
    wood()
    back();

    //color("blue")
    translate([0,wood])
    rotate([90,0])
	difference() {
    wood()
    front();
	translate([0,0,wood-etching])
	wood()
	front_etching();
	}

    translate([box_x+step_display_gap,box_y-step_y]) {
        color("blue")
        dirror_y(step_y)
        translate([0,wood])
        rotate([90,0])
        wood()
        steps();
        
        color("lime")
        place_steps()
        translate([0,-step_overhang_y,-wood])
        wood()
        step_surface();

        color("red")
        place_steps()
        translate([step_x-wood,0,-wood])
	rotate([0,90,0])
        wood()
        step_face();


    }

    //color("cyan")
    translate([0,wood])
    rotate([90,0])
    place_door()
	difference() {
	    wood()
	    door();
		translate([0,0,wood-etching])
		wood()
		door_etching();
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

module steps() {
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

module place_steps() {
    translate([step_x*(steps-1),0])
    for(i=[1:1:(steps-1)]) {
        translate([-step_x*i,0,step_z*i])
        children();
    }
}

module step_surface() {
	difference() {
		square([step_x+step_overhang_x,step_y+step_overhang_y*2]);

		translate([0,step_overhang_y])
		dirror_y(step_y)
		translate([0,wood])
		rotate([0,0,-90])
		dirror_x(wood)
		negative_tails(step_x+step_overhang_x,wood+pad,step_pins,pintail_gap,0,pintail_ear);
	}
}

module step_face() {
	square([step_z,step_y]);
}

assembled();
