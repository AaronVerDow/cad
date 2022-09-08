post_x=150;
post_y=350;

max_x=500;
max_y=300;

inset=50;

corner=30;

bolt_x=100;
bolt_y=150;

bolt=16;

bolt_offset=40;

module dirror_x(x=0) {
	children();
	translate([x,0])
	mirror([1,0])
	children();
}

module dirror_y(y=0) {
	children();
	translate([0,y])
	mirror([0,1])
	children();
}

difference() {
	offset(corner)
	offset(-corner)
	translate([-max_x/2,inset-max_y])
	square([max_x,max_y]);

	translate([-post_x/2,0])
	square([post_x,post_y]);

	translate([-bolt_x/2,-bolt_y-bolt_offset])
	dirror_x(bolt_x)
	dirror_y(bolt_y)
	circle(d=bolt);

}

