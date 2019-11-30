
outer_d=115;
outer_base_d=105;
extra_h=50;
wall=3;
outer_h=wall+extra_h;
inner_d=95;
inner_inner_d=50;
filter_angle=15;
inner_h=tan(filter_angle)*(outer_d-inner_d)/2+outer_h;

cup_wall=5;
pad=0.1;
$fn=200;

tooth_w=37;
tooth_h=inner_h/3*2;
tooth_gap=wall*2;
tooth_degrees=45;
tooth_d=1;
tooth_drain=6;

teeth=5;
max_cup=20;

drain_extra=5;
drain_wall=1.6;
drain_base=1.2;
drain_h=5;

lid_extra=3;

assembled=10;

module drain() {
    cap(outer_base_d+drain_extra*2);
}

module lid() {
    cap(outer_d+lid_extra*2);
}

module cap(d) {
    difference() {
        cylinder(d=d,h=drain_h);
        translate([0,0,drain_base])
        cylinder(d=d-drain_wall*2,h=drain_h);
    }
}


module assembled() {
    translate([0,0,inner_h+assembled+drain_h])
    mirror([0,0,1])
    #lid();

    translate([0,0,-drain_h-assembled])
    #drain();

    main();
}

module positive() {
    cylinder(d1=outer_base_d,d2=outer_d,h=outer_h);
    cylinder(d=inner_d,h=inner_h);
}


module negative() {
    translate([0,0,-pad])
    cylinder(d2=inner_d-wall*2,d1=inner_inner_d,h=inner_h+pad*2);
    difference() {
        translate([0,0,-pad])
        cylinder(d=outer_base_d-wall*2,h=cup_wall+pad);
        translate([0,0,cup_wall/2])
        //fudge
        cylinder(d=inner_inner_d+wall*3,h=cup_wall);
    }
}

module angled_cup_holder() {
    difference() {
        translate([0,0,-pad])
        cylinder(d1=outer_d-wall*2,d2=outer_d-wall*2-max_cup*2,h=max_cup);
        cylinder(d1=inner_inner_d+wall*2,d2=inner_inner_d+wall*2+max_cup*2,h=max_cup);
    }
}

module main() {
    difference() {
        positive();
        negative();
        teeth();
    }
}

module teeth() {
    rotate([0,0,180/teeth])
    translate([0,0,inner_h])
    mirror([0,0,1])
    jaw();
    jaw();
}

module jaw() {
    for (i=[0:360/teeth:359]) {
        rotate([0,0,i])
        other_tooth();
    }
}
module tooth() {
    scale([1,1,tooth_h/sqrt(2*tooth_w*tooth_w)*2])
    rotate([45,0,0])
    translate([0,-tooth_w/2,-tooth_w/2])
    cube([outer_d,tooth_w,tooth_w]);
}

module other_tooth_piece() {
    rotate([0,90,0])
    cylinder(d=tooth_d,h=outer_d/2+8,$fn=12);
}

module other_tooth() {
    hull() {
        translate([outer_d/2,0,tooth_h])
        rotate([0,tooth_drain,0])
        translate([-outer_d/2,0,0])
        other_tooth_piece();

        rotate([0,0,tooth_degrees/2])
        translate([0,0,-tooth_d*2])
        other_tooth_piece();

        rotate([0,0,-tooth_degrees/2])
        translate([0,0,-tooth_d*2])
        other_tooth_piece();
    }
}


display="";
if (display == "") assembled();
if (display == "coffee_stuff.stl") main();
if (display == "coffee_stuff_lid.stl") lid();
if (display == "coffee_stuff_drain.stl") drain();

