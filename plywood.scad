COLOR="";

module if_color(_color) {
    if(COLOR == _color || COLOR == "")
    color(_color)
    children();
}

module plywood(veneer=0.5, layers=3, height=12, glue=0.2, max_x=1000, max_y=1000) {

	module layer(start, end) {
		intersection() {
			translate([-max_x/2, -max_y/2, start])
			cube([max_x, max_y, end-start]);
			children();
		}
	}

	range=height-veneer*2;

	glue_gap=range/(layers);
	layer_gap=range/(layers);

	// glue
	if_color("#72481f")
	for(z=[0:glue_gap:range])
	layer(z+veneer-glue/2,z+veneer+glue/2)
	children();

	// outer inner layers
	if_color("#b78d64")
	for(n=[0:2:layers-1])
	layer(n*layer_gap+veneer+glue/2,n*layer_gap+veneer+layer_gap-glue/2)
	children();

	// middle inner layers
	if_color("#9e734a")
	for(n=[1:2:layers-1])
	layer(n*layer_gap+veneer+glue/2,n*layer_gap+veneer+layer_gap-glue/2)
	children();
	
	// veneer
	if_color("#dca97a") {
		layer(0,veneer-glue/2)
		children();

		layer(height-veneer+glue/2,height)
		children();
	}
	
}

// RENDER obj
module test() {
	test_height=12;
	plywood()
	difference() {
		cube([test_height*3,test_height*3,test_height]);
		translate([0,0,test_height])
		sphere(r=test_height);

	}
}

test();
