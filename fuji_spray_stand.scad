cup_max=79;
cup_min=30.5;
cup_h=20;
cup_tube=21;

cup_wall=3;
cup_wall_base=2.1;

cone_max=165;
cone_min=1;
cone_h=115;
cone_angle=atan((cone_max/2)/cone_h);

angle_h=cup_h+cup_wall_base;
pad=0.1;
$fn=190;

top_h=30;

to_wall=cone_max/2+cup_wall+10;

beam=15;

total_h=top_h+angle_h;

wall_fillet=20;

back_screw=3.5;
back_screw_l=30;

side_screw=4;
side_screw_head=10;
side_screw_grip=cup_wall;
side_screw_h=to_wall/2;

slice=cup_max+cup_wall-30;

module dirror_y() {
    children();
    mirror([0,1])
    children();
}

module holder_positive() {

    cylinder(d1=cup_min+cup_wall_base*2,d2=cup_max+cup_wall*2,h=angle_h);

    translate([0,0,angle_h]) 
    cylinder(d=cup_max+cup_wall*2,h=top_h);

    translate([-to_wall,-beam/2,0])
    cube([to_wall,beam,total_h]);

	difference() {
		translate([-to_wall,-wall_fillet-beam/2])
		cube([wall_fillet+cup_wall,wall_fillet*2+beam,total_h]);

		dirror_y()
		translate([cup_wall+wall_fillet-to_wall,beam/2+wall_fillet,-pad])
		cylinder(r=wall_fillet,h=total_h+pad*2);
	}
}

// RENDER stl
module gun() {
    difference() {
        holder_positive();

        translate([0,0,-pad])
        hull() {
            cylinder(d=cup_tube,h=angle_h+top_h+pad*2);
            translate([cup_max,0])
            cylinder(d=cup_tube,h=angle_h+top_h+pad*2);
        }

        hull() {
            translate([0,0,angle_h])
            cylinder(d=cup_max,h=top_h+pad*2);
            translate([0,0,cup_wall_base])
            cylinder(d1=cup_min,d2=cup_max,h=cup_h);
        }

        translate([cup_max/2+cup_wall,0,angle_h+slice])
        rotate([90,0])
        *cylinder(d=slice*2,h=cup_max+cup_wall*2,center=true);


        translate([0,0,-pad])
        cylinder(d=cup_min,h=angle_h);


	translate([-to_wall-pad,0,total_h/6*5])
	rotate([0,90])
	cylinder(d=back_screw,h=back_screw_l+pad);

	translate([-to_wall-pad,0,total_h/6])
	rotate([0,90])
	cylinder(d=back_screw,h=back_screw_l+pad);

	side_screws(total_h/6*5);
	side_screws(total_h/6);
    }
}

module side_screws(z) {
	dirror_y()
	translate([-to_wall,beam/2+wall_fillet-side_screw_head/2,z])
	rotate([0,90,0])
	*side_screw();	
}

module side_screw() {
	translate([0,0,-pad])
	cylinder(d=side_screw,h=side_screw_h);
	translate([0,0,side_screw_grip])
	cylinder(d=side_screw_head,h=side_screw_h);
}


strainer_h=total_h;
strainer_start=0;
strainer_tab=28;
strainer_lock=[1.05,0.9];
strainer_lock_h=1;

module cone(extra=0) {
	padding=0.1;
	radius=tan(cone_angle)*cone_h+padding; // this is wrong.  Low pad is close enough

    translate([0,0,strainer_h-cone_h])
    cylinder(d1=cone_min+extra,d2=radius*2+extra,h=cone_h+padding);
}

module strainer_positive() {
    intersection() {
        cone(cup_wall*2);
        cylinder(d=cone_max*2,h=strainer_h-strainer_lock_h);
    }
    translate([-to_wall,-beam/2,0])
    cube([to_wall,beam,strainer_h]);

	difference() {
		translate([-to_wall,-wall_fillet-beam/2])
		cube([wall_fillet+cup_wall,wall_fillet*2+beam,strainer_h]);
		dirror_y()
		translate([cup_wall+wall_fillet-to_wall,beam/2+wall_fillet,-pad*2])
		cylinder(r=wall_fillet,h=total_h+pad*4);
	}

}


// RENDER stl
module strainer() {
	*translate([0,0,strainer_h]) #circle(d=cone_max); // debug cone math 
    difference() {
        strainer_positive();
        cone();


	translate([-to_wall-pad,0,strainer_h/6])
	rotate([0,90])
	cylinder(d=back_screw,h=back_screw_l+pad);

	difference() {
		translate([-to_wall-pad,0,strainer_h/6*5])
		rotate([0,90])
		cylinder(d=back_screw,h=back_screw_l+pad);
		cone(cup_wall*2);
	}

	side_screws(strainer_h/2);
    }
	difference() {
		intersection() {
			translate([0,0,strainer_h-strainer_lock_h])
			cylinder(d=cone_max*2,h=strainer_lock_h);
			cone(cup_wall*2);
		}
		intersection() {
			translate([0,0,strainer_h-strainer_lock_h-pad])
			scale(strainer_lock)
			cylinder(d=cone_max,h=strainer_lock_h+pad*2);
			cone();
		}
		intersection() {
			translate([-strainer_tab/2,-cone_max])
			cube([strainer_tab,cone_max*2,strainer_h+pad*2]);
			cone();
		}
		
	}
}


module all() {
    translate([0,0,100])
    strainer();
    gun();

    translate([lid_to_wall-to_wall,100,50])
    lid();
}


lid_h=16;

lid_outer=66.5;
lid_inner=lid_outer-cup_wall*2;

lid_total_h=lid_h+15;

lid_beam_h=15;

lid_beam_rake=90;

lid_rake=105;
lid_rake_h=20;

lid_to_wall=50;

module lid_cone(extra=0,padding=0) {
	translate([0,0,-padding])
	cylinder(d1=beam+extra,d2=lid_outer+extra,h=lid_total_h+padding*2);
}

module lid_positive() {
    //cylinder(d=lid_outer,h=lid_total_h);
	lid_cone();

    difference() {
        lid_beam();

        translate([-lid_outer/2,0,lid_beam_rake+lid_total_h-lid_h])
        rotate([90,0])
        cylinder(r=lid_beam_rake,h=lid_outer,center=true);

        dirror_y()
        translate([cup_wall+wall_fillet-lid_to_wall,beam/2+wall_fillet,-pad])
        cylinder(r=wall_fillet,h=total_h+pad*2);

	translate([-lid_to_wall-pad,0,lid_beam_h/2])
	rotate([0,90])
	#cylinder(d=back_screw,h=back_screw_l+pad);

	translate([to_wall-lid_to_wall,0])
	side_screws(strainer_h/2);
    }
}

module lid_beam() {
    translate([-lid_to_wall,-beam/2,0])
    cube([lid_to_wall,beam,lid_beam_h]);

    translate([-lid_to_wall,-wall_fillet-beam/2])
    cube([wall_fillet+cup_wall,wall_fillet*2+beam,lid_beam_h]);
}


// RENDER stl
module lid() {
    difference() {
        lid_positive();

        //translate([0,0,-pad]) cylinder(d=lid_inner,h=lid_total_h+pad*2);
	lid_cone(-cup_wall*2,pad);

        translate([lid_outer/2,0,lid_rake_h-lid_rake])
        rotate([90,0])
        *cylinder(r=lid_rake,h=lid_outer,center=true);

    }
}

all();

