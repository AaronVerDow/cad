total_width=400;
total_height=800;
total_depth=400;

in=25.4;
wood=in/2;

module dirror_x(x=0) {
    children();
    translate([x,0])
    mirror([1,0])
    children();
}

module wood(height=wood) {
    linear_extrude(height=height)
    children();
}

module side() {
    square([total_width,total_height]);
}


dirror_x(total_width)
rotate([90,0,90])
wood()
side();


