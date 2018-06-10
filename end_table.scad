square_top=30;
shelves = [2, 1];
// 0 = round
// 1 = square
// 2 = leg_supports (square)
shelf_count = len(shelves);
leg_layers=1;
leg_count = 4;
leg_height = 5.5; // bottom shelf
top_height = 18; //top to ground
min_leg = 2; //smallest size a leg can be
plywood = 0.5;
gap = 1/16;
gapp = gap*2;
pad = 0.1;
padd = pad*2;
leg_thick=plywood*leg_layers;

leg_support=4;

top = sqrt(2*pow((square_top/2),2))*2-leg_thick/2-gap; //diameter
bottom = top-6; //diameter
leg_angle = atan((top-bottom)/2/top_height);
echo("top is", top);

$fn=120;


module shelf(type, diameter,leg_width) {
    if (type == 0)
    round_shelf(diameter, leg_width);
    if (type == 1)
    square_shelf(diameter, leg_width);
    if (type == 2)
    square_shelf_leg_supports(diameter, leg_width);
}

module round_shelf(diameter,leg_width) {
    difference() {
        circle(d=diameter);
        leg_slots(diameter, leg_width);
    }
}

module square_shelf(diameter,leg_width) {
    difference() {
        hull() {
            leg_slots(diameter, leg_width);
        }
        leg_slots(diameter, leg_width);
    }
}

module square_shelf_leg_supports(diameter,leg_width) {
    intersection() {
        square_shelf(diameter, leg_width);
        for(i=[0:leg_count-1]) {
            rotate(i*360/leg_count)
            translate([-leg_support/2,-diameter/2])
            square([leg_support,diameter/2]);
        }
    }
}


module leg_slots(diameter, leg_width) {
    for(i=[0:leg_count-1]) {
        rotate(i*360/leg_count)
        translate([-leg_thick/2-gap,-diameter/2])
        square([leg_thick+gapp,leg_width]);
    }
}

module shelf_number(i) {
        shelf(shelves[i], tan(leg_angle)*((top_height-leg_height)/(shelf_count-1)*i+leg_height)*2+bottom,(tan(leg_angle)*((top_height-leg_height)/(shelf_count-1)*i+leg_height)+min_leg)/2+gap/2);
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
        translate([-leg_thick/2-plywood/2,0,0])
        for(l=[1:leg_layers]) {
            translate([plywood*l,0,0])
            leg_3d();
        }
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

assemble();
//plate();
