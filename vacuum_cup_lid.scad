
inner_d2=94;
inner_d1=inner_d2-2;
inner_h=7;
outer_d=100;
outer_h=1.5;

straw=9;
straw2=25;
ring=100;
ring_h=7;
ring_from_lip=2;
total_h=outer_h+inner_h;
pad=0.1;
padd=pad*2;
bigfn=300;
$fn=200;
//$fn=90;

fill=20;

straw_h=15;
straw_wall=1.5;
straw_outer=straw+straw_wall*2;

extra_straw_offset=straw_h-straw;
bend_radius=5;
straw_inset=bend_radius;

straw_offset=15;

insert_wall=3;

lip=1;


module ring(d=ring) {
    translate([0,0,inner_h-ring_h-ring_from_lip])
    cylinder(d=d,h=ring_h);
}

module taper(extra=0,padding=0) {
    translate([0,0,-padding])
    cylinder(d1=inner_d1+extra,d2=inner_d2+extra,h=inner_h+padding*2);
}

module lip() {
    translate([0,0,outer_h-lip])
    rotate_extrude()
    translate([outer_d/2-lip,0,0])
    intersection() {
        circle(r=lip);
        square([lip*3,lip*3]);
    }
    cylinder(d=outer_d-lip*2,h=outer_h);
    cylinder(d=outer_d,h=outer_h-lip);
}

module old_lip() {
    difference() {
        minkowski() {
            translate([0,0,-lip])
            cylinder(d=outer_d-lip*2,h=outer_h);
            sphere(r=lip);
        }
        cylinder(d=outer_d-lip*2,h=outer_h);
    }
}

module blank() {
    curve();
    translate([0,0,inner_h])
    lip();
    straw();
    insert();
}

module straw() {
    translate([-straw_offset,0,0])
    cylinder(d=straw_outer,h=straw_h+inner_h+outer_h);
}

// with rubber ring
module old_insert() {
    difference() {
        taper();
        ring(inner_d2+padd);
    }
    intersection() {
        ring();
        #taper();
    }
}

module insert() {
    difference() {
        taper();
        taper(-insert_wall, pad);
    }
}

module fill() {
    translate([outer_d/4+straw/4,0,-pad]) {
        cylinder(d2=fill,d1=fill+total_h*2+padd*2,h=total_h+padd);
        translate([0,0,inner_h+outer_h-pad])
        cylinder(d1=fill-padd,d2=fill+straw_h*1.5+padd*2,h=straw_h+padd);
    }
}

module fill_avoid_straw() {
    difference() {
        fill();
        straw();
    }
}


module straw_hole() {
    translate([-straw_offset,0,-pad]) {
        cylinder(d=straw,h=total_h+padd+straw_h);
        cylinder(d2=straw,d1=straw+inner_h*2+outer_h*2+extra_straw_offset*2,h=inner_h+outer_h+extra_straw_offset);
    }
}

module curve_negative() {
    translate([0,0,straw_h])
    rotate_extrude()
    translate([outer_d/2-straw_offset-lip,0,0])
    scale([(outer_d-straw_outer-straw_offset*2-lip*2)/(straw_h*2),1])
    circle(r=straw_h);
}


module curve() {
    translate([-straw_offset,0,inner_h+outer_h])
    difference() {
        cylinder(d=outer_d-straw_offset*2-lip*2,h=straw_h);
        curve_negative();
    }
}

module bend() {
    $fn=45;
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


difference() {
    blank();
    straw_hole();
    //fill_avoid_straw();
    translate([-straw_offset,0,-straw_inset]) {
        bend();
        rotate([0,0,180])
        bend();
    }
}
