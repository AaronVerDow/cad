screw=6;
screw_gap=100;
x=0;
y=1;
z=2;
r=8;
front=[30,30,177];
back=front+[0,3,0];
inner=[r*2,r,r*2];
pad=0.1;
padd=pad*2;

slot=[back[x]+padd,6,64];
slot_lip=[slot[x]+padd,2.7+pad,9+pad];

raft=40;
layer_h=0.4;


module screw(z=0) {
    translate([0,front[y]/2,z])
    rotate([0,90,0])
    translate([0,0,-pad])
    cylinder(d=screw,h=front[x]+padd);
}

module screws() {
    translate([0,0,front[z]/2-screw_gap/2]) {
        screw();
        screw(screw_gap);
    }
}

module bar(vector) {
    difference(){
        translate([r,0,r])
        minkowski() {
            cube(vector-inner);
            sphere(r);
        }
        translate([0,-vector[y],0])
        cube(vector);
    }
}

module front() {
    difference(){
        bar(front);
        screws();
    }
}

module slot() {
    translate([-pad,-pad,back[z]/2-slot[z]/2])
    difference() {
        cube(slot);
        translate([-pad,-pad,-pad])
        cube(slot_lip);
    }
}

module back() {
    difference() {
        bar(back);
        slot();
    }
}

module assembled() {
    front();
    translate([front[x]*3,0,0])
    back();
}

module raft(vector) {
    minkowski() {
        cube([vector[z],vector[y],layer_h/2]);
        cylinder(r=raft,h=layer_h/2);
    }
}
module print_front() {
    $fn=90;
    translate([front[z],0,0])
    rotate([0,-90,0])
    front();
    raft(front);
}

module print_back() {
    $fn=90;
    translate([back[z],0,0])
    rotate([0,-90,0])
    back();
    raft(back);
}

display="";
if (display == "") assembled();
if (display == "case_sliders_front.stl") print_front();
if (display == "case_sliders_back.stl") print_back();
