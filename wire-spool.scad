include <gridfinity-rebuilt-utility.scad>

// ===== INFORMATION ===== //
/*
 IMPORTANT: rendering will be better for analyzing the model if fast-csg is enabled. As of writing, this feature is only available in the development builds and not the official release of OpenSCAD, but it makes rendering only take a couple seconds, even for comically large bins. Enable it in Edit > Preferences > Features > fast-csg
 the magnet holes can have an extra cut in them to make it easier to print without supports
 tabs will automatically be disabled when gridz is less than 3, as the tabs take up too much space
 base functions can be found in "gridfinity-rebuilt-utility.scad"
 examples at end of file

 BIN HEIGHT
 the original gridfinity bins had the overall height defined by 7mm increments
 a bin would be 7*u millimeters tall
 the lip at the top of the bin (3.8mm) added onto this height
 The stock bins have unit heights of 2, 3, and 6:
 Z unit 2 -> 7*2 + 3.8 -> 17.8mm
 Z unit 3 -> 7*3 + 3.8 -> 24.8mm
 Z unit 6 -> 7*6 + 3.8 -> 45.8mm

https://github.com/kennetek/gridfinity-rebuilt-openscad

*/

// ===== PARAMETERS ===== //

/* [Setup Parameters] */
$fa = 8;
$fs = 0.25;

/* [General Settings] */
// number of bases along x-axis
gridx = 2;  
// number of bases along y-axis   
gridy = 2;  
// bin height. See bin height information and "gridz_define" below.  
gridz = 9;   
// base unit
length = 42;

/* [Compartments] */
// number of X Divisions
divx = 1;
// number of y Divisions
divy = 1;

/* [Toggles] */
// internal fillet for easy part removal
enable_scoop = true;
// snap gridz height to nearest 7mm increment
enable_zsnap = false;
// enable upper lip for stacking other bins
enable_lip = true;

/* [Other] */
// determine what the variable "gridz" applies to based on your use case
gridz_define = 0; // [0:gridz is the height of bins in units of 7mm increments - Zack's method,1:gridz is the internal height in millimeters, 2:gridz is the overall external height of the bin in millimeters]
// the type of tabs
style_tab = 1; //[0:Full,1:Auto,2:Left,3:Center,4:Right,5:None]

// overrides internal block height of bin (for solid containers). Leave zero for default height. Units: mm
height_internal = 0; 

/* [Base] */
style_hole = 3; // [0:no holes, 1:magnet holes only, 2: magnet and screw holes - no printable slit, 3: magnet and screw holes - printable slit]
// number of divisions per 1 unit of base along the X axis. (default 1, only use integers. 0 means automatically guess the right division)
div_base_x = 0;
// number of divisions per 1 unit of base along the Y axis. (default 1, only use integers. 0 means automatically guess the right division)
div_base_y = 0; 


spool=56;
spool_h=22;

zero=0.01;

spool_top=spool*1.6;
spool_top_z=spool*1.5;

spool_z=5;

hole=40;

module dirror_x() {
	children();
	mirror([1,0])
	children();
}

wire=3;

low_wire=4;
high_wire=spool-4;

viewx=spool_h*0.75;
viewz=spool*0.7;
viewr=3;

my_fn=90;

module wire(x,z=0) {
	translate([x,gridy/2*length+length/2,spool_z+z])
	rotate([90,0])
	cylinder(d=wire,h=gridy/2*length+length);
}

module spool(x=0) {
	translate([x,0,spool_z])
	hull() {
		translate([-spool_h/2,0,spool/2])
		rotate([0,90,0])
		cylinder(d=spool,h=spool_h,$fn=my_fn);
	
		translate([-spool_h/2,-spool_top/2,spool_top_z])
		cube([spool_h,spool_top,zero]);
	}
	translate([x-viewx/2,gridy/2*length+length/2,spool_z+spool/2-viewz/2])
	rotate([90,0])
	linear_extrude(height=gridy*length+length)
	offset(viewr)
	offset(-viewr)
	square([viewx,viewz]);
	//wire(x,low_wire);
	wire(x,high_wire);
}

module positive() {
	gridfinityInit(gridx, gridy, height(gridz), 0, length);
	gridfinityBase(gridx, gridy, length, 0, 0, 1);
}
difference() {
	positive();
	spool();
	dirror_x()
	spool(spool_h+4);

	
	translate([-length/2-gridx/2*length,0,spool_z+spool/2])
	rotate([0,90])
	cylinder(d=hole,h=gridx*length+length,$fn=my_fn);
}
