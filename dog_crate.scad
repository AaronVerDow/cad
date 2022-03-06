pan_x=1000;
pan_y=600;
pan_z=30;


pan_gap=10;

window=500;

top_lip=40;

in=25.4;
wood=in/2;
$fn=200;

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

module floor() {
    square([box_x,box_y]);
}

module roof() {
    square([box_x,box_y]);
}


module end() {
    square([box_z,box_y]);
}

module back() {
    difference() {
        square([box_x,box_z]);
    }
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

    color("blue")
    translate([0,wood])
    rotate([90,0])
    wood()
    front();

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
    }

    color("cyan")
    translate([0,wood])
    rotate([90,0])
    wood()
    place_door()
    door();
}

module steps(i=(steps-1)) {
    if (i>0) {
        square([step_x*i,step_z]); 
        translate([0,step_z])
        steps(i-1);
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
    square([step_x+step_overhang_x,step_y+step_overhang_y*2]);
}

assembled();
