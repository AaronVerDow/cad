window_w=29.25;
window_d=6;
shelf_h=14.5;
shelves=4;
plywood=0.5;
wall=1.25;
extra_shelf=2.5;
gap=1/16;
pad=0.1;
padd=pad*2;
$fn=45;

module side_cutout(z) {
    translate([-pad,wall,z-gap])
    cube([plywood+padd,window_d-wall*2,plywood+gap*2]);
}

module shelf_cutout(y) {
    translate([-pad,-gap+y,-pad])
    cube([plywood+gap+pad,wall+gap*2,plywood+padd]);
}

module shelf_cutouts(x){
    translate([x,0,0]) {
        shelf_cutout(0);
        shelf_cutout(window_d-wall);
    }
}

module shelf(z) {
    translate([0,0,z])
    difference() {
        translate([extra_shelf,0,0])
        minkowski() {
            cube([window_w-extra_shelf*2,window_d,plywood/2]);
            cylinder(r=extra_shelf,h=plywood/2);
        }
        shelf_cutouts(0);
        shelf_cutouts(window_w-plywood);
    }
}

module all_shelves() {
    for(z=[0:shelf_h:(shelves-1)*shelf_h]) {
        shelf(z);
    }
}

module side(x) {
    translate([x,0,0])
    difference() {
        cube([plywood,window_d,(shelves-1)*shelf_h+plywood]);
        for(z=[0:shelf_h:(shelves-1)*shelf_h]) {
            side_cutout(z);
        }
    }
}

module all_sides() {
    side(0);
    side(window_w-plywood);
}

module assembled() {
    color("lime")
    all_shelves();
    all_sides();
}

module shelf2d() {
    projection(cut=true)
    shelf(-plywood/2);
}

module side2d() {
    projection(cut=true)
    rotate([0,90,0])
    side(-plywood/2);
}

//side2d();
//shelf2d();
assembled();
