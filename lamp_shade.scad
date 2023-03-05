in=25.4;

top=4*in;
base=5.2*in;
height=5.2*in;

zero=0.01;


module slice(points=6,od=base) {
	hull()
	for(z=[0:360/points:359])
	rotate([0,0,z])
	translate([od/2,0])
	circle(d=zero);	
}

hull() {
	translate([0,0,height-zero])
	linear_extrude(height=zero)
	slice(points=8,od=top);
	linear_extrude(height=zero)
	slice(points=8);
}

