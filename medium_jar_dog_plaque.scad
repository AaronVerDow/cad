// medium_jar_base.stl
// medium_jar_lid.stl
// https://www.printables.com/model/52276-medium-sized-jar-with-lid/files

scoop=15;
h=200;
base=10;


difference() {
	import("medium_jar_base.stl");
	hull() {
		translate([0,0,base])
		cylinder(d=scoop,h=h);

		rotate([0,40])
		translate([0,0,base])
		cylinder(d=scoop,h=h);
	}
}
