in=25.4;
side=24*in;
wood=0.5*in;
plywood_x=8*12*in;
plywood_y=4*12*in;

couch=3*12*in;

bit=1/4*in;
cut_gap=bit*3;
leg_h=3*12*in;

leg_from_wall=2*in;
corner=leg_from_wall+wood/2;
leg_from_end=corner*2+1*in;
leg_extra=8*in;

leg_wall=4*in;

pins=3;

//layers
outside=0;
inside=1;
pocket=2;


screw=bit*1.1;

function segment_radius(height, chord) = (height/2)+(chord*chord)/(8*height);

module top_3d() {
    wood()
    difference() {
        top();
        top(pocket);
    }
}

module leg_tail_3d() {
    wood()
    difference() {
        leg_tails();
        leg_tails(pocket);
        leg(-leg_wall);
    }
}

module leg_pin_3d() {
    wood()
    difference() {
        leg_pins();
        leg_pins(pocket);
        leg(-leg_wall);
    }


}

module assembled() {
    color("lime")
    translate([0,0,leg_h+wood])
    top_3d();
    legs();

}

module legs() {
    color("blue")
    translate([leg_from_wall,wood+leg_from_wall,0])
    rotate([90,0,0])
    leg_pin_3d();

    color("red")
    translate([leg_from_wall,leg_from_wall,0])
    rotate([90,0,90])
    leg_tail_3d();
}

leg_cut=8*in;

module leg_tails(layer=outside) {
    color("lime")
    if( layer == outside )
    difference() {
        leg()
        children();
        negative_tails(leg_h,wood,pins);
    }

    color("red")
    if( layer == pocket )
    tail_holes(leg_h,wood,pins,screw);

    color("blue")
    if( layer == inside )
    leg(-leg_wall);
}


module leg_pins(layer=outside) {
    color("lime")
    if( layer == outside )
    difference() {
        leg()
        children();
        negative_pins(leg_h,wood,pins);
    }
    color("red")
    if( layer == pocket )
    pin_holes(leg_h,wood,pins,screw);

    color("blue")
    if( layer == inside )
    leg(-leg_wall);
}


top_pin=3/16*in;
top_tail=1/4*in;
top_pins=1;

leg_x=side-leg_from_wall-leg_from_end;
base_cut=3.5*in;

module leg(extra=0) {
    //t=o/a
    opp=leg_extra;
    adj=leg_h-leg_wall;
    delta=atan(opp/adj);

    // c=a/h
    // 1/c=h/a
    // a/c=h
    hyp=adj/cos(delta);

    radius=segment_radius(leg_cut,hyp);


    base_radius=segment_radius(base_cut,leg_x+leg_extra-leg_wall*2);

    difference() {
        translate([-extra,-extra])
        hull() {
            square([leg_x+extra,leg_h+top_pin+extra*2]);
            square([leg_x+leg_extra+extra*2,leg_wall+extra*2]);
        }

        translate([leg_x+leg_extra,leg_wall])
        rotate([0,0,delta])
        translate([radius-leg_cut,hyp/2])
        circle(r=radius-extra,$fn=400);

        translate([0,leg_h+top_pin])
        rotate([0,0,-90])
        negative_pins(leg_x,top_pin,top_pins);

        translate([(leg_x+leg_extra)/2+wood,base_cut-base_radius])
        circle(r=base_radius-extra,$fn=400);
    }

}

module leg_cutsheet(layer=outside) {
    leg_pins(layer);
    translate([leg_x*2+leg_extra+cut_gap,leg_h+top_pin])
    rotate([0,0,180])
    leg_tails(layer);
    translate([leg_x*2+leg_extra+cut_gap*2,0])
    children();
}

module wood() {
    linear_extrude(height=wood)
    children();
}

module plywood() {
    #square([plywood_x,plywood_y]);
    translate([0,0,1])
    children();
}

module couch(less=0) {
    difference(){
            translate([less,less])
            square([couch-less,couch-less]);
            translate([couch,couch])
            circle(r=couch+less,$fn=400);
    }
}

module inside_top() {
    intersection() {
        square([side-corner,side-corner]);
        couch(corner);
    }
}

module top(layer=outside) {
    color("lime")
    if (layer==outside)
    minkowski() {
        inside_top();
        circle(r=corner);
    }

    color("blue")
    if(layer==pocket) {
        translate([leg_from_wall-bit/2,leg_from_wall,0])
        negative_tails(leg_x,wood+bit,1);
        translate([leg_from_wall,leg_from_wall+wood+bit/2,0])
        rotate([0,0,-90])
        negative_tails(leg_x,wood+bit,1);
    }
}

module cutsheet() {
    plywood()
    cutsheet_layer(outside)
    cutsheet_layer(inside)
    cutsheet_layer(pocket);
}

module cutsheet_layer(layer=outside) {
    leg_cutsheet(layer)
    top(layer);
    translate([0,0,1])
    children();
}

module inside_profiles() {
    translate([0,0,1])
    children();
}

pintail_gap=bit;

module pintail_gaps(edge,depth,pins) {
    segments=pins*2+1;
    segment=edge/segments;

    for(y=[segment:segment:edge-1])
    translate([0,y-pintail_gap/2])
    square([depth,pintail_gap]);
}

module negative_pins(edge,depth,pins) {
    segments=pins*2+1;
    segment=edge/segments;

    for(y=[0:segment*2:edge])
    translate([0,y])
    square([depth,segment]);

    pintail_gaps(edge,depth,pins);
     
}

module pintail_test(count=2) {
    color("lime")
    negative_pins(leg_h,wood,count);
    color("blue")
    negative_tails(leg_h,wood,count);
    color("red")
    translate([0,0,1])
    pintail_holes(leg_h,wood,count,4);
}

module tail_holes(edge,depth,pins,hole) {
    segments=pins*2+1;
    segment=edge/segments;

    for(y=[segment/2:segment*2:edge])
    translate([depth/2,y])
    circle(d=hole);
}


module pin_holes(edge,depth,pins,hole) {
    segments=pins*2+1;
    segment=edge/segments;

    for(y=[segment*1.5:segment*2:edge])
    translate([depth/2,y])
    circle(d=hole);
}

module negative_tails(edge,depth,pins) {
    segments=pins*2+1;
    segment=edge/segments;

    for(y=[segment:segment*2:edge-1])
    translate([0,y])
    square([depth,segment]);
    pintail_gaps(edge,depth,pins);

}

module vr() {
    scale(1/1000)
    children();
}

display="";
if(display=="") assembled();
if(display=="light_stand_assembled.stl") vr() assembled();
if(display=="light_stand_top.stl") vr() top_3d();
if(display=="light_stand_leg_pin.stl") vr() leg_pin_3d();
if(display=="light_stand_leg_tail.stl") vr() leg_tail_3d();
