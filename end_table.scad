top = 36; //diameter
bottom = 28; //diameter
shelf_count = 3;
leg_count = 3;
leg_height = 4;
top_height = 28; //top to ground
min_leg = 3; //smallest size a leg can be
plywood = 0.5;
gap = 1/16;
gapp = gap*2;
pad = 0.1;
padd = pad*2;

leg_angle = atan((top-bottom)/2/top_height);


module shelf(diameter, leg_width) {
    difference() {
        circle(r=diameter/2);
        for(i=[0:leg_count-1]) {
            rotate(i*360/leg_count)
            translate([-plywood/2-gap,-diameter/2])
            square([plywood+gapp,leg_width/2]);
        }
    }
}

module draw_shelves() {
    for(i=[0:shelf_count-1]) {
        echo((top_height-leg_height)/(shelf_count-1)*i+leg_height);
        translate([0,0,(top_height-leg_height)/(shelf_count-1)*i+leg_height-plywood])
        linear_extrude(height=plywood)
        shelf(tan(leg_angle)*((top_height-leg_height)/(shelf_count-1)*i+leg_height)*2+bottom,(tan(leg_angle)*((top_height-leg_height)/(shelf_count-1)*i+leg_height)+min_leg)/2);
    }
}

//shelf(bottom,min_leg);

module leg() {
    square([min_leg+(top-bottom)/2,top_height]);
}

draw_shelves();
translate([0,-bottom/2+min_leg,0])
rotate([90,0,-90])
translate([0,0,-plywood/2])
linear_extrude(height=plywood)
leg();
