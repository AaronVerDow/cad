inc = 32;
start = 2;
end = inc;
slots = 15;
height = 0.1;
plate_x = 16*25.4;
plate_y = 12*25.4;
gap_y = 2.5;

translate([0,0,-height])
cube([plate_x,plate_y,height]);
for(x = [start:end]) {
	translate([0,plate_y%(x/inc*25.4*gap_y)/2,0])
	for (y = [0:plate_y/(x/inc*25.4*gap_y)]) {
		color("red")
		translate([x*25.4,y*x/inc*25.4*gap_y,0])
		cylinder(r=x/inc*25.4/2,h=height);
	}
}
