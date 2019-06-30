extrusion_width=1.2;
wall=extrusion_width;
x=250;
y=150;
base_r=20;
inner=220;
side_top=20;
side_bottom=40;

angle=atan((side_bottom-side_top)/y);

pad=0.1;
padd=pad*2; 
gap=20;

crook=0.5;
$fn=90;


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

module side() {
    translate([-x/2,-wall,0])
    cube([x,wall,y]);
    edges();
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

module rotated_side(){
    rotate([-angle,0,0])
    side();
}

module both(){
    rotated_side();
    translate([0,side_bottom*2+gap,0])
    mirror([0,1,0])
    rotated_side();
}

both();
