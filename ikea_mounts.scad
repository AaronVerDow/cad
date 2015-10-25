$fn=140;
lamp_d=15;
lamp_r=lamp_d/2;
wire=5;
lamp_head_d=33;
lamp_head_r=lamp_head_d/2;
lamp_head_grip=20;
d=50;
r=d/2;
lip=20;
lip_h=7;
lamp_h=65-lip_h;
pad=0.1;
padd=pad*2;
gap=1;
lock=2;
wall=5;

screw_d=5;
screw_r=screw_d/2;

screw_head_d=10;
screw_head_r=screw_head_d/2;
screw_head_h=screw_head_r/2;

mount_w = 150;
mount_h = lip_h+gap*2+lock+wall;
screw_from_edge=10;
s=mount_w/2-screw_from_edge;


module screw() {
    translate([0,0,-pad]) {
        cylinder(r=screw_r,h=mount_h+padd);
        cylinder(r2=screw_r,r1=screw_head_r,h=screw_head_h);
    }
}

module mount() {
    difference() {
        translate([-mount_w/2,-mount_w/2,0])
        cube([mount_w,mount_w,mount_h]);
        translate([0,0,wall])
        cylinder(r=r+lip+gap,h=mount_h);
        translate([0,-(r+lip+gap),wall+lock])
        cube([mount_w,(r+lip+gap)*2,lip_h+gap*2+pad]);
        translate([0,0,-pad])
        cylinder(r=r+gap,h=mount_h);
        translate([0,-(r+gap),-pad])
        cube([mount_w,(r+gap)*2,mount_h]);
        
        translate([s,s,0])
        screw();
        translate([-s,s,0])
        screw();
        translate([s,-s,0])
        screw();
        translate([-s,-s,0])
        screw();
    }
}

module lamp() {
    translate([0,0,-lamp_h*1.4])
    difference() {
        union() {
            cylinder(r=r,h=lamp_h);
            translate([0,0,lamp_h])
            cylinder(r=r+lip,h=lip_h);
        }
        translate([0,0,-pad])
        cylinder(r=lamp_r,h=lamp_h+padd);
        translate([0,0,lamp_head_grip])
        cylinder(r=lamp_head_r,h=lamp_h);
        translate([0,-wire/2,-pad])
        cube([d,wire,lamp_h+lip_h+padd]);
    }
}

mount();
//lamp();
