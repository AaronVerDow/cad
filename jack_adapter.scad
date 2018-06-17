groove=12;      // width of groove in middle
groove_h=28;    // groove height 
base_h=7;       // thickness of puck at bottom of groove
puck=79.5;      // main outer diameter of puck
pad=0.1;        // padding negative space for clean cuts
padd=pad*2;
max_z=base_h+groove_h;

side_a=35;      // trim sides
side_b=side_a;
max_x=puck;     // trim width of puck along groove
max_y=side_a+side_b+groove;
edge=5;

screw=5;
screws=6;
screw_h=16;
screw_head=10;
screw_head_h=3;
screw_head_lip=1;

$fn=200;

intersection() {
    difference(){ 
        minkowski() {
            cylinder(d=puck-edge*2,h=max_z-edge);
            sphere(d=edge*2);
        }
        translate([-puck,-groove/2,base_h])
        cube([puck*2,groove,max_z+pad]);
        for(i=[0:360/screws:359]) {
            rotate([0,0,360/screws/2+i])
            translate([puck/3,0,0]) {
                cylinder(d=screw,h=screw_h);
                translate([0,0,screw_head_lip])
                cylinder(d1=screw_head,d2=screw,h=screw_head_h);
                translate([0,0,-pad])
                cylinder(d=screw_head,h=screw_head_lip+pad);
            }
        }
        
    }
    translate([-max_x/2,-groove/2-side_a,0])
    cube([max_x,max_y,max_z]);
}
