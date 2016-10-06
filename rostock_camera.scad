camera_bolt=3.7;
base_bolt=4;
base_gap=1;
camera_w=7.5;
camera_h=30;
thick_wall=3;
bolt_wall=2.2;
base_h=3;
bolt_slot=30;
width=camera_w+thick_wall*2;
pad=0.1;
padd=pad*2;
camera_from_mount=6;
web=0;
mounts=5;
bolt_from_base=30;
$fn = 90;

module base() {
    difference() {
        union() {
            hull() {
                translate([width/2,width/2+bolt_slot,0])
                cylinder(d=width*2,h=base_h);
                translate([width/2,width,0])
                cylinder(d=width*2,h=base_h);
            }
        }
        hull() {
            translate([width/2,width/2+bolt_slot,-pad])
            cylinder(d=base_bolt,h=base_h+padd);
            translate([width/2,width,-pad])
            cylinder(d=base_bolt,h=base_h+padd);
        }
    }
}

module camera_mount(z) {
    translate([0,0,z*camera_h]) {
    cube([width,thick_wall,camera_h]);
        camera_mount_side(0);
        camera_mount_side(width-thick_wall);
    }
}

module camera_mount_side(x){
    translate([x,0,0])
    difference() {
        union() {
            translate([0,camera_bolt/2+bolt_wall+camera_from_mount,camera_h-camera_bolt/2-bolt_wall])
            rotate([0,90,0])
            cylinder(d=camera_bolt+bolt_wall*2,h=thick_wall);
            translate([0,0,camera_h-camera_bolt-bolt_wall*2])
            cube([thick_wall,camera_bolt/2+bolt_wall+camera_from_mount,camera_bolt+bolt_wall*2]);
            cube([thick_wall,thick_wall+web,camera_h]);
        }
        translate([-pad,camera_bolt/2+bolt_wall+camera_from_mount,camera_h-camera_bolt/2-bolt_wall])
        rotate([0,90,0])
        cylinder(d=camera_bolt,h=thick_wall+padd);
    }
}

module base2() {
    difference() {
        union() {
            hull() {
                translate([0,0,camera_bolt/2+bolt_wall])
                rotate([0,90,0])
                cylinder(d=camera_bolt+bolt_wall*2,h=camera_w-base_gap);
                cube([camera_w-base_gap,bolt_from_base,base_h]);
            }
            hull() {
                translate([width/2-camera_w/2-base_gap/2,width/2+bolt_from_base,0])
                cylinder(d=width,h=base_h);
                translate([0,camera_bolt/2+bolt_wall,0])
                cube([camera_w-base_gap,bolt_from_base-camera_bolt/2-bolt_wall,base_h]);
            }
        }
        translate([-pad,0,camera_bolt/2+bolt_wall])
        rotate([0,90,0])
        cylinder(d=camera_bolt,h=camera_w-base_gap+padd);
        translate([width/2-camera_w/2-base_gap/2,width/2+bolt_from_base,-pad])
        cylinder(d=base_bolt,h=base_h+padd);
    }
}

base2();

rotate([90,0,0])
difference() {
    for(i=[0:1:mounts-1]) {
        camera_mount(i);
    }
    translate([-pad,-pad,-pad])
    cube([width+padd,thick_wall+web+padd,camera_h-camera_bolt-bolt_wall*2+pad]);
}
