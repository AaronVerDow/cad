ball=1200;

in=25.4;

base_h=12*in;

wall=8*in;
walll=wall*2;

wood=0.5*in;

dent=base_h-wood*2;

pad=0.1;
padd=pad*2;

splines=6;
spline_delta=360/splines;


module top_slice() {
    projection(cut=true)
    translate([0,0,ball/2+wall-base_h])
    sphere(d=ball+walll);
}

module keys() {
    difference() {
        translate([0,0,ball/2+wall-base_h])
        sphere(d=ball+walll);
        translate([0,0,ball/2+wall/2])
        sphere(d=ball+wall);
    }
}
keys();

module positive() {
    difference() {
        linear_extrude(height=base_h)
        top_slice();
        translate([0,0,ball/2])
        sphere(d=ball);
    }
}

module dent() {
    minkowski() {
        sphere(d=dent);
        linear_extrude(height=pad)
        difference() {
            circle(d=ball+wall);
            top_slice();
        }
    }
}


module top_2d() {
    projection(cut=true)
    difference() {
        translate([0,0,-base_h+pad])
        positive();
        intersection() {
            translate([0,0,-pad])
            spline_3d();
            translate([0,0,(ball+wall)/2-base_h])
            sphere(d=ball+wall);
        }
    }
}

module top_3d() {
    translate([0,0,base_h-wood])
    linear_extrude(height=wood)
    top_2d();
}

module bottom_2d() {
    top_slice();
}

module bottom_3d() {
    translate([0,0,-wood])
    linear_extrude(height=wood)
    bottom_2d();
}

module spline_2d() {
    projection(cut=true)
    rotate([90,0,0])
    difference() {
        positive();
        translate([0,-ball/2-wall,-pad])
        cube([ball+wall,ball+wall,base_h+padd]);
    }
}

module spline_3d() {
    for(angle=[0:spline_delta:360]) {
        rotate([0,0,angle])
        rotate([-90,0,0])
        translate([0,0,-wood/2])
        linear_extrude(height=wood)
        spline_2d();
    }
}


module assembly() {
    color("cyan")
    top_3d();
    color("cyan")
    bottom_3d();
    spline_3d();
}

//assembly();
