tube=22.5;
tube_h=15;
wall=7;
tube_outer=tube+wall*2;
tube_gap=102;

screw=6;
screw_h=4;
screw_wall=wall;
screw_outer=screw_wall*2+screw;
light_gap=40;

angle=35;
options=3;
option=4;
zip=4;


diff_x=40;
diff_y=0;
diff_z=30;

pad=0.1;
padd=pad*2;

module tube_bottom() {
    rotate([-90,0,0])
    cylinder(d=tube_outer,h=tube_h);
}


module tube_top() {
    translate([0,0,tube_gap])
    rotate([-90,0,0])
    cylinder(d=tube_outer,h=tube_h);

}

module light_bottom() {
    translate([diff_x,diff_y,diff_z]) 
    rotate([-90,0,0])
    cylinder(d=screw_outer,h=screw_h);
}

module light_top() {
    translate([diff_x,diff_y,diff_z]) 
    rotate([0,angle,0])
    translate([0,0,light_gap])
    rotate([-90,0,0])
    cylinder(d=screw_outer,h=screw_h);
}
module bar() {
    hull() {
        light_bottom();
        light_top();
    }
}

module sliver() {
    difference() {
        translate([0,0,pad])
        bar();
        bar();
    }
}
module positive() {
    hull() {
        translate([tube/2+wall/2-wall,0,tube_gap])
        rotate([-90,0,0])
        cylinder(d=tube+wall,h=screw_h);
        bar();
    }
    hull() {
    translate([tube/2+wall/2-wall,0,0])
    rotate([-90,0,0])
    cylinder(d=tube+wall,h=screw_h);
        bar();
    }
    //tube_top();
    //tube_bottom();
    translate([tube/2+wall/2-wall,0,0])
    rotate([-90,0,0])
    cylinder(d=tube+wall,h=tube_h);

    translate([tube/2+wall/2-wall,0,tube_gap])
    rotate([-90,0,0])
    cylinder(d=tube+wall,h=tube_h);

}

difference() {
    positive();

    translate([0,-pad,0])
    translate([0,0,tube_gap])
    rotate([-90,0,0])
    hull() {
        cylinder(d=tube,h=tube_h*2);
        translate([-tube_outer,0,0])
        cylinder(d=tube,h=tube_h*2);
    }

    hull() {
        translate([-tube_outer,0,0])
        translate([0,-pad,0])
        rotate([-90,0,0])
        cylinder(d=tube,h=tube_h*2);

        translate([0,-pad,0])
        rotate([-90,0,0])
        cylinder(d=tube,h=tube_h*2);
    }
    //translate([-tube_outer,screw_h,-tube_outer])
    //cube([tube_outer,zip,tube_gap+tube_outer*2]);
    translate([diff_x,diff_y-pad,diff_z]) 
    rotate([-90,0,0])
    cylinder(d=screw,h=screw_h+padd);

    translate([diff_x,diff_y-pad,diff_z]) 
    rotate([0,angle,0])
    translate([0,0,light_gap])
    rotate([-90,0,0])
    cylinder(d=screw,h=screw_h+padd);


}
