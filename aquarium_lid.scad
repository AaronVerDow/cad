tank_x=500;
tank_y=300;
tank_lip=10;

light_x=200;
light_y=80;
light_lip=tank_lip;

inlet=25;
inlet_x=100;
inlet_y=60;

outlet=25;
outlet_x=100;
outlet_y=50;

io_lip=0;

acrylic=25.4/4;

pad=0.1;

screw_top=5;
screw_bottom=3.5;

screw_offset=20;

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

module acrylic() {
	linear_extrude(height=acrylic)
	children();
}

module negative(top=0, padding=0) {

	hull() {
		translate([outlet_x,outlet_y])
		circle(d=outlet+io_lip*2*top);
		translate([outlet_x,-outlet])
		circle(d=outlet+io_lip*2*top);
	}

	hull() {
		translate([tank_x-inlet_x,inlet_y])
		circle(d=inlet+io_lip*2*top);
		translate([tank_x-inlet_x,-inlet])
		circle(d=inlet+io_lip*2*top);
	}

	ll=light_lip*2*top-light_lip*2;

	translate([tank_x/2,tank_y/2])
	square([
		light_x+ll,
		light_y+ll
	],center=true);

	dirror_x(tank_x)
	dirror_y(tank_y)
	translate([screw_offset,screw_offset])
	if(top) {
		circle(d=screw_top);
	} else { 
		circle(d=screw_bottom);
	}
}

module assembled() {
	color("cyan")
	translate([0,0,-acrylic-pad])
	acrylic()
	bottom();

	acrylic()
	top();
}

module bottom() {
	difference() {
		square([tank_x,tank_y]);
		negative();
	}
}

module top() {
	difference() {
		translate([-tank_lip,-tank_lip,0])
		square([tank_x+tank_lip*2,tank_y+tank_lip*2]);
		negative(1);
	}
}

assembled();

