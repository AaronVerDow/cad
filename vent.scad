wall=1;
slat_h=wall;
slat_angle=40;
inner_h=20;
outer_h=wall;
inner_wall=wall;
inner=100;
outer_wall=10;
outer=inner+outer_wall*2;
slat_gap=inner_h;

wire=15;
wire_h=wire;
wire_wall=wall;

pad=0.1;
padd=pad*2;

$fn=90;

module positive() {
    cylinder(d=inner,h=inner_h);
    cylinder(d=outer,h=outer_h);
}

module slat(y=0) {
    translate([0,y,0])
    rotate([-slat_angle,0,0])
    translate([-outer/2,0,-pad])
    cube([outer,slat_h,inner_h*2]);
}

module slats() {
    for(y=[-inner:slat_gap:inner]) {
        slat(y);
    }
}

module negative() {
    difference() {
        translate([0,0,-pad])
        cylinder(d=inner-inner_wall*2,h=inner+padd);
        slats();
    }
}

module wire_start() {
    translate([0,-inner/2+wire/2+wire_h-wire,0])
    children();
}

module wire_end() {
    translate([0,-inner,0])
    children();
}

module wire_slot() {
    hull() {
        wire_start()
        children();
        wire_end()
        children();
    }
}

module wire() {
    translate([0,0,-pad])
    cylinder(d=wire,h=inner_h+padd);
}

module wire_wall() {
    cylinder(d=wire+wire_wall*2,h=inner_h);
}

module vent() {
    difference() {
        positive();
        negative();
    }
}

module vent_with_wire() {
    difference() {
        union() {
            vent();
            intersection() {
                wire_slot() wire_wall();
                positive();
            }
        }
        wire_slot() wire();
    }
}

vent_with_wire();
