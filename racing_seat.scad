in=25.4;
wood=0.5*in;
pad=0.1;
//thickness below platform
base_z=50;

$fn=200;

//how much room for legs 
//space between frame rails 
legs_y=300;

seat_x=200;
seat_y=legs_y+wood*2;
seat=[seat_x,seat_y];
// height above patform
seat_z=30;

seat_angle=10;


// distance from front of seat to pedal board
legs_x=500;

// distance from platform to bottom of desk
legs_z=400;


// extra platform space outside of rail
rail_wall=50;

floor_gap=20;

platform_y=wood*2+legs_y+rail_wall*2;
platform_x=seat_x+legs_x+wood+rail_wall;
platform=[platform_x-floor_gap,platform_y];
platform_translate=[0,0,base_z];

seat_to_wheel_x=200;

desk_x=platform_x-seat_x-seat_to_wheel_x;
desk_y=platform_y;
desk=[desk_x,desk_y];
desk_z=base_z+wood+legs_z;
desk_translate=[seat_x+seat_to_wheel_x,0,desk_z];

pedal_x=legs_y;
pedal_y=200;
pedal=[pedal_x,pedal_y];
pedal_angle=15;

backboard_x=legs_y;
backboard_y=legs_z-pedal_y;
backboard=[backboard_x,backboard_y];
backboard_translate=[0,0,0];

cross_x=platform_x-desk_x/3-wood*2;
cross_y=legs_y-wood*2;
cross_diagonal=sqrt(cross_x*cross_x+cross_y*cross_y);
cross_angle=atan(cross_y/cross_x);

seat_translate=[0,platform_y/2-seat_y/2,base_z+wood+seat_z];

shifter_x=desk_x+60;
shifter_y=90;
shifter=[shifter_x,shifter_y];
shifter_z=desk_z-90;
shifter_translate=[platform_x-shifter_x,-shifter_y+rail_wall,shifter_z];

wheel=80;
wheel_h=30;
inner_wheel=wheel-floor_gap*2;
axle=20;

foot=50;

module wheel() {
    rotate([90,0,0])
    cylinder(d=wheel,h=wheel_h);
}

module wheels() {
    translate([platform_x-wheel/2,rail_wall,wheel/2])
    wheel();
    translate([platform_x-wheel/2,wheel_h+platform_y-rail_wall,wheel/2])
    wheel();
    translate([platform_x-wheel/2,0,wheel/2])
    rotate([-90,0,0])
    cylinder(d=axle,h=platform_y);
}

wheels();
module shifter() {
    square([shifter_x,shifter_y]);
}

module shifter_3d() {
    translate(shifter_translate)
    wood()
    shifter();
}


module cross() {
    square([cross_diagonal,base_z]);
}

module cross_top() {
    square([cross_diagonal,base_z]);
}

module cross_bottom() {
    square([cross_diagonal,base_z]);
}

module cross_3d() {
    translate([wood,rail_wall+wood*2])
    cross_box();
}

module cross_box() {
    rotate([0,0,cross_angle])
    translate([0,wood/2,0])
    rotate([90,0,0])
    wood()
    cross_top();

    translate([0,cross_y,0])
    rotate([0,0,-cross_angle])
    translate([0,wood/2,0])
    rotate([90,0,0])
    wood()
    cross_bottom();
}

module desk() {
    square(desk);
}

module wood() {
    linear_extrude(height=wood)
    children();
}

module desk_3d() {
    translate(desk_translate)
    wood()
    desk();
}

module platform() {
    difference() {
        square(platform);
        translate([platform_x-wheel,-pad])
        square([wheel+pad,rail_wall+pad]);
        translate([platform_x-wheel,platform_y-rail_wall])
        square([wheel+pad,rail_wall+pad]);
    }
}

module platform_3d() {
    translate(platform_translate)
    wood()
    platform();
}

module seat() {
    square(seat);
}

module seat_3d() {
    translate(seat_translate)
    wood()
    seat();
}

module pedal() {
    square(pedal);
}

module pedal_3d() {
    translate([platform_x-wood-rail_wall,platform_y/2-pedal_x/2,base_z+wood])
    rotate([0,-pedal_angle,0])
    rotate([0,90,0])
    rotate([0,0,90])
    wood()
    pedal();
}

module rail_max() {
    square([platform_x,desk_z]);
}

module seat_shadow() {
    translate([0,floor_gap])
    square([seat_x,base_z+wood+seat_z-floor_gap]);
}


module rail() {
    seat_shadow();
    difference() {
        translate([0,floor_gap])
        square([platform_x-floor_gap,desk_z-floor_gap]);
        translate([-desk_x,base_z])
        rail_max();
        translate([seat_x+seat_to_wheel_x,legs_z/2+base_z+wood])
        circle(d=legs_z);
        translate([platform_x-wheel/2,-pad])
        square([wheel/2+pad,wheel/2+pad]);
    }
    hull() {
        inner_wheel();
        rail_foot();
        base();
    }
    hull() {
        rail_backboard_foot();
        inner_wheel();
    }
}

module rail_backboard_foot() {
    translate([platform_x-floor_gap,foot_z])
   square([floor_gap,foot]); 
}

module base() {
    translate([0,floor_gap])
    square([platform_x-wheel/2,base_z-floor_gap]);
}

foot_x=seat_x/3-foot/2;
foot_z=desk_z-foot+wood;

module rail_foot() {
    translate([foot_x,0])
    square([foot,floor_gap]);
}

module inner_wheel() {
    translate([platform_x-wheel/2,wheel/2])
    circle(d=inner_wheel);
}

module foot() {
    square([foot,platform_y]);
}

module backboard_foot() {
    foot();
}

module backboard_foot_3d() {
    translate([platform_x,0,foot_z])
    rotate([0,-90,0])
    wood()
    backboard_foot();
}

module foot_3d() {
    translate([foot_x,0])
    wood()
    foot();
}

module rail_3d() {
    rail_3d_side();
    translate([0,legs_y+wood,0])
    rail_3d_side();
}

module rail_3d_side() {
    translate([0,wood+rail_wall,0])
    rotate([90,0,0])
    #wood()
    rail();
}

module backboard() {
    square(backboard);
}

module backboard_3d() {
    translate([platform_x-wood-rail_wall,platform_y/2-pedal_x/2,base_z+wood+pedal_y])
    rotate([0,90,0])
    rotate([0,0,90])
    wood()
    backboard();
}
module assembled() {
    desk_3d();
    platform_3d();
    seat_3d();
    pedal_3d();
    rail_3d();
    //backboard_3d();
    backboard_foot_3d();
    foot_3d();
    //shifter_3d();
    //cross_3d();
}

assembled();
