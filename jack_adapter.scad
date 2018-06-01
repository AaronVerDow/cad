$fn=200;
groove=12;
groove_h=25;
side=35;
puck=79.5;
base_h=7;
inner_d=groove+side*2;
pad=0.1;
padd=pad*2;
outer_d=puck;
total_h=base_h+groove_h;


difference(){ 
    union() {
        cylinder(d=outer_d,h=total_h);
    }
    translate([-outer_d,-groove/2,base_h])
    cube([outer_d*2,groove,total_h+pad]);
    translate([-outer_d/2,groove/2+side,-pad])
    cube([outer_d,outer_d,total_h+padd]);

    translate([-outer_d/2,-outer_d-groove/2-side,-pad])
    cube([outer_d,outer_d,total_h+padd]);
}
