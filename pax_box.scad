in=2.54;

depth=29*in;
height=71*in;
width=47*in;

wood=0.75*in;

side_h=wood;
bottom_h=wood;
top_h=wood;
back_h=0.5*in;
shelf_h=wood;

pin=3*in;

tail=pin;

pintail_gap=0.05;

pintail=pin+tail+pintail_gap*2;

//$fn=90;

blind=1/8*in;

bit=0.25*in;
pad=0.1;




module pin_edge(pin_h, tail_h, edge) {
    intersection() {
        for(x=[0:pintail:edge]) {
            translate([x+edge%pintail/2-pin/2-pintail_gap/2,0])
            mouse_ears(pin+pintail_gap*2,tail_h);
        }

        // trim off extra mouse ears
        translate([pintail/2-pad,-bit/2])
        square([edge-pintail+pad*2,tail_h+bit]);
    }

    // ends
    translate([-pad,0])
    square([pintail/2+pad*2,tail_h]);
    translate([edge-pintail/2-pad,0])
    square([pintail/2+pad*2,tail_h]);
}

module shelf() {
    square([width-side_h*2,depth-back_h]);
}

module shelf_3d() {
    translate([side_h,0,height/3])
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



module assembled() {
    color("red")
    sides_3d();
    color("blue")
    top_3d();
    color("blue")
    bottom_3d();

    color("lime")
    back_3d();

    color("grey")
    shelf_3d();
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

//bottom();
//top();


