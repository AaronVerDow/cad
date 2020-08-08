in=25.4;
ingot_height=2*in;
ingot_angle=15;
ingot_top_x=2*in;
ingot_top_y=4.5*in;

ingot_base_x = ingot_height*tan(ingot_angle)*2+ingot_top_x;
ingot_base_y = ingot_height*tan(ingot_angle)*2+ingot_top_y;


// how high the actual part is
grip_h = 20;

pad=0.1;

module ingot() {
    slice=0.0001;
    hull() {
        cube([ingot_base_x,ingot_base_y,slice],center=true);
        translate([0,0,ingot_height])
        cube([ingot_top_x,ingot_top_y,slice],center=true);
    }
}


// diameter of maslow sled 
sled=400;

// distnace from bottom edge of maslow to edge of stand
stand=100;

// display height
stand_h=50;

// width of stand supports
support=80;

strap=3;

wood=in/2;
$fn=90;

wall=strap;

module trim() {
    intersection() {
        cylinder(d=sled,h=stand_h);
        children();
    }
}

module place_corner() {
    rotate([0,0,180])
    translate([support/2,sled/2-stand,0])
    children();
}

module maslow() {
    place_corner() {
        translate([0,0,-wood])
        cylinder(d=sled,h=wood);

        trim()
        translate([0,-sled/2+wood/2+stand,stand_h/2])
        cube([sled,wood,stand_h],center=true);

        trim()
        translate([0,0,stand_h/2])
        cube([support,sled,stand_h],center=true);
    }
}

module placed_ingot() {
    translate([ingot_base_x/2+wall,ingot_base_y/2+wall,-pad])
    color("gray")
    ingot();
}

maslow(); placed_ingot();


module blank() {
    intersection() {
        place_corner()
        translate([0,0,-pad])
        cylinder(d=sled,h=stand_h+pad*2);
        cube([sled,sled,grip_h]);
    }
    intersection() {
        minkowski() {
            placed_ingot();
            cylinder(r=strap,h=0.1);
        }
        cube([sled,sled,grip_h]);
    }
}

color("green")
difference() {
    blank();
    placed_ingot();
}
