$fn=60;
bat_x=137;
bat_y=65;
bat_kerf=3;
bat_bot_x=bat_x-bat_kerf;
bat_bot_y=bat_y-bat_kerf;

top_x=85;

bat_z=91;
bat_head_z=15;
bat_base_z=bat_z-bat_head_z;

bar_d=20;
bar_r=bar_d/2;
bar_gap=87;

bat_wall=5;
bar_wall=7;

//how high above bar center point?
bat_raise=15;

pad=0.1;
padd=pad*2;

//gap left below bar between bottom/top
half_gap=3;
lid_gap=0.5;

//bars(bar_d);
//battery();

screw_d=5;
screw_r=screw_d/2;
screw_wall=4;
screw_wall_d=screw_d+screw_wall*2;
screw_wall_r=screw_r+screw_wall;
screw_count=3;

screw_head_d=12;
screw_head_h=4;
screw_loose_d=6.5;

//color("cyan") bottom_box();
top_box();


module top_box(){
    translate([bat_x/2-top_x/2,0,0])
    difference () {
        top_solid();
        translate([-pad,0,0])
        battery();
        bars();
        top_side_negative();
        mirror([0,1,0])
        top_side_negative();
        screws();
        mirror([0,1,0])
        screws();
    }
}

module top_side_negative() {
    translate([-pad,-bar_gap/2-bar_r,-bar_r-bar_wall-pad])
    cube([top_x+padd,bar_d+bar_wall,bar_r+bar_wall+pad]);
}

module top_side_positive() {
    translate([0,bar_gap/2+bar_r,-screw_wall_d-bar_r])
    cube([top_x,bar_wall,screw_wall_d+bar_r]);

    translate([0,bar_gap/2+bar_r+bar_wall/2,-bar_r-screw_wall_d])
    rotate([0,90,0])
    cylinder(d=bar_wall,h=top_x);
}

module top_solid() {
    hull() {
        minkowski() {
            translate([0,-bat_y/2,0])
            cube([top_x/2,bat_y,bat_raise]);
            rotate([0,90,0])
            cylinder(r=bat_wall,h=top_x/2);
        }
        bar(bar_d+bar_wall*2,top_x);
        mirror([0,1,0])
        bar(bar_d+bar_wall*2,top_x);
    }
    top_side_positive();
    mirror([0,1,0])
    top_side_positive();
}

module bottom_box() {
    difference() {
        minkowski() {
            battery();
            sphere(r=bat_wall);
        }
        cut_top();
        battery();
        bars();
    }
    bottom_side_with_screws();
    mirror([0,1,0])
    bottom_side_with_screws();
}

module bottom_side_with_screws() {
    translate([bat_x/2-top_x/2,0,0])
    difference() {
        bottom_side();
        screws();
        bars();
    }
}

module screws() {
    translate([top_x/screw_count/2,0,0])
    for(x=[0:top_x/screw_count:top_x-pad])
    screw(x);
}

module screw(x) {
    translate([x,bar_gap/2+bar_r+bar_wall+pad,-bar_r-screw_wall_r])
    rotate([90,0,0])
    cylinder(d=screw_d,h=bar_d+bar_wall*2+padd);

    translate([x,bar_gap/2+bar_r+bar_wall+pad,-bar_r-screw_wall_r])
    rotate([90,0,0])
    cylinder(d=screw_head_d,h=screw_head_h+pad);

    translate([x,bar_gap/2+bar_r+bar_wall+pad,-bar_r-screw_wall_r])
    rotate([90,0,0])
    cylinder(d=screw_loose_d,h=bar_wall+padd);
}

module bottom_side() {
    difference() {
        bar(bar_d+bar_wall*2,top_x);
        translate([-pad,0,0])
        bar(bar_d,top_x+padd);

        cut_top();
        //junt in case
        translate([-pad,0,0])
        battery();

        //slice off side
        //move in place
        translate([0,(bar_gap/2+bar_wall+bar_d-half_gap),0])
        //center, like a bar
        translate([-pad,-bar_r-bar_wall,-bar_r-bar_wall])
        cube([top_x+padd,bar_d+bar_wall*2,bar_d+bar_wall*2]);
    }
    difference() {
        hull() {
            translate([0,bar_gap/2+half_gap-bar_d,-bar_r-bar_wall])
            cube([top_x,bar_wall,bar_r+bar_wall]);
            bottom_side_for_hulls();
        }
        translate([-pad,0,0])
        battery();
    }
    difference() {
        hull() {
            translate([0,-bar_r-bar_wall+bar_gap/2,-screw_wall_d-bar_r])
            cube([top_x,bar_d+bar_wall-half_gap,screw_wall_d]);
            bottom_edge();
        }
        translate([-pad,0,0])
        battery();
    }
}

module bottom_side_for_hulls() {
    hull() {
        bottom_edge();
        translate([0,0,bat_z-bat_raise-bat_wall])
        bottom_edge();
    }
}

module bottom_edge() {
    translate([0,bat_y/2,-bat_z+bat_raise])
    rotate([0,90,0])
    cylinder(r=bat_wall,h=top_x);
}
module cut_top() {
    translate([-bat_wall*2,-bar_gap/2-bar_r-bar_wall*2,0])
    cube([bat_x+bat_wall*4,bar_gap+bar_d+bar_wall*4,bat_raise+bat_wall*4]);
}

module battery() {
    translate([0,-bat_y/2,-bat_z+bat_raise])
    cube([bat_x,bat_y,bat_z]);
}

module bars() {
    translate([-pad-bat_wall,0,0])
    bar(bar_d,bat_x+bat_wall*2+padd);
    mirror([0,1,0])
    translate([-pad-bat_wall,0,0])
    bar(bar_d,bat_x+bat_wall*2+padd);
}

module bar(d,h) {
    translate([0,bar_gap/2,0])
    rotate([0,90,0])
    cylinder(d=d,h=h);
}
