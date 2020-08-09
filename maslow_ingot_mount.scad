in=25.4;
ingot_height=37;
ingot_angle=15;
ingot_top_x=35;
ingot_top_y=99;

ingot_tree=65;
ingot_tree_h=8;
ingot_tree_w=10;

ingot_base_x = ingot_height*tan(ingot_angle)*2+ingot_top_x;
ingot_base_y = ingot_height*tan(ingot_angle)*2+ingot_top_y;

echo("base");
echo(ingot_base_x);
echo(ingot_base_y);


// how high the actual part is
grip_h = 17;

pad=0.1;
bolt=6;

big_fn=400;

bolt_head=10;
bolt_head_h=1;
bolt_head_taper=3;


module ingot(pad=0) {
    slice=0.0001;
    hull() {
        translate([0,0,-pad/2])
        cube([ingot_base_x,ingot_base_y,slice+pad],center=true);
        translate([0,0,ingot_height])
        cube([ingot_top_x,ingot_top_y,slice],center=true);
    }
}


// diameter of maslow sled 
sled=500;

// distnace from bottom edge of maslow to edge of stand
stand=114;

// display height
stand_h=50;

// width of stand supports
support=180;

strap=3;

wood=in/2;
$fn=90;

wall=strap;

module trim() {
    intersection() {
        cylinder(d=sled,h=stand_h,$fn=big_fn);
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
        cylinder(d=sled,h=wood,$fn=big_fn);

        trim()
        translate([0,-sled/2+wood/2+stand,stand_h/2])
        cube([sled,wood,stand_h],center=true);

        trim()
        translate([0,0,stand_h/2])
        cube([support,sled,stand_h],center=true);
    }
}

module placed_ingot_vertical() {
    translate([ingot_base_x/2+wall,ingot_base_y/2+wall,-pad])
    color("gray")
    ingot();
}

module placed_ingot_horizontal() {
    color("gray")
    translate([ingot_base_y/2,ingot_base_x/2])
    rotate([0,0,90])
    ingot();
}


module place_ingot() {
    angle=-45;
    hyp = ingot_base_x/2;
    x = cos(angle)*hyp;
    y = sin(angle)*hyp;

    color("gray")
    translate([x,-y])
    rotate([0,0,angle])
    translate([0,ingot_base_y/2])
    children();
}

module blank() {
    intersection() {
        place_corner()
        translate([0,0,-pad])
        cylinder(d=sled,h=stand_h+pad*2,$fn=big_fn);
        cube([sled,sled,grip_h]);
    }
    intersection() {
        minkowski() {
            place_ingot()
            ingot();
            cylinder(r=strap,h=0.1);
        }
        cube([sled,sled,grip_h]);
    }
}

module bolt() {
    translate([0,0,-pad])
    cylinder(d=bolt,h=grip_h+pad*2);

    hull() {
        translate([0,0,grip_h-bolt_head_h])
        cylinder(d=bolt_head,h=bolt_head_h+pad);
        translate([0,0,grip_h-bolt_head_taper])
        cylinder(d=bolt,h=bolt_head_taper);
    }
}

module bolts() {
    n=13;
    translate([n,n])
    bolt();
    translate([n,75])
    bolt();
    translate([90,n])
    bolt();
}


module part() {
    color("green")
    difference() {
        blank();
        place_ingot()
        ingot(pad);
        place_ingot()
        ingot_tree(pad*2);
        bolts();
    }
}

module ingot_tree(pad=0) {
    translate([0,0,ingot_tree_h/2-pad/2])
    cube([ingot_base_x+ingot_tree_w*2,ingot_tree,ingot_tree_h+pad],center=true);
}

//maslow();
//place_ingot() { ingot(); ingot_tree(); }

part();

