$fn=90;
p_x=120;
p_y=40;
p_z=80;
wall=4;
walll=wall*2;
pad=0.1;
padd=pad*2;

grip=wall*1.5;
gripp=grip*2;

angle=20;
hyp=p_y+walll;
opp=sin(angle)*hyp;
adj=cos(angle)*hyp;

screw_wall=4;
screw_d=4.5;
screw_wall_d=screw_d+screw_wall*2;
screw_wall_r=screw_wall_d/2;

difference(){
    linear_extrude(height=p_y)
    rotate([angle,0,0])
    projection()
    projector_frame();
    rotate([angle,0,0])
    cube([p_x+walll+padd,p_y*2+walll+padd,p_y]);
    rotate([angle,0,0])
    translate([grip+wall,grip+wall,-p_y])
    cube([p_x-gripp,p_y-gripp,wall+pad+p_y]);
}

rotate([angle,0,0])
projector_frame();

difference() {
    hull() {
        translate([wall,adj-wall,0])
        cube([p_x,wall,p_z+wall]);
        translate([p_x/2,adj,p_z+wall+screw_wall_r])
        rotate([90,0,0])
        cylinder(r=screw_wall_r,h=wall);
    }
    translate([p_x/2,adj+pad,p_z+wall+screw_wall_r])
    rotate([90,0,0])
    cylinder(d=screw_d,h=wall+padd);
}

difference() {
    union() {
        translate([wall,0,p_z+wall-grip])
        cube([grip,adj,grip]);

        translate([p_x+wall-grip,0,p_z+wall-grip])
        cube([grip,adj,grip]);
    }
    rotate([angle,0,0])
    cube([p_x+walll,p_y+wall,p_z+walll]);
}

module projector_frame() {
    translate([wall,wall,0])
    difference() {
        minkowski() {
            cube([p_x,p_y,p_z]);
            cylinder(r=wall,h=wall);
        }
        translate([0,0,wall])
        cube([p_x,p_y,p_z+pad]);
        translate([-wall-pad,-wall-pad,p_z+wall])
        cube([p_x+walll+padd,p_y+walll+padd,wall+pad]);
        translate([grip,-wall-pad,grip+wall])
        cube([p_x-gripp,p_y+walll+padd,p_z]);
        translate([-wall-pad,grip,wall+grip])
        cube([p_x+walll+padd,p_y-gripp,p_z-gripp]);
        translate([grip,grip,-pad])
        cube([p_x-gripp,p_y-gripp,wall+padd]);
    }
}
