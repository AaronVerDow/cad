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
blank_wood=quarter_wood;

leg_wire_r=1*in;
leg_wall=1.5*in;
leg_wire=4*in;

// rack_standards
// https://en.wikipedia.org/wiki/19-inch_rack#/media/File:Server_rack_rail_dimensions.svg
u=1.75*in;
u_hole_gap=0.625*in;
u_hole=0.125*in;
rack=19.125*in; // outer
rack_inner=17.75*in;
us=4;
rack_h=u*us+0.125*in;

cubby=3*in;

covered_front=0;
back_wings=0;
below_rack=1*in;

height=rack+below_rack+rack_base_wood+top_wood+rack_top_wood+cubby;
top_u_h=height-top_wood-u;

pad=0.1;

end_u_depth=26*in;

base_min_x=40.5*in;
legroom=base_min_x;
foot=0; //?
top_x=base_min_x+rack_h*2+leg_wood*4;

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
top_wire_holes=4;
top_wire_wall=2*in;

rack_top_wire=3*in;


// https://www.imovr.com/imovr-vigor-diy-standing-desk-base.html
base_max_x=75.4*in;
base_y=22.8*in;
base_min_z=25.76*in;
base_max_z=50.8*in;
channel_y=0;
base_channel_y=5*in;
base_channel_z=2*in;
channel_z=0;
base_channel_from_back=5*in;
base_foot=3*in;

cubby_wall=0.5*in;

pin=2*in;
tail=pin;
pintail_gap=0.05;
pintail=pin+tail+pintail_gap*2;
bit=0.25*in;

blank_gap=0.1*in;
blank_inset=1*in;
blank_wall=1*in;

rail_choices=3;
rail_flush=7/8*in;
server_flush=3*in;
rail_choice=(server_flush-rail_flush)/(rail_choices-1);
extra_choices=1;

wheel_barrel=7/16*in;
wheel_barrel_h=7/8*in;
wheel_lock=1/8*in;
wheel_lock_h=1/2*in;
wheel_w=(1+5/16)*in;
wheel_max=2.625*in;
wheel_h=(3+5/8)*in;


wheel_min_y=wheel_w/2;
wheel_max_y=wheel_max;
wheel_choices=3;
wheel_choice=(wheel_max_y-wheel_min_y)/(wheel_choices-1);
wheel_extra_choices=wheel_choice*1;


module wheel_max() {
    translate([0,0,below_rack]) {
        cylinder(r=wheel_max,h=wheel_h);
        cylinder(d=wheel_barrel,h=wheel_h+wheel_barrel_h);
        translate([0,0,wheel_h+wheel_lock_h+wheel_lock/2])
        rotate_extrude()
        translate([wheel_barrel/2,0])
        circle(d=wheel_lock);
    }
}

module place_wheels() {
    mirror_x()
    mirror_y()
    for(y=[wheel_min_y:wheel_choice:wheel_max_y+wheel_extra_choices]) {
        translate([leg_wood+rack_h/2,y,-wheel_h])
        children();
    }
}


module u_holes(us=1) {
    for (n=[0:1:us-1]) {
        for (x=[0:u_hole_gap:u]) {
            translate([x-u_hole_gap+u/2+u*n,0,0])
            circle(d=u_hole);
        }
    }
}
module blank_hole() {
    d=rack_h-blank_wall*2;
    translate([rack_h/2,rack_h/2])
    circle(d=d);
}

module blank_holes() {
    blank_hole();
    translate([0,rack])
    mirror([0,1])
    blank_hole();
    translate([0,-rack_h/2+rack/2])
    blank_hole();
}

module blank() {
    difference() {
        square([rack_h-blank_gap*2,rack-blank_gap*2]);
        //blank_holes();
    }
}

module blank_3d() {
    linear_extrude(height=blank_wood)
    blank();
}

module blank_assembled_front_left() {
    translate([foot+leg_wood+blank_gap,blank_wood+blank_inset,rack_base_wood+blank_gap])
    rotate([90,0])
    blank_3d();
}

module blank_assembled_left() {
    blank_assembled_front_left();
    translate([0,top_y])
    mirror([0,1])
    blank_assembled_front_left();
}

module blanks_assembled() {
    blank_assembled_left();
    translate([top_x,0])
    mirror([1,0])
    blank_assembled_left();
}

module base_side() {
    cube([base_foot,base_y,base_min_z]);
}

module base() {
    translate([rack_h+leg_wood*2,top_y-base_y-back_wood,-base_min_z+rack_base_wood+rack+rack_top_wood+cubby]) {
        base_side();
        translate([base_min_x-base_foot,0])
        base_side();
        translate([0,base_y-base_channel_y-base_channel_from_back,base_min_z-base_channel_z])
        cube([base_min_x,base_channel_y,base_channel_z]);
    }
}

module u(slots, depth) {
    cube([rack,depth,u*slots]);
}



module top_wire_placements() {
    from_edge=rack_h/2+leg_wood;
    total_x=top_x-from_edge*2;
    spacing=total_x/(top_wire_holes-1);

    for(x=[0:spacing:total_x])
    translate([x+from_edge,top_y-top_wire_wall])
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
        translate([-leg_wood*1.5,top_y-channel_y-base_channel_from_back])
        square([leg_wood*2,channel_y]);
    }
}

module top_pins_side() {
    top_pins_one(foot+leg_wood);
    top_pins_one(foot+leg_wood*2+rack_h);
}

module top_pins() {
    top_pins_side();
    translate([top_x,0,0])
    mirror([1,0,0])
    top_pins_side();
}

module front_pin() {
    translate([0,front_wood])
    mirror([0,1])
    pin_edge(top_wood,front_wood+pad,foot+leg_wood*2+rack_h);
    translate([foot+leg_wood*2+rack_h,front_wood])
    rotate([0,0,90])
    mouse_ear();
}

module front_pins() {
    front_pin();
    translate([top_x,0,0])
    mirror([1,0,0])
    front_pin();
}


module top_back_wing() {
    translate([-pad,top_y-back_wood])
    square([foot+leg_wood+pad,back_wood+pad]);
    translate([foot+leg_wood,top_y-back_wood])
    mouse_ear();
}

module top_back_wings() {
    top_back_wing();
    translate([top_x,0])
    mirror([1,0])
    top_back_wing();
}

module top() {
    difference() {
        square([top_x,top_y]);
        top_wire_placements()
        top_wire_profile();
        top_pins();
        if(covered_front==1)
        front_pins();
        if(back_wings)
        top_back_wings();
        translate([foot+leg_wood+rack_h,top_y-back_wood,0])
        pin_edge(top_wood,back_wood+pad,leg_wood*2+legroom);
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

module leg_front_plate() {
    translate([rack_base_wood+rack,-pad])
    square([top_wood+cubby+rack_top_wood+pad,front_wood+pad]);
    translate([rack_base_wood+rack,front_wood])
    rotate([0,0,45*4])
    mouse_ear();
}

module leg_front_plates() {
    leg_front_plate();
    translate([0,top_y])
    mirror([0,1])
    leg_front_plate();
}


module old_fancy_leg() {
        wall=4*in;

        module cut(extra=0) {
            translate([rack/2+rack_base_wood,0])
            circle(d=rack+extra*2);
        }

        cut();

        difference() {
            translate([wall/2+rack_base_wood,wall])
            square([rack-wall,top_y-wall*2]);
            cut(wall);
        }
}

function segment_radius(height, chord) = (height/2)+(chord*chord)/(8*height);

leg_center_hole=0;

module fancy_leg() {
        wall=4*in;
        cut=7*in;

        module my_mirror() {
            children();
            translate([0,top_y])
            mirror([0,1])
            children();
        }

        translate([rack_base_wood+below_rack,0]) {
            r=segment_radius(cut,rack);
            my_mirror()
            intersection () {
                square([rack,cut]);
                translate([rack/2,-r+cut])
                circle(r=r, $fn=1000);
            }

            if(leg_center_hole)
            difference() {
                translate([wall/2,wall])
                square([rack-wall,top_y-wall*2]);
                my_mirror()
                translate([rack/2,-r+cut])
                circle(r=r+wall, $fn=1000);
            }
        }
}

module leg() {
    difference() {
        square([height,top_y]);

        fancy_leg();

        //translate([height-rack/2-top_wood-cubby-rack_top_wood,top_y/2]) leg_wires();

        translate([height-top_wood-channel_z,top_y-channel_y-base_channel_from_back])
        square([channel_z+top_wood+pad,channel_y]);

        // bottom box joint
        translate([rack_base_wood+below_rack,0])
        rotate([0,0,90])
        tail_holes(leg_wood,rack_base_wood+pad,top_y);

        // middle box joint
        translate([rack_base_wood+rack+rack_top_wood+below_rack,0])
        rotate([0,0,90])
        tail_holes(leg_wood,rack_top_wood,top_y);

        // top pins
        translate([height-top_wood,0])
        mirror([1,0])
        rotate([0,0,90])
        pin_edge(leg_wood,top_wood+pad,top_y);

    }
}

module outer_leg() {
    difference() {
        leg();
        if(covered_front==1)
        leg_front_plates();
    }
}

module inner_leg_pin() {
    translate([height-top_wood-cubby-rack_top_wood,top_y-back_wood])
    pin_edge(leg_wood,back_wood+pad,top_wood+cubby+rack_top_wood);
    translate([height-top_wood-cubby-rack_top_wood,top_y-back_wood])
    rotate([0,0,45*6])
    mouse_ear();
}
module inner_leg_pins() {
    inner_leg_pin();
    if(covered_front==1)
    translate([0,top_y])
    mirror([0,1])
    inner_leg_pin();
}

module inner_leg() {
    difference() {
        leg();
        cubby_holes();
        inner_leg_pins();
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
    translate([leg_wood*2+rack_h+foot,0,0])
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
    difference() {
        rack_common();
        if(covered_front==1)
        translate([0,front_wood])
        mirror([0,1])
        pin_edge(rack_top_wood,front_wood+pad,rack_h+leg_wood*2);
        translate([rack_h/2+leg_wood,top_y-top_wire_wall])
        circle(d=top_wire);
    }
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


module mirror_x() {
    children();
    translate([top_x,0])
    mirror([1,0])
    children();
}


module mirror_y() {
    children();
    translate([0,top_y])
    mirror([0,1])
    children();
}

module rack_common() {
    difference() {
        square([rack_h+leg_wood*2,top_y]);

        translate([leg_wood,0])
        rotate([0,0,90])
        pin_edge(rack_base_wood+pad,leg_wood,top_y);

        translate([leg_wood+rack_h,0])
        mirror([1,0])
        rotate([0,0,90])
        pin_edge(rack_base_wood,leg_wood+pad,top_y);

        mirror_y()
        for (y=[rail_flush:rail_choice:server_flush+extra_choices*rail_choice]) {
            translate([rack_h/2-u*us/2+leg_wood,y])
            u_holes(us);
        }
    }
}

module rack_base() {
    difference() {
        rack_common();
        translate([-foot,0])
        place_wheels()
        circle(d=wheel_barrel);
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
    if(back_wings)
    color("gray")
    back_wings_assembled();
    if(covered_front)
    color("tan")
    fronts_assembled();
    //color("white")
    //blanks_assembled();
    place_wheels()
    #wheel_max();
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

module back_leg_tail() {
    translate([leg_wood,0])
    rotate([0,0,90])
    tail_edge(back_wood,leg_wood+pad,top_wood+cubby+leg_wood);
}

module back_leg_tails() {
    back_leg_tail();
    translate([leg_wood*2+legroom,0,0])
    mirror([1,0,0])
    back_leg_tail();
}


module back() {
    difference() {
        x=leg_wood*2+legroom;
        square([x,top_wood+cubby+rack_top_wood]);
        translate([0,cubby+rack_top_wood])
        tail_edge(back_wood,top_wood+pad,x);
        back_leg_tails();
    }
}

module back_3d() {
    linear_extrude(height=back_wood)
    back();
}

module back_assembled() {
    translate([leg_wood+rack_h+foot,top_y,height-top_wood-cubby-rack_top_wood])
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
    difference() {
        front_positive();
        translate([0,top_wood])
        mirror([0,1])
        tail_edge(front_wood,top_wood+pad,foot+leg_wood*2+rack_h);
        translate([foot,top_wood+cubby])
        tail_edge(front_wood,rack_top_wood+pad,rack_h+leg_wood*2);

        translate([foot+leg_wood+rack_h,0])
        mirror([1,0])
        rotate([0,0,90])
        tail_edge(front_wood,leg_wood+pad,top_wood+cubby+rack_top_wood);
    }
}

module front_positive() {
    translate([foot,0])
    square([leg_wood*2+rack_h,top_wood+cubby+rack_top_wood]);
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
    rotate([0,0,45])
    translate([0,bit/2])
    circle(d=bit);
}

module mouse_ears(x,y) {
    square([x,y]);
    translate([x,0])
    mouse_ear();
    rotate([0,0,-90])
    mouse_ear();
}


//assembled();

plywood_x=8*12*in;
plywood_y=4*12*in;

module plywood() {
    color("blue")
    translate([0,0,-pad])
    square([plywood_x,plywood_y]);
}

module spaced_depth() {
    for ( i= [0:1:$children-1])
    translate([0,i*(top_y+2*in)])
    children(i);
}


module spaced_height() {
    for ( i= [0:1:$children-1])
    translate([i*(height+2*in),0])
    children(i);
}

module sheet() {
    translate([0,plywood_y])
    rotate([0,0,-90])
    spaced_depth() {
        spaced_height() {
            inner_leg();
            inner_leg();
        }
        spaced_height() {
            outer_leg();
            outer_leg();
        }
    }
}

assembled();
