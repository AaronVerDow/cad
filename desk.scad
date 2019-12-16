in=25.4; // convert to mm
top_y=24*in;


three_quarter_wood=0.75*in; // actual plywood thicknesses will vary
half_wood=0.5*in;
quarter_wood=0.25*in;

top_wood=three_quarter_wood;
leg_wood=half_wood;
rack_base_wood=half_wood;
rack_top_wood=half_wood;
back_wood=quarter_wood;
front_wood=quarter_wood;

leg_wire_r=1*in;
leg_wall=1.5*in;
leg_wire=4*in;

// rack_standards
// https://en.wikipedia.org/wiki/19-inch_rack#/media/File:Server_rack_rail_dimensions.svg
u=1.75*in;
u_hole_gap=0.625*in;
rack=19*in; // outer
rack_inner=17.75*in;

cubby=3*in;

height=rack+rack_base_wood+top_wood+rack_top_wood+cubby;
top_u_h=height-top_wood-u;

pad=0.1;

end_u_depth=26*in;

legroom=24*in;
foot=4*in; //?
top_x=legroom+8*u+leg_wood*4+foot*2;

echo("height");
echo(height/in);

echo("top_x");
echo(top_x/in);

echo("base x");
echo(legroom/in);

back_wall=2*in;
front_wall=-6*in;


top_wire=2*in;
top_wire_lip=5;


// https://www.imovr.com/imovr-vigor-diy-standing-desk-base.html
base_min_x=46.6*in;
base_max_x=75.4*in;
base_y=22.8*in;
base_min_z=23.9*in;
base_max_z=49.5*in;
base_channel_y=5*in;
base_channel_z=2*in;
base_channel_from_back=5*in;

cubby_wall=0.5*in;

pin=2*in;
tail=pin;
pintail_gap=0.05;
pintail=pin+tail+pintail_gap*2;
bit=0.25*in;


module base_side() {
    cube([foot,base_y,base_min_z]);
}

module base() {
    translate([0,top_y-base_y-back_wood,-base_min_z+rack_base_wood+rack+rack_top_wood+cubby]) {
        base_side();
        translate([top_x-foot,0])
        base_side();
        translate([0,base_y-base_channel_y-base_channel_from_back,base_min_z-base_channel_z])
        cube([top_x,base_channel_y,base_channel_z]);
    }
}



module u(slots, depth) {
    cube([rack,depth,u*slots]);
}

module top_wire_placement(y) {
    translate([foot+leg_wood+2*u,y])
    children();
}

module top_wire_placements() {
    y=top_y-top_wire;
    top_wire_placement(y)
    children();
    translate([top_x,0])
    mirror([1,0])
    top_wire_placement(y)
    children();
    translate([top_x/2,y])
    children();
}

module top_wire_profile() {
    circle(d=top_wire);
}

module top_wire_pocket() {
    circle(d=top_wire+top_wire_lip*2);
}

module top_pins_one(x) {
    translate([x,0])
    difference() { 
        rotate([0,0,90])
        tail_holes(top_wood,leg_wood,top_y);
        translate([-leg_wood*1.5,top_y-base_channel_y-base_channel_from_back])
        square([leg_wood*2,base_channel_y]);
    }
}

module top_pins_side() {
    top_pins_one(foot+leg_wood);
    top_pins_one(foot+leg_wood*2+4*u);
}

module top_pins() {
    top_pins_side();
    translate([top_x,0,0])
    mirror([1,0,0])
    top_pins_side();
}

module top() {
    difference() {
        square([top_x,top_y]);
        top_wire_placements()
        top_wire_profile();
        top_pins();
    }
}

module top_3d() {
    difference() {
        linear_extrude(height=top_wood)
        top();
        translate([0,0,top_wood-top_wire_lip])
        linear_extrude(height=top_wood)
        top_wire_placements()
        top_wire_pocket();
    }
}

module top_assembled() {
    translate([0,0,height-top_wood])
    top_3d();
}

module leg_wires() {
    wire_corners(rack, top_y, leg_wall, leg_wire);
    circle(d=rack-leg_wall*2);
}

module cubby_hole() {
    translate([height-top_wood-cubby/2,(cubby-cubby_wall*2)/2+front_wood+cubby_wall])
    circle(d=cubby-cubby_wall*2);
}

module cubby_holes() {
    cubby_hole();
    translate([0,top_y])
    mirror([0,1])
    cubby_hole();
}


module wire_corners(x,y,wall,open) {
    difference () {
        inx=x-wall*2;
        iny=y-wall*2;
        square([inx,iny],center=true);
        to_corner=sqrt(inx*inx+iny*iny);
        circle(d=to_corner-open);
    }
}

module leg() {
    difference() {
        square([height,top_y]);
        translate([height-rack/2-top_wood-cubby-rack_top_wood,top_y/2])
        leg_wires();

        translate([height-top_wood-base_channel_z,top_y-base_channel_y-base_channel_from_back])
        square([base_channel_z+top_wood+pad,base_channel_y]);

        // bottom box joint
        translate([rack_base_wood,0])
        rotate([0,0,90])
        tail_edge(leg_wood,rack_base_wood+pad,top_y);

        // middle box joint
        translate([rack_base_wood+rack+rack_top_wood,0])
        rotate([0,0,90])
        tail_holes(leg_wood,rack_top_wood,top_y);

        translate([height-top_wood,0])
        mirror([1,0])
        rotate([0,0,90])
        pin_edge(leg_wood,top_wood+pad,top_y);
    }
}

module outer_leg() {
    difference() {
        leg();
    }
}

module inner_leg() {
    difference() {
        leg();
        cubby_holes();
    }
}


module inner_leg_3d() {
    linear_extrude(height=leg_wood)
    inner_leg();
}

module outer_leg_3d() {
    linear_extrude(height=leg_wood)
    outer_leg();
}


module inner_leg_assembled() {
    translate([leg_wood*2+u*4+foot,0,0])
    rotate([0,-90,0])
    inner_leg_3d();
}

module outer_leg_assembled() {
    translate([leg_wood+foot,0,0])
    rotate([0,-90,0])
    outer_leg_3d();
}

module inner_legs_assembled() {
    inner_leg_assembled();
    translate([top_x,0,0])
    mirror([1,0,0])
    inner_leg_assembled();
}

module outer_legs_assembled() {
    outer_leg_assembled();
    translate([top_x,0,0])
    mirror([1,0,0])
    outer_leg_assembled();
}

module rack_top() {
    rack_base();
}

module rack_top_3d() {
    linear_extrude(height=rack_top_wood)
    rack_top();
}

module rack_top_assembled() {
    translate([foot,0,height-top_wood-cubby-rack_top_wood])
    rack_top_3d();
}

module rack_tops_assembled() {
    rack_top_assembled();
    translate([top_x,0,0])
    mirror([1,0,0])
    rack_top_assembled();
}


module rack_base() {
    difference() {
        square([4*u+leg_wood*2,top_y]);
        translate([leg_wood,0])
        rotate([0,0,90])
        pin_edge(rack_base_wood+pad,leg_wood,top_y);
        translate([leg_wood+4*u,0])
        mirror([1,0])
        rotate([0,0,90])
        pin_edge(rack_base_wood,leg_wood+pad,top_y);
    }
}

module rack_base_3d() {
    linear_extrude(height=rack_base_wood)
    rack_base();
}

module rack_base_assembled() {
    translate([foot,0,height-top_wood-cubby-rack_top_wood-rack-rack_base_wood])
    rack_base_3d();
}

module rack_bases_assembled() {
    rack_base_assembled();
    translate([top_x,0,0])
    mirror([1,0,0])
    rack_base_assembled();
}

module back_3d() {
    linear_extrude(height=top_wood)
    back();
}

module top_assembled() {
    translate([0,0,height-top_wood])
    top_3d();
}

module assembled() {
    //#base();
    color("purple")
    top_assembled();
    //leg_us();
    color("red")
    inner_legs_assembled();
    color("blue")
    outer_legs_assembled();
    color("lime")
    rack_bases_assembled();
    color("lime")
    rack_tops_assembled();
    color("gray")
    back_assembled();
    color("gray")
    back_wings_assembled();
    color("tan")
    fronts_assembled();
}

module back_wing() {
    wing();
}

module back_wing_3d() {
    linear_extrude(height=back_wood)
    back_wing();
}

module back_wing_assembled() {
    translate([0,top_y-back_wood,height])
    rotate([-90,0,0])
    back_wing_3d();
}

module back_wings_assembled() {
    back_wing_assembled();
    translate([top_x,0,0])
    mirror([1,0,0])
    back_wing_assembled();
}


module leg_u() {
    translate([leg_wood+foot,-pad,height-top_wood-cubby-rack_top_wood])
    rotate([0,90,0])
    #u(4,top_y+pad*2);
}

module leg_us() {
    leg_u();
    translate([top_x,0,0])
    mirror([1,0,0])
    leg_u();
}

back_wire_wall=leg_wall;
back_wire=6*in;

module back() {
    square([leg_wood*2+legroom,top_wood+cubby+rack_top_wood]);
}

module back_3d() {
    linear_extrude(height=back_wood)
    back();
}

module back_assembled() {
    translate([leg_wood+4*u+foot,top_y,height-top_wood-cubby-rack_top_wood])
    rotate([90,0,0])
    back_3d();
}

module wing() {
    difference() {
        square([foot+leg_wood,top_wood+cubby+rack_top_wood]);
        r2=cubby+rack_top_wood;
        translate([0,top_wood+cubby+rack_top_wood])
        scale([1,r2/foot])
        circle(r=foot);
    }

}

module front() {
    front_positive();
}

module front_positive() {
    translate([foot,0])
    square([leg_wood*2+4*u,top_wood+cubby+rack_top_wood]);
    wing();
}

module front_3d() {
    linear_extrude(height=back_wood)
    front();
}

module front_assembled() {
    translate([0,0,height])
    rotate([-90,0,0])
    front_3d();
}

module fronts_assembled() {
    front_assembled();
    translate([top_x,0,0])
    mirror([1,0,0])
    front_assembled();
}


assembled();

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

module tail_edge(tail_h, pin_h, edge) {
    for(x=[0:pintail:edge-pintail]) {
        translate([x+tail/2+edge%pintail/2+pintail_gap/2,0])
        mouse_ears(pin+pintail_gap*2,pin_h);
    }
}

module tail_holes(tail_h,pin_h,edge) {
    tail_edge(tail_h,pin_h,edge);
    translate([0,pin_h])
    mirror([0,1])
    tail_edge(tail_h,pin_h,edge);
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
