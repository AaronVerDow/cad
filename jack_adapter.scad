$fn=200;
groove=10;
groove_h=37;
side=35;
puck=99;
base_h=5;
inner_d=groove+side*2;
pad=0.1;
padd=pad*2;
puck_wall=5;
outer_d=puck+puck_wall*2;
total_h=base_h+groove_h+puck_wall;


difference(){ 
    union() {
        cylinder(d=outer_d,h=total_h);
    }
    translate([-outer_d,-groove/2,base_h+puck_wall])
    cube([outer_d*2,groove,total_h+pad]);
    translate([0,0,-pad])
    cylinder(d=puck,h=puck_wall+pad);
    translate([-outer_d/2,groove/2+side,-pad])
    cube([outer_d,outer_d,total_h+padd]);

    translate([-outer_d/2,-outer_d-groove/2-side,-pad])
    cube([outer_d,outer_d,total_h+padd]);
}
