treadmill_width=500;
in=25.4;
bit=0.25*in;
pad=1;

slide_base_width=300;
slide_base_depth=200;

// size of the square
slide_top_width=250;
slide_top_depth=200;


slide_base_screw=bit;
slide_top_screw=bit;

slide_height=30;

radius=30;

wood=0.5*in;

strut=radius*2;

strut_angle=45;
strut_length=36*in;
strut_screw=bit;

panel_x=30;
panel_y=10;

cutgap=bit*3;

top_wing=80;
top_skirt=1*in;
top_x=treadmill_width;
top_y=slide_top_depth+top_wing;

function segment_radius(height, chord) = (height/2)+(chord*chord)/(8*height);

module top(extra=0) {
    r = segment_radius(top_wing-top_skirt, top_x-radius*2);
    minkowski() {
        difference() {
            square([top_x-radius*2,top_y-radius*2],center=true);
            translate([0,-top_y/2-r+radius+top_wing-top_skirt])
            circle(r=r,$fn=200);
        }
        circle(r=radius+extra);
    }
}

module top_edge() {
    difference() {
        top();
        top(-top_skirt);
        translate([0,top_skirt+pad])
        top(-top_skirt);
    }
}

module top_edge_cutsheet(layer=0) {
    if(!layer) 
    translate([top_x/2,top_y/2]) {
        top_edge();
        translate([0,top_y/2-slide_top_depth/2+cutgap])
        slide_top();
    }

    translate([0,top_y+cutgap])
    children();
}

module top_cutsheet(layer=0) {
    translate([top_x/2,top_y/2]) {
        if(!layer)
        top();
        translate([0,top_y/2+cutgap])
        children();
    }
}

module dirror_x(x) {
    children();
    translate([x,0])
        mirror([1,0])
        children();
}

module dirror_y(y) {
    children();
    translate([0,y])
        mirror([0,1])
        children();
}

module strut_mount() {
    translate([-treadmill_width/2+wood,slide_base_depth/2+radius-strut])
        square([treadmill_width-wood*2,strut]);
}

colors=["lime", "blue", "red"];

module cutsheet(layer=0) {
    color(colors[layer])
    strut_cutsheet(layer)
    top_edge_cutsheet(layer)
    top_cutsheet(layer)
    base_cutsheet(layer);
    translate([0,0,1])
    children();
}

module place_strut_cutsheet() {
    children();
    translate([strut+cutgap,0])
    children();
}

module strut_cutsheet(layer=0) {
    translate([strut/2,radius])
    if (layer) {
        place_strut_cutsheet()
        strut_holes();
    } else {  
        place_strut_cutsheet()
        strut();
    }
    translate([strut*2+cutgap*2,0])
    children();
}

cutsheet(0)cutsheet(1);


module strut_ends() {
    children();
    translate([0,strut_length])
    children();
}

module strut_holes() {
    strut_ends()
    circle(d=strut_screw);
}

module strut() {
    hull() {
        strut_ends()
        circle(d=strut);
    }
}


module base_cutsheet(layer) {
    translate([0,slide_base_depth/2+radius,0]) {
        if(layer) {
            base_holes();
        } else {
            base();
        }
        translate([0,slide_base_depth/2+cutgap+radius/2,0])
        children();
    }
}

module slide_base_placement() {
    dirror_x()
    dirror_y()
    translate([-slide_base_width/2,-slide_base_depth/2])
    children();
}

module base_holes() {
    slide_base_placement()
    circle(d=slide_base_screw);
}

module base() {
    difference() {
        hull() {
            slide_base_placement()
            circle(r=radius);
            strut_mount();
        }
        translate([-panel_x/2,-slide_base_depth/2-radius])
        square([panel_x,panel_y]);
    }
}

module slide_top_cutsheet(layer) {
    if(!layer)
    translate([0,slide_top_depth/2])
    slide_top();
}

module slide_top() {
    square([slide_top_width,slide_top_depth],center=true);
}

module wood_hole() {
    translate([0,0,-pad])
    linear_extrude(height=wood+pad*2)
    children();
}

module wood() {
    linear_extrude(height=wood)
    children();
}

module assembled() {
    color("lime")
    difference() {
        wood()
        base();
        
        wood_hole()
        base_holes();
    }

    color("red")
    translate([0,0,slide_height+wood])
    wood()
    slide_top();

    translate([0,-top_y/2+slide_top_depth/2,slide_height+wood*2]) {
        color("blue")
        wood()
        top();
        color("magenta")
        translate([0,0,-wood])
        wood()
        top_edge();
    }
    

    dirror_x()
    translate([treadmill_width/2,slide_base_depth/2,wood/2])
    rotate([-90,0,90])
    difference() {
        wood()
        strut();
        wood_hole()
        strut_holes();
    }

}
