tube=30;
height=tube;
screw=3;
taper=1;

slit=0.5;
slits=3;

corner=3;

base=3;

pad=0.1;

$fn=90;

difference() {
	translate([0,0,-corner])
	minkowski() {
		cylinder(d=tube-corner*2,h=height);
		sphere(r=corner);
	}
	translate([0,0,-pad])
	cylinder(d1=screw,d2=screw-taper,h=height+pad*2);
	
	for(z=[0:360/slits:359])
	rotate([0,0,z])
	translate([0,-slit/2,base])
	cube([tube,slit,height]);

	translate([0,0,-corner*4])
	cylinder(d=tube+pad*2,h=corner*4);
}
