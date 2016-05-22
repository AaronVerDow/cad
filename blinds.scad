$fn=25;
base_x=45.7;
base_y=15.5-1.3;
base_z=2;

center_x=15.8;
center_y=5.3;
center_z=9.8;

side_x=3.8;
side_y=2.9;
side_z=6.7;

insert_offset=2.5;
side_offset=12;
base_radius=2;

arc=6-base_radius;
arc_scale=arc/base_x;

radius=1;
taper=0.5;
div=4;


//base
difference() {
    translate([base_radius,base_radius,base_radius])
    minkowski() {
        union() {
            cube([base_x-base_radius*2,base_y-base_radius,base_z]);

            scale([1,arc_scale,1])
            translate([base_x/2-base_radius,0,0])
            cylinder(r=base_x/2-base_radius,h=base_z);
        }
        sphere(r=base_radius);
    }
    translate([-base_radius,-base_radius,base_z])
    cube([base_x*2,base_y*2,base_z*2]);
}

//center
minkowski() {
    translate([base_x/2-center_x/2+radius,-center_y/2+insert_offset+radius,base_z])
    cube([center_x-radius*2,center_y-radius*2,center_z/div]);
    cylinder(r1=radius,r2=radius-taper,h=center_z*(div-1)/div);
}

//left
minkowski() {
    translate([base_x/2-side_x/2-side_offset+radius,-side_y/2+insert_offset+radius,base_z])
    cube([side_x-radius*2,side_y-radius*2,side_z/div]);
    cylinder(r1=radius,r2=radius-taper,h=side_z*(div-1)/div);
}

//right
minkowski() {
    translate([base_x/2-side_x/2+side_offset+radius,-side_y/2+insert_offset+radius,base_z])
    cube([side_x-radius*2,side_y-radius*2,side_z/div]);
    cylinder(r1=radius,r2=radius-taper,h=side_z*(div-1)/div);
}

