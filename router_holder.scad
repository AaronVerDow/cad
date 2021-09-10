router=69.2;
router_h=80;

// assumed to be square
screws_y=30;
screws_z=35;

$fn=90;

mount_wall=10;

mount_bolt=6.3;

wall=12;

groove=wall/2;

grooves=16;

lock_x=40;


lock_offset=0;
lock_bolt=mount_bolt;
lock_wall=5;
lock_body=lock_wall*2+lock_bolt;

lock_y=router+wall*2+lock_wall*2+lock_offset*2+lock_bolt;

lock_head=15;


gap=3;

gap_y=wall+lock_offset+lock_wall;
gap_angle=45;


gap_offset=tan(gap_angle)*gap_y/2-3;

pad=0.1;

bit_x=69.2; // bit to mount surface

mount_head=15; // diamter of mount bolt head
mount_head_h=5;
mount_bolt_h=30;

module dirror_x() {
    children();
    mirror([1,0])
    children();
}


module dirror_y() {
    children();
    mirror([0,1])
    children();
}

module dirror_z() {
    children();
    mirror([0,0,1])
    children();
}

module router() {
    translate([0,0,-pad]) {
        cylinder(d=router,h=router_h+pad*2);
        for(z=[0:360/grooves:359])
        rotate([0,0,z])
        translate([router/2,0])
        cylinder(d=groove,h=router_h+pad*2);
    }
}

module place_locks() {
    translate([0,0,router_h/2])
    dirror_y()
    dirror_z()
    translate([0,router/2+wall+lock_offset,-router_h/2+lock_body/2])
    rotate([0,90,0])
    children();
}


module body() {
    cylinder(d=router+wall*2,h=router_h);

    //translate([0,0,router_h/2]) cube([lock_x,lock_y,router_h],center=true);

    hull()
    place_mounts()
    mount_bolt_body();

    hull()
    place_locks()
    lock_bolt_body();
}

module gap() {
    translate([0,0,router_h/2])
    cube([gap,lock_y,router_h+pad*2],center=true);
}

module fancy_gap() {
    dirror_y()
    translate([-gap_offset,router/2+gap_y/2,-pad])
    dirror_y()
    rotate([0,0,-gap_angle])
    cube([gap,gap_y,router_h+pad*2]);
}

module place_mounts() {
    translate([0,0,router_h/2])
    dirror_y()
    dirror_z()
    translate([-bit_x,screws_y/2,screws_z/2])
    rotate([0,90])
    children();
}

module lock_bolt_body() {
    cylinder(d=lock_body,h=lock_x,center=true);
}

module mount_bolt_body() {
    cylinder(d=mount_bolt+mount_wall*2,h=bit_x);
}

module lock_bolt() {
    cylinder(d=lock_bolt,h=lock_x+pad*2,center=true);
    dirror_z()
    translate([0,0,lock_x/2])
    cylinder(d=lock_head,h=router);
}

module mount_bolt() {
    translate([0,0,-pad])
    cylinder(d=mount_bolt,h=bit_x+pad);
    translate([0,0,mount_bolt_h])
    cylinder(d=mount_head,h=bit_x-mount_bolt_h);
}


difference() {
    body();
    router();
    gap();

    place_mounts()
    mount_bolt();

    place_locks()
    lock_bolt();
}
