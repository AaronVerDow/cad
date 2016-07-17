$fn=200;
in=25.4;
base_w=38*in;
base_h=66*in;

bottom_couch_w=86*in;

top_h=110*in;

stud=3.5*in;

wall=stud;

base_neg_w=base_w-wall*2;

steps=2;

plywood=in/2;

tabs=stud*5;

total=100;
half=total/2;
width=5;

tip=26;

plywood_x=4*12*in;
plywood_y=8*12*in;


module all_the_things() {
    things();
    rotate([0,0,360/3]) 
    things();
    rotate([0,0,360/3*2]) 
    things();
}

module things() {
    thing();
    translate([-total/3*2,0,0])
    thing();
    translate([-total/3*4,0,0])
    thing();
    translate([total/3*2,0,0])
    thing();
}

module thing() {
    for(angle=[0:360/3:360]) {
        rotate([0,0,angle]) {
            translate([0,-width/2])
            square([half,width]);

            translate([half+width,0])
            rotate([0,0,360/3*2])
            translate([0,-width])
            square([tip,width]);

            translate([half+width,0])
            mirror([0,1,0])
            rotate([0,0,360/3*2])
            translate([0,-width])
            difference() {
                square([tip,width]);
                translate([tip,0])
                rotate([0,0,])
                square([width*3,width*2]);
            }
        }
    }
}

assembled();

module assembled() {
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

    assembled_back();

    translate([0,0,stud])
    corner();

    mirror([0,1,0])
    translate([0,-bottom_couch_w,stud])
    corner();
}

//flat();
//linear_extrude(height=plywood)
//top_bottom2d();

module flat() {
    translate([-plywood_x*1.2,0])
    square([plywood_x,plywood_y]);

    side2d();
    translate([base_w*1.2,0])
    side2d();

    for(i=[0:tabs*2:tabs*6])
    translate([i,-tabs*2])
    #corner2d();

    for(i=[0:tabs*2:tabs*2])
    translate([i,-tabs*4])
    triple2d();

    translate([base_w*2.4,0])
    top2d();

    translate([base_w*4,0])
    top_bottom2d();
    
}

module assembled_back() {
    translate([0,0,base_h])
    rotate([-90,0,0])
    rotate([0,-90,0])
    triple();

    translate([0,bottom_couch_w,base_h-stud])
    rotate([90,0,0])
    rotate([0,-90,0])
    triple();

    rotate([0,-90,0])
    corner();

    translate([0,bottom_couch_w,0])
    mirror([0,1,0])
    rotate([0,-90,0])
    corner();
}

module corner() {
    color("maroon")
    linear_extrude(height=plywood)
    corner2d();
}

module triple() {
    color("maroon")
    linear_extrude(height=plywood)
    triple2d();
}

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

hole=5*in;
hole_gap=3*in;

module top_bottom2d() {
    difference() {
        square([base_w,bottom_couch_w]);
        square([stud,stud]);
        translate([0,bottom_couch_w-stud])
        #square([stud,stud]);
        //rotate([0,0,45])
        //for(y=[0:hole+hole_gap:bottom_couch_w])
        //for(x=[0:hole+hole_gap:base_w])
        //translate([x,y])
        //#square([hole,hole]);
    }
}

module top2d() {
    difference() {
        square([base_w,bottom_couch_w]);
        square([stud,stud]);
        translate([0,bottom_couch_w-stud])
        #square([stud,stud]);
    }
}

module joist(x,z) {
    translate([x,stud,z])
    cube([stud,bottom_couch_w-stud*2,stud]);
}

module assembled_side() {
    color("cyan")
    rotate([90,0,0])
    linear_extrude(height=plywood)
    side2d();

    translate([0,0,plywood+stud])
    leg(0,0,top_h-plywood-stud);

    color("orange")
    step(stud,0,0);

    color("orange")
    step(stud,0,base_h-stud);
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
    cube([base_w-stud,stud,stud]);
}

module leg(x,y,h) {
    color("lime")
    translate([x,y,0])
    cube([stud,stud,h]);
}

cutaway=base_h*1.05;
cutaway_min=6*in;

module side2d() {
        minkowski() {
            translate([stud/2,stud/2])
            difference() {
                //square([base_w-stud,base_h-stud+base_h/2]);
                square([base_w-stud,base_h-stud]);
                translate([cutaway/2+cutaway_min,(base_h-stud)/2])
                circle(d=cutaway);
            }
            circle(d=stud);
        }
        //translate([0,base_h-stud])
        //minkowski() {
            //translate([stud/2,stud/2])
        //scale([1,0.5])
            //difference() {
                ////square([base_w-stud,base_h-stud+base_h/2]);
                //square([base_w-stud,(base_h-stud)/2]);
                //translate([cutaway/2+cutaway_min,(base_h-stud)/2])
                //circle(d=cutaway);
            //}
            //circle(d=stud);
        //}
        translate([0,base_h-stud])
        triple2d();

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
