use <joints.scad>;
in=25.4;
ft=12*in;
wall=3*in;
$fn=200;

wood=in/2;

function segment_radius(height, chord) = (height/2)+(chord*chord)/(8*height);

// how wide top of the rail is
rail_top_width=1.75*in;

// how wide the bottom rail is 
rail_bottom_width=1.125*in;

// how far top of the rail is from the groupd
rail_top=32*in;

// how far the bottom rail is from the ground
rail_bottom=6*in;

// how much to grip the rail
grip=2*in;

spine=6*in;

top_x=25*in;
top_y=13*in;

// how far apart legs are
legs=top_x-3*in*2;

// radius of corners of top
top_r=1*in;

// how hight the desk is from the ground
total_h=46*in;

// radius of corners of leg
leg_r=1*in;


hip_h=8*in;

hip_grip=1*in;

gap=in/8;
hip_pins=1;
leg_pins=2;

leg_inset=1*in;
hip_inset=leg_inset;

top_inset=1.9*in;
    
module top() {
    difference() {
        minkowski() {
            square([top_x-top_r*2,top_y-top_r*2],center=true); 
            circle(r=top_r);
        }
        translate([-top_x/2,wood/2+gap])
        rotate([0,0,-90])
        negative_tails(top_x,wood+gap*2,hip_pins,gap);

        dirror_x()
        translate([-legs/2-gap-wood/2,-top_y/2])
        negative_tails(top_y,wood+gap*2,leg_pins,gap);
    }
}

module top_halo() {
    top=top_y-leg_inset*2;
    //translate([top_inset,total_h-wood]) {
        //difference() {
            //circle(d=top);
            //translate([-top,0])
            //square([top*2,top*2]);
        //}
        //translate([-top/2,0])
        //square([top,wood]);
    //}
    translate([top_inset,total_h-wood]) 
    translate([-top/2,0])
    square([top,wood]);
}

module top_rail_halo() {
    //translate([-rail_top_width/2,rail_top]) #circle(d=grip*2+rail_top_width);
    translate([-rail_top_width/2,rail_top-grip/2])
    square([grip*2+rail_bottom_width, grip],center=true);
}

module bottom_rail_halo() {
    //translate([-rail_top_width/2,rail_bottom]) circle(d=grip*2+rail_bottom_width);
    translate([-rail_top_width/2,rail_bottom-grip/2])
    square([grip*2+rail_bottom_width, grip],center=true);
}


module midpoint() {
    d=grip*2+rail_bottom_width;
    //translate([d/2,rail_top-grip-rail_top_width/2]) circle(d=d);
    translate([top_inset+top_y/2-leg_inset-grip-rail_bottom_width/2,total_h-wood/2])
    square([grip*2+rail_bottom_width, wood],center=true);
}

module leg_positive() {
    // translate([0,leg_gap]) square([spine,total_h-leg_gap]);

    hull() {
        top_halo();
        top_rail_halo();
    }
    hull() {
        top_halo();
        midpoint();
    }

    hull() {
        bottom_rail_halo();
        midpoint();
    }
}

module leg_negative()   {
    rails();
    translate([-top_y/2+top_inset,total_h])
    rotate([0,0,-90])
    negative_pins(top_y,wood,leg_pins,gap);

    translate([-wood/2-gap+top_inset,total_h-hip_h/2])
    square([wood+gap*2,hip_h/2]);
}


module leg() {
    difference() {
        leg_positive();
        leg_negative();
    }
}


pad=0.1;
module rail_top() {
    h=grip+pad;
    translate([-rail_top_width,-h+rail_top])
    square([rail_top_width,h]);
}

module rails() {
    translate([-rail_bottom_width/2-rail_top_width/2,0])
    square([rail_bottom_width, rail_bottom]);
  
    rail_top();
    translate([-rail_top_width*1.5-rail_bottom_width/2-grip,rail_bottom])
    square([rail_top_width, grip*2]);
}
    

module wood() {
    translate([0,0,-wood/2])
    linear_extrude(height=wood)
    children();
}

module dirror_y() {
    children();
    mirror([0,1,0])
    children();
}
module dirror_x() {
    children();
    mirror([1,0,0])
    children();
}

module hip() {
    difference () {
        hull() {
            translate([0,-wood/2+hip_h])
            square([top_x-hip_inset*2,wood],center=true);
            d=hip_grip*2+wood;
            dirror_x()
            translate([legs/2,d/2])
            circle(d=d);
        }
        dirror_x()
        translate([-wood/2-gap+legs/2,0])
        square([wood+gap*2,hip_h/2]);

        translate([-top_x/2,hip_h])
        rotate([0,0,-90])
        negative_pins(top_x,wood,hip_pins,gap);

        r = segment_radius(hip_h/2,legs-wood);
        translate([0,hip_h/2-r])
        circle(r=r);
    }
}

module railing() {
    
    spacing=6*in;
    
    translate([0,-rail_top_width/2,rail_top-rail_top_width/2])
    rotate([0,90,0])
    cylinder(d=rail_top_width,h=top_x*2,center=true);

    translate([0,-rail_top_width/2,rail_bottom-rail_bottom_width/2])
    rotate([0,90,0])
    cylinder(d=rail_bottom_width,h=top_x*2,center=true);

    for(x=[-top_x+spacing/2:spacing:top_x])
    translate([x,-rail_top_width/2,rail_bottom])
    cylinder(d=rail_bottom_width,h=rail_top-rail_bottom-rail_top_width/2);
}

// RENDER png
module assembled() {
    color("red")
    rotate([0,0,90])
    dirror_y()
    translate([0,legs/2])
    rotate([90,0,0])
    wood()
    leg();

    color("blue")
    translate([0,top_inset,total_h-wood/2])
    wood()
    top();

    color("lime")
    translate([0,top_inset,total_h-hip_h])
    rotate([90,0,0])
    wood()
    hip();

    color("gray") railing();
}

// RENDER png
// RENDER svg
// RENDER dxf
module cutsheet() {
    translate([-top_y/2,0]) {
        color("red") leg();
        translate([-top_y,0])
        mirror([1,0])
        color("red") leg();
    }

    translate([top_x/2,top_y/2])
    color("blue")top();

    translate([top_x/2,top_y*1.5])
    color("lime")hip();


    //translate([-2*ft,0,-1]) #square([4*ft,4*ft]);
}

cutsheet();
