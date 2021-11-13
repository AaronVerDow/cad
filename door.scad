door_x=655;
door_y=2010;

stile=101.5;

top_rail=stile;
intermediate_rail=stile;
lock_rail=stile;
mullion=0; // center stile

lock=door_y*0.4;

rail=door_x-stile*2;

echo(rail=rail);

in=25.4;
pad=0.1;

wood=in/2;

cat_x=150;
cat_y=350;
bottom_rail=cat_y;

cat_wall=stile;
$fn=400;

module cat() {
    translate([door_x/2,0]) {
        translate([0,cat_y-cat_x/2])
        circle(d=cat_x);
        translate([-cat_x/2,0])
        square([cat_x,cat_y-cat_x/2]);
    }
}

module dirror_x(x=0) {
    children();
    translate([x,0])
    mirror([1,0])
    children();
}

module dirror_y(y=0) {
    children();
    translate([0,y])
    mirror([0,1])
    children();
}

module dirror_z() {
    children();
    mirror([0,0,1])
    children();
}

module face() {

    color("gray")
    dirror_x(door_x)
    wood()
    stile();

    translate([stile,0])
    wood()
    bottom_rail();

    translate([stile,door_y-stile])
    wood()
    top_rail();

    translate([stile,lock-stile/2])
    wood()
    lock_rail();
}

module lock_rail() {
    square([rail,lock_rail]);
}

module top_rail() {
    square([rail,top_rail]);
}

// RENDER svg
module bottom_rail() {
    difference() {
        union() {
            square([rail,bottom_rail]);
            hull() {
                translate([rail/2,cat_y-cat_x/2])
                circle(d=cat_x+cat_wall*2);
                translate([rail/2,0])
                circle(d=cat_x+cat_wall*2);
            }
        }
        translate([-stile,0])
        cat();
        translate([0,pad-cat_wall*4])
        square([rail,cat_wall*4]);
        
    }
}

module stile() {
    square([stile,door_y]);
}

module wood(height=wood) {
    linear_extrude(height=height)
    children();
}

plywood_x=8*12*in;
plywood_y=4*12*in;

module center() {
    difference() {
        square([door_x,door_y]);
        cat();
    }
}

module assembled() {
    color("cyan")
    translate([0,0,-wood/2])
    wood()
    center();

    dirror_z()
    translate([0,0,wood/2])
    face();
}

stiles=4;
cutgap=in;

//cutsheet();
module cutsheet() {
    color("tan")
    translate([0,0,-2])
    square([plywood_x,plywood_y]);
    
    translate([0,door_x,0])
    rotate([0,0,-90])
    center();

    translate([door_y,door_x+cutgap])
    rotate([0,0,90])
    for(n=[1:1:stiles])
    translate([stile*n-stile+cutgap*n-cutgap,0])
    stile();
    
}

assembled();
