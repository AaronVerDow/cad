in=25.4;

top=36*in;

top_h=1*in;

base_h=25*in;
base_base=14*in;
base_top=base_base;
base_min=6*in;
$fn=90;
base_wall=2*in;

//wood=3/4*in;
wood=1/2*in;

function segment_radius(height, chord) = (height/2)+(chord*chord)/(8*height);
base_radius=segment_radius((base_base-base_min)/2,base_h);

COLOR="";

module if_color(_color) {
    if(COLOR == _color || COLOR == "")
    color(_color)
    children();
}

module base_profile(extra=0) {
    rotate_extrude()
    base_half(extra);
}

module base_half(extra=0) {
    difference() {
        square([base_base/2,base_h]);
        translate([base_radius+base_min/2,base_h/2])
        circle(r=base_radius+extra);
    }
}

module top() {
    color("chocolate")
    translate([0,0,base_h])
    cylinder(d=top,h=top_h);
}

// RENDER obj
module profile() {
    top();
    if_color("brown")
    base_profile();
}

module hollow_base_half() {
    difference() {
        base_half();
        base_half(base_wall);
    }
}

module centered_wood() {
    translate([0,0,-wood/2])
    wood()
    children();
}

module wood() {
    linear_extrude(height=wood)
    children();
}

module stave_base() {
    staves=9;
    if_color("brown")
    for(z=[0:360/staves:359])
    rotate([90,0,z])
    translate([0,0,-wood/2])
    wood()
    hollow_base_half();
}


// RENDER obj
// RENDER png
module staves() {
    top();
    stave_base();
}

module slices(count) {
    for(x=[0:top/count:top])
    translate([x-top/2-wood/2,-top/2,-base_h/2])
    cube([wood,top,base_h*2]);
}


module impossibly_sliced() {
    top();
    if_color("brown")
    intersection() {
        rotate([0,20,0])
        slices(20);
        base_profile();
    }
    if_color("brown")
    intersection() {
        rotate([0,0,90])
        slices(2);
        base_profile();
    }
}

// RENDER obj
// RENDER png
module sliced() {
    slice_gap=1.8*in;

    if_color("brown")
    rotate([0,0,90]) {
        rotate([-105,0,0])
        translate([0,0,base_base/2])
        for(z=[0:slice_gap:base_base*2])
        translate([0,0,-z])
        centered_wood()
        projection(cut=true)
        translate([0,0,-base_base/2+z])
        rotate([90+15,0,0])
        base_profile();

        rotate([-90,0,90])
        centered_wood()
        projection(cut=true)
        rotate([90,0,0])
        base_profile();
        translate([0,0,-wood])
        if_color("brown")
        cylinder(d=base_base,h=wood);
    }

    top();
}


module angled_slice(angle=0) {
    projection(cut=true)
    rotate([90+angle,0,0])
    translate([0,0,-base_h/2])
    base_profile();
}

module angled_staves(angle=0) {
    staves=7;
    if_color("brown")
    for(z=[0:360/staves:359])
    rotate([90+angle,0,z])
    centered_wood()
    difference() {
        angled_slice(angle);
        translate([-base_wall,0])
        angled_slice(angle);
    }
}

module pixelated(slices=3,angle=63,width=wood*3) {
    for(z=[0:wood:base_h])
    translate([0,0,z])
    centered_wood()
    difference() {
        projection(cut=true)
        translate([0,0,-z])
        children();
        if(z)
        for(n=[0:360/slices:359])
        rotate([0,0,z/wood*angle+n])
        //square([base_base*1.2,wood*3],center=true);
        translate([0,0,-width/2])
        square([base_base*1.2,width]);
    }
}

// RENDER obj
// RENDER png
module stacked() {
    if_color("brown")
    pixelated(3,62,wood*3)
    difference() {
        base_profile(0);
        base_profile(base_wall);
    }
    top();
}
