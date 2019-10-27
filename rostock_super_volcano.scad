sides=3;
side=78;
platform_holes_r=side/sqrt(3);
platform_holes_d=platform_holes_r*2;

tab=9;
tab_h=2;
tab_hole=3;

tab_offset=38;

pad=0.1;
padd=pad*2;
$fn=200;

ring=platform_holes_d-20;
ring_wall=tab_h;
ring_h=tab_h*3;

top_ring=ring-ring_wall*2;
screw_hole=2.5;

slide_inset=17;

module tab() {
    difference() {
        tab_positive();
        translate([platform_holes_r,0,-pad])
        cylinder(d=tab_hole,h=tab_h+padd);
    }
}

module tab_positive() {
    translate([platform_holes_r,0,0])
    cylinder(d=tab,h=tab_h);
    translate([0,-tab/2,0])
    cube([platform_holes_r,tab,tab_h]);
}

module tabs() {
    for(i=[0:360/sides:359]){
        rotate([0,0,i])
        tab();
    }
}

module inset(extra=0, pade=0) {
        rotate([0,0,-360/3/2])
        translate([ring/2-slide_inset-extra,-ring/2,-padd])
        cube([ring,ring,ring_h+padd*2]);
}

module base() {
    translate([0,0,-tab_offset])
    difference() {
            tabs();
            translate([0,0,-pad])
            cylinder(d=ring-ring_wall*2,h=ring_h+padd);
    }
    translate([0,0,-tab_offset])
    difference() {
        cylinder(d=ring,h=ring_h);
        difference() {
            translate([0,0,-pad])
            cylinder(d=ring-ring_wall*2,h=ring_h+padd);
            inset(ring_wall, padd);
        }
        inset();
    }
}


module top() {
    difference() {
        tabs();
        translate([0,0,-pad])
        cylinder(d=top_ring,h=tab_h+padd);
    }
}


module bridge_positive() {
    hull() {
        tab_positive();
        translate([0,0,-tab_offset])
        intersection() {
            tab_positive();
            cylinder(d=ring,h=ring_h);
        }
    }
}

module bridge() {
    difference() {
        bridge_positive();
        translate([0,0,-tab_offset-pad])
        cylinder(d1=ring-ring_wall*2,d2=top_ring,h=tab_offset+tab_h+padd);
        translate([platform_holes_r,0,-tab_offset])
        cylinder(d=screw_hole,h=tab_h+tab_offset+padd);
        cylinder(d=platform_holes_d*1.5,h=tab_h+pad);
    }
}

module bridges() {
    for(i=[0:360/sides:359]){
        rotate([0,0,i])
        bridge();
    }
}


probe_screw=2.5;
probe_screw_gap=18.5;
wires=1;
probe_screw_h=1+wires;
pull_screw=3.5;
pull_screw_h=20;
pull_wall=1;
probe_wall=2;
nut=7.5;
nut_h=2;
nut_sides=4;
outer_nut=10;
probe=probe_wall*2+probe_screw;
slide_gap=0.2;
slide_wall=1;

slide_inside=outer_nut+slide_gap*2;
slide_outside=slide_inside+slide_wall*2;
slide_h=pull_screw_h+probe-pull_wall*2-nut_h-6;

module slide() {
    difference() {
        cylinder(d=slide_outside,h=slide_h);
        slide_negative();
    }
}
module slide_negative() {
    translate([0,0,-pull_wall])
    cylinder(d=slide_inside,h=slide_h);
    translate([-slide_outside/2,-slide_outside/2-pad,-pad])
    cube([slide_outside,probe_screw_h+slide_gap+pad,slide_h+padd]);
    cylinder(d=pull_screw,h=slide_h+pad);
}


module probe_screw() {
    translate([0,0,-pad])
    cylinder(d=probe_screw,h=probe_screw_h+padd);
}

module probe_wall() {
    cylinder(d=probe_screw+probe_wall*2,h=probe_screw_h);
}

module probe_positive() {
    hull() {
        probe_wall();
        translate([probe_screw_gap,0,0])
        probe_wall();
    }
    pull_nut();
}


module probe() {
    difference() {
        probe_positive();
        probe_screw();
        translate([probe_screw_gap,0,0])
        probe_screw();
        translate([probe_screw/2+probe_wall,-probe_screw/2-probe_wall-pad,-pad])
        cube([probe_screw_gap-probe_wall*2-probe_screw,probe_wall*2+probe_screw+padd,wires+pad]);
    }
}

module pull_nut() {
    translate([probe_screw_gap/2,-probe/2,outer_nut/2])
    rotate([-90,0,0])
    difference() {
        cylinder(d=outer_nut,h=probe);
        translate([0,0,-pad])
        cylinder(d=pull_screw,h=probe+padd);
        translate([0,0,-probe_wall])
        rotate([0,0,45])
        cylinder(d=nut,h=probe,$fn=nut_sides);
    }
}


module position_slide() {
    rotate([0,0,90-360/sides/2])
    translate([0,-ring/2+ring_wall/2+slide_inset,-tab_offset])
    children();
}

module cage() {
    position_slide()
    slide();
    difference() {
        base();
        position_slide()
        slide_negative();
    }
    bridges();
}

display="";
if(display=="") {
    cage();
    probe();
}
if(display=="rostock_super_volcano_probe.stl") 
rotate([-90,0,0])
probe();
if(display=="rostock_super_volcano_cage.stl") 
cage();
