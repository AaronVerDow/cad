base_x=50;
base_y=30;
base_z=3;

center_x=15;
center_y=5;
center_z=10;

side_x=4;
side_y=3;
side_z=6;

insert_offset=5;
side_offset=12;

arc=6;
arc_scale=arc/base_x;

cube([base_x,base_y,base_z]);
translate([base_x/2-center_x/2,-center_y/2+insert_offset,base_z])
cube([center_x,center_y,center_z]);
translate([base_x/2-side_x/2-side_offset,-side_y/2+insert_offset,base_z])
cube([side_x,side_y,side_z]);
translate([base_x/2-side_x/2+side_offset,-side_y/2+insert_offset,base_z])
cube([side_x,side_y,side_z]);

scale([1,arc_scale,1])
translate([base_x/2,0,0])
cylinder(r=base_x/2,h=base_z);
