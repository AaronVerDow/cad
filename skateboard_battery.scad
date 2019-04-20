batt=[140,68,27];
big_fn=200;
$fn=90;
x=0;
y=1;
z=2;

max_y=130;

outer=max_y;
outer_offset=0;
outer_scale=0.53;

batt_side_h=7;

big_hole=max_y-20;

screw=3;
screw_offset=(max_y-batt[y])/4;
screw_driver=12;



pad=0.1;
padd=pad*2;
wall=1.8;
walll=wall*2;
right=[0,90,0];

shell_gap=wall;
shell_h=180;

function wall(x=0) = x + wall;
function walll(x=0) = x + walll;
function pad(x=0) = x + pad;
function padd(x=0) = x + padd;

module screw(x=0,y=0) {
    translate([x,y,-pad()]) {
        cylinder(h=padd(wall()),d=screw);
        translate([0,0,wall*2])
        cylinder(h=batt[z],d=screw_driver);
    }
}

module air_flow() {
    difference() {
        inner_body();
        
        //battery wall
        translate([-pad(),-wall(batt[y]/2),0])
        cube([padd(batt[x]),walll(batt[y]),batt[z]*2]);

        //bottom
        translate([-batt[x]/2,-outer,wall(-outer*2)])
        cube([batt[x]*2,outer*2,outer*2]);

        // top
        translate([-batt[x]/2,-outer,batt[z]])
        cube([batt[x]*2,outer*2,outer*2]);
    }
}

module body(extra) {
    translate([-extra/2,0,-outer_offset])
    scale([1,1,outer_scale])
    rotate(right)
    cylinder(h=batt[x]+extra,d=outer-wall()*2,$fn=big_fn);
}

module inner_body() {
    translate([-pad,0,0])
    body(pad*4);
}

module outer_body(height, extra) {
    minkowski() {
        body(height);
        rotate(right)
        cylinder(d=extra,h=pad);
    }
}

module battery_holder() {
	difference() {
		outer_body(-pad, walll);
		air_flow();
		// battery
		translate([-pad(),-batt[y]/2,-pad()])
		cube([padd(batt[x]),batt[y],pad(batt[z])]);

		// cut off bottom
		translate([-batt[x]/2,-outer,-outer*2])
		cube([batt[x]*2,outer*2,outer*2]);
		
		// cut off top
		translate([-batt[x]/2,-outer,wall(batt[z])])
		cube([batt[x]*2,outer*2,outer*2]);

		// big circle in center
		translate([batt[x]/2,0,wall+batt_side_h])
		cylinder(h=wall(padd(batt[y])),d=big_hole,$fn=big_fn);


		// lower sides of battery holder
		translate([-pad,-batt[y]/2-wall-pad,batt_side_h+wall])
		cube([batt[x]+padd,batt[y]+wall*2+padd,batt[z]-batt_side_h-wall]);
	   
		screws(screw_offset);
		screws(batt[x]-screw_offset);
	}
}

module screws() {
    y_screws(screw_offset);
    y_screws(batt[x]-screw_offset);
}
module y_screws(x=0) {
    y=batt[y]/2+screw_offset;
    screw(x,y);
    screw(x,-y);
}

module shell() {
	difference() {
		outer_body(shell_h-batt[x], wall*4+shell_gap);

		// flat top
		translate([-shell_h/2,-outer,batt[z]+wall+wall+shell_gap])
		cube([shell_h*2,outer*2,outer*2]);

		// flat bottom
		translate([-shell_h/2,-outer,-outer*2])
		cube([shell_h*2,outer*2,outer*2]);

		// inside curve
		difference() {
			outer_body(shell_h-batt[x]+padd, wall*2+shell_gap);

			// flat top
			translate([-shell_h/2,-outer,batt[z]+wall+shell_gap])
			cube([shell_h*2,outer*2,outer*2]);
		}
	}
}

module assembled() {
	translate([0,0,batt[z]*2])
	shell();
	color("lime")
	battery_holder();
}

display="";
if (display == "") assembled();
if (display == "skateboard_battery_holder.stl") battery_holder();
if (display == "skateboard_battery_shell.stl") shell();
