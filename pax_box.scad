in=25.4;

back_h=0.25*in;
depth=(22+11/16)*in+back_h;

height=(92+7/8)*in;
width=(19+5/8)*in;

wood=11/16*in;

side_h=wood;
bottom_h=wood;
top_h=wood;
shelf_h=wood;

pin=3*in;

tail=pin;

pintail_gap=0.05;

pintail=pin+tail+pintail_gap*2;

//$fn=90;

blind=1/8*in;

bit=0.25*in;
pad=0.1;


hole=1/8*in;

hole_d=0.25*in;

hole_gap=(19+7/8)*in/15;

rail_one=depth-1.0625*in;
rail_three=rail_one-20.5*in;
rail_two=rail_three+8.5*in;

bottom_shelf=(3+7/16)*in;

// https://www.amazon.com/gp/product/B01C91KTSU/ref=ppx_od_dt_b_asin_title_s00?ie=UTF8&psc=1

leveler_foot=1.5*in;
leveler_hole=2*in;
leveler_wall=0.25*in;

module hole() {
    circle(d=hole);
}

module rail(x) {
    for(y=[0:hole_gap:height]) {
        translate([x,y])
        hole();
    }
}

module rails() {
    rail(rail_one);
    rail(rail_two);
    rail(rail_three);
}



module pin_edge(pin_h, tail_h, edge) {
    intersection() {
        for(x=[0:pintail:edge]) {
            translate([x+edge%pintail/2-pin/2-pintail_gap/2,0])
            mouse_ears(pin+pintail_gap*2,tail_h);
        }

        // trim off extra mouse ears
        translate([pintail/4-pad,-bit/2])
        square([edge-pintail/2+pad*2,tail_h+bit]);
    }

    // ends
    translate([-pad,0])
    square([pintail/4+pad*2,tail_h]);
    translate([edge-pintail/4-pad,0])
    square([pintail/4+pad*2,tail_h]);
}

module shelf() {
    square([width-side_h*2,depth-back_h]);
}

module shelf_3d(z) {
    translate([side_h,0,z])
    linear_extrude(height=top_h)
    shelf();
}

module tail_edge(pin_h, tail_h, edge) {
    for(x=[0:pintail:edge-pintail]) {
        translate([x+tail/2+edge%pintail/2+pintail_gap/2,0])
        mouse_ears(pin+pintail_gap*2,pin_h);
    }
}


module side() { 
    square([depth,height]);
}

module side_cuts() {
    translate([0,bottom_h])
    mirror([0,1])
    tail_edge(bottom_h+pad,side_h+pad,depth);
    translate([0,height-top_h])
    tail_edge(top_h+pad,side_h+pad,depth);

    translate([back_h,0])
    rotate([0,0,90])
    tail_edge(back_h+pad,side_h+pad,height);
}

module top() {
    difference() {
        translate([blind,0])
        square([width-blind*2,depth]);
        translate([side_h,0])
        rotate([0,0,90])
        pin_edge(bottom_h+pad,side_h+pad,depth);
        translate([width-side_h,0])
        rotate([0,0,90])
        mirror([0,1])
        pin_edge(bottom_h+pad,side_h+pad,depth);

        translate([0,depth-back_h])
        tail_edge(back_h+pad,bottom_h+pad,width);
    }
}

module top_3d() {
    translate([0,0,height-top_h])
    linear_extrude(height=top_h)
    top();
}

module bottom() {
    difference() {
        translate([blind,0])
        square([width-blind*2,depth]);
        translate([side_h,0])
        rotate([0,0,90])
        pin_edge(bottom_h+pad,side_h+pad,depth);

        translate([width-side_h,0])
        rotate([0,0,90])
        mirror([0,1])
        pin_edge(bottom_h+pad,side_h+pad,depth);

        translate([0,depth-back_h])
        tail_edge(back_h+pad,bottom_h+pad,width);

        place_levelers()
        circle(d=leveler_hole);
    }
}

module bottom_3d() {
    linear_extrude(height=bottom_h)
    bottom();
}


module side_3d() {
    difference() {
        linear_extrude(height=side_h)
        side();
        translate([0,0,blind])
        linear_extrude(height=side_h)
        side_cuts();
        translate([0,0,wood-hole_d])
        linear_extrude(height=side_h)
        rails();
    }
}

module side_3d_placed() {
    translate([side_h,depth,0])
    rotate([0,0,-90])
    rotate([90,0,0])
    side_3d();
}

module sides_3d() {
    translate([side_h,0,0])
    mirror([1,0,0])
    side_3d_placed();
    translate([width-side_h,0])
    side_3d_placed();
}


module leveler() {
    cylinder(d=7/16*in,h=3*in);
    cylinder(d=leveler_foot,h=5/8*in);
}

module place_leveler_front_left() {
    translate([leveler_hole/2+side_h+leveler_wall,leveler_hole/2+leveler_wall])
    children();
}

module mirror_y() {
    children();
    translate([width,0])
    mirror([1,0])
    children();
}


module mirror_x() {
    children();
    translate([0,depth])
    mirror([0,1])
    children();
}

module place_leveler_left() {
   mirror_y()
   place_leveler_front_left() 
   children();
}

module place_levelers() {
    mirror_x()
    place_leveler_left()
    children();
}

leveler_min_height=5/8*in;

module assembled() {
    color("red")
    sides_3d();
    color("blue")
    top_3d();
    color("blue")
    bottom_3d();

    color("green")
    back_3d();

    color("grey")
    shelf_3d(bottom_shelf-shelf_h);
    shelf_3d(leveler_min_height+shelf_h);
    place_levelers()
    #leveler();
}

module back() {
    difference() {
        translate([blind,0])
        square([width-blind*2,height]);

        // bottom
        translate([0,bottom_h,0])
        mirror([0,1,0])
        pin_edge(back_h+pad,bottom_h+pad,width);

        // top
        translate([0,-top_h,0])
        translate([0,height])
        pin_edge(back_h+pad,top_h+pad,width);

        //left
        translate([side_h,0])
        rotate([0,0,90])
        pin_edge(back_h+pad,side_h+pad,height);

        //right
        translate([width-side_h,0])
        mirror([1])
        rotate([0,0,90])
        pin_edge(back_h+pad,side_h+pad,height);
    }
}

module back_3d() {
    translate([0,depth,0])
    rotate([90,0,0])
    linear_extrude(height=back_h)
    back();
}


module mouse_ear() {
    translate([0,bit/2])
    circle(d=bit);
}

module mouse_ears(x,y) {
    square([x,y]);
    translate([x,0])
    rotate([0,0,45])
    mouse_ear();
    rotate([0,0,-45])
    mouse_ear();
}

module flat() {
    side();
    translate([0,-depth*1.1])
    top();
    translate([0,-depth*2.2])
    bottom();
}

//back();
//flat();

assembled();
//side_3d();

//bottom();
//top();


