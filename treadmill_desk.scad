treadmill_width=500;

slide_base_width=300;
slide_top_width=250;
slide_base_depth=200;
slide_top_depth=200;

radius=30;
in=25.4;

wood=0.5*in;

strut=radius*2;

strut_angle=45;
strut_length=36*in;

panel_x=30;
panel_y=10;

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

module base() {
    difference() {
        hull() {
            dirror_x()
            dirror_y()
            translate([-slide_base_width/2,-slide_base_depth/2])
            circle(r=radius);
            strut_mount();
        }
        translate([-panel_x/2,-slide_base_depth/2-radius])
        square([panel_x,panel_y]);
    }
    translate([0,0,1])
    children();
}

module slide_base() {
}

module wood() {
    linear_extrude(height=wood)
    children();
}

module assembled() {
    wood()
    base();
}

//assembled();
