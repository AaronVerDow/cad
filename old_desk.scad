in=25.4; // convert to mm
top_y=24*in;


three_quarter_wood=0.75*in; // actual plywood thicknesses will vary
half_wood=0.5*in;
quarter_wood=0.25*in;

top_wood=three_quarter_wood;
lattice_wood=half_wood;
leg_wood=half_wood;
leg_rack_base_wood=half_wood;
foot_wood=half_wood;
spine_wood=half_wood;
end_rack_wood=half_wood;
front_rack_wood=half_wood;
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

height=rack+leg_rack_base_wood+top_wood+lattice_wood+u;
top_u_h=height-top_wood-u;

pad=0.1;

top_u_gap=spine_wood;

end_u_depth=26*in;

legroom=rack*2+spine_wood;
top_x=legroom+8*u+leg_wood*4;

echo("height");
echo(height/in);

echo("top_x");
echo(top_x/in);

echo("base x");
echo(legroom/in);

back_wall=2*in;
front_wall=-6*in;


// https://www.imovr.com/imovr-vigor-diy-standing-desk-base.html
base_min_x=46.6*in;
base_max_x=75.4*in;
base_y=22.8*in;
base_min_z=23.9*in;
base_max_z=49.5*in;
base_foot_x=4*in; //?
base_channel_y=5*in;
base_channel_z=2*in;
base_channel_from_back=5*in;

module base_side() {
    cube([base_foot_x,base_y,base_min_z]);
}

module base() {
    translate([leg_wood*2+4*u,top_y-base_y-back_wood,-base_min_z+leg_rack_base_wood+rack]) {
        base_side();
        translate([legroom-base_foot_x,0])
        base_side();
        translate([0,base_y-base_channel_y-base_channel_from_back,base_min_z-base_channel_z])
        cube([legroom,base_channel_y,base_channel_z]);
    }
}

#base();


module u(slots, depth) {
    cube([rack,depth,u*slots]);
}

module top() {
    square([top_x,top_y]);
}

module top_3d() {
    linear_extrude(height=top_wood)
    top();
}

module top_assembled() {
    translate([0,0,height-top_wood])
    top_3d();
}

module lattice() {
    difference() {
        square([top_x,top_y]);
    }
}

module lattice_3d() {
    linear_extrude(height=lattice_wood)
    lattice();
}

module lattice_assembled() {
    translate([0,0,height-top_wood-u-lattice_wood])
    lattice_3d();
}


module front_u(x=0) {
    translate([-rack/2+x,-pad,top_u_h])
    #u(1,top_y+pad*2);
}

module end_u() {
    translate([-pad,rack/2+top_y/2,top_u_h])
    rotate([0,0,-90])
    #u(1,top_y+pad*2);
}

module top_us() {
    front_u(top_x/2-rack/2-top_u_gap/2);
    front_u(top_x/2+rack/2+top_u_gap/2);
    end_u();
    translate([top_x,0,0])
    mirror([1,0,0])
    end_u();
}

module assembled() {
    color("purple")
    top_assembled();
    color("lime")
    lattice_assembled();
    //top_us();
    //leg_us();
    color("red")
    spine_assembled();
    color("red")
    inner_legs_assembled();
    color("blue")
    outer_legs_assembled();
    color("lime")
    leg_rack_bases_assembled();
    color("magenta")
    feet_assembled();
    color("magenta")
    end_racks_assembled();
    color("blue")
    front_racks_assembled();
    color("gray")
    back_assembled();
}


module leg_u() {
    translate([leg_wood,-pad,height-top_wood-u-lattice_wood])
    rotate([0,90,0])
    #u(4,top_y+pad*2);
}

module leg_us() {
    leg_u();
    translate([top_x,0,0])
    mirror([1,0,0])
    leg_u();
}

module leg_wires() {
    wire_corners(rack, top_y, leg_wall, leg_wire);
    circle(d=rack-leg_wall*2);
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
        translate([height-top_wood-u,top_y/2-rack/2])
        square([top_wood+u,rack]);
        translate([height-rack/2-top_wood-u-lattice_wood,top_y/2])
        leg_wires();
    }
}

module outer_leg() {
    leg();
}

module inner_leg() {
    leg();
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
    translate([leg_wood*2+u*4,0,0])
    rotate([0,-90,0])
    inner_leg_3d();
}

module outer_leg_assembled() {
    translate([leg_wood,0,0])
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

module leg_rack_base() {
    square([4*u+leg_wood*2,top_y]);
}

module leg_rack_base_3d() {
    linear_extrude(height=leg_rack_base_wood)
    leg_rack_base();
}

module leg_rack_base_assembled() {
    translate([0,0,height-top_wood-u-lattice_wood-rack-leg_rack_base_wood])
    leg_rack_base_3d();
}

module leg_rack_bases_assembled() {
    leg_rack_base_assembled();
    translate([top_x,0,0])
    mirror([1,0,0])
    leg_rack_base_assembled();
}

module foot() { 
    square([4*u+leg_wood*2,top_y]);
}
module foot_3d() {
    linear_extrude(height=foot_wood)
    foot();
}
module foot_assembled() { 
    foot_3d();
}

module feet_assembled() {
    foot_assembled();
    translate([top_x,0,0])
    mirror([1,0,0])
    foot_assembled();
}

module spine() {
    square([top_wood+u+lattice_wood,top_y]);
}

module spine_3d() {
    linear_extrude(height=spine_wood)
    spine();
}

module spine_assembled() {
    translate([spine_wood/2+top_x/2,0,height-top_wood-u-lattice_wood])
    rotate([0,-90,0])
    spine_3d();
}

module end_rack() {
    square([(top_x-rack*2-spine_wood)/2,top_wood+u+lattice_wood]);
}

module end_rack_3d() {
    linear_extrude(height=end_rack_wood)
    end_rack();
}

module end_rack_assembled() {
    translate([0,top_y/2-rack/2-end_rack_wood,height])
    rotate([-90,0,0])
    end_rack_3d();
}

module end_racks_assembled_left() {
    end_rack_assembled();
    translate([0,top_y,0])
    mirror([0,1,0])
    end_rack_assembled();
}

module end_racks_assembled() {
    end_racks_assembled_left();
    translate([top_x,0,0])
    mirror([1,0,0])
    end_racks_assembled_left();
}

module front_rack() {
    square([top_wood+u+lattice_wood,(top_y-rack)/2]);
}

module front_rack_3d() {
    linear_extrude(height=front_rack_wood)
    front_rack();
}

module front_rack_assembled() {
    translate([top_x/2-spine_wood/2-rack-front_rack_wood,0,height])
    rotate([0,90,0])
    front_rack_3d();
}

module front_racks_assembled_left() {
    front_rack_assembled();
    translate([0,top_y,0])
    mirror([0,1,0])
    front_rack_assembled();
}

module front_racks_assembled() {
    front_racks_assembled_left();
    translate([top_x,0,0])
    mirror([1,0,0])
    front_racks_assembled_left();
}
module back_3d() {
    linear_extrude(height=top_wood)
    back();
}

module top_assembled() {
    translate([0,0,height-top_wood])
    top_3d();
}

module lattice() {
    top();
}

module lattice_3d() {
    linear_extrude(height=lattice_wood)
    lattice();
}

module lattice_assembled() {
    translate([0,0,height-top_wood-u-lattice_wood])
    lattice_3d();
}


module front_u(x=0) {
    translate([-rack/2+x,-pad,top_u_h])
    #u(1,top_y+pad*2);
}

module end_u() {
    translate([-pad,rack/2+top_y/2,top_u_h])
    rotate([0,0,-90])
    #u(1,top_y+pad*2);
}

module top_us() {
    front_u(top_x/2-rack/2-top_u_gap/2);
    front_u(top_x/2+rack/2+top_u_gap/2);
    end_u();
    translate([top_x,0,0])
    mirror([1,0,0])
    end_u();
}

module assembled() {
    color("purple")
    top_assembled();
    color("lime")
    lattice_assembled();
    //top_us();
    //leg_us();
    color("red")
    spine_assembled();
    color("red")
    inner_legs_assembled();
    color("blue")
    outer_legs_assembled();
    color("lime")
    leg_rack_bases_assembled();
    //color("magenta")
    //feet_assembled();
    color("magenta")
    end_racks_assembled();
    //color("blue")
    //front_racks_assembled();
    color("gray")
    back_assembled();
    color("tan")
    front_assembled();
}


module leg_u() {
    translate([leg_wood,-pad,height-top_wood-u-lattice_wood])
    rotate([0,90,0])
    #u(4,top_y+pad*2);
}

module leg_us() {
    leg_u();
    translate([top_x,0,0])
    mirror([1,0,0])
    leg_u();
}

module outer_leg() {
    leg();
}

module inner_leg() {
    leg();
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
    translate([leg_wood*2+u*4,0,0])
    rotate([0,-90,0])
    inner_leg_3d();
}

module outer_leg_assembled() {
    translate([leg_wood,0,0])
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

module leg_rack_base() {
    square([4*u+leg_wood*2,top_y]);
}

module leg_rack_base_3d() {
    linear_extrude(height=leg_rack_base_wood)
    leg_rack_base();
}

module leg_rack_base_assembled() {
    translate([0,0,height-top_wood-u-lattice_wood-rack-leg_rack_base_wood])
    leg_rack_base_3d();
}

module leg_rack_bases_assembled() {
    leg_rack_base_assembled();
    translate([top_x,0,0])
    mirror([1,0,0])
    leg_rack_base_assembled();
}

module foot() { 
    square([4*u+leg_wood*2,top_y]);
}
module foot_3d() {
    linear_extrude(height=foot_wood)
    foot();
}
module foot_assembled() { 
    foot_3d();
}

module feet_assembled() {
    foot_assembled();
    translate([top_x,0,0])
    mirror([1,0,0])
    foot_assembled();
}

module spine() {
    square([top_wood+u+lattice_wood,top_y]);
}

module spine_3d() {
    linear_extrude(height=spine_wood)
    spine();
}

module spine_assembled() {
    translate([spine_wood/2+top_x/2,0,height-top_wood-u-lattice_wood])
    rotate([0,-90,0])
    spine_3d();
}

module end_rack() {
    square([(top_x-rack*2-spine_wood)/2,top_wood+u+lattice_wood]);
}

module end_rack_3d() {
    linear_extrude(height=end_rack_wood)
    end_rack();
}

module end_rack_assembled() {
    translate([0,top_y/2-rack/2-end_rack_wood,height])
    rotate([-90,0,0])
    end_rack_3d();
}

module end_racks_assembled_left() {
    end_rack_assembled();
    translate([0,top_y,0])
    mirror([0,1,0])
    end_rack_assembled();
}

module end_racks_assembled() {
    end_racks_assembled_left();
    translate([top_x,0,0])
    mirror([1,0,0])
    end_racks_assembled_left();
}

module front_rack() {
    square([top_wood+u+lattice_wood,(top_y-rack)/2]);
}

module front_rack_3d() {
    linear_extrude(height=front_rack_wood)
    front_rack();
}

module front_rack_assembled() {
    translate([top_x/2-spine_wood/2-rack-front_rack_wood,0,height])
    rotate([0,90,0])
    front_rack_3d();
}

module front_racks_assembled_left() {
    front_rack_assembled();
    translate([0,top_y,0])
    mirror([0,1,0])
    front_rack_assembled();
}

module front_racks_assembled() {
    front_racks_assembled_left();
    translate([top_x,0,0])
    mirror([1,0,0])
    front_racks_assembled_left();
}

back_wire_wall=leg_wall;
back_wire=6*in;

module back() {
    y=height-top_wood-u;
    x=top_x-8*u-leg_wood*2;

    r1=y-back_wall-lattice_wood;
    r2=x/2-leg_wood-back_wall;
    difference() {
        square([x,y]);
        translate([x/2,0])
        scale([r2/r1,1])
        circle(r=r1);
        translate([x/2,0])
        wire_corners(x-leg_wood*2,y*2-lattice_wood-foot_wood,back_wire_wall,back_wire);
    }
}

module back_3d() {
    linear_extrude(height=back_wood)
    back();
}

module back_assembled() {
    translate([leg_wood+4*u,top_y,0])
    rotate([90,0,0])
    back_3d();
}

module front() {
    y=height-top_wood-u;
    x=top_x-8*u-leg_wood*2;

    r1=y-front_wall-lattice_wood;
    r2=x/2-leg_wood-front_wall;
    difference() {
        square([x,y]);
        translate([x/2,0])
        scale([r2/r1,1])
        circle(r=r1);
    }
}

module front_3d() {
    linear_extrude(height=back_wood)
    front();
}

module front_assembled() {
    translate([leg_wood+4*u,front_wood,0])
    rotate([90,0,0])
    front_3d();
}


assembled();
