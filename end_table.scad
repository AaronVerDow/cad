top = 36; //diameter
bottom = 25; //diameter
shelf_count = 2;
leg_count = 4;
leg_height = 8;
top_height = 28; //top to ground
min_leg = 2; //smallest size a leg can be
plywood = 0.5;
gap = 1/16;
gapp = gap*2;
pad = 0.1;
padd = pad*2;

leg_angle = atan((top-bottom)/2/top_height);

$fn=120;


module shelf(diameter,leg_width) {
    difference() {
        circle(r=diameter/2);
        for(i=[0:leg_count-1]) {
            rotate(i*360/leg_count)
            translate([-plywood/2-gap,-diameter/2])
            square([plywood+gapp,leg_width]);
        }
    }
}

module shelf_number(i) {
        shelf(tan(leg_angle)*((top_height-leg_height)/(shelf_count-1)*i+leg_height)*2+bottom,(tan(leg_angle)*((top_height-leg_height)/(shelf_count-1)*i+leg_height)+min_leg)/2+gap/2);
}

module assemble_shelves() {
    for(i=[0:shelf_count-1]) {
        translate([0,0,(top_height-leg_height)/(shelf_count-1)*i+leg_height-plywood])
        linear_extrude(height=plywood)
        shelf_number(i);
    }
}

module assemble_legs() {
    for(i=[0:leg_count-1]) {
        rotate(i*360/leg_count)
        leg_3d();
    }
}

//shelf(bottom,min_leg);

module leg() {
    difference() {
        square([min_leg+(top-bottom)/2,top_height]);
        translate([min_leg,0])
        rotate(-leg_angle)
        square([min_leg+(top-bottom),top_height*2]);
        for(i=[0:shelf_count-1]) {
            translate([0,(top_height-leg_height)/(shelf_count-1)*i+leg_height-plywood-gap])
            square([(tan(leg_angle)*((top_height-leg_height)/(shelf_count-1)*i+leg_height)+min_leg)/2+gap/2,plywood+gapp]);
        }
            
    }
}

module leg_3d() {
    translate([0,-bottom/2+min_leg,0])
    rotate([90,0,-90])
    translate([0,0,-plywood/2])
    color("lime")
    linear_extrude(height=plywood)
    leg();
}

module assemble() {
    assemble_shelves();
    assemble_legs();
}

tree=2;

module plate() {
    for(i=[0:leg_count/2-1]) {
        translate([i*((top-bottom)/2+min_leg*2+tree*2),0]) {
            leg();
            translate([min_leg+(top-bottom)/2+tree+min_leg,top_height])
            rotate(180)
            leg();
        }
    }
    if(leg_count%2 != 0) {
            translate([floor(leg_count/2)*((top-bottom)/2+min_leg*2+tree*2),0])
            leg();
    }
    translate([0,-top/2-tree])
    for(i=[0:shelf_count-1]) {
        //too much math, I can drag in inkscape
        translate([top*i,0])
        shelf_number(i);
    }
}

//assemble();
plate();
