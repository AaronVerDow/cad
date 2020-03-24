screw=5;
u=45;
rail_inside=17.75*25.4;
rail_outside=19.25*25.4;
front_gap=80;
us=13;
depth=20*25.4;
wall=60;
walll=wall*2;
max_x=rail_outside+walll;
max_y=us*u+walll;
max_z=depth+wall+front_gap;
pad=0.1;
padd=pad*2;

module pillar(){ 
    cylinder(d=wall, $fn=0, h=max_z);
}
module shell_face() {
    for(n=[0:wall:max_x]) {
        translate([0,n,0])
        pillar();
    }
}

module rack() {
    difference() {
        cube([max_x, max_y, max_z]);
        translate([max_x/2-rail_inside/2, wall, -pad])
        cube([rail_inside, us*u, max_z+padd]);
        translate([wall, wall, max_z-wall/2-front_gap+pad])
        cube([rail_outside, us*u, wall/2+front_gap+pad]);

    }
}

module back_lid() {
    translate([max_x/2-rail_inside/2, wall, -pad])
    cube([rail_inside, us*u, wall]);
    cube([max_x, max_y, wall/2]);
}

module front_lid() {
    translate([wall, wall, 0])
    cube([rail_outside, us*u, wall]);
    cube([max_x, max_y, wall/2]);
}

module assembled(gap) {

    translate([0,0,gap])
    color("lime")
    rack();

    back_lid();

    translate([0,0,max_z+gap*2])
    front_lid();
}

assembled(walll);
