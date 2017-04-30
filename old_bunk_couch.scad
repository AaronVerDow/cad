in=25.4;
base_w=36*in;
base_h=54*in;

bottom_couch_w=64*in;

top_h=92*in;

stud=3.5*in;

wall=stud;

base_neg_w=base_w-wall*2;

steps=2;

plywood=in/2;

tabs=stud;

assembled_side();
translate([0,bottom_couch_w,0])
mirror([0,1,0])
assembled_side();

joist(0,0);
joist(0,base_h-stud);
joist(base_w-stud,base_h-stud);

color("magenta")
translate([0,0,base_h])
linear_extrude(height=plywood)
top2d();

color("lime")
translate([0,0,base_h-stud-plywood])
linear_extrude(height=plywood)
top_bottom2d();

module triple2d() {
    corner2d();
    translate([0,stud,0])
    mirror([0,1,0])
    corner2d();
}

module corner2d() {
    translate([stud/2+tabs,stud/2])
    circle(d=stud);
    translate([stud/2,stud/2+tabs])
    circle(d=stud);
    difference() {
        square([tabs+stud/2,tabs+stud/2]);
        translate([tabs+stud/2,tabs+stud/2])
        circle(r=tabs-stud/2);
    }
}

module top_bottom2d() {
    square([base_w,bottom_couch_w]);
}

module top2d() {
    translate([0,-plywood-stud])
    difference() {
        square([base_w,bottom_couch_w+plywood*2+stud*2]);
        square([stud,stud]);
        translate([0,bottom_couch_w+plywood*2+stud])
        square([stud,stud]);
    }
}

module joist(x,z) {
    translate([x,-plywood,z])
    cube([stud,bottom_couch_w+plywood*2,stud]);
}

module assembled_side() {
    color("cyan")
    rotate([90,0,0])
    linear_extrude(height=plywood)
    side2d();

    leg(0,-stud-plywood,top_h);
    leg(base_w-stud,-stud-plywood,base_h);

    for(z=[0:(base_h-wall)/(steps+1):base_h]){
        color("orange")
        step(stud,-stud-plywood,z);
    }
    assembled_outside();
}

module assembled_outside() {
    translate([0,-stud-plywood,0])
    rotate([90,0,0])
    linear_extrude(height=plywood)
    corner2d();

    translate([base_w,-stud-plywood,0])
    mirror([1,0,0])
    rotate([90,0,0])
    linear_extrude(height=plywood)
    corner2d();

    translate([base_w,-stud-plywood,base_h])
    rotate([90,180,0])
    linear_extrude(height=plywood)
    corner2d();

    for(z=[(base_h-wall)/(steps+1):(base_h-wall)/(steps+1):base_h]){
        translate([0,-stud-plywood,z])
        rotate([90,0,0])
        linear_extrude(height=plywood)
        triple2d();
    }

    for(z=[(base_h-wall)/(steps+1):(base_h-wall)/(steps+1):base_h-(base_h-wall)/(steps+1)]){
        translate([base_w,-stud-plywood,z])
        mirror([1,0,0])
        rotate([90,0,0])
        linear_extrude(height=plywood)
        triple2d();
    }
}

module step(x,y,z) {
    translate([x,y,z])
    cube([base_w-stud*2,stud,stud]);
}

module leg(x,y,h) {
    color("lime")
    translate([x,y,0])
    cube([stud,stud,h]);
}

module side2d() {
    difference() {
        union() {
            difference() {
                square([base_w,base_h]);
                base_negative();
            }
            base_positive();
        }
        square([stud,stud]);
        translate([0,base_h-stud])
        square([stud,stud]);
        translate([base_w-stud,base_h-stud])
        square([stud,stud]);
    }
}

module base_positive() {
    for(y=[0:(base_h-wall)/(steps+1):base_h]){
            translate([0,y])
            step2d();
    }
}

module base_negative() {
    hull() {
        translate([base_w/2,base_neg_w/2+wall])
        circle(d=base_neg_w);
        translate([base_w/2,base_h-base_neg_w/2-wall])
        circle(d=base_neg_w);
    }
    square([stud,stud]);
}

module step2d() {
    square([base_w,wall]);
}
