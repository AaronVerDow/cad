include <polyScrewThread_r1.scad>

PI=3.141592;
od=34;
delta=0.5;
od_nut=od+delta;
thread_step=8;
step_shape_deg=55;
thread_length=100;
resolution=1.5;
//resolution=1.5;
countersink=2;
between_flats=64;
hex_h=24;

hook_od=18;
hook_or=hook_od/2;
hook_wall=4;
hook_ir=hook_or-hook_wall;

pad=0.1;

//screw();
nut();
module screw() {
  hex_screw(od,  // Outer diameter of the thread
             thread_step,  // Thread step
            step_shape_deg,  // Step shape degrees
            thread_length,  // Length of the threaded section of the screw
           resolution,  // Resolution (face at each 2mm of the perimeter)
            countersink,  // Countersink in both ends
            between_flats,  // Distance between flats for the hex head
             hex_h,  // Height of the hex head (can be zero)
             0,  // Length of the non threaded section of the screw
             0);  // Diameter for the non threaded section of the screw
	translate([0,0,thread_length+hex_h])
	rotate([0,90,0]) {
		difference() {
			cylinder(h=hook_wall,r=hook_or,center=true);
			cylinder(h=hook_wall+pad*2,r=hook_ir,center=true);
		}
	
	}
}
 
module nut() {
 hex_nut(between_flats,  // Distance between flats
           hex_h,  // Height 
           thread_step,  // Step height (the half will be used to countersink the ends)
          step_shape_deg,  // Degrees (same as used for the screw_thread example)
          od_nut,  // Outer diameter of the thread to match
         resolution);  // Resolution, you may want to set this to small values
}
