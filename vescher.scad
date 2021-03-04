vesa_large=100;
vesa_small=75;
vesa_screw=5;

module dirror_y() {
    children();
    mirror([0,1,0])
    children();
}


module dirror_x() {
    children();
    mirror([1,0,0])
    children();
}


module vesa() {
    dirror_y()
    dirror_x() {
        translate([vesa_large/2,vesa_large/2])
        children();
        translate([vesa_small/2,vesa_small/2])
        children();
    }

}

in=25.4;

center=45;


count=5;
gap=vesa_large-(vesa_large-vesa_small)/2;

target=[300,500];

module double_vescher(area) {
    intersection () {
        dirror_y()
        dirror_x()
        for(x=[0:gap:area[0]/2+gap])
        for(y=[0:gap:area[1]/2+gap])
        translate([x,y]) {
            vesa() circle(d=vesa_screw);
            translate([-gap/2,-gap/2])
            vesa() circle(d=vesa_screw);
            //circle(d=center);
            translate([-gap/2,0])
            rotate([0,0,360/8/2])
            circle(d=center,$fn=8);
            translate([0,-gap/2,0])
            rotate([0,0,360/8/2])
            circle(d=center,$fn=8);
        }
        difference() {
            square(area,center=true);
            children();
        }
    }

}

//double_vescher(target);
module repeat(area) {
    dirror_y()
    dirror_x()
    for(x=[0:gap:area[0]/2+gap])
    for(y=[0:gap:area[1]/2+gap])
    translate([x,y])
    children();
}

module vescher(area) {
    intersection() {
        repeat(area) rotate([0,0,360/8/2]) circle(d=70,$fn=8);
        difference() {
            square(area,center=true);
            children();
        }
    }
    intersection() {
        repeat(area) vesa() circle(d=vesa_screw);
        square(area,center=true);
    }

}


//foo();
