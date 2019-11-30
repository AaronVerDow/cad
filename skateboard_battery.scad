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
battery_shell_h=180;

function wall(x=0) = x + wall;
function walll(x=0) = x + walll;
function pad(x=0) = x + pad;
function padd(x=0) = x + padd;

module screw(x=0,y=0) {
    translate([x,y,-pad()]) {
        cylinder(h=padd(wall()),d=screw);
        translate([0,0,wall])
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

module shell(shell_h) {
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

module esc() {

    screw=3.5;
    //esc_x=34;
    fudge=2;
    esc_x=34+fudge+8;
    esc_y=110;
    esc_z=8;
    $fn=90;

    rec_x=45;
    rec_y=22;
    rec_z=5;

    wall=5-fudge/2;
    walll=wall*2;

    pad=0.1;
    padd=pad*2;
    screw_h=4;

    zip_h=wall/2;
    zip_w=6;

    screw_head=9;
    //set to 6 for nuts
    screw_head_fn=$fn;

    //center=esc_y/2+zip_w/2+screw_head/2;
    center=esc_y/2;


    module esc_zip() {
        translate([0,-zip_w/2,0]) {
            translate([pad,0,-pad])
            cube([wall+pad,zip_w,wall+esc_z+padd]);
            translate([wall+esc_x-pad,0,-pad])
            cube([wall+padd,zip_w,wall+esc_z+padd]);
            translate([0,0,-pad])
            cube([esc_x+walll+padd,zip_w,zip_h+pad]);
        }
    }


    difference() {
        union() {
            hull() {
                // esc 
                cube([esc_x+walll,esc_y,esc_z+wall]);
                // screw 
                translate([-screw/2,center,0])
                cylinder(h=screw_h,d=screw+walll);
                // screw
                translate([esc_x+screw/2+walll,esc_y/2,0])
                cylinder(h=screw_h,d=screw+walll);
            }
            //reciever
            translate([wall*3+screw,center-rec_y/2-wall,0])
            cube([rec_x+wall+esc_x,rec_y+walll,rec_z+wall]);
        }
        // esc hole
        translate([wall,-pad,wall])
        cube([esc_x,esc_y+padd,esc_z+pad]);
        // screw
        translate([-screw/2,center,-pad]) {
            cylinder(h=esc_z*2,d=screw);
            translate([0,0,screw_h])
            cylinder(h=esc_z*2,d=screw_head,$fn=screw_head_fn);
            //cylinder(h=esc_z+walll,d1=screw+walll,d2=screw+walll*2+esc_z*2);
        }
        // screw
        translate([wall+esc_x+screw/2+wall,center,-pad]) {
            cylinder(h=esc_z*2,d=screw);
            translate([0,0,screw_h])
            cylinder(h=esc_z*2,d=screw_head,$fn=screw_head_fn);
            //cylinder(h=esc_z+walll,d1=screw+walll,d2=screw+walll*2+esc_z*2);
        }

        translate([esc_x+wall*3+screw,center-rec_y/2,wall]) {
            // esc
            cube([rec_x,rec_y,rec_z+pad]);
            // esc zip tie
            translate([rec_x/2-zip_w/2,-wall-pad,-wall-pad]) {
                cube([zip_w,rec_y+walll+padd,zip_h+pad]);
                cube([zip_w,wall+padd,rec_z+wall+padd]);
                translate([0,rec_y+wall,0])
                cube([zip_w,wall+padd,rec_z+wall+padd]);
            }
        }
        translate([0,esc_y/5,0])
        esc_zip();
        translate([0,esc_y-esc_y/5,0])
        esc_zip();
    }
}

hole_y=96;

esc_x=120;
esc_y=44;
esc_z=15;

rec_x=45;
rec_y=22;
rec_z=15;

button=11.5;

wires=8;
esc_shell=esc_x+10*2;


module new_esc() { 
    module esc(extra=0,padding=0) {
        translate([0-padding,-hole_y/2-padding,wall])
        cube([esc_x+padding-wall,esc_y+extra-padding,esc_z+padding]);
    }
    difference(){
        esc(wall,0);
        esc(0,pad);
    }
    
    module rec(extra=0, padding=0) {
        translate([esc_x-rec_x-wall-extra,hole_y/2-rec_y-extra,wall])
        cube([rec_x+extra+padding,rec_y+extra+padding,rec_z+padding]);
    }
    difference() {
        rec(wall, 0);
        rec(0, pad);
    }

    
    difference() {
        translate([-batt[x]/2+esc_x/2,0,0])
        outer_body(esc_x-batt[x],walll);
		// cut off bottom
		translate([-batt[x]/2,-outer,-outer*2])
		cube([batt[x]*2,outer*2,outer*2]);

        esc(0,pad);
		
        translate([-pad,hole_y/3,batt[z]/2])
        rotate([0,90,0])
        cylinder(d=button,h=wall+padd);

		// cut off top
		translate([-batt[x]/2,-outer,wall(batt[z])-wires])
		cube([batt[x]*2,outer*2,outer*2]);
        intersection() {
            translate([-batt[x]/2+esc_x/2,0,0])
            outer_body(esc_x-batt[x]-wall*2,pad);
            translate([wall,-hole_y/2,wall])
            cube([esc_x-wall*2,hole_y,batt[z]+pad]);
        }
        y_screws(esc_x/2);
    }

}
module assembled() {
    //translate([0,0,batt[z]*2])
   //shell(battery_shell_h);
	//color("lime")
	//battery_holder();
    new_esc();
    shell(esc_shell);
}


display="";
if (display == "") assembled();
if (display == "skateboard_battery_holder.stl") battery_holder();
if (display == "skateboard_battery_shell.stl") shell(battery_shell_x);
if (display == "skateboard_esc_shell.stl") shell(esc_shell);
if (display == "skateboard_esc_holder.stl") new_esc();
