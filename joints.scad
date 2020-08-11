module pintail_gaps(edge,depth,pins,gap=0) {
    segments=pins*2+1;
    segment=edge/segments;

    for(y=[segment:segment:edge-1])
    translate([0,y-gap/2])
    square([depth,gap]);
}

module negative_pins(edge,depth,pins,gap=0,hole=0) {
    segments=pins*2+1;
    segment=edge/segments;

    for(y=[0:segment*2:edge])
    translate([0,y])
    square([depth,segment]);

    pintail_gaps(edge,depth,pins,gap);

    if(hole)
    pin_holes(edge,depth,pins,hole);

}

module pintail_test(edge=200,depth=12,pins=4,gap=3,hole=6) {
    color("lime")
    negative_pins(edge,depth,pins,gap,hole);
    color("blue")
    negative_tails(edge,depth,pins,gap,hole);
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

module negative_tails(edge,depth,pins,gap=0,hole=0) {
    segments=pins*2+1;
    segment=edge/segments;

    for(y=[segment:segment*2:edge-1])
    translate([0,y])
    square([depth,segment]);
    pintail_gaps(edge,depth,pins,gap);

    if(hole)
    tail_holes(edge,depth,pins,hole);
}

pintail_test();
