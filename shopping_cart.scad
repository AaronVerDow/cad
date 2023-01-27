total_width=400;
total_height=800;
total_depth=400;

back_wheels=100;
wheelbase=total_depth+back_wheels;

basket_depth=150;

shelves=3;

in=25.4;
wood=in/2;

wheel_x=40;
wheel_y=80;
wheel_wall=30;

shelf_gap=(total_height-basket_depth-wood)/(shelves+1);

handle_y=100;
handle_z=30;
handle_d=80;

module wheel_outside() {
	offset(wheel_wall)
	square([wheel_x,wheel_y],center=true);
}

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
	hull() {
		square([total_width,total_height]);
		translate([-handle_y,handle_z+total_height])
		circle(d=handle_d);
	}
}

module front() {
	square([total_width,total_height]);
}

module base() {
	hull() {
		square([total_width,total_depth]);
		dirror_x(total_width)
		translate([wood/2,-back_wheels])
		wheel_outside();
	}
}

module shelf() {
	square([total_width,total_depth]);
}

module basket_bottom() {
	square([total_width,total_depth]);
}

module basket_back() {
	square([total_width,basket_depth+wood]);
}


color("magenta")
translate([0,wood,total_height-basket_depth-wood])
rotate([90,0,0])
wood()
basket_back();

translate([0,0,total_height-wood-basket_depth])
color("red")
wood()
basket_bottom();

for(z=[0:shelf_gap:shelf_gap*shelves])
translate([0,0,z])
color("red")
wood()
shelf();

color("red")
wood()
base();

color("blue")
translate([0,total_depth,0])
rotate([90,0,0])
wood()
front();

color("lime")
dirror_x(total_width)
rotate([90,0,90])
wood()
side();
