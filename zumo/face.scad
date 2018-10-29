$fn=90;
face_x=98;
face_y=38.7;

led=5.5;
led_box=10;
led_box_h=3.5;

screw=2.5;

eye_gap=50;
eye_x=eye_gap/2;
eye_y=face_y-5.2;

screw_gap=30;
screw_x=screw_gap/2;
screw_y=face_y-7;

ring_center=eye_x-screw_x+3;
ring_thick=2;

ring_outer=ring_center+ring_thick/2;
ring_inner=ring_center-ring_thick/2;
ring_angle=37;

pad=0.1;
padd=pad*2;

mouth_x=35;
mouth_y=5;
mouth_offset=4.2;

teeth=12;
tooth_gap=0.6;

frown=mouth_y/2;
frown_angle=14;

face_thick=0.5;
face_angle=15;

brow_x=ring_inner+ring_thick*2;
brow_y=ring_thick;


module teeth(){
    gap=mouth_x/teeth;
    for(x=[0:gap:mouth_x]) {
        translate([-tooth_gap/2+x,-pad])
        square([tooth_gap,mouth_y+padd]);
    }
}

module half_frown() {
    translate([0,frown])
    rotate([0,0,frown_angle])
    square([mouth_x,mouth_y]);
}

module frown() {
    half_frown();
    translate([mouth_x,0])
    mirror([1,0])
    half_frown();
}

module mouth() {
    translate([-mouth_x/2,mouth_offset])
    difference() {
        square([mouth_x,mouth_y]);
        //teeth();
        frown();
    }
}

module screw() {
    translate([screw_x,screw_y])
    circle(d=screw);
    translate([-screw_x,screw_y])
    circle(d=screw);
}

module screws() {
    screw();
}

module led() {
    hull() {
        circle(d=led);
        translate([-led_box/2,-led_box/2])
        square([led_box,led_box_h]);
    }
}

module ring(d=0) {
    difference() {
        circle(d);
        rotate([0,0,ring_angle])
        translate([-d-pad,0])
        square([d*2+padd,d*2+padd]);
    }
}

module eye() {
    led();
    difference() {
        ring(ring_outer);
        ring(ring_inner);
    }
}

module eyes() {
    translate([eye_x,eye_y])
    eye();
    translate([-eye_x,eye_y])
    mirror([1,0,0])
    eye();
}

module brow() {
    rotate([0,0,ring_angle])
    square([brow_x,brow_y]);
    ring(ring_inner);
}


module face_positive() {
    translate([eye_x,eye_y])
    brow();
    translate([-eye_x,eye_y])
    mirror([1,0,0])
    brow();
    translate([-face_x/2,0])
    square([face_x,face_y]);
}

module face() {
    difference() {
        face_positive();
        eyes();
        //screws();
        mouth();
    }
}

module face_3d() {
    difference() {
        rotate([90-face_angle,0,0])
        translate([0,0,-face_thick])
        linear_extrude(height=face_thick)
        face();
        translate([-face_x/2-pad,0,-face_thick*2])
        cube([face_x+padd,face_thick*2,face_thick*2]);
    }
}

module face_to_print() {
    rotate([90+face_angle,0,0])
    face_3d();
}

face_to_print();
