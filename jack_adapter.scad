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
screws=4;
screw_h=16;
screw_head=10;
screw_head_h=3;
screw_head_lip=1;

layer_h=0.4;

magnet=10; 
magnet_pad=layer_h*2; 
magnet_h=max_z-magnet_pad;
magnet_offset=puck/3;

raft=30;
raft_d=puck+raft*2;


$fn=100;

module jack_adapter() {
    intersection() {
        difference() { 
            puck();
            groove();
            screws();
            magnets();
        }
        binding_box();
    }
}

module magnets() {
    translate([0,magnet_offset,0])
    magnet();
    translate([0,-magnet_offset,0])
    magnet();
}

module magnet() {
    translate([0,0,-pad])
    cylinder(d=magnet,h=magnet_h+pad);
}

module binding_box() {
    translate([-max_x/2,-groove/2-side_a,0])
    cube([max_x,max_y,max_z]);
}

module puck() {
    minkowski() {
        cylinder(d=puck-edge*2,h=max_z-edge);
        sphere(d=edge*2);
    }
}


module groove() {
    translate([-puck,-groove/2,base_h])
    cube([puck*2,groove,max_z+pad]);
}

module screws() {
    for(i=[0:360/screws:359]) {
        rotate([0,0,360/screws/2+i])
        translate([puck/3,0,0]) {
            screw();
       }
    }
}

module screw() {
    cylinder(d=screw,h=screw_h);
    translate([0,0,screw_head_lip])
    cylinder(d1=screw_head,d2=screw,h=screw_head_h);
    translate([0,0,-pad])
    cylinder(d=screw_head,h=screw_head_lip+pad);
}

module raft() {
    difference() {
        cylinder(d=raft_d,h=layer_h);
        translate([0,0,-pad])
        cylinder(d=puck-padd,h=layer_h+padd);
    }
}

jack_adapter();
//raft();
