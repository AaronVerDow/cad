in=25.4;
ft=12*in;
float=150; // gap to ground
counter_height=32*in;  // ground to surface of counter
counter_depth=12*in;
counter_wood=in;
// shelves are on bottom
// bins are on top
shelf_depth=10*in;

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
counter_radius=counter_overhang;
counter_width=width+counter_overhang*2;


total_height=eyeline-float+shade+bin_height;
shelf_height=counter_height-counter_wood-float;

bin_shelf=eyeline+shade+wood;

wire_hole=1.5*in;

module paper_cup() {
    color("white")
    scale(25.4)
    translate([0,0,2.1])
    import("coffee_stuff/paper_cup.stl"); // https://www.cgtrader.com/free-3d-models/food/beverage/paper-coffee-cup-86b8dde0-1eb5-4347-a470-78ec53ea430b
}

module paper_lid() {
    color("white")
    scale(25.4)
    translate([0,0,-1.9])
    import("coffee_stuff/paper_lid.stl"); // https://www.cgtrader.com/free-3d-models/food/beverage/paper-coffee-cup-86b8dde0-1eb5-4347-a470-78ec53ea430b
}

module whiskey(x,y) {
    translate([width*x,bin_depth*y,bin_shelf])
    color("brown",0.1)
    rotate([90,0])
    import("coffee_stuff/whiskey.stl");
}

module paper_lid_stack() {
    h=100;
    gap=8;
    for(z=[0:gap:h])
    translate([0,0,z])
    paper_lid();
}

module paper_cup_stack() {
    h=100;
    gap=8;
    translate([0,0,h+100])
    rotate([180,0,0])
    for(z=[0:gap:h])
    translate([0,0,z])
    paper_cup();
}


translate([width*0.9,shelf_depth*0.7,float+wood])
paper_lid_stack();
translate([width*0.9,shelf_depth*0.4,float+wood])
paper_lid_stack();
translate([width*0.96,shelf_depth*0.7,float+wood])
paper_cup_stack();
translate([width*0.96,shelf_depth*0.4,float+wood])
paper_cup_stack();

module beans(x,y) {
    translate([width*x,bin_depth*y,bin_shelf])
    color("maroon")
    rotate([0,0,90])
    scale(40)
    import("coffee_stuff/coffee_bag.stl"); // https://www.cgtrader.com/free-3d-models/food/beverage/coffee--4
}

whiskey_gap=0.07;
for(x=[0.05:whiskey_gap:0.3])
whiskey(x,0.8);
for(x=[0.05+whiskey_gap/2:whiskey_gap:0.3-whiskey_gap/2])
whiskey(x,0.4);

beans(0.8,0.75);
beans(0.8,0.45);
beans(0.72,0.45);
beans(0.72,0.77);

translate([width*0.9,bin_depth/4*3,bin_shelf])
scale(10)
rotate([0,0,23])
translate([2.6,5.3,7])
rotate([90,0,0])
import("coffee_stuff/french_press.stl"); // https://www.cgtrader.com/free-3d-models/household/kitchenware/french-press--3

module kettle() {
    color("silver")
    rotate([0,0,50])
    scale(1000)
    import("coffee_stuff/kettle.stl"); // https://www.cgtrader.com/free-3d-models/household/kitchenware/electric-kettle-c94b4f42-c3fa-4612-b7e2-05546b213a11
}

module gooseneck() {
    color("dimgray")
    scale(1000)
    import("coffee_stuff/gooseneck.stl"); // https://www.cgtrader.com/free-3d-models/interior/kitchen/pour-over-kettle-style-hario-buono-kettle-1l
}

module chemex() {
    color("white",0.3)
    translate([-80,100,0])
    rotate([90,0,0])
    import("coffee_stuff/chemex.stl"); // https://www.thingiverse.com/thing:3319049/files
}

appliances() {
    grinder();
    decaf_grinder();
    siphon();
    chemex();
    gooseneck();
    kettle();
}

hanging_mugs();

module siphon() {
    top=120;
    top_h=140;
    gap=top+30;
    
    color("white", 0.3)
    translate([-gap/2,0]) {
        translate([gap,0]) {
            translate([0,0,top_h])
            cylinder(d=30,h=100);
            cylinder(d=top,h=top_h);
        }

        ball_h=100;

        translate([0,0,ball_h])
        sphere(d=top);

        translate([0,-top/2-10])
        cylinder(d=10,h=top/2+ball_h);
        translate([-top/2,-top/2])
        cube([top,top,5]);
    }
}

x=0;
y=1;
z=2;

module decaf_grinder() {
    box=[100,130,180];
    top=[80,100,50];

    bin=[60,60,100];
    knob=40;
    knob_h=20;
    module bin() {
        translate([0,-bin[y]/2+box[y]/2+1,bin[z]/2+1])
        cube(bin,center=true);
    }

    module positive() {
        translate([0,0,box[z]/2])
        cube(box,center=true);
    }

    color("dimgray")
    difference() {
        positive();
        bin();
    }

    color("black",0.2)
    bin();

    color("black",0.2)
    translate([0,0,top[z]/2+box[z]-1])
    cube(top,center=true);

    color("dimgray")
    translate([0,box[y]/2,(box[z]-bin[z])/2+bin[z]])
    rotate([-90,0])
    cylinder(d=knob,h=knob_h);
    
}

module grinder() {
    back=150;
    front=100;
    offset=100;
    front_h=200;
    back_h=300;
    bin=front+3;
    bin_h=150;
    module bin(extra=0) {
        translate([1,offset,extra])
        cylinder(d=bin,h=bin_h-extra*2);
    }   
    
    color("gray")
    difference() {
        hull() {
            translate([0,offset])
            cylinder(d=front,h=front_h);
            cylinder(d=back,h=front_h);
        }
        translate([0,0,0])
        bin(5);
    }
    color("white",0.3)
    bin(6);
    color("white",0.3)
    translate([0,0,front_h+1])
    cylinder(d=back,h=back_h-front_h);
    
}






module dirror_x(x=0) {
    children();
    translate([x,0])
    mirror([1,0,0])
    children();
}


module appliances() {
    gap=counter_width/$children;
    for(i=[0:1:$children-1])
    translate([gap/2+gap*i-counter_overhang,counter_depth*0.34,counter_height])
    children(i); 
}

module wood(h=wood) {
    color("tan")
    linear_extrude(height=h)
    children();
}

module assembled() {


    translate([0,wood,float])
    rotate([90,0])
    wood()
    solid_back();

    translate([0,0,counter_height-counter_wood])
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

    translate([width*0.7,counter_depth*0.7,counter_height])
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
    difference() {
        union() {
            square([counter_width,counter_depth/2]);
            offset(counter_radius)
            offset(-counter_radius)
            square([counter_width,counter_depth]);
        }
        dirror_x(counter_width)
        translate([counter_width/6,wire_hole/2+wood*2])
        circle(d=wire_hole);
    }
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

mug_row=6;
hook_length=3*in;

module hanging_mugs() {
    gap=width/mug_row;

    
    for(x=[gap/2:gap:width-gap/2])
    hanging_mug(x,bin_depth/3);

    for(x=[gap:gap:width-gap])
    hanging_mug(x,bin_depth/3*2);
}

module hanging_mug(x=0,y=0) {
    translate([x,y,eyeline+shade-hook_length])
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

    color("white")
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

// RENDER stl
module norender() {
    echo(0);
}
