in=25.4;
pad=10;
zero=10;

// actual lumber sizes
one=0.75*in;
two=1.5*in;
three=2.5*in;
four=3.5*in;

sauna_x=1205;
sauna_y=1050;
sauna_z=2050;
sauna_wall=50;
sauna_floor=240;

vacuum_width=360;
vacuum_height=120;

ceiling=sauna_z;
back_wall=2390;
left_wall=1220;
right_wall=490;
wall_thickness=zero;

porch=560;


shelf_x=42*in;
shelf_z=31*in;
shelf_y=7.75*in; // guess

// distance from bottom to floor
shelf_height=ceiling*0.46;

// Overall: 22.5" wide x 17.75" deep x 17.25" high
hamper_x=22.5*in;
hamper_y=17.75*in;
hamper_z=17.25*in;

// x  hamper_y
// 1  hamper_x


gap=in;
bench_x=back_wall-sauna_x-gap*2;
bench_y=right_wall-gap;
bench_z=hamper_z+3*in;

porch_extension=porch-110;


plank_width=three;
plank_height=one;
plank_corner=in/4;

benchtop=plank_height;

// sauna gap is 14
plank_gap=one;

joist_width=two;
joist_height=vacuum_height;
joist_gap=16*in;

floor_height=joist_height+plank_height;

module joist() {
    translate([-joist_width/2,0])
    cube([joist_width,sauna_y+gap+porch,joist_height]);
}

module joists() {
    for(x=[joist_width/2:joist_gap:back_wall])
    translate([x,0])
    joist();
}

color("wheat")
intersection() {
    translate([0,-porch,0])
    joists();
    translate([0,0,-pad])
    linear_extrude(height=joist_height+pad*2)
    floor_profile();
}

module plank_profile() {
    offset(plank_corner)
    offset(-plank_corner)
    square([plank_width,plank_height]);
}

module plank() {
    rotate([90,0,90])
    linear_extrude(height=back_wall)
    plank_profile();
}

module planks() {
    color("tan")
    for(i=[0:plank_width+plank_gap:sauna_y+gap+porch])
    translate([0,i,0])
    plank();
}

translate([0,0,joist_height])
intersection() {
    translate([0,-porch])
    planks();
    translate([0,0,-pad])
    linear_extrude(height=plank_height+pad*2)
    floor_profile();
}

module floor_profile() {
    difference() {
        hull() {
            translate([0,-porch-gap])
            square([sauna_x+porch_extension,porch]);

            translate([sauna_x+gap,sauna_y-right_wall])
            square([back_wall-sauna_x-gap*2,right_wall-gap]);
        }
        translate([-gap,-gap])
        square([sauna_x+gap*2,sauna_y+gap*2]);
    }
}

//linear_extrude(height=floor_height) floor_profile();

module hamper() {
    color("tan")
    difference() {
        translate([0,0,hamper_x/2])
        scale([1,hamper_y/hamper_x,1])
        sphere(d=hamper_x,$fn=12);

        translate([0,0,hamper_z])
        cylinder(d=hamper_x,h=hamper_x);

    }
}


module wall_shelf() {
    //#cube([shelf_x,zero,shelf_z]);
    color("tan")
    translate([-shelf_x/2,0,-280])
    rotate([90,0])
    linear_extrude(height=shelf_y)
    scale(4.9)
    import("HelloKitty.svg");
}


module sauna() {
    color("peru")
    difference() {
        cube([sauna_x,sauna_y,sauna_z]);
        translate([sauna_wall,-sauna_wall,sauna_floor])
        cube([sauna_x-sauna_wall*2,sauna_y,sauna_z-sauna_wall-sauna_floor]);
    }
}

module walls() {
    cube([back_wall,wall_thickness,ceiling]);
    translate([-zero,-left_wall,0])
    cube([zero,left_wall,ceiling]);
    translate([back_wall,-right_wall,0])
    cube([zero,right_wall,ceiling]);
}

module benchtop() {
    intersection() {
        planks();
        translate([0,0,-pad])
        cube([bench_x,bench_y,benchtop+pad*2]);
    }
}

bench_leg_wall=four;
bench_leg_width=two;

module bench_leg() {
    color("wheat")
    difference() {
        cube([bench_leg_width,bench_y,bench_z-benchtop]);
        translate([-pad,bench_leg_wall,bench_leg_wall])
        cube([bench_leg_width+pad*2,bench_y-bench_leg_wall*2,bench_z-benchtop-bench_leg_wall*2]);
    }
}

bench_shelf_x=bench_x-hamper_x-bench_leg_width;
bench_shelf_z=bench_z/2;

module bench_shelf() {
    
}

module bench() {
    translate([0,0,bench_z-benchtop])
    benchtop();
    bench_leg();

    
    translate([bench_x-bench_leg_width,0])
    bench_leg();
    
    translate([bench_shelf_x-bench_leg_width,0])
    bench_leg();

    bench_shelf();
}

//!bench();

translate([sauna_x+gap,sauna_y-bench_y-gap,floor_height])
bench();

sauna();
translate([0,sauna_y,0])
walls();
translate([(back_wall-sauna_x)/2+sauna_x,sauna_y,shelf_height])
wall_shelf();

translate([back_wall-hamper_x/2-gap-bench_leg_width,sauna_y-hamper_y/2,floor_height])
hamper();
