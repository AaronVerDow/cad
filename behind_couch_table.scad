in=25.4;
top_x=52*in;
top_y=6*in;
top_z=31.5*in;

spine_h=3*in;
spine_from_end=spine_h;

spine_inset=spine_h;
spine_inset_r=spine_h/2;

wood=in/2;

furnace_x=2.5*in;
furnace_y=9*in;

couch_x=3.75*in;
couch_y=4.5*in;

legs=2;

spacing=top_x/(legs-0.5);

gap=in/8;

module wood() {
    linear_extrude(height=wood)
    children();
}


module top() {
    square([top_x,top_y]);
}

module assembled() {
    translate([0,0,top_z-wood])
    color("blue")
    wood()
    top();

    translate([0,wood/2+top_y/2,top_z-spine_h-wood])
    rotate([90,0,0])
    color("lime")
    wood()
    spine();


    for(x=[spacing/4:spacing:top_x])
    translate([-wood/2+x,0,0])
    rotate([90,0,90])
    color("red")
    wood()
    leg();
}

module dirror_x(x=0){
    children();
    translate([x,0,0])
    mirror([1,0,0])
    children();
}

module spine() {
    
    difference() {
        hull() {
            translate([spine_from_end,spine_h-1])
            square([top_x-spine_from_end*2,1]);
            dirror_x(top_x)
            translate([spine_from_end+spine_inset,spine_inset_r])
            circle(r=spine_inset_r);
        }
        for(x=[spacing/4:spacing:top_x])
        translate([x-wood/2-gap,0])
        square([wood+gap*2,spine_h/2]);
    }
}

module leg() {
    difference() {
        hull() {
            square([top_y,top_z-wood]);
            translate([top_y,0])
            square([couch_x,couch_y]);
        }
        square([furnace_x,furnace_y]);
        translate([top_y/2-wood/2-gap,top_z-wood-spine_h/2])
        square([wood+gap*2,spine_h/2]);
    }
}

assembled();
