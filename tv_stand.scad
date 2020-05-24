in=25.4;
tv_x=200;
tv_y=200;
tv_wall=1*in;

pad=0.1;

stand_x=100;
stand_y=430;

base_x=700;
base_y=500;

base_wood=17;

base_r=base_wood/2;

base_screw_wall=1*in;

bit=0.251*in;
cut_gap=bit*3;


base_screw=bit;
tv_screw=bit;
tv_screw_pocket=1*in;
washers=8;

base_x_screws=5;
base_y_screws=4;
base_screw_pocket=1*in;

pocket=0.25*in;

module pocket_extrude() {
    translate([0,0,base_wood-pocket])
    linear_extrude(height=pocket+pad)
    children();
}



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

module plywood() {
    translate([0,0,-1])
    #square([4*12*in,4*12*in],center=true);
}

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

module wood(padding=0) {
    translate([0,0,-padding])
    linear_extrude(height=base_wood+padding*2)
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


module place() {
    translate([-270,-50])
    rotate([0,0,-20])
    children();
}

module anchor() {
    translate([-2*12*in,2*12*in])
    circle(d=bit);
};

anchor();

module assembled() { // tv_stand_.scad.assembled.scad
    plywood();
    place()
    outside_profile()
    pocket()
    drill();
}

display="";
if(display=="") assembled();
if(display=="tv_stand_outside_profile.svg") place() outside_profile();
if(display=="tv_stand_pocket.svg") place() pocket();
if(display=="tv_stand_inside_profile.svg") place() drill();
