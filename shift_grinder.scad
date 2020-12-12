motor=26.5;
motor_h=12.5;

weight=13;
weight_h=12;

stick=10;
stick_h=18;
stick_flat=1.5;

$fn=90;
pad=0.1;

stick_grip=3;

ball=45;

ball_offset=3;

screw=3;
screw_h=12;
screw_head=6;
screw_head_h=3;
screw_grip=2;

screw_ring=motor+screw+1;

screws=6;

bolt_head=10;
bolt_head_h=2.5;
bolt=4;
bolt_h=5;

//explode=(sin($t*360)/2+0.5)*25;
explode=0;

wire=4;


module motor(pad=0) {
        cylinder(d=motor,h=motor_h+pad);
        translate([0,0,pad])
        cylinder(d=weight,h=weight_h+motor_h-pad);
}

module wire() {
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

}

//insides();
assembled(30);

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

module screws(extra=0,pilot=0) {
    for(r=[0:360/screws:359])
    rotate([0,0,r])
    translate([screw_ring/2,0,motor_h+screw_grip]) {
        translate([0,0,-screw_h])
        cylinder(d=screw+pilot,h=screw_h+pad);
        difference() {
            cylinder(d=screw_head,h=screw_head_h+extra);
            if(!extra)
            translate([0,0,screw_head_h/4+pad])
            cylinder(d=screw_head/3*2,h=screw_head_h/4*3,$fn=6);
        }
    }
}

// RENDER stl
module base() {
    difference() {
        ball();
        translate([0,0,ball/2+motor_h])
        cube([ball,ball,ball],center=true);
        motor(pad);
        stick();
        screws();
        bolt();
        wire();
    }
}

screw_pilot=0.5;


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

