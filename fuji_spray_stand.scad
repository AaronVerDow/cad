cup_max=73;
cup_min=30;
cup_h=20;
cup_tube=23;

cup_wall=3;
cup_wall_base=3;

angle_h=cup_h+cup_wall_base;
pad=0.1;
$fn=190;

top_h=14;

to_wall=100;

beam=15;

total_h=top_h+angle_h;

wall_fillet=20;


module dirror_y() {
    children();
    mirror([0,1])
    children();
}

module holder_positive() {

    cylinder(d1=cup_min+cup_wall_base*2,d2=cup_max+cup_wall*2,h=angle_h);

    translate([0,0,angle_h]) 
    cylinder(d=cup_max+cup_wall*2,h=top_h);

    translate([-to_wall,-beam/2,0])
    cube([to_wall,beam,total_h]);

    translate([-to_wall,-wall_fillet-beam/2])
    cube([wall_fillet+cup_wall,wall_fillet*2+beam,total_h]);
}

module gun() {
    difference() {
        holder_positive();

        translate([0,0,-pad])
        hull() {
            cylinder(d=cup_tube,h=angle_h+top_h+pad*2);
            translate([cup_max,0])
            cylinder(d=cup_tube,h=angle_h+top_h+pad*2);
        }

        hull() {
            translate([0,0,angle_h])
            cylinder(d=cup_max,h=top_h+pad*2);
            translate([0,0,cup_wall_base])
            cylinder(d1=cup_min,d2=cup_max,h=cup_h);
        }

        slice=cup_max+cup_wall-30;
        translate([cup_max/2+cup_wall,0,angle_h+slice])
        rotate([90,0])
        cylinder(d=slice*2,h=cup_max+cup_wall*2,center=true);


        translate([0,0,-pad])
        cylinder(d=cup_min,h=angle_h);

        dirror_y()
        translate([cup_wall+wall_fillet-to_wall,beam/2+wall_fillet,-pad])
        cylinder(r=wall_fillet,h=total_h+pad*2);
    }
}


cone_max=150;
cone_min=1;
cone_h=110;

strainer_h=15;
strainer_start=50;

module cone(extra=0) {
    translate([0,0,-strainer_start])
    cylinder(d1=cone_min+extra,d2=cone_max+extra,h=cone_h);
}

module strainer_positive() {
    intersection() {
        cone(cup_wall);
        cylinder(d=cone_max,h=strainer_h);
    }

    translate([-to_wall,-beam/2,0])
    cube([to_wall,beam,strainer_h]);

    translate([-to_wall,-wall_fillet-beam/2])
    cube([wall_fillet+cup_wall,wall_fillet*2+beam,strainer_h]);

}


module strainer() {
    difference() {
        strainer_positive();
        cone();
        dirror_y()
        translate([cup_wall+wall_fillet-to_wall,beam/2+wall_fillet,-pad])
        cylinder(r=wall_fillet,h=total_h+pad*2);
    }
}


module all() {
    translate([0,0,100])
    strainer();
    gun();

    translate([0,0,50])
    lid();
}


lid_h=20;

lid_outer=65;
lid_inner=lid_outer-cup_wall*2;

lid_total_h=lid_h+15;

lid_beam_h=lid_total_h;

lid_beam_rake=90;

lid_rake=90;
lid_rake_h=20;

module lid_positive() {
    cylinder(d=lid_outer,h=lid_total_h);

    difference() {
        lid_beam();
        translate([-lid_outer/2,0,lid_beam_rake+lid_total_h-lid_h])
        rotate([90,0])
        cylinder(r=lid_beam_rake,h=lid_outer,center=true);
    }
}

module lid_beam() {
    translate([-to_wall,-beam/2,0])
    cube([to_wall,beam,lid_beam_h]);

    translate([-to_wall,-wall_fillet-beam/2])
    cube([wall_fillet+cup_wall,wall_fillet*2+beam,lid_beam_h]);
}


module lid() {
    difference() {
        lid_positive();

        translate([0,0,-pad])
        cylinder(d=lid_inner,h=lid_total_h+pad*2);

        dirror_y()
        translate([cup_wall+wall_fillet-to_wall,beam/2+wall_fillet,-pad])
        cylinder(r=wall_fillet,h=total_h+pad*2);

        translate([lid_outer/2,0,lid_rake_h-lid_rake])
        rotate([90,0])
        cylinder(r=lid_rake,h=lid_outer,center=true);
    }
}

all();
