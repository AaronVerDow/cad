extrusion_width=1.2;
wall=extrusion_width;
x=275;
y=200;
base_r=20;
inner=250;
side_top=20;
side_bottom=50;

angle=atan((side_bottom-side_top)/y);

pad=0.1;
padd=pad*2; 
gap=20;

crook=0.5;
$fn=90;

inner_edge=30;
inner_crook=1;

base=wall;


module corner() {
    translate([x/2,(x-inner)/2+wall+crook,0]) 
    intersection() {
        difference() {
            cylinder(d=x-inner+wall*2,h=y);
            translate([0,0,-pad])
            cylinder(d=x-inner,h=y+padd);
        }
        translate([-x,-x,-pad])
        cube([x,x,y+padd*2]);
    }

}


module corners() {
    corner();
    mirror([1,0,0])
    corner();
}

module edge() {
    translate([x/2,crook/2,0])
    difference() {
        cylinder(d=wall*2+crook,h=y);
        translate([0,0,-pad])
        cylinder(d=crook,h=y+padd);
        translate([-wall*4-crook*2,-wall*2-crook,-pad])
        cube([wall*4+crook*2,wall*4+crook*2,y+padd]);
    }
}

module edges() {
    edge();
    mirror([1,0,0])
    edge();
}

module inner_edges() {
    inner_edge();
    mirror([1,0,0])
    inner_edge();
}

module trimmed_side() {
    difference() {
        side();
        translate([-x,-side_bottom/2,y])
        cube([x*2,side_bottom*2,side_bottom]);
    }
}

module side() {
    translate([-x/2,-wall,0])
    cube([x,wall,y]);
    edges();
    inner_edges();
    difference() {
        union() {
            translate([-inner/2,(x-inner)/2+wall+crook,0])
            cube([inner,side_bottom,y]);
            corners();
        }
        translate([-inner/2+wall,-pad,-pad])
        cube([inner-wall*2,side_bottom+padd,y+padd]);

        translate([0,side_bottom,0])
        rotate([angle,0,0])
        translate([-x/2,0,-y/3])
        cube([x,side_bottom,y*2]);
        
        rotate([angle,0,0])
        translate([-x/2,0,-y])
        cube([x,side_bottom*2,y]);
    }
}

module base_side() {
    translate([inner/2-inner_edge-wall-inner_crook,0,0])
    cube([inner_edge+inner_crook,51,base]);
}

module base() {
    base_side();
    mirror([1,0,0])
    base_side();
}


module rotated_side(){
    difference() {
        rotate([-angle,0,0])
        trimmed_side();
        translate([-x,-side_bottom/2,-side_bottom])
        cube([x*2,side_bottom*2,side_bottom]);
    }
    base();
}

module both(){
    rotated_side();
    translate([0,side_bottom*2+gap,0])
    mirror([0,1,0])
    rotated_side();
}

module inner_edge() {
    translate([inner/2-inner_edge-wall-inner_crook/2,side_bottom-side_top/2,0])
    rotate([angle,0,0])
    difference() {
        minkowski() {
            cube([inner_edge,side_top/2,y*1.1]);
            cylinder(d=inner_crook+wall*2,h=pad);
        }
        minkowski() {
            translate([0,-wall-crook,0])
            cube([inner_edge,side_top/2+wall+crook,y*1.1]);
            cylinder(d=inner_crook,h=padd);
        }
        translate([0,-wall*2-inner_crook,0])
        cube([inner_edge+inner_crook+wall,side_top/2+wall+crook,y*1.1]);
    }
}

rotated_side();


display="";
//if (display == "") both();
if (display == "lys_bag.stl") rotated_side();
