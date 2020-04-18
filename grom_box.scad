in=25.4;
bag_x=16*in;
bag_y=10*in;
bag_z=12*in;

wood=1/2*in;

box_x=bag_x+wood*2;
box_y=bag_y+wood*2;
box_z=8*in;

onewheel_d=10*in;
onewheel_h=7*in;

onewheel_x=22*in;
onewheel_y=2*in;
onewheel_z=8*in;

bit=0.25*in;
cutgap=bit*3;

module dirror_x(x=0) {
    children();
    translate([x,0,0])
    mirror([1,0,0])
    children();
}

module onewheel() {
    #translate([0,0,onewheel_z/2+wood]) {
        cylinder(d=onewheel_d,h=onewheel_h,center=true);
        cube([onewheel_x,onewheel_y,onewheel_z],center=true);
    }
}

module wood(padding=0) {
    translate([0,0,-padding])
    linear_extrude(height=wood+padding*2)
    children();
}

module assembled() {
    onewheel();

    color("lime")
    wood()
    base();

    color("blue")
    dirror_x()
    translate([-box_x/2,0,box_z/2])
    rotate([90,0,90])
    wood()
    side();
}

module cutsheet() {
    base_cutsheet()
    side_cutsheet()
    side_cutsheet();
}

module base_cutsheet() {
    base();
    translate([0,box_y+cutgap,0])
    children();
}

module side_cutsheet() {
    side();
    translate([0,box_z+cutgap,0])
    children();
}

module base() {
    color("lime")
    square([box_x,box_y],center=true);
}

module side() {
    color("blue")
    square([box_y,box_z],center=true);
}

cutsheet();
