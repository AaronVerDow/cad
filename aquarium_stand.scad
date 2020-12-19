in=25.4;

back_wood=in/4;
depth=240;

height=715;
short_height=595;

// printer cabinets
width=600;

// other 
wide_width=29.5*in;

//wide_cut_sheets();

wood=0.75*in;

side_wood=wood;
bottom_wood=0;
top_wood=wood;
shelf_wood=wood;

plywood_x=8*in*12;
plywood_y=4*in*12;
plywood_edge=1;

show_plywood=0;
show_pockets=1;
show_profiles=1;

pin=3*in;

tail=pin;


//$fn=90;
$fn=12;
pad=3/16*in;

blind=0;

bit=0.25*in;

door_height=90.125*in;
short_door_height=76.75*in;
door_width=(19+5/8)*in;
door_wood=0.5*in;


// hide or show pins
details=1;

hole=0;

hole_d=0.25*in;

hole_gap=1.25*in;

echo("hole gap");
echo(hole_gap/in);

//from back
//rail_one=depth-1.0625*in;
//rail_three=rail_one-20.5*in;
//rail_two=rail_three+8.5*in;

//from front
rail_one=depth-(1+3/32)*in;
rail_two=rail_one-(10+13/16)*in;
rail_three=rail_two-(8+13/16)*in;


rail_from_top=(1+7/8)*in;

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
shade_h=bottom_shelf-shelf_wood;


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


standard_shelves=[];
fixed_shelves=[];
shaded_fixed_shelves=[];

i3=44.25*in;
polar=16.5*in;
rostock=27.25*in;

shaded_fixed_air_shelves=[
    //rostock,
    //i3,polar,
];

wire_hole=0;
//air_hole=4.25*in;
//air_hole=2*in;

wire_hole_wall=0;

lip=0.25*in;
side_hole_wall=0.25*in;
wire_hole_outer=wire_hole+lip*2;

shelf_bite=shelf_wood-0.25*in;
shade_bite=shelf_bite-0.125*in;

corner_clip=0;

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

module rail(x, height) {
    //for(y=[height-rail_from_top:-hole_gap:bottom_shelf_z]) {
    holes=59;
    total=hole_gap*(holes-1);
    for(y=[0:hole_gap:total]) {
        translate([x,y+height-total-rail_from_top])
        hole();
    }
}

module rails(height) {
    rail(rail_one, height);
    rail(rail_two, height);
    rail(rail_three, height);
}

pin_screw=0.125*in;

module tail_screws(pin_h, tail_h, edge) {
    if (details) {
        for(x=[0:pintail:edge]) {
            translate([x+edge%pintail/2,pin_h/2])
            circle(d=pin_screw);
        }
    }
}


module pin_screws(pin_h, tail_h, edge) {
    translate([-pintail_gap,0])
    if (details) {
        for(x=[pintail:pintail:edge]) {
            translate([x+edge%pintail/2-tail/2-pin/2,tail_h/2])
            circle(d=pin_screw);
        }
    }
}

pintail_gap=in/16;
pintail=pin+tail+pintail_gap*2;

module pin_edge(pin_h, tail_h, edge) {
    translate([-pintail_gap/2,0])
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
        square([pintail/2+pad*2,tail_h]);
    }
}

module tail_edge(pin_h, tail_h, edge) {
    translate([-pintail_gap/2,0])
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
    difference() {
        square([width-side_wood*2,depth-back_wood]);
    }
}

module place_side_holes(side_hole) {
	translate([side_hole/2+lip+side_hole_wall+back_wood,0]) {
		translate([0,bottom_shelf+side_hole/2+lip+side_hole_wall])
		children();
		//translate([0,height-top_wood-side_hole_wall-side_hole/2+lip]) children(); // top
	}
}
module top(width,depth) {
    difference() {
        translate([blind,0])
        square([width-blind*2,depth]);

        mirror_x(width)
        translate([side_wood,depth])
        mirror([0,1])
        rotate([0,0,90]) {
            pin_edge(bottom_wood,side_wood,depth);
            pin_screws(bottom_wood,side_wood,depth);
        }


        translate([0,depth-back_wood])
        tail_edge(back_wood+pad,bottom_wood+pad,width);

        shaded_pockets(width);
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

module side_3d(width,depth,height,side_hole) {
    translate([side_wood,depth,0])
    rotate([0,0,-90])
    rotate([90,0,0])
    difference() {
        linear_extrude(height=side_wood)
        side(depth,height,side_hole);

        translate([0,0,blind])
        linear_extrude(height=side_wood)
        side_cuts(depth,height);

        translate([0,0,wood-hole_d])
        linear_extrude(height=side_wood)
        rails(height);
    }
}

hand=1;

hand_x=110;
hand_y=35;
hand_from_top=50;

module dirror_x() {
    children();
    mirror([1,0])
    children();
}


module hand() {
    hull()
    dirror_x()
    translate([(hand_x-hand_y)/2,0])
    circle(d=hand_y);
}


module side(depth,height,side_hole) { 
	difference () {
		square([depth,height]);

        if(side_hole)
		place_side_holes(side_hole)
		circle(d=side_hole);

        circle(r=corner_clip);
        
        if(hand)
        translate([depth/2,height-hand_y/2-hand_from_top])
        hand();
        
	}
}

module side_cuts(depth,height) {

    // bottom
    if (bottom_wood)
    translate([0,bottom_wood])
    mirror([0,1])
    tail_edge(bottom_wood+pad,side_wood+pad,depth);

    // top
    translate([0,height-top_wood]) {
        tail_edge(top_wood+pad,side_wood+pad,depth);
        tail_screws(top_wood,side_wood,depth);
    }

    // back
    translate([back_wood,0])
    rotate([0,0,90])
    tail_edge(back_wood+pad,side_wood+pad,height);

	place_y(cat(
        [bottom_shelf_z, leveler_z],
        shaded_fixed_air_shelves
    )) {
        tail_holes(shelf_wood,side_wood,depth);
        tail_screws(shelf_wood,side_wood,depth);
    }
}


module sides_3d(width,depth,height,side_hole) {
    mirror_x(width)
    translate([side_wood,0,0])
    mirror([1,0,0])
    side_3d(width,depth,height,side_hole);
}


module leveler() {
    cylinder(d=7/16*in,h=3*in);
    cylinder(d=leveler_foot,h=5/8*in);
}

module place_leveler(width,depth) {
    mirror_x(width)
    translate([leveler_hole/2+side_wood+leveler_wall,leveler_hole/2+leveler_wall])
    children();
}

module place_levelers(width, depth) {
    place_leveler(width,depth)
    children();

    translate([0,depth-corner_clip])
    mirror([0,1])
    place_leveler(width,depth)
    children();
}

module bottom_shelf(width, depth) {
	difference() {
        add_wire_hole(width, depth)
		shaded_fixed_shelf(width, depth);
        place_levelers(width, depth)
        circle(d=socket_hole);
	}
}

module wire_hole_cut_3d(width,depth){
        translate([0,0,shelf_wood/2])
        linear_extrude(height=shelf_wood/2+pad)
        wire_hole(width,depth,lip);
}

module bottom_shelf_3d(width, depth) {
    translate([0,0,bottom_shelf_z])
    difference() {
        shaded_shelf(width)
        linear_extrude(height=shelf_wood)
        bottom_shelf(width, depth);
                
        wire_hole_cut_3d(width,depth);
    }
}


module leveler_shelf(width, depth) {
	difference() {
        add_wire_hole(width, depth)
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
        translate([shelf_wood,depth,0])
        mirror([0,1])
        rotate([0,0,90])
        pin_edge(shelf_wood,side_wood,depth);

        translate([0,depth-back_wood])
        pin_edge(shelf_wood,back_wood+pad,width);
    }
}

module wire_hole(width,depth,extra=0) {
    translate([width-side_wood,depth-back_wood])
    //hull() {
        circle(d=wire_hole+extra*2);
        //translate([0,-wire_hole/2])
        //circle(d=wire_hole+extra*2);
    //}
}

module add_wire_hole(width, depth, extra=0) {
    difference() {
        children();
        wire_hole(width,depth,extra);
    }
}

module shaded_fixed_shelf(width, depth) {
    difference() {
        fixed_shelf(width, depth);
        shaded_pockets(width);
    }
}

module shaded_pockets(width) {
    translate([shelf_wood,shade_y,0]) {
        tail_holes(shade_wood,shelf_wood,width-side_wood*2);
        //tail_screws(shade_wood,shelf_wood,width-side_wood*2);
    }
}

module shaded_fixed_air_shelf_3d(width, depth) {
    shaded_shelf(width)
    linear_extrude(height=shelf_wood)
    shaded_fixed_air_shelf(width, depth);
}



module shaded_fixed_shelf_3d(width, depth) {
    shaded_shelf(width)
    linear_extrude(height=shelf_wood)
    fixed_shelf(width, depth);
}

module shaded_fixed_air_shelf(width, depth) {
    difference() {
        shaded_fixed_shelf(width, depth);
        mirror_x(width)
        translate([air_hole/2+side_wood+lip+side_hole_wall,depth-air_hole/2-back_wood-lip-side_hole_wall])
        circle(d=air_hole);

        translate([width/2+tail,depth-back_wood])
        hull() {
            circle(d=wire_hole/2);
            translate([0,-wire_hole/4])
            circle(d=wire_hole/2);
        }
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



tube_hole=1.5*in;
tube_holes=6;
tube_holes_from_top=20;

module back(width, height) {
    
    difference() {
        union() {
            translate([blind,leveler_z])
            square([width-blind*2,height-leveler_z]);
            if(bottom_wood)
            square([width-blind*2,leveler_z+pad]);
            
        }

        // bottom
        if(bottom_wood)
        translate([0,bottom_wood,0])
        mirror([0,1,0])
        pin_edge(back_wood+pad,bottom_wood+pad,width);

        // top
        translate([0,-top_wood,0])
        translate([0,height]) {
            pin_edge(back_wood,top_wood+pad,width);
            pin_screws(back_wood,top_wood,width);
        }

        // sides
        mirror_x(width)
        translate([side_wood,0])
        rotate([0,0,90]) {
            pin_edge(back_wood,side_wood,height);
            pin_screws(back_wood,side_wood,height);
        }

        place_y(cat(bottom_shelf_z,shaded_fixed_air_shelves)) {
            tail_holes(shelf_wood,back_wood+pad,width);
            tail_screws(shelf_wood+pad,back_wood+pad,width);
        }

        place_y(leveler_z)
        translate([0,shelf_wood,0])
        mirror([0,1,0]) {
            tail_edge(shelf_wood+pad,back_wood+pad,width);
            tail_screws(shelf_wood+pad,back_wood+pad,width);
        }
    
        thx=width-side_wood*2;
        thg=thx/(tube_holes);

        for(x=[thg/2:thg:thx])
        translate([x+side_wood,height-top_wood-tube_hole/2-tube_holes_from_top])
        circle(d=tube_hole);
    }
}

module back_3d(width, depth, height) {
    translate([0,depth,0])
    rotate([90,0,0])
    linear_extrude(height=back_wood)
    back(width, height);
}



module bottom_shade(width) {
	//square([width-side_wood*2,bottom_shelf-bottom_wood-shelf_wood]);
    shade(width,bottom_shelf-bottom_wood-shelf_wood);
}

module bottom_shade_3d(width) {
	translate([side_wood,shade_y,bottom_shelf-shelf_wood+shade_bite])
	rotate([-90,0,0])
	linear_extrude(height=shade_wood)
	bottom_shade(width);
}

module shade(width,shade_h=shade_h) {
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

module plywood(show_plywood=1) {
    line=0.5*in;
    corner=3*in;
    if(show_plywood)
    color("blue")
    translate([0,0,-pad*2])
    square([plywood_x,plywood_y]);
    
    mirror_y(plywood_y)
    mirror_x(plywood_x)
    color("lime")
    translate([0,0,-pad*2]) {
        square([line,corner]);
        square([corner,line]);
    }
}

module assembled(width,depth,height,side_hole=0) {
    color("red")
    sides_3d(width,depth,height,side_hole);
    color("blue")
    top_3d(width,depth,height);

    
    if(bottom_wood)
    color("blue")
    bottom_3d(width, depth);

    color("green")
    back_3d(width, depth, height);

    color("grey")
    place_levelers(width, depth)
    #leveler();

	place_z(fixed_shelves)
	fixed_shelf_3d(width, depth);

	place_z(shaded_fixed_shelves)
	shaded_fixed_shelf_3d(width, depth);

	place_z(shaded_fixed_air_shelves)
	shaded_fixed_air_shelf_3d(width, depth);

	color("cyan")
	place_z(height-top_wood)
    shade_3d(width);
	color("cyan")
	place_z(shaded_fixed_shelves)
    shade_3d(width);
	color("cyan")
	place_z(shaded_fixed_air_shelves)
    shade_3d(width);


	leveler_shelf_3d(width, depth);
	bottom_shelf_3d(width, depth);
	color("cyan")
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

module shade_to_cut(shade_h=shade_h) {
    translate([shade_h,0])
    rotate([0,0,90])
    shade(width,shade_h);
}

module spaced_shade(shade_h=shade_h) {
    for ( i= [0:1:$children-1]) 
    translate([i*(shade_h+2*in),0])
    children(i);
}

module cut_sheet_one(width, depth, height, side_hole, show_plywood=1,show_profiles=1,show_pockets=1) {
    side_one(width, depth, height, width, side_hole, show_plywood, show_profiles, show_pockets)
    translate([0,width])
    if(show_profiles)
    three_skinny_shelves(depth) {

        top(width,depth);
        bottom_shelf(width,depth);
        leveler_shelf(width, depth);
    }
}

module cut_sheet_two(width, depth, height, side_hole, show_plywood=1,show_profiles=1,show_pockets=1) {
    side_two(depth, width, height, width, side_hole, show_plywood, show_profiles, show_pockets)
    translate([0,width])
    if(show_profiles)
    three_skinny_shelves(depth) {
        top(width,depth);
        bottom_shelf(width,depth);
        leveler_shelf(width, depth);
    }
}

module cut_sheet_three(width, depth, height, show_plywood=1,show_profiles=1,show_pockets=1) {
    back_three(depth,width,height,width, show_plywood, show_profiles, show_pockets)
    if(show_profiles)
    spaced_shade() {
    translate([shade_h,0])
    rotate([0,0,90])
        bottom_shade(width);
        shade_to_cut();
        shade_to_cut();
    }
}

module cut_sheets(width, depth, height, side_hole,  show_plywood=1,show_profiles=1,show_pockets=1) {
    spaced_y(plywood_y+6*in) {
        cut_sheet_one(width, depth, height, side_hole, show_plywood,show_profiles,show_pockets);
        cut_sheet_two(width, depth, height, side_hole, show_plywood,show_profiles,show_pockets);
        cut_sheet_three(width, depth, height, show_plywood,show_profiles,show_pockets);
    }
}

module side_to_cut(width,depth,height,gap_y,side_hole,show_profiles=1,show_pockets=1) {
    rotate([0,0,90]) {
        if(show_profiles) {
            difference() {
                side(depth,height,side_hole);
                if(!blind) {
                    side_cuts(depth,height);
                    rails(height);
                }
            }
        }

        if(blind)
        if(show_pockets)
        translate([0,0,pad])
        color("red") {
            side_cuts(depth,height);
            rails(height);
        }
    }
}

module two_wide_shelves(width) {
    shelf_gap_x=(plywood_x-width*2)/2;
    translate([shelf_gap_x/2,0])
    spaced_x(width+shelf_gap_x) {
        children(0);
        children(1);
    }
}


module three_wide_shelves(width) {
    shelf_gap_x=(plywood_x-width*3)/3;
    translate([shelf_gap_x/2,0])
    spaced_x(width+shelf_gap_x) {
        children(0);
        children(1);
        children(2);
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

module side_one(width, depth, height, bottom_row_y,side_hole=0,show_plywood=1,show_profiles=1,show_pockets=1) {
    plywood(show_plywood);
    gap_y=(plywood_y-depth-bottom_row_y)/3;
    translate([height+(plywood_x-height)/2,bottom_row_y+gap_y*2])
    side_to_cut(width,depth,height,gap_y,side_hole,show_profiles,show_pockets);

    translate([0,gap_y])
    children();
}

module side_two(depth, width, height, bottom_row_y,side_hole=0,show_plywood=1,show_profiles=1,show_pockets=1) {
    plywood(show_plywood);
    gap_y=(plywood_y-bottom_row_y-depth)/3;
    gap_x=(plywood_x-height)/2;

    translate([height+gap_x,depth+bottom_row_y+gap_y*2])
    mirror([0,1])
    side_to_cut(width,depth,height,gap_y,side_hole,show_profiles,show_pockets);


    translate([0,gap_y])
    children();

}

module back_three(depth, width, height, bottom_row_y, show_plywood=1,show_profiles=1,show_pockets=1) {
    gap_y=(plywood_y-bottom_row_y-width)/3;
    
    plywood(show_plywood);
    if(show_profiles)
    translate([height+(plywood_x-height)/2,bottom_row_y+gap_y*2])
    rotate([0,0,90])
    back(width, height);


    translate([gap_y,gap_y])
    children();
}

module plywood_text(text) {
    text_h=8*in;
    text(text,text_h,halign="right");
}

gap=6*in;

module wide_cut_sheets(width, depth, height) {
    spaced_y(plywood_y+gap) {

        side_one(width, depth, height, depth)
        two_wide_shelves(width) {
            leveler_shelf(width, depth);
        }

        side_two(depth, width, height, depth)
        two_wide_shelves(width) {
            top(width,depth);
            bottom(width,depth);
        }


        back_three(depth,width,height,0)
        bottom_shade(width, depth);
    }
}

module door(door_h,cabinet_h) {
    translate([0,-door_wood-pad,cabinet_h-door_h])
    cube([door_width,door_wood,door_h]);
}

//door(short_door_height, short_height);

//wide_cut_sheets(wide_width,depth,height);


//translate([-width-gap,-depth-gap])

// rostock
my_height=short_height;
my_side_hole=air_hole;


module high_res() {
    $fn=300;
    children();
}


display="";
//if(display=="") assembled(width,depth,my_height,my_side_hole);
//cut_sheets(width, depth, my_height, my_side_hole, show_plywood, 1, 1);
//if(display=="short_1_profiles.dxf")high_res()
high_res()cut_sheet_one(width,depth,my_height,my_side_hole,0,1,0);
if(display=="short_2_profiles.dxf")high_res()
cut_sheet_two(width,depth,my_height,my_side_hole,0,1,0);
if(display=="short_3_profiles.dxf") high_res()
cut_sheet_three(width,depth,my_height,0,1,0);
