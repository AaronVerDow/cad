in=25.4; // convert to mm
top_y=24*in;

pin_screw=1/8*in;


three_quarter_wood=0.703*in; // actual plywood thicknesses will vary
half_wood=0.5*in;
quarter_wood=0.25*in;

top_wood=three_quarter_wood;
leg_wood=half_wood;
rack_base_wood=half_wood;
rack_top_wood=half_wood;
back_wood=half_wood;
front_wood=quarter_wood;
blank_wood=quarter_wood;
spine_wood=three_quarter_wood;
leg_cover_wood=quarter_wood;
double_top_wood=quarter_wood;

leg_wire_r=1*in;
leg_wall=1.5*in;
leg_wire=4*in;

blind=0*in;


details=1;

// rack_standards
// https://en.wikipedia.org/wiki/19-inch_rack#/media/File:Server_rack_rail_dimensions.svg
u=1.75*in;
u_hole_gap=0.625*in;
u_hole=0.125*in;
rack=19.125*in; // outer
rack_inner=17.75*in;
us=4;
rack_h=u*us+0.125*in;

echo("blank dimensions");
echo(rack/in);
echo(rack_h/in);


cubby=3*in;

covered_front=0;
back_wings=0;
below_rack=0*in;
double_top_wall=2*in;

height=rack+below_rack+rack_base_wood+top_wood+rack_top_wood+cubby;
top_u_h=height-top_wood-u;

pad=0.1;

end_u_depth=26*in;

base_min_x=40.5*in;
legroom=base_min_x;
wing=0*in; //?
top_x=wing*2+base_min_x+rack_h*2+leg_wood*4;

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

blank_gap=0*in;
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


back_x=leg_wood*2+legroom;
back_y=top_wood+cubby+rack_top_wood;

$fn=4;
hole_fn=8;
mid_fn=40;


leg_base_top_x=(7+5/8)*in;
leg_base_top_y=(3+7/8)*in;
leg_base_top_z=2*in;
leg_base_top=[
    leg_base_top_x,
    leg_base_top_y,
    leg_base_top_z
];

leg_base_leg_x=2*in;
leg_base_leg_y=(3+3/16)*in;
leg_base_leg_z=14*in;
leg_base_leg_offset_x=1*in;
leg_base_leg_offset_y=leg_base_top_y/2-leg_base_leg_y/2;
leg_base_leg_offset_z=4.25*in;

leg_base_leg_offset=[
    leg_base_leg_offset_x,
    leg_base_leg_offset_y,
    height-top_wood-leg_base_leg_offset_z-leg_base_leg_z
];


rack_top_extra=3*in;

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
        translate([wing+leg_wood+rack_h/2,y,-wheel_h])
        children();
    }
}


module u_holes(us=1) {
	if(details)
    for (n=[0:1:us-1]) {
        for (x=[0:u_hole_gap:u]) {
            translate([x-u_hole_gap+u/2+u*n,0,0])
            circle(d=u_hole,$fn=hole_fn);
        }
    }
}

blank_hole=rack_h-blank_wall*2;
module blank_hole() {
    translate([rack_h/2-blank_gap,0])
    circle(d=blank_hole,$fn=mid_fn);
}

module blank_holes() {
    mirror_y(rack-blank_gap*2)
    translate([0,rack_h/2-blank_gap])
    #blank_hole();
    translate([0,rack/2-blank_gap])
    blank_hole();
}

module blank() {
    difference() {
        square([rack_h-blank_gap*2,rack-blank_gap*2]);
        blank_holes();
    }
}

module blank_3d() {
    linear_extrude(height=blank_wood)
    blank();
}

module blank_assembled_front_left() {
    translate([wing+leg_wood+blank_gap,blank_wood+blank_inset,rack_base_wood+blank_gap])
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
    from_edge=rack_h/2+leg_wood+wing;
    total_x=top_x-from_edge*2;
    spacing=total_x/(top_wire_holes-1);

    for(x=[0:spacing:total_x])
    translate([x+from_edge,top_y-top_wire_wall])
    children();

}

module top_wire_profile() {
    circle(d=top_wire,$fn=mid_fn);
}

module top_wire_pocket() {
    circle(d=top_wire+top_wire_lip*2,$fn=mid_fn);
}

module top_pins_side() {
    translate([wing+leg_wood,0])
    difference() { 
        rotate([0,0,90]) {
            tail_edge(top_wood,leg_wood,top_y);
            intersection() {
                tail_screws(top_wood,leg_wood,top_y);
                translate([double_top_wall*1.5,0])
                square([top_x,top_y]);
            }
        }
        translate([-leg_wood*1.5,top_y-channel_y-base_channel_from_back])
        square([leg_wood*2,channel_y]);
    }

    translate([wing+leg_wood+rack_h+tan(angle)*(height-rack_base_wood)+leg_wood/cos(angle),0])
    difference() { 
        rotate([0,0,90]) {
            tail_holes(top_wood,leg_wood/cos(angle)+tan(angle)*top_wood,top_y);
            intersection() {
                tail_screws(top_wood,leg_wood,top_y);
                translate([double_top_wall*1.5,0])
                square([top_x,top_y]);
            }
        }
        translate([-leg_wood*1.5,top_y-channel_y-base_channel_from_back])
        square([leg_wood*2,channel_y]);
    }


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
    pin_edge(top_wood,front_wood+pad,wing+leg_wood*2+rack_h);
    translate([wing+leg_wood*2+rack_h,front_wood])
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
    square([wing+leg_wood+pad,back_wood+pad]);
    translate([wing+leg_wood,top_y-back_wood])
    mouse_ear();
}

module top_back_wings() {
    top_back_wing();
    translate([top_x,0])
    mirror([1,0])
    top_back_wing();
}


module top_profile() {
    translate([0,double_top_wall])
    square([top_x,top_y-double_top_wall]);
}

module top() {
    difference() {
        top_profile();
        top_wire_placements()
        top_wire_profile();
        top_pins();
        if(covered_front==1)
        front_pins();
        if(back_wings)
        top_back_wings();

        back_top_x=tan(angle)*(rack+rack_top_wood+cubby+top_wood);
        translate([wing+leg_wood+rack_h+back_top_x,top_y-back_wood,0])
        tail_edge(top_wood,back_wood+pad,back_x-back_top_x*2);

        mirror_y(top_y)
        translate([rack_h+leg_wood-spine_wing,top_y/2-leg_base_top_y/2-spine_wood])
        tail_holes(top_wood+pad,spine_wood,top_x-rack_h*2-leg_wood*2+spine_wing*2);
    }
}

module top_3d() {
    difference() {
        linear_extrude(height=top_wood)
        top();
        if(!double_top_wall)
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
    circle(d=rack-leg_wall*2,$fn=mid_fn);
}

module cubby_hole() {
    translate([height-top_wood-cubby/2,(cubby-cubby_wall*2)/2+front_wood+cubby_wall])
    circle(d=cubby-cubby_wall*2,$fn=mid_fn);
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
leg_curve=7*in;

module fancy_leg() {
        translate([rack_base_wood+below_rack,0]) {
            r=segment_radius(leg_curve,rack);
            mirror_y(top_y)
            intersection () {
                square([rack,leg_curve]);
                translate([rack/2,-r+leg_curve])
                circle(r=r, $fn=1000);
            }
        }
}

inner_leg_safety=cubby;

function hyp(h) = h/cos(angle);
function wood(h) = sin(angle)*h;
function tilted(h,wood) = hyp(h)+wood(wood);

module inner_leg() {

    translate([-wood(leg_wood),0])
    difference() {
        square([tilted(height, leg_wood),top_y]);

        // cubby holes
        mirror_y(top_y)
        translate([hyp(height-top_wood-cubby/2),(cubby-cubby_wall*2)/2+front_wood+cubby_wall])
        circle(d=cubby-cubby_wall*2,$fn=mid_fn);

        inner_leg_pins();

        // center cut
        translate([0,top_y/2-leg_base_top_y/2
        //-spine_wood
        ])
        square([tilted(height,leg_wood),leg_base_top_y
        //+spine_wood*2
        ]);

        // bottom box joint
        translate([tilted(rack_base_wood+below_rack, leg_wood),0])
        rotate([0,0,90])
        tail_edge(leg_wood,tilted(rack_base_wood+pad,leg_wood),top_y);

        r=segment_radius(leg_curve,hyp(rack));
        mirror_y(top_y)
        translate([hyp(rack)/2+hyp(rack_base_wood),-r+leg_curve])
        circle(r=r, $fn=1000);

        // middle box joint
        translate([tilted(rack_base_wood+rack+rack_top_wood+below_rack,leg_wood),0])
        rotate([0,0,90]) {
            tail_holes(leg_wood,tilted(rack_top_wood,leg_wood),top_y);
            if(!blind)
            tail_screws(leg_wood,rack_top_wood,top_y);
        }

        // top pins
        translate([hyp(height-top_wood),0])
        mirror([1,0])
        rotate([0,0,90]) {
            pin_edge(leg_wood,tilted(top_wood+pad,leg_wood),top_y);
        }

        // spine pins
        mirror_y(top_y)
        translate([inner_leg_safety,top_y/2-leg_base_top_y/2-spine_wood])
        pin_edge(leg_wood,spine_wood+pad,hyp(height)-inner_leg_safety*2);

        // spine pin ends
        mirror_x(hyp(height))
        translate([0,top_y/2-leg_base_top_y/2-spine_wood])
        square([inner_leg_safety,leg_base_top_y+spine_wood*2]);


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
        rotate([0,0,90]) {
            tail_holes(leg_wood,rack_base_wood+pad,top_y);
            if(!blind)
            tail_screws(leg_wood,rack_base_wood+pad,top_y);
        }

        // middle box joint
        translate([rack_base_wood+rack+rack_top_wood+below_rack,0])
        rotate([0,0,90]) {
            tail_holes(leg_wood,rack_top_wood,top_y);
            if(!blind)
            tail_screws(leg_wood,rack_top_wood,top_y);
        }

        // top pins
        translate([height-top_wood,0])
        mirror([1,0])
        rotate([0,0,90]) {
            pin_edge(leg_wood,top_wood+pad,top_y);
        }

    }
}

module outer_leg() {
    difference() {
        leg();
        if(covered_front==1)
        leg_front_plates();
        // top pins
        translate([height-top_wood,0])
        mirror([1,0])
        rotate([0,0,90])
        pin_screws(leg_wood,top_wood+pad,top_y);
    }
}

module inner_leg_pin() {
    translate([height-top_wood-cubby-rack_top_wood,top_y-back_wood]) {
        short_tail_edge(leg_wood,back_wood+pad,top_wood+cubby+rack_top_wood);
        //pin_screws(leg_wood,back_wood+pad,top_wood+cubby+rack_top_wood);
    }
    //translate([height-top_wood-cubby-rack_top_wood,top_y-back_wood]) rotate([0,0,45*6]) mouse_ear();
}


module inner_leg_pins() {
    inner_leg_pin();
    if(covered_front==1)
    mirror_y(top_y)
    inner_leg_pin();
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
    translate([leg_wood*2+rack_h+wing,0,rack_base_wood+below_rack])
    rotate([0,-90+angle,0])
    translate([-rack_base_wood-below_rack,0])
    inner_leg_3d();
}

module outer_leg_assembled() {
    translate([leg_wood+wing,0,0])
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
    extra=rack_top_extra+tan(angle)*rack_base_wood;
    difference() {
        union() {
            rack_common(extra);
            translate([rack_h/2+leg_wood,top_y-top_wire_wall])
            circle(d=top_wire+0.5*in,$fn=mid_fn);

        }
        if(covered_front==1)
        translate([0,front_wood])
        mirror([0,1])
        pin_edge(rack_top_wood,front_wood+pad,rack_h+leg_wood*2);

        translate([rack_h/2+leg_wood,top_y-top_wire_wall])
        circle(d=top_wire,$fn=mid_fn);
    }
}

angle=atan(
    (leg_cover_wood*2+rack_top_extra-leg_wood)
    /
    (rack)
);

echo("angle");
echo(angle);

module rack_top_3d() {
    linear_extrude(height=rack_top_wood)
    rack_top();
}

module rack_top_assembled() {
    translate([wing,0,height-top_wood-cubby-rack_top_wood])
    rack_top_3d();
}

module rack_tops_assembled() {
    rack_top_assembled();
    translate([top_x,0,0])
    mirror([1,0,0])
    rack_top_assembled();
}


module mirror_x(x=top_x) {
    children();
    translate([x,0])
    mirror([1,0])
    children();
}


module mirror_y(y=top_y) {
    children();
    translate([0,y])
    mirror([0,1])
    children();
}

module rack_common(extra=0) {
    difference() {
        translate([blind,0])
        square([rack_h+leg_wood*2-blind*2+extra,top_y]);

        translate([leg_wood,0])
        rotate([0,0,90])
        pin_edge(rack_base_wood+pad,leg_wood,top_y);

        difference() {
            translate([leg_wood+rack_h+extra-tan(angle)*rack_base_wood,0])
            mirror([1,0])
            rotate([0,0,90])
            pin_edge(rack_base_wood,leg_wood+pad+tan(angle)*rack_base_wood*2,top_y);

            translate([0,top_y/2-leg_base_top_y/2-spine_wood])
            square([rack_h+leg_wood*2+extra,leg_base_top_y+spine_wood*2]);
        }

        mirror_y()
        for (y=[rail_flush:rail_choice:server_flush+extra_choices*rail_choice]) {
            translate([rack_h/2-u*us/2+leg_wood,y])
            u_holes(us);
        }

        translate([leg_wood+rack_h,top_y/2-leg_base_top_y/2-spine_wood])
        square([leg_base_leg_x+leg_cover_wood+extra,leg_base_top_y+spine_wood*2]);
    }
}

module rack_base() {
    difference() {
        rack_common();
        translate([-wing,0])
        place_wheels()
        circle(d=wheel_barrel,$fn=hole_fn);
    }
}

module rack_base_3d() {
    linear_extrude(height=rack_base_wood)
    rack_base();
}

module rack_base_assembled() {
    translate([wing,0,height-top_wood-cubby-rack_top_wood-rack-rack_base_wood])
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
module leg_base() {
    hull() {
        translate([0,0,height-leg_base_top_z-top_wood])
        cube(leg_base_top);

        translate([leg_base_leg_offset_x,leg_base_leg_offset_y,height-top_wood-leg_base_leg_offset_z])
        cube([leg_base_leg_x,leg_base_leg_y,leg_base_leg_offset_z]);
    }

    translate(leg_base_leg_offset)
    cube ([ leg_base_leg_x, leg_base_leg_y, leg_base_leg_z ]);

    
}
module leg_bases_assembled() {
    mirror_x(top_x)
    translate([leg_wood+leg_cover_wood+rack_h-leg_base_leg_offset_x,top_y/2-leg_base_top_y/2])
    leg_base();
}

module leg_cover_common(y) {
    x=leg_base_top_y+spine_wood*2;
    tall=rack+rack_top_wood+rack_base_wood;
    difference() {
        square([x,y]);
        mirror_x(x)
        translate([spine_wood,0])
        rotate([0,0,90])
        pin_edge(leg_cover_wood,spine_wood+pad,tall);
    }
}

module leg_cover() {
    leg_cover_common(rack+rack_top_wood+rack_base_wood);
}

module inner_leg_cover() {
    x=leg_base_top_y+spine_wood*2;
    intersection() { 
        leg_cover_common(height-top_wood-leg_base_leg_offset_z);
        square([x,leg_base_leg_x/tan(angle)]);
    }
}

spine_wall=1.5*in;

spine_wing=rack_h;

module spine_inner_leg(x,y) {
    difference() {
        children();
        mirror_x(x)
        translate([0,rack_base_wood+below_rack])
        rotate([0,0,-angle])
        translate([-x+leg_wood,-rack_base_wood-below_rack])
        square([x,y]);
    }
}

module spine() {
    x=top_x-rack_h*2-leg_wood*2;
    y=top_wood+cubby+rack_top_wood+rack+rack_base_wood;
    leg=2*in+leg_cover_wood*2;
    r=segment_radius(leg_base_leg_offset_z-spine_wall,x-leg*2);

    inside_y=height-top_wood-leg_base_leg_offset_z;
    translate([0,height-y])
    difference() {
        translate([-spine_wing,0])
        square([x+spine_wing*2,y]);


        translate([-spine_wing,y-top_wood])
        pin_edge(top_wood+pad,spine_wood,x+spine_wing*2);

        mirror_x(x)
        hull() {
            translate([-spine_wing,0])
            square([spine_wing+pad,height-top_wood-cubby]);
            translate([-spine_wing,0])
            square([pad,height-top_wood]);
        }

        // center
        spine_inner_leg(x,y)
        intersection() {
            translate([x/2,-r+leg_base_leg_offset_z-spine_wall+inside_y])
            circle(r=r,$fn=900);
            translate([leg,0])
            square([x-leg*2,height]);
        }

        
        tall=rack+rack_top_wood+rack_base_wood;

        // inner cover pins
        mirror_x(x)
        spine_inner_leg(x,y)
        translate([leg_cover_wood+leg_base_leg_x+leg_cover_wood*2,0])
        rotate([0,0,90])
        tail_edge(spine_wood,leg_cover_wood+pad,tall);

        // outer cover pins
        mirror_x(x)
        translate([leg_cover_wood,0])
        rotate([0,0,90])
        tail_edge(spine_wood,leg_cover_wood+pad,tall);

        // inner leg pins
        //translate([0,rack_base_wood+below_rack])
        //translate([leg_wood+inner_leg_safety,-rack_base_wood-below_rack])
        rotate([0,0,90-angle])
        translate([inner_leg_safety,0.25*in])
        mirror([0,1])
        tail_edge(spine_wood,leg_wood+pad,hyp(height)-inner_leg_safety*2);
    }
}


module spine_assembled() {
    mirror_y(top_y)
    translate([rack_h+leg_wood,top_y/2-leg_base_top_y/2])
    rotate([90,0,0])
    linear_extrude(height=spine_wood)
    spine();

}

module leg_cover_assembled() {

    mirror_x(top_x)
    translate([rack_h+leg_wood,
    top_y/2-leg_base_top_y/2-spine_wood,
    below_rack
    ])
    rotate([90,0,90])
    linear_extrude(height=leg_cover_wood)
    leg_cover();

    mirror_x(top_x)
    translate([rack_h+leg_wood+leg_cover_wood+leg_base_leg_x,
    top_y/2-leg_base_top_y/2-spine_wood,
    below_rack
    ])
    rotate([90,0,90])
    linear_extrude(height=leg_cover_wood)
    inner_leg_cover();
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
    //#leg_bases_assembled();

    color("green")
    spine_assembled();

    leg_cover_assembled();

    if(double_top_wall) double_top_assembled();
    //color("white")
    //blanks_assembled();
    //place_wheels() #wheel_max();
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
    translate([leg_wood+wing,-pad,height-top_wood-cubby-rack_top_wood])
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
    short_tail_edge(back_wood,leg_wood+pad,top_wood+cubby+leg_wood);
}


module back_leg_tails() {
    back_leg_tail();
    translate([leg_wood*2+legroom,0,0])
    mirror([1,0,0])
    back_leg_tail();
}


module back() {
    bottom_x=tan(angle)*rack;
    top_x=tan(angle)*(rack+rack_top_wood+cubby+top_wood);
    difference() {
        square([back_x,back_y]);
        translate([top_x,cubby+rack_top_wood]) {
            pin_edge(back_wood,top_wood+pad,back_x-top_x*2);
            //tail_screws(back_wood,top_wood+pad,back_x-top_x*2);
        }
        // back_leg_tails();

        mirror_x(back_x)
        translate([bottom_x,0])
        rotate([0,0,-angle])
        translate([-bottom_x*2,-back_y/2])
        square([bottom_x*2,back_y*2]);

        mirror_x(back_x)
        translate([bottom_x+leg_wood/cos(angle),0])
        rotate([0,0,90-angle])
        translate([-sin(angle)*leg_wood,0])
        short_pin_edge(leg_wood,back_wood+pad,(top_wood+cubby)/cos(angle));
    }
}


module back_3d() {
    linear_extrude(height=back_wood)
    back();
}

module back_assembled() {
    translate([leg_wood+rack_h+wing,top_y,height-top_wood-cubby-rack_top_wood])
    rotate([90,0,0])
    back_3d();
}

module wing() {
    difference() {
        square([wing+leg_wood,top_wood+cubby+rack_top_wood]);
        r2=cubby+rack_top_wood;
        translate([0,top_wood+cubby+rack_top_wood])
        scale([1,r2/wing])
        circle(r=wing,$fn=mid_fn);
    }

}

module front() {
    difference() {
        front_positive();
        translate([0,top_wood])
        mirror([0,1])
        tail_edge(front_wood,top_wood+pad,wing+leg_wood*2+rack_h);
        translate([wing,top_wood+cubby])
        tail_edge(front_wood,rack_top_wood+pad,rack_h+leg_wood*2);

        translate([wing+leg_wood+rack_h,0])
        mirror([1,0])
        rotate([0,0,90])
        tail_edge(front_wood,leg_wood+pad,top_wood+cubby+rack_top_wood);
    }
}

module front_positive() {
    translate([wing,0])
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

module tail_screws(tail_h, pin_h, edge) {
	if(details)
	for(x=[0:pintail:edge]) {
		translate([x+edge%pintail/2,pin_h/2])
		circle(d=pin_screw,$fn=hole_fn);
	}
}


module pin_screws(pin_h, tail_h, edge) {
	if(details)
	for(x=[pintail:pintail:edge]) {
		translate([x+edge%pintail/2-tail/2-pin/2,tail_h/2])
		circle(d=pin_screw,$fn=hole_fn);
	}
}

module pin_edge(pin_h, tail_h, edge) {
    if(details) {
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
}

module short_pin_edge(pin_h, tail_h, edge) {
    if(details) {
        
        intersection() {
            union() {
                translate([edge/2,pin_h/2])
                circle(d=pin_screw,$fn=hole_fn);
                translate([-tail-pin/2+edge/2,0]) { 
                    translate([0,0])
                    mouse_ears(pin+pintail_gap*2,tail_h);
                    translate([pintail,0])
                    mouse_ears(pin+pintail_gap*2,tail_h);
                }
            }
            translate([0,-pin_h/2])
            square([edge,pin_h*2]);
        }

    }
}


module short_tail_edge(tail_h, pin_h, edge) {
    if(details) {
        translate([edge/2-pin/2,0])
        mouse_ears(pin+pintail_gap*2,pin_h);
    }
}


module tail_edge(tail_h, pin_h, edge) {
    if(details) {
        for(x=[0:pintail:edge-pintail]) {
            translate([x+tail/2+edge%pintail/2+pintail_gap/2,0])
            mouse_ears(pin+pintail_gap*2,pin_h);
        }
    }
}

module tail_holes(tail_h,pin_h,edge) {
    if(details) {
        tail_edge(tail_h,pin_h,edge);
        translate([0,pin_h])
        mirror([0,1])
        tail_edge(tail_h,pin_h,edge);
    }
}

module mouse_ear() {
    rotate([0,0,45])
    translate([0,bit/2])
    circle(d=bit,$fn=hole_fn);
}

module mouse_ears(x,y) {
    square([x,y]);
    translate([x,0])
    mouse_ear();
    rotate([0,0,-90])
    mouse_ear();
}


plywood_x=4*12*in;
plywood_y=8*12*in;

module plywood(show_plywood=1) {
    line=1;
    corner=50;

    mirror_x(plywood_x)
    mirror_y(plywood_y)
    color("lime")
    translate([0,0,-pad*2]) {
        square([line,corner]);
        square([corner,line]);
    }
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



module plywood_text(text) {
    text_h=8*in;
    text(text,text_h,halign="right");
}


    //plywood_text("sheet ");
module sheet() {
    plywood();
    sheet_gap=2*in;

    xp=cubby+rack/2+rack_top_wood-(rack_h+leg_wood+sheet_gap+below_rack)/2;
    yp=4*in;

    module leg_placement() {
        translate([rack_h+leg_wood*2+sheet_gap,0])
        children();
    }

    module half() {

        rack_top();
        leg_placement()
        inner_leg();

        translate([0,top_y*2-yp*2]) {
            rack_base();
            leg_placement()
            outer_leg();
        }
    }

    scatter_x=height+sheet_gap+rack_h+leg_wood*2+xp;
    scatter_y=top_y*4-yp*3;
    y_gap=(plywood_y-scatter_y)/5;

    translate([xp+plywood_x/2-scatter_x/2,y_gap*2+back_y]) {
        half();
        translate([rack_h+leg_wood*2+sheet_gap+height-xp,top_y-yp])
        mirror([1,0])
        half();
    }

    translate([plywood_x/2-back_x/2,y_gap])
    back();
}

module double_top_assembled() {
    translate([0,0,height])
    difference() {
        linear_extrude(height=double_top_wood)
        double_top();
        translate([0,0,top_wood-top_wire_lip])
        linear_extrude(height=top_wood)
        top_wire_placements()
        top_wire_pocket();
    }

    mirror_x(top_x)
    color("green")
    translate([0,0,height-top_wood])
    linear_extrude(height=top_wood)
    double_top_side();

    color("blue")
    translate([top_x/2-double_top_center/2,0,height-top_wood])
    linear_extrude(height=top_wood)
    double_top_center();



}


module double_top_profile() {
        intersection() {
            translate([0,double_top_wall])
            minkowski() {
                square([top_x,top_y]);
                circle(r=double_top_wall,$fn=mid_fn);
            }
            translate([-double_top_wall,0])
            square([top_x+double_top_wall*2,top_y]);
        }
}

module double_top() {
    difference() {
        double_top_profile();
        top_wire_placements()
        difference() {
            top_wire_pocket();
            top_wire_profile();
        }
    }
}

module double_top_edge() {
    difference() {
        double_top_profile();
        top_profile();
        mirror_x(top_x+double_top_wall*2)
        translate([0,double_top_wall])
        rotate([0,0,270])
        mouse_ear();
        gap=12*in;
        start_x=(top_x+double_top_wall*2-gap/2)%gap+gap/4-double_top_wall;

        translate([top_x/2-double_top_center/2,0])
        for(x=[double_top_wall:(double_top_center-double_top_wall*2)/2:double_top_center-double_top_wall])
        translate([x,double_top_wall/2])
        circle(d=pin_screw,$fn=hole_fn);

        for(y=[double_top_wall:(top_y-double_top_wall*2)/2:top_y-double_top_wall])
        translate([-double_top_wall/2,y])
        circle(d=pin_screw,$fn=hole_fn);

        translate([top_x/2-double_top_center/2-double_top_wall,double_top_wall/2])
        circle(d=pin_screw,$fn=hole_fn);

    }
}

double_top_center=42*in;

module double_top_center() {
    translate([-top_x/2+double_top_center/2,0])
    intersection() {
        double_top_edge();
        translate([top_x/2-double_top_center/2,-pad])
        square([double_top_center,top_y+pad*2]);
    }
}

module double_top_side() {
    intersection() {
        double_top_edge();
        translate([-double_top_wall-pad,-pad])
        square([(top_x-double_top_center)/2+double_top_wall+pad,top_y+pad*2]);
    }
}

module top_sheet() {

    plywood();
    gap_x=(plywood_x-top_y*2+double_top_wall)/2;
    from_edge=2*in;

    translate([0,from_edge]) {

        translate([top_y+gap_x/2,double_top_wall])
        rotate([0,0,90])
        double_top();

        for(y=[0:(top_x+double_top_wall*2)/4:top_x+double_top_wall*2])
        translate([gap_x+top_y,y])
        circle(d=0.5*in);

        translate([top_y-double_top_wall+gap_x/2+gap_x,top_x+double_top_wall])
        rotate([0,0,90+180])
        top();

        translate([plywood_x/2-double_top_center/2,top_x+double_top_wall*3])
        double_top_center();

        translate([plywood_x-top_y/2,top_x+double_top_wall*6])
        rotate([0,0,90])
        double_top_side();

        translate([plywood_x+double_top_wall*2-top_y/2,top_x+double_top_wall*7+(top_x-double_top_center)])
        rotate([0,0,90])
        mirror([1,0])
        double_top_side();

        translate([0,plywood_y])
        blank();
    }
}


gap=6*in;

module cut_sheets() {
    sheet();
	translate([plywood_x+gap,0]) {
		top_sheet();
	}
}


module vr() {
    scale(1/1000)
    children();
}

display="";
if(!display) 
//spine();
//double_top_edge();
//cut_sheets();
//top_sheet();
assembled();
//back_3d();
//leg_cover();
//rack_top();
//inner_leg();
//blank();
//top();

if(display=="desk_assembled.stl") {
    $fn=20;
    vr()
    assembled();
}

if(display=="desk_sheet_one_profiles.dxf") {
    $fn=300;
    rotate([0,0,90])
    sheet();
}
if(display=="desk_top_sheet_profiles.dxf") {
    $fn=300;
    rotate([0,0,90+180])
    top_sheet();
}

if(display=="desk_blank.dxf") {
    $fn=300;
    blank();
}

if(display=="desk_top.stl")vr() top_assembled();
if(display=="desk_inner_legs.stl")vr() inner_legs_assembled();
if(display=="desk_outer_legs.stl")vr() outer_legs_assembled();
if(display=="desk_rack_bases.stl")vr() rack_bases_assembled();
if(display=="desk_rack_tops.stl")vr() rack_tops_assembled();
if(display=="desk_back.stl")vr() back_assembled();
if(display=="desk_spine.stl")vr() spine_assembled();
if(display=="desk_leg_cover.stl")vr() leg_cover_assembled();
if(display=="desk_double_top.stl")vr() linear_extrude(height=double_top_wood) double_top();
if(display=="desk_top_center.stl")vr() linear_extrude(height=top_wood) double_top_center();
if(display=="desk_top_side.stl")vr() linear_extrude(height=top_wood) double_top_side();
 
