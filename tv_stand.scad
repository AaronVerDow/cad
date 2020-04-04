in=25.4;
tv_x=200;
tv_y=200;
tv_wall=1*in;

stand_x=100;
stand_y=430;

base_x=700;
base_y=500;

base_wood=17;

base_r=base_wood/2;

base_screw_wall=1*in;

bit=0.25*in;
cut_gap=bit*3;


base_screw=0.25*in;
tv_screw=0.25*in;
tv_screw_pocket=1*in;
washers=8;

module tv_placement() {
    translate([-tv_x/2,stand_y])
    mirror_y(tv_y)
    mirror_x(tv_x)
    children();
}

module washer_placement() {
    translate([tv_x/2+tv_screw/2+tv_wall*2+cut_gap*2,stand_y+tv_y])
    rotate([0,0,20])
    for(y=[0:1:washers-1])
    translate([0,-(tv_wall*2+tv_screw+cut_gap)*y])
    children();
}

module tv() {
    hull() {
        tv_placement()
        circle(d=tv_wall*2+tv_screw);
    }
}

module mirror_y(y=0) {
    children();
    translate([0,y])
    mirror([0,1])
    children();
}

module mirror_x(x=0) {
    children();
    translate([x,0])
    mirror([1,0])
    children();
}



module base() {
    hull() {
        mirror_x()
        translate([-base_x/2,-base_r/2])
        circle(d=base_r*2);
        translate([0,-base_y+base_r/2])
        circle(d=base_r*2);
    }
}


module outside_profile() {
    hull() {
        base();
        tv();
    }
    washer_placement()
    circle(d=tv_wall*2+tv_screw);
    translate([0,0,1])
    children();
}

base_x_screws=5;
base_y_screws=4;
base_screw_pocket=0.5*in;


outside_profile()
pocket()
drill();

module pocket() {
    color("lime") {
        tv_placement()
        circle(d=tv_screw_pocket);
        place_base_screws()
        circle(d=base_screw_pocket);
    }
    translate([0,0,1])
    children();
}

module drill() {
    color("blue") {
        tv_placement()
        circle(d=tv_screw);
        place_base_screws()
        circle(d=base_screw);
        washer_placement()
        circle(d=tv_screw);
    }
    translate([0,0,1])
    children();
}

module place_base_screws() {

    for(x=[0:(base_x-base_screw_wall*2)/(base_x_screws-1):base_x-base_screw_wall*2])
    translate([x-base_x/2+base_screw_wall,-base_r/2])
    children();

    for(y=[0:(base_y-base_screw_wall)/(base_y_screws-1):base_y-base_screw_wall])
    translate([0,-y-base_r/2])
    children();
}
