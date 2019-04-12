extrusion_width=0.35;
layer_height=0.16;

wrist_thick=40;
wrist_width=60;
stand_width=60;
stand_wall=extrusion_width*2;
base=layer_height*3;
pad=0.1;
screw=3;
screw_head=12;


$fn=200;
module wrist_half(extra=0,extra_h=0) {
    cylinder(d=wrist_thick+extra,h=stand_width+extra_h);
}

module wrist(extra=0,extra_h=0) {
    translate([0,wrist_thick/2-wrist_width/2,0])
    hull() {
        wrist_half(extra,extra_h);
        translate([0,wrist_width-wrist_thick,0])
        wrist_half(extra,extra_h);
    }
}

module screw() {
    translate([0,0,-pad])
    cylinder(d=screw,h=base+pad*2);
}

module edge_screw() {
    translate([0,wrist_width/2-stand_wall-screw_head/2,0])
    screw();
}

module edge_screws() {
    edge_screw();
    mirror([0,1,0])
    edge_screw();
}

module screws() {
    screw();
    edge_screws();
}

difference() {
    wrist();
    translate([0,0,base])
    wrist(-stand_wall*2);
    screws();
}
