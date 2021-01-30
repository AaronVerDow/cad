motor=26.5;
motor_h=12.5;

weight=13;
weight_h=12;

fudge=0.3;
stick=10+fudge;
stick_h=16;
stick_flat=stick-8.5;

$fn=90;
pad=0.1;

stick_grip=3;

ball=55;

ball_offset=4;

screw=3;
screw_h=12;
screw_head=6;
screw_head_h=3;
screw_grip=2;

screw_ring=motor+screw+8;

screws=5;

bolt_head=10;
bolt_head_h=2.5;
bolt=4;
bolt_h=5;

screw_pilot=0.5;
//explode=(sin($t*360)/2+0.5)*25;
explode=0;

middle_h=13;

wire=7;

//insides();
assembled(30);

module motor(pad=0,extra=0) {
        cylinder(d=motor,h=motor_h+pad);
        translate([0,0,pad])
        cylinder(d=weight,h=weight_h+motor_h-pad+extra);
}

module wire(wire=wire) {
    translate([0,motor/2,0])
    cylinder(d=wire,h=motor_h+pad);
    hull() {
        translate([0,motor/2,0])
        sphere(d=wire);
        translate([0,stick/2-stick_flat,motor_h+weight_h+ball_offset-ball])
        sphere(d=wire);
    }
}

module inner(explode=0) {
    //translate([0,0,explode*5.5]) color("darkslategray") cap_screws();
    
    translate([0,0,explode*4])
    color("darkslategray")
    screws();


    translate([0,0,explode*1.5])
    color("gray")
    motor(-pad);

    translate([0,0,-explode*1.5])
    difference() {
        color("silver")
        stick();
        bolt();
    }

    translate([0,0,explode])
    color("darkslategray")
    bolt(1);

}


module assembled(explode=0) {
    translate([0,0,explode*2.5])
    top();

    inner(explode);

    base();

    translate([0,explode])
    wire_key();

}

wire_key=wire-0.7;

module slice(w,extra=0) {
    difference() {
        intersection() {
            //ball();
            cube([w,ball*1.1,ball*1.1],center=true);
        }
        translate([0,0,extra])
        trim_top();
        translate([0,-extra])
        hull() {
            wire(w+pad*2);
            translate([0,-ball])
            wire(w+pad*2);
        }
    }
}

// RENDER stl
module wire_key() {
    difference() {
        intersection() {
            slice(wire_key);
            ball();
        }
        screws();
    }
}

//base();

module assembled_three(explode=0) {
    translate([0,0,explode*4.5])
    cap();

    translate([0,0,explode*2.5])
    middle();

    inner(explode);

    base();

}


module cap_screws(extra=0,pilot=0,base_extra=0) {
    rotate([0,0,360/screws/2])
    translate([0,0,middle_h])
    screws(extra,pilot,weight+screw*2,base_extra);
}

module insides() {
    inner();
    color("blue") wire();
    #ball();
}

module bolt(display=0) {
    translate([0,0,-bolt_head_h]) {
        difference() {
            cylinder(d1=bolt,d2=bolt_head+pad*2,h=bolt_head_h+pad);
	    if(display)
            translate([0,0,screw_head_h/4+pad])
            cylinder(d=screw_head/3*2,h=screw_head_h/4*3,$fn=6);
        }
        translate([0,0,-bolt_h])
        cylinder(d=bolt,h=bolt_h+pad);
    }
}

module screws(extra=0,pilot=0,ring=screw_ring,base_extra=0) {
    for(r=[0:360/screws:359])
    rotate([0,0,r+90])
    translate([ring/2,0,motor_h+screw_grip]) {
        translate([0,0,-screw_h-base_extra])
        cylinder(d=screw+pilot,h=screw_h+pad+base_extra);
        difference() {
            cylinder(d=screw_head,h=screw_head_h+extra);
            if(!extra)
            translate([0,0,screw_head_h/4+pad])
            cylinder(d=screw_head/3*2,h=screw_head_h/4*3,$fn=6);
        }
    }
}

module trim_top() {
    translate([0,0,ball/2+motor_h])
    cube([ball,ball,ball],center=true);
}

// RENDER stl
module base() {
    difference() {
        ball();
        trim_top();
        motor(pad);
        stick();
        screws();
        bolt();
        wire();
        slice(wire,1);
    }
}



// RENDER stl
module top() {
    difference() {
        ball();
        translate([0,0,-ball/2+motor_h])
        cube([ball,ball,ball],center=true);
        motor(-pad);
        screws(ball,screw_pilot);
    }

}

module cap() {
    difference() {
        ball();
        translate([0,0,-ball/2+motor_h+middle_h])
        cube([ball,ball,ball],center=true);
        motor(-pad);
        cap_screws(ball,screw_pilot);
    }

}

module middle() {
    difference() {
        ball();
        translate([0,0,-ball/2+motor_h])
        cube([ball,ball,ball],center=true);
        motor(-pad,middle_h);
        screws(ball,screw_pilot);

        translate([0,0,ball/2+motor_h+middle_h])
        cube([ball,ball,ball],center=true);
    
        cap_screws(ball,screw_pilot,middle_h);
    }

}

module ball() {
    translate([0,0,motor_h+weight_h-ball/2+ball_offset])
    sphere(d=ball,$fn=200);
}

module stick() {
    translate([0,0,-stick_h*2-stick_grip])
    difference() {
        cylinder(d=stick,h=stick_h*2);
        translate([-stick/2,stick/2-stick_flat,stick_h-pad])
        cube([stick,stick,stick_h+pad*2]);
    }
}
