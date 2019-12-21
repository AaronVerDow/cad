in=25.4;

back_wood=0.25*in;
depth=(22+11/16)*in+back_wood;

height=(92+7/8)*in;
width=(19+5/8)*in;

wood=11/16*in;

side_wood=wood;
bottom_wood=0.25*in;
top_wood=wood;
shelf_wood=wood;

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

socket_hole=5/8*in;
leveler_barrel=7/16*in;
leveler_min_height=5/8*in;
leveler_foot=1.5*in;
leveler_hole=2*in;
leveler_wall=0.25*in;

shade_wood=0.25*in;
shade_y=0.25*in;
shade_h=3*in;


bottom_shelf_z=bottom_shelf-shelf_wood;
leveler_z=leveler_min_height+shelf_wood;

custom_shelves=[
	bottom_shelf_z,
	leveler_z,
];


standard_shelves=[
	74.5*in,
	41.75*in,
	16.75*in,
];

fixed_shelves=cat(custom_shelves, standard_shelves);

wire_hole=2.5*in;
air_hole=4*in;
side_hole=air_hole;

lip=0.25*in;
wire_hole_wall=0.25*in;
wire_hole_outer=wire_hole+lip*2;
side_hole_outer=side_hole+lip*2;

shelf_bite=shelf_wood-0.25*in;
shade_bite=shelf_bite-0.125*in;

function cat(L1, L2) = [for(L=[L1, L2], a=L) a];

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
    square([width-side_wood*2,depth-back_wood]);
}

module shelf_3d(z) {
    translate([side_wood,0,z])
    linear_extrude(height=top_wood)
    shelf();
}

module tail_edge(pin_h, tail_h, edge) {
    for(x=[0:pintail:edge-pintail]) {
        translate([x+tail/2+edge%pintail/2+pintail_gap/2,0])
        mouse_ears(pin+pintail_gap*2,pin_h);
    }
}

module place_side_holes() {
	translate([side_hole_outer/2+wire_hole_wall+back_wood,0]) {
		translate([0,bottom_shelf+side_hole_outer/2+wire_hole_wall])
		children();
		//translate([0,height-top_wood-wire_hole_wall-side_hole_outer/2]) children(); // top
	}
}

module side() { 
	difference () {
		square([depth,height]);
		place_side_holes()
		circle(d=side_hole);
	}
}

module side_cuts() {
    translate([0,bottom_wood])
    mirror([0,1])
    tail_edge(bottom_wood+pad,side_wood+pad,depth);
    translate([0,height-top_wood])
    tail_edge(top_wood+pad,side_wood+pad,depth);

    translate([back_wood,0])
    rotate([0,0,90])
    tail_edge(back_wood+pad,side_wood+pad,height);

	place_y(fixed_shelves)
	tail_holes(shelf_wood,side_wood,depth);
}

module top() {
    difference() {
        translate([blind,0])
        square([width-blind*2,depth]);
        translate([side_wood,0])
        rotate([0,0,90])
        pin_edge(bottom_wood+pad,side_wood+pad,depth);
        translate([width-side_wood,0])
        rotate([0,0,90])
        mirror([0,1])
        pin_edge(bottom_wood+pad,side_wood+pad,depth);

        translate([0,depth-back_wood])
        tail_edge(back_wood+pad,bottom_wood+pad,width);
    }
}

module top_3d() {
    translate([0,0,height-top_wood])
    linear_extrude(height=top_wood)
    top();
}

module bottom() {
    difference() {
        translate([blind,0])
        square([width-blind*2,depth]);
        translate([side_wood,0])
        rotate([0,0,90])
        pin_edge(bottom_wood+pad,side_wood+pad,depth);

        translate([width-side_wood,0])
        rotate([0,0,90])
        mirror([0,1])
        pin_edge(bottom_wood+pad,side_wood+pad,depth);

        translate([0,depth-back_wood])
        tail_edge(back_wood+pad,bottom_wood+pad,width);

        place_levelers()
        circle(d=leveler_hole);
    }
}

module bottom_3d() {
    linear_extrude(height=bottom_wood)
    bottom();
}


module side_3d() {
    difference() {
        linear_extrude(height=side_wood)
        side();
        translate([0,0,blind])
        linear_extrude(height=side_wood)
        side_cuts();
        translate([0,0,wood-hole_d])
        linear_extrude(height=side_wood)
        rails();

        translate([0,0,wood-lip])
        linear_extrude(height=side_wood)
		place_side_holes()
		circle(d=side_hole_outer);
    }
}

module side_3d_placed() {
    translate([side_wood,depth,0])
    rotate([0,0,-90])
    rotate([90,0,0])
    side_3d();
}

module sides_3d() {
    translate([side_wood,0,0])
    mirror([1,0,0])
    side_3d_placed();
    translate([width-side_wood,0])
    side_3d_placed();
}


module leveler() {
    cylinder(d=7/16*in,h=3*in);
    cylinder(d=leveler_foot,h=5/8*in);
}

module place_leveler_front_left() {
    translate([leveler_hole/2+side_wood+leveler_wall,leveler_hole/2+leveler_wall])
    children();
}

module mirror_x() {
    children();
    translate([width,0])
    mirror([1,0])
    children();
}


module mirror_y() {
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



module bottom_shelf_3d() {
	translate([0,0,bottom_shelf_z])
	linear_extrude(height=shelf_wood)
	bottom_shelf();
}

module bottom_shelf() {
	difference() {
		fixed_shelf();
        place_levelers()
        circle(d=socket_hole);
	}
}

module leveler_shelf_3d() {
	translate([0,0,leveler_z])
	linear_extrude(height=shelf_wood)
	leveler_shelf();
}

module leveler_shelf() {
	difference() {
		fixed_shelf();
        place_levelers()
        circle(d=leveler_barrel);
		translate([-pad,-pad])
		square([width+pad*2,shade_y+shade_wood+pad]);
	}
}

module place_y(list) {
    for(y=list) {
        translate([0,y,0])
        children();
    }
}

module place_z(list) {
    for(z=list) {
        translate([0,0,z])
        children();
    }
}

module fixed_shelf() {
    difference() {
        translate([blind,0,0])
        square([width-blind*2,depth]);
        mirror_x()
        translate([shelf_wood,0,0])
        rotate([0,0,90])
        pin_edge(shelf_wood,side_wood,depth);
        translate([0,depth-back_wood])
        pin_edge(shelf_wood,back_wood+pad,width);
        
        circle(d=air_hole);
    }
}

module shaded_fixed_shelf() {
    fixed_shelf();
}

module shaded_pockets() {
    translate([shelf_wood,shade_y,0])
    tail_holes(shade_wood,shelf_wood,width-side_wood*2);
}

module shaded_fixed_shelf_3d() {
    shaded_shelf()
    linear_extrude(height=shelf_wood)
    fixed_shelf();
}

module shaded_fixed_air_shelf_3d() {
}

module shaded_fixed_air_shelf() {
    shaded_fixed_shelf();
}

module shaded_shelf() {
    difference () {
        children();
        translate([0,0,-shelf_wood+shelf_bite])
        linear_extrude(height=shelf_wood)
        shaded_pockets();
    }
}

module fixed_shelf_3d() {
    linear_extrude(height=shelf_wood)
    fixed_shelf();
}


module back() {
    difference() {
        translate([blind,0])
        square([width-blind*2,height]);

        // bottom
        translate([0,bottom_wood,0])
        mirror([0,1,0])
        pin_edge(back_wood+pad,bottom_wood+pad,width);

        // top
        translate([0,-top_wood,0])
        translate([0,height])
        pin_edge(back_wood+pad,top_wood+pad,width);

        //left
        translate([side_wood,0])
        rotate([0,0,90])
        pin_edge(back_wood+pad,side_wood+pad,height);

        //right
        translate([width-side_wood,0])
        mirror([1])
        rotate([0,0,90])
        pin_edge(back_wood+pad,side_wood+pad,height);

        place_y(fixed_shelves)
        tail_holes(shelf_wood,back_wood+pad,width);

    }
}

module back_3d() {
    translate([0,depth,0])
    rotate([90,0,0])
    linear_extrude(height=back_wood)
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

module tail_holes(pin_h,tail_h,edge) {
    tail_edge(pin_h,tail_h,edge);
    translate([0,pin_h])
    mirror([0,1])
    tail_edge(pin_h,tail_h,edge);
}

module bottom_shade() {
	square([width-side_wood*2,bottom_shelf-shelf_wood*2]);
}

module bottom_shade_3d() {
	translate([side_wood,shade_y,bottom_shelf-shelf_wood])
	rotate([-90,0,0])
	linear_extrude(height=shade_wood)
	bottom_shade();
}

module shade_3d() {
	translate([side_wood,shade_y,shade_bite])
	rotate([-90,0,0])
	linear_extrude(height=shade_wood)
	shade();
}

module shade() {
    difference() {
        square([width-side_wood*2,shade_h+shade_bite]);
        translate([0,shade_bite])
        mirror([0,1])
        pin_edge(shade_wood,shade_bite+pad,width-side_wood*2);
    }
}


plywood_x=8*in*12;
plywood_y=4*in*12;
plywood_edge=1;
module plywood() {
    color("blue") translate([0,0,-pad]) square([plywood_x,plywood_y]);
}

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
    place_levelers()
    #leveler();

	place_z(standard_shelves)
	shaded_fixed_shelf_3d();

	color("white")
	place_z(standard_shelves)
    shade_3d();


	leveler_shelf_3d();
	bottom_shelf_3d();
	color("white")
	bottom_shade_3d();
}



module cut_sheet_one() {
    plywood();
    gap_y=(plywood_y-depth-width)/3;
    gap_x=(plywood_x-height)/2;
    translate([height+gap_x,width+gap_y*2])
    rotate([0,0,90]) {
        side();
        translate([0,0,pad])
        color("red") {
            side_cuts();
            rails();
        }
    }

    translate([gap_x,gap_y+width])
    spaced_x(plywood_x) {
        rotate([0,0,-90])
        fixed_shelf();
        rotate([0,0,-90])
        fixed_shelf();
        rotate([0,0,-90])
        fixed_shelf();
        //shelf();
    }
}

module spaced_x(x) {
    for ( i= [0:1:$children-1]) 
    translate([x/($children)*(i),0])
    children(i);
}

module spaced_sheets() {
    for (i=[0:1:$children-1]) 
    translate([0,i*sheets_gap])
    children(i);
}



module cut_sheet_two() {
    plywood();
    gap_y=(plywood_y-width-depth)/3;
    gap_x=(plywood_x-height)/2;

    translate([gap_x,width+gap_y*2])
    mirror([0,1])
    rotate([0,0,90+180]) {
        side();
        translate([0,0,pad])
        color("red") {
            side_cuts();
            rails();
        }
    }


    translate([gap_x,gap_y]) {
        translate([0,width])
        spaced_x(plywood_x) {
            rotate([0,0,-90])
            top();
            rotate([0,0,-90])
            bottom();
            rotate([0,0,-90])
            leveler_shelf();
        }
    }
}

module shade_to_cut() {
    translate([shade_h,0])
    rotate([0,0,90])
    shade();
}

module spaced_shade() {
    for ( i= [0:1:$children-1]) 
    translate([i*(shade_h+2*in),0])
    children(i);
}


module cut_sheet_three() {
    gap_y=(plywood_y-width*2)/3;
    gap_x=(plywood_x-height)/2;
    plywood();
    translate([height+gap_x,width*2+gap_y*2])
    mirror([0,1])
    rotate([0,0,90])
    back();
    translate([gap_x,gap_y]) {
        spaced_shade() {
            shade_to_cut();
            shade_to_cut();
            shade_to_cut();
            shade_to_cut();
            shade_to_cut();
            translate([0,width])
            rotate([0,0,-90])
            bottom_shelf();
        }
    }
}

sheets_gap=2*in+plywood_y;

module cut_sheets() {
    spaced_sheets() {
        cut_sheet_one();
        cut_sheet_two();
        cut_sheet_three();
    }
}

cut_sheets();

//back();
//flat();

//fixed_shelf_3d();
//translate([-width,-depth])
//assembled();
//side_3d();

//shade_3d();
//bottom();
//top();


