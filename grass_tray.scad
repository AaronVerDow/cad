max_x=180;
max_y=85;
max_z=15;
$fn=90;

tray_wall=1.5;
waterproofing=0.7;

inner_tray_wall=tray_wall;
outer_tray_wall=tray_wall;
outer_tray_base=tray_wall;
inner_tray_base=tray_wall;
outer_corner=10;

top_tray_wall=tray_wall;
top_tray_base=tray_wall;

tray_h=10;

tray_angle=15;

nothing=0.01;
airgap=5;

pillar=6;
pillar_key=pillar/3*2;
pillar_hole=pillar_key*1.2;

pillar_offset=15;

opp=tan(tray_angle)*tray_h;
pad=0.1;

hole=3.5;

hole_gap=hole*3;
hole_wall=8;

explode=0;

module holes() {
    
    translate([-max_x/2+max_x%hole_gap/2,-max_y/2+max_y%hole_gap/2]) {

        for(x=[0:hole_gap:max_x])
        for(y=[0:hole_gap:max_y])
        translate([x,y])
        circle(d=hole);

        translate([hole_gap/2,hole_gap/2])
        for(x=[0:hole_gap:max_x])
        for(y=[0:hole_gap:max_y])
        translate([x,y])
        circle(d=hole);
    }
}


module dirror_y() {
    children();
    mirror([0,1,0])
    children();
}

module dirror_x() {
    children();
    mirror([1,0,0])
    children();
}

module pillars() {
    dirror_x()
    dirror_y()
    translate([max_x/2-pillar_offset,max_y/2-pillar_offset])
    children();
    children();
}

// RENDER stl
module base() {
    color("lime")
    translate([0,0,-explode])
    tray(max_x,max_y,tray_h,outer_corner,outer_tray_wall,outer_tray_base,opp);
}

// RENDER stl
module inner() {
    inner_diff=outer_tray_wall+waterproofing;
    color("blue")
    translate([0,0,outer_tray_base+waterproofing]) {
        tray(max_x-inner_diff,max_y-inner_diff,tray_h-outer_tray_base-waterproofing,outer_corner,outer_tray_wall,outer_tray_base,opp);
        pillars() {
            cylinder(d=pillar,h=tray_h+airgap-inner_tray_base-waterproofing);
            cylinder(d=pillar_key,h=tray_h+airgap-inner_tray_base-waterproofing+top_tray_base);
        }
    }

}

translate([0,0,-tray_h-airgap-pad]) {
    base();

    inner();
}

top();

// RENDER stl
module top() {
    translate([0,0,explode])
    difference() {
        tray(max_x,max_y,max_z,outer_corner,top_tray_wall,top_tray_base);
        pillars()
        translate([0,0,-pad])
        cylinder(d=pillar_hole,h=top_tray_base+pad*2);

        translate([0,0,-pad])
        linear_extrude(height=top_tray_base+pad*2)
        intersection() {
            holes();
            difference() {
                offset(-hole_wall)
                square([max_x,max_y],center=true);
                pillars()
                circle(d=pillar*1.5);
            }
        }
    }
}

module tray(x,y,z,r,wall,base,in=0) {
    difference() {
        tray_shape(x,y,z,r,in);
        translate([0,0,base])
        tray_shape(x-wall,y-wall,z-base+pad,r-wall/2,in);
    }
}

module tray_shape(x,y,z,r,in=0) {
    hull() {
        linear_extrude(height=nothing)
        round(r)
        offset(-in)
        square([x,y],center=true);

        translate([0,0,z-nothing])
        linear_extrude(height=nothing)
        round(r)
        square([x,y],center=true);
    }
}

module round(r) {
    offset(r)
    offset(-r)
    children();
}
