$fn=200;
in=25.4;


panel_w=3*12*in;

stud=3.5*in;

wall=stud;

plywood=in/2;

tabs=stud*4;

back_h=5*12*in;
front_h=7*12*in;
base_l=9.5*12*in;
base_w=8*12*in;
roof_back=1*12*in;
roof_front=1.5*12*in;

roof_l=roof_back+roof_front+base_l;
roof_side=6*in;
roof_w=roof_side*2+base_w;

roof_angle=atan((front_h-back_h)/base_l);

roof_hyp=base_l/cos(roof_angle);
front_angle=10;

hole=5*in;
hole_gap=3*in;

panel_front=tan(roof_angle)*(panel_w-stud);

circle_multiplier=1.2;

side_cutaway=(back_h+panel_front)*circle_multiplier;
cutaway_min=3.5*in;

cutaway=back_h*circle_multiplier;

// RENDER obj
// RENDER stl
module with_car() {
    color("cyan")
    translate([0,200,-600])
    scale(304.8)
    import("fiat_500.stl");
    assembled();
}

with_car();

module assembled() {
    rotate([0,0,90])
    translate([-base_l/2,-base_w/2]) {
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
 
module side2d() {
    minkowski() {
        translate([stud/2,stud/2])
        difference() {
            square([panel_w-stud,back_h-stud]);
            translate([cutaway/2+cutaway_min,(back_h-stud)/2])
            circle(d=cutaway);
        }
        circle(d=stud);
    }
}
