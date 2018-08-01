filament=1.2;
wall=filament*4;
$fn=50;

display="";

//cap
top_wall=3;
shaft=7;
knob=22;
knob_h=29;
knob_lip=26.5;
knob_lip_h=4.5;
//cap

knob_lock=knob_lip; 
knob_lock_w=8.5; 

// body
lid_h=3;
lid_top=knob_lip;
lid_bottom=lid_top-lid_h;
silo=36;
silo_h=107;
grinder=39.8;
grinder_h=34;
chute=42;
chute_h=3;
flair_h=19;
// body
grinder_lock=42; 
grinder_lock_w=12.5; 
//grinder_h=34(grinder_lock-grinder)/2;

grinder_h=37;

base_h=flair_h+chute_h+grinder_h+silo_h+lid_h;
profile_d=base_h*4;
profile_r=profile_d/2;
base_min=grinder+wall*2;
base_max=100;


cap=base_min+6;
cap_offset=6;
shaft_wall=2;
shaft_h=cap-cap_offset-shaft_wall;
cap_h=knob_lip_h+knob_h+shaft_h+top_wall;

extrusion_width=1.2;

pad=0.1;
padd=pad*2;

module locks(diameter, width, height, count) {
    for(i=[0:360/count:359]) {
        rotate([0,0,i])
        lock(diameter, width, height);
    }
}

module lock(diameter, width, height) {
    intersection() {
        union() {
            cylinder(d=diameter, h=height);
            translate([0,0,height])
            cylinder(d1=diameter, d2=diameter/2, h=diameter/4);
        }
        translate([0,-width/2,-pad])
        cube([diameter/2+pad,width,height+height/4+padd]);
    }
}

module cap_positive() {
    translate([0,0,cap/2-cap_offset])
    sphere(d=cap);
}
module cap_negative() {
    shaft();
    knob();
    knob_lip();
    translate([0,0,-cap])
    cylinder(d=cap,h=cap);
}
module cap() {
    difference() {
        cap_positive();
        cap_negative();
    }
}

module shaft() {
    translate([0,0,-pad])
    cylinder(d=shaft,h=shaft_h+pad);
}
module knob() {
    translate([0,0,-pad]) {
        cylinder(d=knob,h=knob_h+pad);
        locks(knob_lock, knob_lock_w, knob_h+pad-(knob_lock-knob)/2, 3);
    }
    translate([0,0,knob_h]) {
        cylinder(d1=knob, d2=0, h=knob/2);
        children();
    }
}

module knob_lip() {
    translate([0,0,-pad])
    cylinder(d=knob_lip,h=knob_lip_h+pad);
    translate([0,0,knob_lip_h]) {
        cylinder(d2=knob_lip/2, d1=knob_lip, h=knob_lip/4);
        children();
    }
}

module base() {
    difference() {
		base_positive();
		base_negative();
    }
}

module base_positive() {
	rotate_extrude()
	base_profile();
}

module lid_bottom(p=0) {
	translate([0,0,-p])
	cylinder(d=lid_bottom, h=lid_h/2+p*2);
	translate([0,0,lid_h/2]) children();
}

module lid_top(p=0) {
	cylinder(d=lid_top, h=lid_h/2+p);
	translate([0,0,lid_h/2]) children();
}

module lid_shaft() {
    translate([0,0,-pad])
    cylinder(d=shaft,h=lid_h+padd);
}

module lid() {
	difference() {
		lid_bottom() lid_top();
        lid_shaft();
	}
}


module lid_to_print() {
    $fn=200;
    rotate([180,0,0])
    lid();
}


module silo() {
    module top() {
        cylinder(d2=lid_bottom-padd, d1=lid_bottom+silo_h*2+padd,h=silo_h+padd);
    }
    module bottom() {
        cylinder(d2=grinder+silo_h*2+padd, d1=grinder-padd,h=silo_h+padd);
    }
    translate([0,0,-pad])
    intersection() {
        top();
        bottom();
    }
	translate([0,0,silo_h]) children();
}

module chute() {
    translate([0,0,-pad])
    cylinder(d=chute,h=chute_h+pad);
	translate([0,0,chute_h]) {
        cylinder(d2=chute/2,d1=chute,h=chute/4);
        children();
    }
}
module grinder() {
	chute()
	grinder_body()
	children();
}

module grinder_locks() {
    locks(grinder_lock, grinder_lock_w, grinder_h-(grinder_lock-grinder)/2+pad, 2);
}
module grinder_body() {
    translate([0,0,-pad]) {
        cylinder(d=grinder,h=grinder_h+pad);
        grinder_locks();
    }
	translate([0,0,grinder_h]) {
        cylinder(d1=grinder,d2=grinder/2,h=grinder/4);
        children();
    }
}

module flair() {
    translate([0,0,-pad])
	cylinder(d2=chute-padd, d1=chute+flair_h*2+padd,h=flair_h+padd);
	translate([0,0,flair_h]) children();
}


module base_profile(diff=0, p=0) {
    difference() {
		translate([0,-p])
        square([base_max/2,base_h+p*2]);
		$fn=100;
        translate([profile_r+base_min/2+diff,base_h/2])
        circle(d=profile_d);
    }
}

module cap_profile() {
    square([cap/2,cap_h]);
}

module assembled() {
    base();
    translate([0,0,base_h+10])
    lid();
    translate([0,0,base_h+50])
    cap();
}

module base_to_print() {
    $fn=200;
    rotate([0,180,0])
    base();
}

module cap_to_print() {
    $fn=200;
    cap();
}

module base_negative_raw() {
	flair()
    grinder()
	silo()
	lid_bottom(pad)
	lid_top(pad);
}

module base_negative() {
    intersection() {
        rotate_extrude()
        base_profile(-wall, pad);
		base_negative_raw();
	}
}

module test_overlap() {if ($children > 1 ) { for (i = [0 : $children - 2]) { for (j = [i + 1 : $children - 1]) { intersection() { children(i); children(j); } } } } }

module timeline() {
    module spaced(x=0, y=0) {
        for( i= [0:1:$children-1])
        translate([x*i,y*i,0])
        children(i);
    }

    module label(string) {
		rotate([0,0,45])
        translate([30,0,0])
        linear_extrude(pad)
        text(string);
        children();
    }

	spaced(x=base_min*2) {
		label("");
        label("cap") cap();
        label("cap_negative") {
            #cap_positive();
            cap_negative();
        }
        label("shaft") shaft();
        label("knob") knob();
        label("knob_lip") knob_lip();
    }
	spaced(y=base_min*2) {
		label("assembled") assembled();
		label("base_negative") {
			#base_positive();
			base_negative();
		}	
		label("");
        label("base_negative_raw")#base_negative_raw();
		label("");
        label("flair") #flair();
		spaced(x=80) {
			label("grinder") #grinder();
			label("chute") #chute();
			label("grinder_body") #grinder_body();
			label("grinder_locks") grinder_locks();
		}
        // too big
		// label(""); label("silo") #silo(); label("");
		spaced(x=40) {
			label("lid") lid();
			label("lid_top") #lid_top();
			label("lid_bottom") #lid_bottom();
            label("lid_shaft") {
                lid_shaft();
            }
		}
        label("base_profile") base_profile();
	}
}
 
if (display == "") timeline();
if (display == "pepper_base.stl") base_to_print();
if (display == "pepper_cap.stl") cap_to_print();
if (display == "pepper_lid.stl") lid_to_print();
