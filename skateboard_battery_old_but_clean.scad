batt=[140,68,25];
$fn=90;
x=0;
y=1;
z=2;

max_y=130;

outer=max_y;
outer_offset=0;
outer_scale=0.52;

big_hole=max_y-20;

screw=3;
screw_offset=(max_y-batt[y])/4;
nut=6;
nut_h=1.5;

module screw(x=0,y=0) {
    translate([x,y,-pad()]) {
        cylinder(h=padd(wall()),d=screw);
        translate([0,0,wall(pad(-nut_h))])
        cylinder(h=pad(nut_h),d=nut,$fn=6);
    }
}

pad=0.1;
padd=pad*2;
wall=3;
walll=wall*2;
right=[0,90,0];

function wall(x=0) = x + wall;
function walll(x=0) = x + walll;
function pad(x=0) = x + pad;
function padd(x=0) = x + padd;

module air_flow() {
    difference() {
        inner_body();
        
        //battery wall
        translate([-pad(),-wall(batt[y]/2),0])
        cube([padd(batt[x]),walll(batt[y]),batt[z]*2]);

        //bottom
        translate([-batt[x]/2,-outer,wall(-outer*2)])
        cube([batt[x]*2,outer*2,outer*2]);

        // top
        translate([-batt[x]/2,-outer,batt[z]])
        cube([batt[x]*2,outer*2,outer*2]);
    }
}

module body(x) {
    translate([0,0,-outer_offset])
    scale([1,1,outer_scale])
    rotate(right)
    cylinder(h=x,d=outer-wall()*2);
}

module inner_body() {
    translate([-pad,0,0])
    body(padd(batt[x]));
}

module outer_body() {
    minkowski() {
        body(batt[x]-pad);
        rotate(right)
        cylinder(d=walll,h=pad);
    }
}

difference() {
    outer_body();

    // battery
    translate([-pad(),-batt[y]/2,-pad()])
    cube([padd(batt[x]),batt[y],pad(batt[z])]);

    // cut off bottom
    translate([-batt[x]/2,-outer,-outer*2])
    cube([batt[x]*2,outer*2,outer*2]);
    
    // cut off top
    translate([-batt[x]/2,-outer,wall(batt[z])])
    cube([batt[x]*2,outer*2,outer*2]);

    // big circle in center
    translate([batt[x]/2,0,-pad()])
    cylinder(h=wall(padd(batt[y])),d=big_hole);

    air_flow();
   
    screws(screw_offset);
    screws(batt[x]-screw_offset);
}

module screws(x=0) {
    y=batt[y]/2+screw_offset;
    screw(x,y);
    screw(x,-y);
}
