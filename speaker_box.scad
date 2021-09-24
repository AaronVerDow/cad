use <joints.scad>;
pad=0.1;
zero=0.001;
in=25.4;
$fn=90;
wood=in/2;


width=400;
height=300;
bottom=200;
top=100;
back_offset=10;

front_angle=atan((bottom-top-back_offset)/height);
back_angle=atan((back_offset)/height);

front=height/cos(front_angle);
back=height/cos(back_angle);

back_extra=sin(back_angle)*wood;
front_extra=sin(front_angle)*wood;

speaker=10*in;

bit=in/4;
x_pins=3;
pintail_gap=in/16;
pintail_holes=0;
pintail_ear=bit;

module dirror_y(y=0) {
	children();
	translate([0,y])
	mirror([0,1])
	children();
}

module dirror_x(x=0) {
	children();
	translate([x,0])
	mirror([1,0])
	children();
}

module wood(h=wood) {
	linear_extrude(height=h)
	children();
}

module top() {
	difference() {
		translate([0,-back_extra])
		square([width,top+front_extra+back_extra]);

		translate([width,-pad-back_extra])
		rotate([0,0,90])
		negative_tails(width,wood+back_extra+pad,x_pins,pintail_gap,pintail_holes,pintail_ear);
		translate([width,top+front_extra+pad])
		mirror([0,1,0])
		rotate([0,0,90])
		#negative_tails(width,wood+front_extra+pad,x_pins,pintail_gap,pintail_holes,pintail_ear);
	}
}

module bottom() {
	difference() {
		square([width,bottom]);
		dirror_y(bottom)
		translate([width,-pad])
		rotate([0,0,90])
		negative_tails(width,wood+back_extra+pad,x_pins,pintail_gap,pintail_holes,pintail_ear);
	}
}

module side() {
	hull() {
		translate([back_offset,height-zero])
		square([top,zero]);
		square([bottom,zero]);
	}
}

module front() {
	difference() {
		square([width,front+front_extra]);
		translate([width/2,front/2])
		circle(d=speaker);
	}
}

module back() {
	difference() {
		square([width,back+back_extra]);
		dirror_y(back+back_extra)
		translate([width,-pad])
		rotate([0,0,90])
		negative_pins(width,wood+back_extra+pad,x_pins,pintail_gap,pintail_holes,pintail_ear);
	}
}

module assembled() {
	color("brown")
	translate([0,back_offset,height-wood])
	wood()
	top();

	color("brown")
	wood()
	bottom();

	color("chocolate")
	dirror_x(width)
	rotate([90,0,90])
	wood()
	side();

	color("peru")
	rotate([90-back_angle,0])
	translate([0,0,-wood])
	wood()
	back();

	color("peru")
	translate([0,bottom,0])
	rotate([90+front_angle,0])
	wood()
	front();
}

assembled();
