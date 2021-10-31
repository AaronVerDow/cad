tank_x=600;
tank_y=240;
tank_lip=6;

light_x=418;
light_y=109;
hole_x=380;
hole_y=light_y;

light_lip=tank_lip;

inlet=15;
inlet_x=55-inlet/2;
inlet_y=55-inlet;

outlet=15;
outlet_x=40-outlet/2;
outlet_y=65-outlet;

io_lip=0;

acrylic=25.4/4;

pad=0.1;

screw_top=0;
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

	if(top){ 
		translate([tank_x/2,tank_y/2])
		square([
			light_x,
			light_y
		],center=true);
	} else {
		translate([tank_x/2,tank_y/2])
		square([hole_x,hole_y],center=true);
	}

	if(screw_top)
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

