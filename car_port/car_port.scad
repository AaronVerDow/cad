$fn=200;
in=25.4;
panel_w=38*in;
base_h=66*in;

translate([340,0,-600])
translate([base_l/2,base_w/2,0])
rotate([0,0,-90])
scale(304.8)
color("cyan")
import("fiat_500.stl");

bottom_couch_w=86*in;

top_h=110*in;

panel_w=3*12*in;

stud=3.5*in;

wall=stud;

base_neg_w=panel_w-wall*2;

steps=2;

plywood=in/2;

tabs=stud*4;

total=100;
half=total/2;
width=5;

tip=26;

plywood_x=4*12*in;
plywood_y=8*12*in;

back_h=5*12*in;
front_h=7*12*in;
base_l=9.5*12*in;
base_w=7*12*in;
roof_back=1*12*in;
roof_front=1.5*12*in;

roof_l=roof_back+roof_front+base_l;
roof_side=6*in;
roof_w=roof_side*2+base_w;

roof_angle=atan((front_h-back_h)/base_l);

roof_hyp=base_l/cos(roof_angle);
front_angle=10;

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
    translate([0,base_w,0])
    mirror([0,1,0])
    assembled_side();

    color("lime") {
        joist(0,0);
        joist(0,back_h-stud);
        joist(base_l-stud,front_h-stud);
    }

    color("peru")
    translate([0,0,back_h])
    rotate([0,-roof_angle,0])
    translate([-roof_back,-roof_side,0])
    linear_extrude(height=plywood)
    square([roof_l,roof_w]);

    assembled_back();

    translate([0,0,stud])
    corner();

    mirror([0,1,0])
    translate([0,-base_w,stud])
    corner();

    translate([base_l,0,front_h])
    rotate([0,90,0])
    corner();

    mirror([0,1,0])
    translate([base_l,-base_w,front_h])
    rotate([0,90,0])
    corner();
}

//flat();
//linear_extrude(height=plywood)
//top_bottom2d();

module flat() {
    translate([-plywood_x*1.2,0])
    square([plywood_x,plywood_y]);

    side2d();
    translate([panel_w*1.2,0])
    side2d();

    for(i=[0:tabs*2:tabs*6])
    translate([i,-tabs*2])
    #corner2d();

    for(i=[0:tabs*2:tabs*2])
    translate([i,-tabs*4])
    triple2d();

    translate([panel_w*2.4,0])
    top2d();

    translate([panel_w*4,0])
    top_bottom2d();
    
}

module assembled_back() {
    #color("maroon")
    translate([-plywood,0,0])
    rotate([90,0,90])
    linear_extrude(height=plywood)
    side2d();

    #color("maroon")
    translate([0,base_w,0])
    rotate([90,0,90+180])
    linear_extrude(height=plywood)
    side2d();
}

module corner() {
    #color("maroon")
    linear_extrude(height=plywood)
    corner2d();
}

module triple() {
    #color("maroon")
    linear_extrude(height=plywood)
    triple2d();
}

module triple2d() {
    corner2d();
    translate([0,stud,0])
    mirror([0,1,0])
    corner2d();
}

module bad_angled_corner2d() {
    translate([stud/2+tabs,stud/2+tan(roof_angle)*(tabs+stud/2)])
    circle(d=stud);
    translate([1,1])
    circle(d=2);
    translate([stud/2,stud/2+tabs])
    circle(d=stud);

    a=tabs-tan(roof_angle)*(tabs+stud/2);
    o=tabs;
    h=sqrt(a*a+o*o);
    difference() {
        square([tabs+stud/2,tabs+stud/2]);
        translate([stud/2,tabs+stud/2])
        rotate(atan(o/a))
        translate([0,-h/2])
        #circle(d=h-stud);
    }
}



module angled_corner2d() {
    translate([stud/2+tabs,stud/2+tan(roof_angle)*(tabs+stud/2)])
    circle(d=stud);
    translate([1,1])
    circle(d=2);
    translate([stud/2,stud/2+tabs])
    circle(d=stud);

    a=tabs-tan(roof_angle)*(tabs+stud);
    o=tabs;
    h=sqrt(a*a+o*o);
    difference() {
        square([tabs+stud/2,tabs+stud/2]);
        translate([tabs+stud/2,tabs+stud/2])
        scale([1,a/o])
        circle(r=tabs-stud/2);
        rotate(roof_angle)
        translate([0,-tabs*2])
        square([tabs*2,tabs*2]);
    }
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
        square([panel_w,base_w]);
        square([stud,stud]);
        translate([0,base_w-stud])
        #square([stud,stud]);
        //rotate([0,0,45])
        //for(y=[0:hole+hole_gap:base_w])
        //for(x=[0:hole+hole_gap:base_w])
        //translate([x,y])
        //#square([hole,hole]);
    }
}

module top2d() {
    difference() {
        square([panel_w,base_w]);
        square([stud,stud]);
        translate([0,base_w-stud])
        #square([stud,stud]);
    }
}

module joist(x,z) {
    translate([x,stud,z])
    cube([stud,base_w-stud*2,stud]);
}

module assembled_side() {
    #color("maroon")
    rotate([90,0,0])
    linear_extrude(height=plywood)
    actual_side2d();

    translate([0,0,plywood+stud])
    cube([stud,stud,back_h-stud*2-plywood]);

    translate([base_l-stud,0,stud])
    cube([stud,stud,front_h-stud*2-plywood]);

    color("lime")
    cube([base_l,stud,stud]);

    color("lime")
    translate([0,0,back_h])
    rotate([0,-roof_angle,0])
    translate([0,0,-stud])
    cube([roof_hyp-20,stud,stud]);

    translate([base_l,0,0])
    rotate([90,-90,0])
    corner();

    #color("maroon")
    translate([base_l,0,front_h])
    rotate([90,180,0])
    linear_extrude(height=plywood)
    angled_corner2d();
}

module assembled_outside() {
    translate([0,-stud-plywood,0])
    rotate([90,0,0])
    linear_extrude(height=plywood)
    corner2d();

    translate([panel_w,-stud-plywood,0])
    mirror([1,0,0])
    rotate([90,0,0])
    linear_extrude(height=plywood)
    corner2d();

    translate([panel_w,-stud-plywood,base_h])
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
        translate([panel_w,-stud-plywood,z])
        mirror([1,0,0])
        rotate([90,0,0])
        linear_extrude(height=plywood)
        triple2d();
    }
}

module step(x,y,z) {
    translate([x,y,z])
    cube([panel_w-stud,stud,stud]);
}

module leg(x,y,h) {
    color("lime")
    translate([x,y,0])
    cube([stud,stud,h]);
}

panel_front=tan(roof_angle)*(panel_w-stud);

circle_multiplier=1.2;

side_cutaway=(back_h+panel_front)*circle_multiplier;
cutaway_min=3.5*in;

module actual_side2d() {
        minkowski() {
            translate([stud/2,stud/2])
            difference() {
                union() {
                    square([panel_w-stud,back_h-stud]);
                    translate([0,back_h-stud])
                    rotate(roof_angle)
                    translate([0,-panel_front*2])
                    square([panel_w-stud,panel_front*2]);
                }
                translate([side_cutaway/2+cutaway_min,(back_h+panel_front-stud)/2])
                circle(d=side_cutaway);
            }
            circle(d=stud);
        }
}
 
cutaway=back_h*circle_multiplier;

module side2d() {
        minkowski() {
            translate([stud/2,stud/2])
            difference() {
                //square([base_w-stud,base_h-stud+base_h/2]);
                square([panel_w-stud,back_h-stud]);
                translate([cutaway/2+cutaway_min,(back_h-stud)/2])
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
        //translate([0,base_h-stud])
        //triple2d();

}

module base_positive() {
    for(y=[0:(base_h-wall)/(steps+1):base_h]){
            translate([0,y])
            step2d();
    }
}

module base_negative() {
    hull() {
        translate([panel_w/2,base_neg_w/2+wall])
        circle(d=base_neg_w);
        translate([panel_w/2,base_h-base_neg_w/2-wall])
        circle(d=base_neg_w);
    }
    square([stud,stud]);
}

module step2d() {
    square([panel_w,wall]);
}
