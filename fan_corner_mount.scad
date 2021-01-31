fan=153;
cage=141;
screw=4;

fan_h=15.5;

shock=3;
shock_x=5.5;
shock_y=16;

rib_y=3;
rib_x=9;

mount=5.5;
mount_h=13;


//mount_od=mount_wall*2+mount;
//mount_wall=5;

mount_od=fan_h;

screw_offset=7;

pad=0.1;

keep=20;
big_fn=400;
$fn=90;



module place_fan() {
    translate([-cage/2+screw_offset,cage/2-screw_offset,0])
    children();
}

module fan_negative() {
    cylinder(d=fan,h=fan_h+pad*2,center=true,$fn=big_fn);
    rotate([0,0,-45])
    translate([fan/2+rib_x/2,0,0])
    cube([rib_x+1,rib_y,fan_h+pad*2],center=true);
}

module fan_body() {
    difference() {
        cube([cage,cage,fan_h],center=true);
        fan_negative();
    }
}

module fan() {
    intersection() {
        place_fan()
        fan_body();
        keep();
    }
}

module keep() {
    cylinder(d=keep*2,h=fan_h+pad*2,center=true);
}

module body() {
    hull() {
        fan();
        place_mount()
        cylinder(d=mount_od,h=mount_h);
    }
}

module shock() {
    translate([screw_offset,-screw_offset])
    cylinder(d=shock,h=fan_h+pad*2,center=true);
}

module shocks() {
    translate([-shock_x,shock_y])
    shock();
    translate([-shock_y,shock_x])
    shock();
}


module assembled() {
    difference() {
        body();
        place_fan()
        fan_negative();
        cylinder(d=screw,h=fan_h+pad*2,center=true);
        shocks();
        place_mount()
        cylinder(d=mount,h=mount_h+pad);
    }
}

//fan_body();

assembled();


module place_mount() {
    rotate([90,0,45])
    translate([0,0,screw/2])
    children();
}
