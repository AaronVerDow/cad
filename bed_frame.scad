x=60;
y=80;
z=12;


x_ribs=4;
y_ribs=3;

rib=0.5;

pad=0.1;


module bed() {
    color("white")
    translate([0,0,z])
    cube([x,y,z]);
}

module positive() {
    cube([x,y,z]);
}

module x_rib(y=0) {
    translate([-x/2,y,-z/2])
    cube([x*2,rib,z*2]); 
}

module y_rib(x=0) {
    translate([x,-y/2,-z/2])
    cube([rib,y*2,z*2]); 
}

module x_ribs(ribs=x_ribs) {
    intersection() {
        children();
        translate([0,(y-rib)/x_ribs/2,0])
        for(y=[0:(y-rib)/x_ribs:y-rib]) {
            x_rib(y);
        }
    }
}

module y_ribs(ribs=y_ribs) {
    intersection() {
        children();
        translate([(x-rib)/ribs/2,0,0])
        for(x=[0:(x-rib)/ribs:x-rib]) {
            y_rib(x);
        }
    }
}

module x_flat_ribs(ribs=x_ribs) {
    intersection() {
        children();
        for(y=[0:(y-rib)/ribs:y-rib+pad]) {
            x_rib(y);
        }
    }
}

module y_flat_ribs(ribs=y_ribs) {
    intersection() {
        children();
        for(x=[0:(x-rib)/ribs:x-rib+pad]) {
            y_rib(x);
        }
    }
}


module flat_ribs() {
    y_flat_ribs()
    children();
    x_flat_ribs()
    children();
}

module ribs() {
    y_ribs()
    children();
    x_ribs()
    children();
}

module castle() {
    difference() {
        flat_ribs()
        positive();
        translate([0,(y-rib)/x_ribs/2,0])
        for(y=[0:(y-rib)/x_ribs:y-rib]) {
            translate([-pad,y,0])
            rotate([0,90,0])
            cylinder(d=14,h=x+pad*2);
        }
        translate([(x-rib)/y_ribs/2,0,0])
        for(x=[0:(x-rib)/y_ribs:x-rib]) {
            translate([x,-pad,0])
            rotate([-90,0,0])
            cylinder(d=14,h=y+pad*2);
        }
    }
}

module block() {
    ribs()
    cube([x,y,z]);
}

module flared_block() {
    inner_cut=4;
    ribs()
    hull() {
        translate([0,0,z-pad])
        cube([x,y,pad]);
        translate([inner_cut,inner_cut,0])
        cube([x-inner_cut*2,y-inner_cut*2,pad]);
    }
}

rays=17;

module ray(i=0) {
    rotate([0,0,-i])
    translate([-rib/2,0,-z/2])
    cube([rib,y*4,z*2]); 
}

module rays(center_x,center_y) {
    intersection() {
        children();
        translate([-center_x,-center_y,0])
        for(i=[0:90/rays:90]) {
            ray(i);
        }
    }
}


diag_ribs=5;

module diag_rib(diag=0) {
    rotate([0,0,-atan(x/y)])
    translate([-(x+y)*2,diag,-z/2])
    cube([(x+y)*4,rib,z*2]); 
}

diag=sqrt(x*x+y*y);
module diag_ribs(ribs=x_ribs) {
    intersection() {
        children();
        for(y=[0:diag/diag_ribs:diag]) {
            diag_rib(y);
        }
    }
}

module mirror_diag() {
    diag_ribs()
    positive();
}

module mirror_rays() {
    rays(62,62)
    positive();
    translate([x,0,0])
    mirror([1,0,0])
    rays(62,62)
    positive();
}

module _floor() {
    color("black")
    translate([-x,-y,-pad])
    cube([x*3,y*3,pad*2]);
}

module room() {
    _floor();
    bed();
}
//room();
//flared_block();
//mirror_rays();

castle();

