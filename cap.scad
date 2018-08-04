// A cap for anything
// By Tony Mansson
// Copyright and related rights waived via CC-BY
// Using Dan Kirshners magnificent thread library http://dkprojects.net/openscad-threads/

use <threads.scad>;

layer_h=0.4;
// These are your parameters:
capheight = 16;              // Total height of cap
facets = 8;                 // 6 makes a nut, 100 makes it smooth
thread_diameter = 45.7;     // whole thread is inside this diameter
thread_pitch = 3;            // mm per turn
wall_thickness = 9;          // Wall thickness
top=layer_h*6;
pad=0.1;

raft=40;


// Making a cap....
cap_diameter = thread_diameter + wall_thickness;
cap_radius =  cap_diameter / 2;
hole_length = capheight - top;

translate ([0,0,capheight]) rotate([180,0,0]){
    difference () {
      cylinder (r=cap_radius, h=capheight, $fn=facets);
      translate([0,0,-pad])
      metric_thread (diameter=thread_diameter, pitch=thread_pitch, length=hole_length+pad, internal=true, n_starts=1);
    }
}
display="";
if (display == "cap.stl");
if (display == "cap_with_raft.stl")cylinder(d=raft*2+thread_diameter+wall_thickness*2,h=layer_h);
