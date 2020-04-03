in=25.4;
box_x=12.5*in;
box_y=16.2*in;
box_z=10.5*in;
lid=0.25*in;
lid_h=2.5*in;

cubby_x=box_x+2*in;
cubby_y=box_y/3*2;
cubby_z=box_z+lid_h*1.5;

// https://www.amazon.com/Pieces-Premium-Cedar-Wood-Shims/dp/B07V9PLBZM/
shim_x=1/4*in;
shim_y=(1+7/16)*in;
shim_z=8.75*in;

rows=5;
columns=3;
wood=0.75*in;

pad=0.1;

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

sides();
shelves();
boxes();

for(row=[0:1:rows-1])
for(column=[0:1:columns])
translate([(cubby_x+wood)*column,0,(cubby_z+wood)*row])
dirror_y()
translate([-cubby_x/2,-cubby_y/2+shelf_y/2,extra_bottom+wood/2])
dirror_x(-wood)
shim();

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


module shelf() {
    square([shelf_x,shelf_y],center=true);
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

module side() {
    square([side_x,side_y],center=true);
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
