in=25.4;
box_x=12.5*in;
box_y=16.2*in;
box_z=10.5*in;
lid=0.25*in;
lid_h=2.5*in;

plywood_x=8*12*in;
plywood_y=4*12*in;

bit=1/4*in;
cut_gap=bit*3;

cubby_x=box_x+2*in;
cubby_y=box_y/3*2;
cubby_z=box_z+lid_h*1.5;

function segment_radius(height, chord) = (height/2)+(chord*chord)/(8*height);



// https://www.amazon.com/Pieces-Premium-Cedar-Wood-Shims/dp/B07V9PLBZM/
shim_x=1/4*in;
shim_y=(1+7/16)*in;
shim_z=8.75*in;

shim_target=shim_x;
shim_grip=shim_y/3*2+bit/2;

rows=6;
columns=4;
wood=0.75*in;

pad=0.1;

shelf_x_gap=1/8*in;
shelf_y_gap=bit/2;

corner_x=lid_h;
corner_y=lid_h;
extra_top=corner_y;
extra_bottom=corner_y;

shelf_ends=cubby_x/3;

side_x=cubby_y;
side_y=(cubby_z+wood)*(rows-1)+extra_top+extra_bottom+wood;

echo(side_y/in);


shelf_x=wood+(cubby_x+wood)*columns+shelf_ends*2;
shelf_y=cubby_y/3;


module cutsheets() {
    side_cutsheet()
    shelf_cutsheet();
}

module shelf_cutsheet() {
    plywood();
    gap=shelf_y+cut_gap;
    max=cut_gap*rows*2+shelf_y*rows*2-cut_gap;
    for(y=[0:gap:max])
    translate([shelf_x/2,shelf_y/2+y+(plywood_y-max)/2])
    shelf();
}

module side_cutsheet() {
    less_gap=90;
    gap=side_x+cut_gap-less_gap;
    max=cut_gap*columns+side_x*columns+side_x-less_gap*columns-less_gap;
    plywood();

    rotate([0,0,90])
    for(x=[0:gap*2:max])
    translate([side_x/2+x+(plywood_y-max)/2,-side_y/2])
    side();

    rotate([0,0,90])
    for(x=[gap:gap*2:max])
    translate([side_x/2+x+(plywood_y-max)/2,-side_y/2-cubby_x/2-extra_top/2-wood/2])
    side();


    translate([0,plywood_y*1.2])
    children();
}

module plywood() {
    translate([0,0,-1])
    #square([plywood_x,plywood_y]);
}

module assembled() {
    color("cyan")
    sides();
    shelves();
    //boxes();
    //shims();
}

module shims() {
    for(row=[0:1:rows-1])
    for(column=[0:1:columns])
    translate([(cubby_x+wood)*column,0,(cubby_z+wood)*row])
    dirror_y()
    translate([-cubby_x/2,-cubby_y/2+shelf_y+shim_y/2-shim_grip,extra_bottom+wood/2])
    dirror_x(-wood)
    shim();
}

module shim() {
    color("red")
    translate([0,-shim_y/2,-shim_z/2])
    hull() {
        cube([pad,shim_y,shim_z]);
        translate([0,0,shim_z-pad])
        cube([shim_x,shim_y,pad]);
    }
}

module corner() {
    hull() {
        square([corner_x*2+wood,wood],center=true);
        translate([0,-wood/2-corner_y/2])
        square([wood,corner_y],center=true);
    }
}

module corners() {
    for(row=[0:1:rows-1])
    for(column=[0:1:columns])
    translate([(cubby_x+wood)*column,0,(cubby_z+wood)*row+extra_bottom+wood])
    dirror_y()
    translate([-cubby_x/2-wood/2,-cubby_y/2+shelf_y/2,-wood/2])
    rotate([90,0,0])
    wood()
    corner();
}

module box() {
    translate([0,0,box_z/2-lid_h/2+pad]) {
        color("white")
        cube([box_x,box_y,box_z-lid_h],center=true);
        color("gray")
        translate([0,0,box_z/2])
        cube([box_x+lid*2,box_y+lid*2,lid_h],center=true);
    }
}


module cubby() {
    translate([0,0,cubby_z/2])
    #cube([cubby_x,cubby_y,cubby_z],center=true);
}

module fill_cubbies() {
    for(row=[0:1:rows-1])
    for(column=[0:1:columns-1])
    translate([(cubby_x+wood)*column,0,(cubby_z+wood)*row+extra_bottom+wood])
    children();
}

module boxes() {
    fill_cubbies() {
        box();
        //cubby();
    }
}


shelf_cut=shim_grip;

module shelf() {
    radius=segment_radius(shelf_cut,cubby_x-shim_target*2);
    difference() {
        square([shelf_x,shelf_y],center=true);

        for(row=[0:1:rows-2])
        translate([row*(cubby_x+wood)-shelf_x/2+shelf_ends+wood/2,-shelf_y/2+shim_grip/2])
        square([wood+shim_target*2,shim_grip+pad],center=true);

        gap=cubby_x+wood;
        max=cubby_x*columns+wood*columns-wood;
        for(x=[0:gap:max])
        translate([x-gap,-radius-shelf_y/2+shelf_cut])
        circle(r=radius,$fn=400);


    }
}

module dirror_x(x=0) {
    children();
    translate([x,0,0])
    mirror([1,0,0])
    children();
}

module dirror_y(y=0) {
    children();
    translate([0,y,0])
    mirror([0,1,0])
    children();
}


module shelves() {
    for(row=[0:1:rows-1])
    translate([0,0,(cubby_z+wood)*row+extra_bottom+wood])
    dirror_y()
    translate([shelf_x/2-cubby_x/2-wood-shelf_ends,cubby_y/2-shelf_y/2,-wood/2])
    wood()
    shelf();
}

side_cut=shelf_y;

module side() {
    radius=segment_radius(side_cut, cubby_z);
    difference() {
        square([side_x,side_y],center=true);
        dirror_x()
        for(row=[0:1:rows-1])
        translate([side_x/2-shelf_y-shelf_x_gap+shim_grip,(cubby_z+wood)*row+extra_bottom-side_y/2])
        square([shelf_y+pad+shelf_x_gap-shim_grip,wood+shelf_y_gap]);

        dirror_x()
        for(y=[0:cubby_z+wood:side_y-extra_top-extra_bottom-wood*2])
        translate([-radius-side_x/2+side_cut,y-side_y/2+extra_bottom+wood+cubby_z/2])
        circle(r=radius,$fn=400);

    }
}

module wood() {
    linear_extrude(height=wood,center=true)
    children();
}

module sides() {
    for(row=[0:1:rows-2]) {
        translate([row*(cubby_x+wood)-cubby_x/2-wood/2,0,side_y/2])
        rotate([90,0,90])
        wood()
        side();
    }
}

module vr() {
    scale(1/1000)
    children();
}


display="";
if(display=="") shim();
if(display=="bankers_shelf_assembled.stl") vr() assembled();
if(display=="bankers_shelf_box.stl") vr() box();
if(display=="bankers_shelf_side.stl") vr() wood() side();
if(display=="bankers_shelf_shelf.stl") vr() wood() shelf();
if(display=="bankers_shelf_box.stl") vr() box();
if(display=="bankers_shelf_shim.stl") vr() shim();
