use <joints.scad>;
in=25.4;
ft=in*12;
plywood_x=8*ft;
plywood_y=4*ft;
// used for preview
plywood_z=3*in;

wheel_x=5.5*in;
wheel_y=2*in;
wheel_z=5.5*in;

wheel_x=150;
wheel_y=70;
wheel_z=127;

// how high does the lever go
wheel_open_min=65;
wheel_open_max=95;

// how much do the wheels lift
wheel_locked=150-wheel_z;

wheel_fudge=3*in;

wood=0.75*in;

spine_x=4*in;
spine_y=plywood_y-ft*1.5;
rest=8.5*in;

angle=20;

wheelbase_x=4*ft;
wheelbase_y=1.5*ft;

bar_wall=spine_x;

peak_x=(spine_y*sin(angle))+(spine_x*cos(angle));
peak_y=(spine_y*cos(angle))-(spine_x*sin(angle));
back_angle=atan((wheelbase_y-peak_x)/(peak_y+rest));

bar_angle=angle;
bar_h=rest*1.5;

$fn=90;

back_fillet_x=spine_x*1.5;
back_fillet_y=spine_x;

wing_inset=bar_wall*2+ft;
bit=0.25*in;
gap=bit/4;
joint_hole=0;
ear=bit;
spine_back_pins=4;


module back_fillet() {
    difference() {
        hull() {
            translate([-back_fillet_x/2,wood/2])
            square([back_fillet_x,wood],center=true);
            translate([-1,0])
            square([1,back_fillet_y]);
        }
        dirror_x()
        rotate([0,0,90])
        negative_pins(back_fillet_x,wood,1,gap,joint_hole,ear);

        square([wood*2,wood*2],center=true);

        //translate([0,spine_x]) mirror([0,1,0]) dirror_x() negative_slot((spine_x-wood)/2,wood/2+gap/2,ear);
    }
}

module wood() {
    linear_extrude(height=wood)
    children();
}

module rest() {
    difference() {
        hull() {
            translate([rest/2,wood/2])
            square([rest+wood,wood],center=true);

            translate([-wood/2,0])
            square([wood,rest+wood]);
        }
        translate([-wood/2,0])
        dirror_x(wood)
        negative_tails(rest+wood,wood+gap,1,gap,joint_hole,ear);
    }
}

outer_edge=6*in;
top_edge=6*in;

module back() {
    difference() {
        square([plywood_x,plywood_y]);
         
        dirror_x(plywood_x)
        translate([plywood_x-outer_edge,(plywood_y-spine_y-rest)/2])
        rotate([0,0,angle])
        side();


        translate([0,-bar_wall])
        wings_cutsheet();

        translate([plywood_x/2,plywood_y-top_edge])
        //rotate([0,0,back_angle+angle-13])
        bar();

        
        dirror_x(plywood_x)
        translate([outer_edge+spine_x,plywood_y/2-rest-in])
        rotate([0,0,-90])
        back_fillet();

        dirror_x(plywood_x)
        translate([plywood_x-outer_edge-spine_x*2,plywood_y/2])
        mirror([0,1])
        rotate([0,0,-90])
        back_fillet();

        dirror_x(plywood_x)
        translate([(plywood_x-wheelbase_x)/2,0])
        dirror_x(wood)
        negative_tails(spine_y,wood+gap,spine_back_pins,gap,joint_hole,ear);

        dirror_x(plywood_x)
        translate([plywood_x/2-wheelbase_x/2+wood/2,0,0])
        dirror_y(spine_y)
        translate([0,spine_y/8])
        rotate([0,0,90])
        dirror_x(wood)
        negative_tails(back_fillet_x,wood+gap,1,gap,joint_hole,ear);

        //translate([0,plywood_y/3*2])
        dirror_x(plywood_x)
        translate([outer_edge+rest+spine_x,plywood_y/2+rest])
        rotate([0,0,180-45])
        rest();
    }
}

module bar() {
    difference() {
        union() {
            square([wheelbase_x,bar_wall],center=true);
            dirror_x()
            translate([wheelbase_x/2,0])
            circle(d=bar_wall);
        }

        dirror_x()
        translate([wheelbase_x/2-wood/2,-bar_wall/2])
        dirror_x()
        negative_slot(bar_wall/2,wood/2+gap/2,ear);
    }   
}

module wings_cutsheet() {
    wing_cutsheet();
    translate([plywood_x,plywood_y])
    mirror([0,1,0])
    mirror([1,0,0])
    wing_cutsheet();
}

module wing_cutsheet() {
    translate([plywood_x/2+spine_y/2+1*in,plywood_y/2-5*in])
    rotate([0,0,90-back_angle])
    wing();
}

//translate([0,-wheelbase_y*2,0])assembled(25,98,true);

assembled(0);

cg=40;
module cg(tilt) {
    translate([0,0,rest])
    rotate([90-angle+tilt,0,0])
    translate([0,0,-wood])
    translate([plywood_x/2,plywood_y/2,rest/2])
    sphere(d=cg);
}

module assembled(tilt=0,wing_tilt=0,bar_stored=false) {
    color("lime")
    translate([0,0,rest])
    rotate([90-angle+tilt,0,0])
    translate([0,0,-wood])
    wood()
    back();

    //color("white") cg(tilt);
    color("white")
    projection(cut=false)
    cg(tilt);

    color("indigo")
    if(bar_stored) {
        translate([0,0,rest])
        rotate([90-angle+tilt,0,0])
        translate([plywood_x/2,spine_y-bar_wall/2,-wood*2])
        wood()
        bar();
    } else {
        translate([0,wheelbase_y])
        rotate([back_angle,0,0])
        translate([0,0,bar_h])
        rotate([0,0])
        translate([plywood_x/2,-bar_wall/2,-wood/2])
        wood()
        bar();
    }

    translate([0,0,rest])
    rotate([tilt,0])
    translate([0,0,-rest])
    dirror_x(plywood_x)
    translate([plywood_x/2-wheelbase_x/2,0])
    rotate([90,0,90]) {
        color("magenta")
        wood()
        side();

        color("blue")
        translate([spine_x/2,0,wood])
        rotate([0,0,-angle])
        rotate([0,-wing_tilt,0])
        rotate([0,0,angle])
        translate([-spine_x/2,0,-wood])
        wood()
        wing();
    }

    color("red")
    dirror_x(plywood_x)
    translate([plywood_x/2-wheelbase_x/2+wood/2,0,rest])
    rotate([-angle+tilt,0,0])
    translate([0,wood])
    rotate([180,0,0])
    wood()
    rest();

    color("brown")
    dirror_x(plywood_x)
    translate([plywood_x/2-wheelbase_x/2+wood/2,0,rest])
    rotate([-angle+tilt,0,0])
    dirror_z(spine_y)
    translate([0,0,spine_y/8])
    wood()
    back_fillet();

    //wheels();
}

module wheels() {
    translate([0,-wheel_fudge])
    dirror_x(plywood_x)
    dirror_y(wheelbase_y-wheel_y+wheel_fudge)
    translate([plywood_x/2-wheelbase_x/2-wheel_x,-wheel_y/2,]) {

        color("orangered")
        translate([0,0,-wheel_locked])
        cube([wheel_x,wheel_y,wheel_locked]);

        color("orange")
        cube([wheel_x,wheel_y,wheel_z]);

        color("yellow")
        translate([0,0,wheel_z])
        cube([wheel_x,wheel_y,wheel_open_min]);

        color("khaki")
        translate([0,0,wheel_z+wheel_open_min])
        cube([wheel_x,wheel_y,wheel_open_max]);
    }
}

module dirror_z(z=0) {
    children();
    translate([0,0,z])
    mirror([0,0,1])
    children();
}

module side() {
    translate([0,rest])
    rotate([0,0,-angle])
    difference() {
        side_positive();
        translate([-rest*2,0])
        square([rest*2,spine_y]);

        translate([wood,0])
        mirror([0,1])
        rotate([0,0,90])
        negative_pins(rest+wood,wood,1,gap,joint_hole,ear);

        negative_pins(spine_y,wood,spine_back_pins,gap,joint_hole,ear);

        //translate([wood,spine_y]) mirror([0,1]) negative_slot(bar_wall/2,wood+gap,ear);
        
    }
}

module side_positive() {
    square([spine_x,spine_y]);
    intersection() {
        circle(d=rest*2,$fn=200);
        translate([-rest+spine_x,0])
        square([rest*2,rest*2],center=true);
    }
}

module wing() {
    difference() {
        translate([0,rest])
        rotate([0,0,-angle])
        translate([spine_x,-rest])
        square([wheelbase_y,plywood_y+rest]);


        // back
        translate([wheelbase_y,0])
        rotate([0,0,back_angle])
        translate([0,-rest])
        square([wheelbase_y*2,plywood_y*2]);

        // trim bottom
        translate([0,-wheelbase_y*2])
        square([wheelbase_y*2,wheelbase_y*2]);

        translate([wheelbase_y,0])
        rotate([0,0,back_angle])
        translate([0,bar_h])
        rotate([0,0,90])
        dirror_x()
        negative_slot(bar_wall/2,wood/2+gap/2,ear);
    }
}

