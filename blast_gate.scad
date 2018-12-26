in=25.4;

// printer extrusion width
extrusion_width=1.2;

// printer layer height 
layer_height=0.4;

// outer diameter of bigger pipe
big_pipe=4*in;

// height of bigger pipe
big_h=1.5*in;

// outer diameter of smaller pipe
small_pipe=3*in;

// height of smaller pipe
small_h=1.5*in;

// how thick is the pipe
pipe_wall=extrusion_width;

// how thick the gate is
gate_h=layer_height*3;

// diameter of bolts
bolt=8;

// make gate bigger than small pipe
gate_extra=5;

// diameter of gate
gate=gate_extra+small_pipe;

// extra on gate to grip
gate_grip=10;

// extra space between gate and the plates
gate_h_gap=0.2;

// extra space around gate
gate_gap=0.2;

// padding for clean differences
pad=0.1;
padd=pad*2;

// how high are the plates
side_h=3;

// general smoothness
$fn=90;

// smoothness for pipes
big_fn=400;

// how close can the bolt get to the gate
bolt_inner_wall=2;

// how close can the bolt get to the edge of the part or the big pipe
bolt_outer_wall=5;

bolt_outer=bolt+bolt_outer_wall*2;
bolt_offset_from_gate=gate/2+bolt_inner_wall+bolt/2;
bolt_offset_from_big_pipe=big_pipe/2+bolt_outer_wall+bolt/2;

module pipe(pipe, height) {
	difference() {
		cylinder(d=pipe,h=height,$fn=big_fn);
		translate([0,0,-pad])
		cylinder(d=pipe-pipe_wall*2,h=height+padd,$fn=big_fn);
	}
}

module bolt_negative(height=side_h) {
	translate([0,0,-pad])
	cylinder(d=bolt,h=height+padd);
}

module bolt_positive(height=side_h) {
	cylinder(d=bolt_outer,h=height);
}

module bolts() {
	if ( bolt_offset_from_gate > bolt_offset_from_big_pipe ) {
		bolts_of_offset(bolt_offset_from_gate,bold_offset_from_big_pipe)
		children();
	} else {
		bolts_of_offset(bolt_offset_from_big_pipe,bolt_offset_from_gate)
		children();
	}
}

module bolts_of_offset(x,y) {
	for(i=[0:90:179]) {
		rotate([0,0,i+45+90])
		translate([x,0,0])
		children();
	}
	translate([big_pipe/2-bolt_outer/2,-y,0])
	children();
	translate([big_pipe/2-bolt_outer/2,y,0])
	children();
}

module plate(height=side_h) {
	difference() {
		hull() {
			bolts()
			bolt_positive(height);
			cylinder(d=gate+bolt_inner_wall*2,h=height);
		}
		bolts()
		bolt_negative(height);
	}
}

module side(pipe, height) {
	pipe(pipe,height);
	difference() {
		plate();
		translate([0,0,-pad])
		cylinder(d=small_pipe,h=side_h+padd);
	}
}

module grip() {
	difference() {
		translate([-gate_grip/2,0,0])
		full_grip();
		translate([pad,0,0])
		gate(padd*2,gate_grip);
	}
}

module full_grip() {
	minkowski() {
		difference() {
			gate();
			translate([-pad,0,-pad])
			gate(padd,padd);
		}
		rotate([90,0,0])
		cylinder(d=gate_grip,h=pad);
	}
}

module assembled_gate(extra=0,extra_h=0) {
	color("lime") {
		gate(extra,extra_h);
		grip();
	}
}

module gate(extra=0,extra_h=0) {
	intersection() {
		hull() {
			cylinder(d=gate+extra,h=gate_h+extra_h);
			translate([gate+extra,0,0])
			cylinder(d=gate+extra,h=gate_h+extra_h);
		}
		hull() {
			translate([gate_grip,0,0])
			plate(gate_h+extra_h);
			plate(gate_h+extra_h);
		}
	}
}

module slide() {
	color("cyan")
	difference() {
		plate(gate_h);
		translate([0,0,-pad])
		gate(gate_gap,gate_h_gap+padd);
	}
}

module assembled(gap=0) {
	translate([0,0,-gate_h-gap])
	assembled_gate();

	translate([0,0,-gate_h-gap*2])
	slide();

	side(big_pipe,big_h);

	translate([0,0,-gate_h-gap*3])
	mirror([0,0,1])
	side(small_pipe,small_h);
}

display="";
if (display == "") assembled(10);
if (display == "blast_gate_big_pipe.stl") side(big_pipe,big_h);
if (display == "blast_gate_small_pipe.stl") side(small_pipe,small_h);
if (display == "blast_gate_slide.stl") slide();
if (display == "blast_gate_gate.stl") assembled_gate();
