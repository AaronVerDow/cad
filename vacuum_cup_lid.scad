
inner_d2=100;
inner_d1=inner_d2-2;
inner_h=7;
outer_d=105;
outer_h=3;

straw=15;
straw2=25;
ring=100;
ring_h=7;
ring_from_lip=2;
total_h=outer_h+inner_h;
pad=0.1;
padd=pad*2;
$fn=90;

fill=30;

straw_h=20;
straw_wall=2;
straw_outer=straw+straw_wall*2;

module ring(d=ring) {
    translate([0,0,inner_h-ring_h-ring_from_lip])
    cylinder(d=d,h=ring_h);
}

module taper() {
    cylinder(d1=inner_d1,d2=inner_d2,h=inner_h);
}

module blank() {
    curve();
    translate([0,0,inner_h])
    cylinder(d=outer_d,h=outer_h);
    straw();
    insert();
}

module straw() {
    cylinder(d=straw_outer,h=straw_h+inner_h+outer_h);
}

module insert() {
    difference() {
        taper();
        ring(inner_d2+padd);
    }
    intersection() {
    ring();
        taper();
    }
}

module fill() {
    translate([outer_d/4+straw/4,0,-pad]) {
        cylinder(d2=fill,d1=fill+total_h*2+padd*2,h=total_h+padd);
        translate([0,0,inner_h+outer_h-pad])
        cylinder(d1=fill-padd,d2=fill+straw_h*2+padd*2,h=straw_h+padd);
    }
}

module fill_avoid_straw() {
    difference() {
        fill();
        straw();
    }
}

extra_straw_offset=5;

module straw_hole() {
    translate([0,0,-pad]) {
        cylinder(d=straw,h=total_h+padd+straw_h);
        cylinder(d2=straw,d1=straw+inner_h*2+outer_h*2+extra_straw_offset*2,h=inner_h+outer_h+extra_straw_offset);
    }
}

module curve_negative() {
    translate([0,0,straw_h])
    rotate_extrude()
    translate([outer_d/2,0,0])
    scale([(outer_d-straw_outer)/(straw_h*2),1])
    circle(r=straw_h);
}


module curve() {
    translate([0,0,inner_h+outer_h])
    difference() {
        cylinder(d=outer_d,h=straw_h);
        curve_negative();
    }
}

bend_radius=5;

module bend() {
    translate([-straw/2-bend_radius,0,inner_h+outer_h+straw_h]) {
        translate([0,0,bend_radius+straw/2])
        rotate([0,-90,0])
        cylinder(d=straw,h=outer_d);
        intersection() {
            translate([0,-straw/2-pad,0])
            cube([straw+bend_radius+pad,straw+padd,straw+bend_radius+pad]);
            rotate([90,0,0])
            rotate_extrude()
            translate([straw/2+bend_radius,0,0])
            circle(d=straw);
        }
    }
}

straw_inset=bend_radius+1;

difference() {
    blank();
    straw_hole();
    fill_avoid_straw();
    translate([0,0,-straw_inset])
    bend();
}
