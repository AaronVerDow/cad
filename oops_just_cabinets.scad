in=25.4;
ft=12*in;
float=150; // gap to ground
counter_height=32*in;  // ground to surface of counter
counter_depth=16*in;
counter_wood=in;

*scale(100)
// https://www.cgtrader.com/free-3d-models/food/beverage/coffee--4
import("coffee_stuff/coffee_bag.stl");

*scale(20)
rotate([90,0,0])
// https://www.cgtrader.com/free-3d-models/household/kitchenware/french-press--3
import("coffee_stuff/french_press.stl");

*scale(1000)
// https://www.cgtrader.com/free-3d-models/household/kitchenware/electric-kettle-c94b4f42-c3fa-4612-b7e2-05546b213a11
import("coffee_stuff/kettle.stl");

scale(1000)
// https://www.cgtrader.com/free-3d-models/interior/kitchen/pour-over-kettle-style-hario-buono-kettle-1l
import("coffee_stuff/gooseneck.stl");

// shelves are on bottom
// bins are on top
shelf_depth=12*in;

bin_depth=shelf_depth;
eyeline=5*ft;  // bottom of shade to ground

shade=4*in;
backstop=shade;

back_wood=in/2;
wood=in/2;

bin_height=(counter_height-float)/2;

width=5*ft;

cubby=width/3;

counter_overhang=counter_depth-shelf_depth;
counter_width=width+counter_overhang*2;


total_height=eyeline-float+shade+bin_height;
shelf_height=counter_height-float;

module dirror_x(x=0) {
    children();
    translate([x,0])
    mirror([1,0,0])
    children();
}


module wood(h=wood) {
    linear_extrude(height=h)
    children();
}

module assembled() {


    translate([0,wood,float])
    rotate([90,0])
    wood()
    solid_back();

    translate([0,0,counter_height])
    wood(counter_wood)
    counter();

    translate([0,0,float])
    wood()
    shelf();

    translate([0,0,(shelf_height)/2-wood/2+float])
    wood()
    shelf();

    dirror_x(width)
    translate([0,0,float])
    rotate([90,0,90])
    wood()
    shelf_side();

    translate([0,0,eyeline+shade])
    wood()
    bin_shelf();

    translate([0,0,eyeline+shade+bin_height])
    wood()
    bin_shelf();

    dirror_x(width)
    translate([0,0,eyeline])
    rotate([90,0,90])
    wood()
    bin_side();

    translate([0,bin_depth,eyeline])
    rotate([90,0])
    wood()
    shade();

    dirror_x(width)
    translate([cubby-wood/2,0,float])
    rotate([90,0,90])
    wood()
    shelf_cubby();

    translate([width/2,0,float+shelf_height/2])
    rotate([90,0,90])
    wood()
    shelf_cubby();

    dirror_x(width)
    translate([cubby-wood/2,0,eyeline+shade])
    rotate([90,0,90])
    wood()
    bin_cubby();

    translate([width*0.8,counter_depth*0.7,counter_height+counter_wood])
    mug();
}


assembled();

module shelf_side() {
    square([shelf_depth,shelf_height]);
}

module solid_back() {
    shelf_back();
    translate([0,eyeline-float])
    bin_back();
}

module bin_back() {
    square([width,bin_height+shade]);
}

module shelf_back() {
    square([width,shelf_height]);
    translate([-counter_overhang,counter_height-float])
    square([counter_width,backstop]);
}

module counter() {
    translate([-counter_overhang,0])
    square([counter_width,counter_depth]);
}

module shelf() {
    square([width,shelf_depth]);
}

module bin_shelf() {
    square([width,bin_depth]);
}

module bin_side() {
    square([bin_depth,bin_height+shade]);
}

module bin_cubby() {
    square([bin_depth,bin_height]);
}

module shelf_cubby() {
    square([shelf_depth,shelf_height/2]);
}

module shade() {
    square([width,shade]);
}

mug_gap=6*in;

module hanging_mug() {
    mug(1);
}

module mug(hanging=0) {
    // "Fragments" or fineness. Higher = smoother
    $fn = 20;
    // Rounding of the bottom, radius in mm.
    cornd=10;  // 
    // Height of the cup in mm
    ovrht = 115; 
    // Major radius of the cup in mm.
    cupwd = 41; 
    // Width of the wall  in mm.
    cupwal = 4; 
    // Thickness of handle in mm.
    handlr = 5.25; 
    cornerd = min(cornd,cupwd/2); // Bad things happen if you try to round the bottom too much!
    cupht = ovrht - cornerd - cupwal*.5; // cup height adjusted for other features

    if(hanging) {
        mirror([1,0])
        rotate([0,-45,0])
        translate([-cupwd,0,-cupht*0.8])
        cup();
    } else {
        translate([0,0,cornd])
        cup();
    }

    /* The next functions make a primitive coffee cup from two cylinders and a torus.  */
    module cupprim(h1,r1,rc) {
        cylinder(h1,r1,r1);

        rotate_extrude(convexity=10)
        translate([r1-rc,0,-rc/2])
        circle(r=rc);

        translate([0,0,-rc])
        cylinder(rc,r1-rc,r1-rc);
    }  

    module cup() {
        // This makes the top rim rounded.
        translate([0,0,cupht])
        rotate_extrude(convexity=10)
        translate([cupwd-cupwal/2,0,0])
        circle(r=cupwal/2);

        /* Next, we use difference() function to subtract a smaller primitive from a bigger one to make a shell.*/
        difference() {
            cupprim(cupht,cupwd,cornerd);
            translate([0,0,cupwal])
            cupprim(cupht+.1,cupwd-cupwal,cornerd);
        }     
        // Let's make the handle a torus
        difference () {
            rotate (a=90, v=[1,0,0]) {
                translate([cupwd,.5*cupht,0])
                scale([.75,1,1.75])
                rotate_extrude(convexity=12)
                translate([.4*cupht,0,0])
                circle(r=handlr); 
            }
            translate ([0,0,cupwal])
            cupprim(cupht,cupwd-cupwal,cornerd);
        }
    }

}
