screw=5;
width=1.25*25.4;
beam_height=12;
lip_height=beam_height/2;

height=lip_height+beam_height;
lip=width/4;

screw_offset=5;
pad=0.1;
$fn=200;

difference() {
	hull() {
		translate([0,lip+screw_offset])
		cylinder(d=width,h=height);
		cylinder(d=width,h=height);
	}
	translate([0,0,-pad])
	cylinder(d=screw,h=height+pad*2);

	translate([-width/2-pad,screw_offset+lip,-pad])
	cube([width+pad*2,width*2,height+pad*2]);

	translate([-width/2-pad,screw_offset,-pad])
	cube([width+pad*2,width*2,beam_height+pad]);
	
}
