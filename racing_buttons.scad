estop_hole=22.5;
estop_gap=30;

arcade_hole=28;
arcade_gap=35/2;
arcade_stack=arcade_gap*2+5;

toggle_hole=12.5;
// more than needed
toggle_gap=15;

//max_x=estop_gap*2+arcade_gap*2+toggle_gap*2;
max_x=145;
max_y=84;

gaps=0;

face_h=3;
base_h=2;
support_h=3;

screw_offset=6;

flat_small=16.5;
flat_big=19.5;
flat_gap=35;


estop_behind=40+face_h;
depth=max_y*1.5;

$fn=90;

pad=0.1;

module assembled() {
    difference() {
        union() {
            place_face()
            linear_extrude(height=face_h)
            square([max_x,max_y],center=true);

            translate([-max_x/2,0,-base_h])
            cube([max_x,depth,base_h]);

            support();

            translate([-max_x/2,depth-support_h])
            rotate([-90,0])
            linear_extrude(height=support_h)
            hull() {
                square([support_h,max_y]);
                square([max_x,base_h]);
            }

            translate([-max_x/2,0,-max_y])
            cube([support_h,depth,max_y]);
            
        }

        difference() {
            translate([-max_x/2+screw_offset+support_h,screw_offset+support_h,-base_h-pad])
            cube([max_x-screw_offset*2-support_h*2,depth-screw_offset*2-support_h*2,base_h+pad*2]);
            place_screws()
            cylinder(r=screw_offset,h=base_h+pad*4);
        }

        place_face()
        translate([0,0,-pad])
        linear_extrude(height=face_h+pad*2)
        buttons();

        translate([-max_x/2-pad,0,-max_y/2])
        rotate([90,0,90]) {
            translate([estop_behind,0])
            linear_extrude(height=support_h+pad*2)
            stacked_arcade()
            translate([arcade_stack-arcade_gap*2,0])
            stacked_arcade();

            translate([estop_behind/2,-flat_gap/2])
            cylinder(d=flat_small,h=support_h+pad*2);

            translate([estop_behind/2,flat_gap/2])
            cylinder(d=flat_big,h=support_h+pad*2);
        }
        
        //holes();

        screws();

    }
}


screw=4.5;

module place_screws() {
    translate([0,depth/2])
    dirror_x()
    dirror_y()
    translate([max_x/2-support_h-screw_offset,(depth-face_h-support_h)/2-screw_offset,-base_h-pad])
    children();
}

module screws() {
    place_screws()
    cylinder(d=screw,h=base_h+pad*2);
}


assembled();

module support() {
    mirror([1,0])
    translate([-max_x/2,0])
    rotate([0,90,0])
    linear_extrude(height=support_h)
    hull() {
        square([base_h,depth]);
        square([max_y,face_h]);
    }
}



module holes() {
    place_face()
    mirror([0,0,1])
    linear_extrude(height=depth-face_h)
    buttons(1);
}

module place_face() {
    rotate([90,0])
    translate([0,-max_y/2,-face_h])
    children();
}

module gap(gap) {
    circle(r=gap);
}

module estop(gap=0) {
    translate([estop_gap,0]) {
        circle(d=estop_hole);
        if(gap)gap(estop_gap);
    }


    translate([estop_gap*2,0])
    children();
}

module dirror_x(x=0) {
    children();
    translate([x,0])
    mirror([1,0])
    children();
}



module dirror_y(y=0) {
    children();
    translate([0,y])
    mirror([0,1])
    children();
}

module arcade(gap=0) {
    translate([arcade_gap,0]) {
        circle(d=arcade_hole);
        if(gap)gap(arcade_gap);
    }

    translate([arcade_gap*2,0])
    children();
}


module stacked_arcade(gap=0) {
    dirror_y()
    translate([arcade_gap,arcade_stack/2]) {
        circle(d=arcade_hole);
        if(gap)gap(arcade_gap);
    }

    translate([arcade_gap*2,0])
    children();
}

module toggle(gap=0) {
    translate([toggle_gap,0]) {
        circle(d=toggle_hole);
        if(gap)gap(toggle_gap);
    }
    translate([toggle_gap*2,0])
    children();
}


module buttons(gap=0) {
    translate([-estop_gap-arcade_gap-toggle_gap,0])
    estop(gap)
    stacked_arcade(gap)
    toggle(gap);
}
