socket=50;
socket_flange=70;
wall=5;
socket_grip=wall;
side_wall=wall;
bottom_wall=side_wall;
back_wall=wall;

bulb=80;
shade=bulb*1.5;
wall_to_shade=20;
wall_offset=wall_to_shade+shade/2;

shade_height=180;
shade_wall=1;
shade_base=shade_wall;

shade_fn=400;
pad=0.1;;


base=socket+20;
base_height=80;

base_cut=wall_offset-side_wall*3;
base_cut_r=base_cut*0.99;

wire=15;

screw=4.5;
screw_offset=wall+10;

$fn=90;

module shade() {
    color("white")
    difference() {    
        cylinder(d=shade,h=shade_height,$fn=shade_fn);
        translate([0,0,shade_base])
        cylinder(d=shade-shade_wall*2,h=shade_height,$fn=shade_fn);
        translate([0,0,-pad])
        cylinder(d=socket,h=shade_base+pad*2);
    }
}


module base_positive() {
    difference() {
        translate([0,-base/2])
        cube([wall_offset,base,base_height]);

        translate([-back_wall,side_wall-base/2,bottom_wall])
        cube([wall_offset,base-side_wall*2,base_height-socket_grip-bottom_wall]);

        translate([0,base/2+pad])
        rotate([90,0])
        linear_extrude(height=base+pad*2)
        offset(base_cut_r)
        offset(-base_cut_r)
        square([base_cut*2,(base_height-socket_grip)*2],center=true);
    }

    difference() {
        cylinder(d=base,h=base_height);
        translate([0,0,-socket_grip])
        cylinder(d=base+pad*2,h=base_height);
    }
}

module dirror_y() {
    children();
    mirror([0,1])
    children();
}


difference() {
    base_positive();
    cylinder(d=socket,h=base_height+pad);
    screw(screw_offset);
    screw(base_height-screw_offset);

    dirror_y()
    translate([wall_offset+pad,base/2-side_wall-wire/2,base_height-socket_grip-wire/2])
    rotate([0,-90,0])
    cylinder(d=wire,h=back_wall+pad*2);
}



module screw(z=0) {
    translate([wall_offset+pad,0,z])
    rotate([0,-90,0])
    cylinder(d=screw,h=back_wall+pad*2);
}


translate([0,0,base_height])
shade();

