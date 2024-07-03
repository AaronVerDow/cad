one=19;
two=38;
four=90;

pad=0.1;
zero=0.01;

// from amazon listing:
// 41.3 x 47.2 x 74.8 inches 
in=25.4;
// packing wood with sauna
base_wood=8.5;

base_x=1200;
base_y=1050;

max_height=150;

wheelbase=74;
wheel_diameter=120;
wheel_height=80;
wheel_bump=25;

wood_flat_height=max_height-base_wood-wheel_height;
wheel_offset=wheelbase/2+two/2;
wood_flat_wide=wheelbase+two+pad*2;

module wheel() {
    hull() {
        translate([0,0,wheel_height-wheel_bump])
        cylinder(d=wheel_diameter,h=wheel_bump);
        cube([wheelbase,wheelbase,zero],center=true);
    }
}

translate([wheel_offset,wheel_offset,max_height-base_wood-wheel_height])
wheel();

module twobyfour(length) {
    cube([length,two,four]);
}

translate([0,0,-base_wood]){
    color("tan")
    linear_extrude(height=base_wood)
    square([base_x,base_y]);
    //#cube([base_x,base_y,max_height]);
}

module dirror_y(y=0) {
    children();
    translate([0,y])
    mirror([0,1])
    children();
}


module dirror_x(x=0) {
    children();
    translate([x,0])
    mirror([1,0])
    children();
}

//#cube([base_x,base_y,max_height]);


module beam_x(y=0) {
    color("lime")
    translate([0,y])
    twobyfour(base_x);
}

module beam_y(x=0) {
    color("blue")
    translate([x+two,two])
    rotate([0,0,90])
    twobyfour(base_y-two*2);
}

module beams() {
    beam_x();
    beam_x(base_y-two);
    dirror_x(base_x) {
        beam_y();
        beam_y(wheelbase);
        beam_y(base_x/3);
    }
}


difference() {
    beams();
    dirror_y(base_y)
    dirror_x(base_x)
    translate([-pad,-pad,max_height-base_wood-wheel_height])
    cube([wood_flat_wide,wood_flat_wide,wheel_height]);
}

echo("CUTSHEET=================================================");
echo("Base sheet ", base_x, "x", base_y, ", ", base_wood, " thick");
echo("6x 2x4", base_y-two*2, "long");
echo("4x of above with", wood_flat_wide-two, "wide flat");
echo("2x 2x4", base_x, "long with", wood_flat_wide, "wide flat");
echo("Flat is", wood_flat_height, "thick");
echo("=========================================================");

