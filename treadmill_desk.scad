treadmill_width=500;
in=25.4;
bit=0.25*in;
pad=1;

slide_base_width=300;
slide_top_width=250;
slide_base_depth=200;
slide_top_depth=200;

slide_base_screw=bit;
slide_top_screw=bit;

slide_height=30;

radius=30;

wood=0.5*in;

strut=radius*2;

strut_angle=45;
strut_length=36*in;

panel_x=30;
panel_y=10;

cutgap=bit*3;

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

module cutsheet(layer=0) {
    base_cutsheet(layer)
    slide_top_cutsheet(layer);
}

cutsheet();

module base_cutsheet(layer) {
    translate([0,slide_base_depth/2+radius,0]) {
        if(layer) {
            base_hole();
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

module slide_top_cutsheet() {
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

    translate([0,0,slide_height+wood])
    wood()
    slide_top();
}
