in=25.4;

back_wood=0.25*in;
depth=(22+11/16)*in+back_wood;

height=(92+7/8)*in;

// printer cabinets
width=(19+5/8)*in;

// other 
//width=29.5*in;

//wide_cut_sheets();

wood=11/16*in;

side_wood=wood;
bottom_wood=0.25*in;
top_wood=wood;
shelf_wood=wood;

plywood_x=8*in*12;
plywood_y=4*in*12;
plywood_edge=1;

pin=3*in;

tail=pin;

pintail_gap=0.05;

pintail=pin+tail+pintail_gap*2;

//$fn=90;

blind=1/8*in;

bit=0.25*in;
pad=0.1;


// hide or show pins
details=0;

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

// no shelves
standard_shelves=[];
//fixed_shelves=[];

wire_hole=2.5*in;
air_hole=4*in;
side_hole=air_hole;

lip=0.25*in;
wire_hole_wall=0.25*in;
wire_hole_outer=wire_hole+lip*2;
side_hole_outer=side_hole+lip*2;

shelf_bite=shelf_wood-0.25*in;
shade_bite=shelf_bite-0.125*in;

// =========== utilities ===========

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

function cat(L1, L2) = [for(L=[L1, L2], a=L) a];

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


module mirror_x(width) {
    children();
    translate([width,0])
    mirror([1,0])
    children();
}


module mirror_y(depth) {
    children();
    translate([0,depth])
    mirror([0,1])
    children();
}

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
    if (details) {
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

module tail_edge(pin_h, tail_h, edge) {
    if (details) {
        for(x=[0:pintail:edge-pintail]) {
            translate([x+tail/2+edge%pintail/2+pintail_gap/2,0])
            mouse_ears(pin+pintail_gap*2,pin_h);
        }
    }
}

module tail_holes(pin_h,tail_h,edge) {
    mirror_y(pin_h)
    tail_edge(pin_h,tail_h,edge);
}

module shelf(width, depth) {
    square([width-side_wood*2,depth-back_wood]);
}

module place_side_holes() {
	translate([side_hole_outer/2+wire_hole_wall+back_wood,0]) {
		translate([0,bottom_shelf+side_hole_outer/2+wire_hole_wall])
		children();
		//translate([0,height-top_wood-wire_hole_wall-side_hole_outer/2]) children(); // top
	}
}
module top(width,depth) {
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

module top_3d(width,depth,height) {
    translate([0,0,height-top_wood])
    linear_extrude(height=top_wood)
    top(width,depth);
}

module bottom(width,depth) {
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

        place_levelers(width, depth)
        circle(d=leveler_hole);
    }
}

module bottom_3d(width,depth) {
    linear_extrude(height=bottom_wood)
    bottom(width,depth);
}

module side_3d(width,depth,height) {
    translate([side_wood,depth,0])
    rotate([0,0,-90])
    rotate([90,0,0])
    difference() {
        linear_extrude(height=side_wood)
        side(depth,height);

        translate([0,0,blind])
        linear_extrude(height=side_wood)
        side_cuts(depth,height);

        translate([0,0,wood-hole_d])
        linear_extrude(height=side_wood)
        rails();

        translate([0,0,wood-lip])
        linear_extrude(height=side_wood)
		place_side_holes()
		circle(d=side_hole_outer);
    }
}

module side(depth,height) { 
	difference () {
		square([depth,height]);
		place_side_holes()
		circle(d=side_hole);
	}
}

module side_cuts(depth,height) {
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


module sides_3d(width,depth,height) {
    mirror_x(width)
    translate([side_wood,0,0])
    mirror([1,0,0])
    side_3d(width,depth,height);
}


module leveler() {
    cylinder(d=7/16*in,h=3*in);
    cylinder(d=leveler_foot,h=5/8*in);
}

module place_levelers(width, depth) {
    mirror_x(width)
    mirror_y(depth)
    translate([leveler_hole/2+side_wood+leveler_wall,leveler_hole/2+leveler_wall])
    children();
}

module bottom_shelf(width, depth) {
	difference() {
		fixed_shelf(width, depth);
        place_levelers(width, depth)
        circle(d=socket_hole);
	}
}

module bottom_shelf_3d(width, depth) {
	translate([0,0,bottom_shelf_z])
	linear_extrude(height=shelf_wood)
	bottom_shelf(width, depth);
}


module leveler_shelf(width, depth) {
	difference() {
		fixed_shelf(width, depth);
        place_levelers(width, depth)
        circle(d=leveler_barrel);
		translate([-pad,-pad])
		square([width+pad*2,shade_y+shade_wood+pad]);
	}
}

module leveler_shelf_3d(width, depth) {
	translate([0,0,leveler_z])
	linear_extrude(height=shelf_wood)
	leveler_shelf(width, depth);
}

module fixed_shelf(width, depth) {
    difference() {
        translate([blind,0,0])
        square([width-blind*2,depth]);

        mirror_x(width)
        translate([shelf_wood,0,0])
        rotate([0,0,90])
        pin_edge(shelf_wood,side_wood,depth);

        translate([0,depth-back_wood])
        pin_edge(shelf_wood,back_wood+pad,width);
    }
}

module shaded_fixed_shelf(width, depth) {
    fixed_shelf(width, depth);
}

module shaded_pockets(width) {
    translate([shelf_wood,shade_y,0])
    tail_holes(shade_wood,shelf_wood,width-side_wood*2);
}

module shaded_fixed_shelf_3d(width, depth) {
    shaded_shelf(width)
    linear_extrude(height=shelf_wood)
    fixed_shelf(width, depth);
}

module shaded_fixed_air_shelf(width, depth) {
    difference() {
        shaded_fixed_shelf(width, depth);
        circle(d=air_hole);
    }
}

module shaded_shelf(width) {
    difference () {
        children();
        translate([0,0,-shelf_wood+shelf_bite])
        linear_extrude(height=shelf_wood)
        shaded_pockets(width);
    }
}

module fixed_shelf_3d(width, depth) {
    linear_extrude(height=shelf_wood)
    fixed_shelf(width, depth);
}


module back(width, height) {
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

        // sides
        mirror_x(width)
        translate([side_wood,0])
        rotate([0,0,90])
        pin_edge(back_wood+pad,side_wood+pad,height);

        place_y(fixed_shelves)
        tail_holes(shelf_wood,back_wood+pad,width);
    }
}

module back_3d(width, depth, height) {
    translate([0,depth,0])
    rotate([90,0,0])
    linear_extrude(height=back_wood)
    back(width, height);
}



module bottom_shade(width) {
	square([width-side_wood*2,bottom_shelf-shelf_wood*2]);
}

module bottom_shade_3d(width) {
	translate([side_wood,shade_y,bottom_shelf-shelf_wood])
	rotate([-90,0,0])
	linear_extrude(height=shade_wood)
	bottom_shade(width);
}

module shade(width) {
    difference() {
        square([width-side_wood*2,shade_h+shade_bite]);
        translate([0,shade_bite])
        mirror([0,1])
        pin_edge(shade_wood,shade_bite+pad,width-side_wood*2);
    }
}

module shade_3d(width) {
	translate([side_wood,shade_y,shade_bite])
	rotate([-90,0,0])
	linear_extrude(height=shade_wood)
	shade(width);
}

module plywood() {
    color("blue") translate([0,0,-pad]) square([plywood_x,plywood_y]);
}

module assembled(width,depth,height) {
    color("red")
    sides_3d(width,depth,height);
    color("blue")
    top_3d(width,depth,height);
    //color("blue")
    //bottom_3d(width, depth);

    color("green")
    back_3d(width, depth, height);

    color("grey")
    place_levelers(width, depth)
    #leveler();

	place_z(standard_shelves)
	shaded_fixed_shelf_3d(width, depth);

	color("white")
	place_z(standard_shelves)
    shade_3d(width);


	leveler_shelf_3d(width, depth);
	bottom_shelf_3d(width, depth);
	color("white")
	bottom_shade_3d(width);
}




module spaced_y(y) {
    for (i=[0:1:$children-1]) 
    translate([0,i*y])
    children(i);
}

module spaced_x(asdf) {
    for(foo=[0:1:$children-1]) 
    translate([asdf*foo,0])
    children(foo);
}

module shade_to_cut() {
    translate([shade_h,0])
    rotate([0,0,90])
    shade(width);
}

module spaced_shade() {
    for ( i= [0:1:$children-1]) 
    translate([i*(shade_h+2*in),0])
    children(i);
}

module cut_sheets(width, depth, height) {
    spaced_y(plywood_y+6*in) {

        side_one(width, depth, height, width)
        three_skinny_shelves(depth) {
            fixed_shelf(width, depth);
            fixed_shelf(width, depth);
            fixed_shelf(width, depth);
        }

        side_two(depth, width, height, width)
        three_skinny_shelves(depth) {
            top(width,depth);
            bottom(width,depth);
            leveler_shelf(width, depth);
        }


        back_three(depth,width,height,width)
        spaced_shade() {
            shade_to_cut();
            shade_to_cut();
            shade_to_cut();
            shade_to_cut();
            shade_to_cut();
            translate([0,width])
            rotate([0,0,-90])
            bottom_shelf(width, depth);
        }

    }
}

module side_to_cut(width,depth,height,gap_y) {
    rotate([0,0,90]) {
        side(depth,height);
        translate([0,0,pad])
        color("red") {
            side_cuts(depth,height);
            rails();
        }
    }
}

module three_skinny_shelves(depth) {
    shelf_gap_x=(plywood_x-depth*3)/3;
    translate([shelf_gap_x/2,0])
    rotate([0,0,-90])
    spaced_y(depth+shelf_gap_x) {
        children(0);
        children(1);
        children(2);
    }
}

module side_one(width, depth, height, bottom_row_y) {
    plywood();
    gap_y=(plywood_y-depth-bottom_row_y)/3;
    translate([height+(plywood_x-height)/2,width+gap_y*2])
    side_to_cut(width,depth,height,gap_y);

    translate([0,bottom_row_y+gap_y])
    children();
}

module side_two(depth, width, height, bottom_row_y) {
    plywood();
    gap_y=(plywood_y-width-depth)/3;
    gap_x=(plywood_x-height)/2;

    translate([height+gap_x,depth+gap_y*2+bottom_row_y])
    mirror([0,1])
    side_to_cut(width,depth,height,gap_y);


    translate([0,bottom_row_y+gap_y])
    children();

}

module back_three(depth, width, height, bottom_row_y) {
    gap_y=(plywood_y-bottom_row_y-width)/3;
    
    plywood();
    translate([height+(plywood_x-height)/2,width+gap_y*2])
    rotate([0,0,90])
    back(width, height);


    translate([0,gap_y])
    children();
}

module plywood_text(text) {
    text_h=8*in;
    text(text,text_h,halign="right");
}
module wide_cut_sheet_one() {
    plywood();
    plywood_text("wide 1/2 #1 ");
    gap_y=(plywood_y-depth*2)/3;
    gap_x=(plywood_x-height)/2;
    echo("gap_y");
    echo(gap_y/in);
    translate([height+gap_x,depth+gap_y*2])
    rotate([0,0,90]) {
        side(depth,height);
        translate([0,0,pad])
        color("red") {
            side_cuts(depth,height);
            rails();
        }
    }
    shelf_gap_x=(plywood_x-width*3)/4;
    translate([shelf_gap_x,gap_y])
    spaced_x(shelf_gap_x+width) {
        fixed_shelf(width, depth);
        fixed_shelf(width, depth);
        fixed_shelf(width, depth);
        //shelf(width, depth);
    }
}

module wide_cut_sheet_two() {
    plywood();
    plywood_text("wide 1/2 #2 ");
    gap_y=(plywood_y-depth*2)/3;
    gap_x=(plywood_x-height)/2;

    translate([gap_x,depth+gap_y*2])
    mirror([0,1])
    rotate([0,0,90+180]) {
        side(depth,height);
        translate([0,0,pad])
        color("red") {
            side_cuts(depth,height);
            rails();
        }
    }


    shelf_gap_x=(plywood_x-width*3)/4;
    translate([shelf_gap_x,gap_y])
    spaced_x(shelf_gap_x+width) {
        top(width,depth);
        bottom(width,depth);
        leveler_shelf(width, depth);
    }
}

module wide_cut_sheet_three() {
    plywood_text("wide 1/4 #3 ");
    gap_y=(plywood_y-width*2)/3;
    gap_x=(plywood_x-height)/2;
    plywood();
    translate([height+gap_x,width-gap_y])
    mirror([0,1])
    rotate([0,0,90])
    back(width, height);
}

module wide_cut_sheets() {
    spaced_y(plywood_y+6*in) {
        wide_cut_sheet_one();
        wide_cut_sheet_two();
        wide_cut_sheet_three();
    }
}


cut_sheets(width, depth, height);


//back(width, height);

//fixed_shelf_3d(width, depth);
//translate([-width,-depth])
//assembled(width,depth,height);
//side_3d(width,depth,height);
