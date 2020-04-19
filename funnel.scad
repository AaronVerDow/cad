top_y=47;
top=80;
top_x=top;
bed_x=55;
bed_y=98;
first_layer_h=0.06;
top_z=10;

top_corner=5;

mid_z=40;

angle=45;

bottom=17;
bottom_z=50;

wall=1;
$fn=190;

small_fn=12;

pad=1;

hole=2.5;
hole_gap=0.5;


straw=4;

module top(padding=0,extra=0) {
    translate([0,0,-padding])
    difference() {
        minkowski() {
            sphere(r=top_corner+extra,$fn=42);
            intersection() {
                translate([0,0,top_z/2+padding-top_corner])
                cube([top_x-top_corner*2,top_y-top_corner*2,top_z+padding*2-top_corner],center=true);
                cylinder(d=top-top_corner*2,h=top_z+padding*2-top_corner);
            }
        }
        translate([-top_x/2,-top_y/2,-top_corner-pad])
        cube([top_x,top_y,top_corner+pad]);
    }
}

middle_d=hole+wall*2;

module middle(padding=0,extra=0) {
    hull() {
        top(padding,extra);
        translate([0,0,-padding])
        cylinder(d=middle_d+extra*2,h=top_z+mid_z+padding+extra);
    }
}

straw_angle=atan((top-middle_d)/2/mid_z);
//straw_angle=0;
//translate([0,0,top_z+mid_z])
//rotate([0,straw_angle+180])
//translate([-straw/2-wall,0,(bottom/2-straw/2-wall)/cos(straw_angle)])
side_straw_h=(mid_z+top_z)/cos(straw_angle);

bottom_straw_z=top_z+mid_z-tan(straw_angle)*(bottom/2-straw/2-wall); // ?? I give up
module straw(padding=0,extra=0) {
    straw_seed()
    linear_extrude(height=bottom_z+mid_z)
    children();


    straw_seed()
    translate([-straw/2-wall,0])
    rotate([-90,0,0])
    rotate_extrude(angle=straw_angle)
    translate([straw/2+wall,0]) // ready to rotate
    children();

    straw_seed(straw_angle)
    mirror([0,0,1])
    linear_extrude(height=side_straw_h)
    children();
}

difference() {
    translate([0,0,first_layer_h/2])
    cube([bed_x,bed_y,first_layer_h],center=true);
    translate([0,0,-1])
    rotate([0,0,90])
    top();
}

module straw_seed(a=0) {
    translate([-bottom/2,0,bottom_straw_z]) //bottom_root
    rotate([0,a,0])
    translate([straw/2+wall,0]) // ready to rotate
    children();
}



module old_straw(padding=0,extra=0) {
    color("lime")
    translate([-bottom/2,0,bottom_straw_z])
    rotate([0,straw_angle,0])
    translate([straw/2+wall,0,-side_straw_h])
    cylinder(d=straw+wall*2,h=side_straw_h);
    difference() {
        translate([-bottom/2+straw/2+wall,0,bottom_straw_z])
        cylinder(d=straw+extra*2,h=top_z+mid_z+bottom_z+padding*2);
    }
}


module bottom(padding=0,extra=0) {
    h=top_z+mid_z+bottom_z+padding*2;
    translate([0,0,-padding])
    difference() {
        cylinder(d=bottom+extra*2,h=h);
        translate([0,-bottom/2,0])
        translate([0,0,-pad])
        cylinder(d=straw-extra*2,h=h+pad*2);
    }
}

module main_body() {
    top();
    bottom();
    middle();
}


module assembled() {
    difference() {
        main_body();
        top(0.1,-wall);
        difference() {
            bottom(pad,-wall);
            middle();
        }
        middle(0.1,-wall);
        holes();
        //straw() circle(d=straw);
        translate([0,bottom/2,top_z+mid_z+bottom_z])
        rotate([45,0,0])
        translate([-bottom,-bottom*1.5,0])
        cube([bottom*2,bottom*2,bottom*2]);
    }

}

module complex_straw() {

    intersection() {
        main_body();
        difference() {
            straw() circle(d=straw+wall*2);
            straw() circle(d=straw);
        }
    }
}

rotate([0,0,90])
assembled();

module hole(x=0,y=0) {
    translate([x,y,-pad])
    cylinder(d=hole,h=top_z+mid_z+bottom_z+pad*2,$fn=small_fn);
}


module all_holes() {
    translate([-bottom/2+(bottom%(hole+hole_gap))/2-hole_gap/2-hole/2,-bottom/2+(bottom%(hole+hole_gap))/2-hole/2-hole_gap/2,0])
    for(x=[0:hole+hole_gap:bottom+hole_gap])
    for(y=[0:hole+hole_gap:bottom+hole_gap])
    hole(x,y);
}


module holes() {
    intersection() {
        all_holes();
        bottom(pad,-wall);
    }
}
