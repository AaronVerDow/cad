box_x=100;
box_y=163;
box_z=20;

ml19=25.8;
ml18=25.8;
ml17=23.8;
ml16=21.8;
ml15=21.8;

hole_z=15;

pad=0.1;

wall=1.5;

module hole(hole_d,center_d) {
    translate([hole_d/2+wall,hole_d/2+wall,box_z-hole_z])
    cylinder(d=hole_d,h=hole_z+pad);
    
}

difference() {
    cube([box_x,box_y,box_z]);
    hole(ml19,0);

}
