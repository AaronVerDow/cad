$fn=90;
filament=1.2;
bolt=8;
bolt_gap=77;
bolt_h=10;
bolt_wall=bolt+filament*6;

light_grip=13.3;
light_grip_h=6;

light=15.5;
light_h=18;
wall=filament*2;
light_wall=light+wall*2;
light_wall_h=light_h+light_grip_h;

shade1=light;
shade1_wall=shade1+wall*2;
shade_h=13;
shade2=shade1+shade_h*0.75;
shade2_wall=shade2+wall*2-0.1;

pad=0.1;
padd=pad*2;

module negative_space() {
    translate([0,0,-pad])
    cylinder(d=light_grip,h=light_grip_h+padd);
    translate([0,0,light_grip_h])
    cylinder(d=light,h=light_h+pad);
    translate([0,0,light_wall_h])
    cylinder(d1=shade1,d2=shade2,h=shade_h+pad);
}

difference() {
    hull() {
        translate([-bolt_gap/2,0,0])
        cylinder(d=bolt_wall,h=bolt_h);
        translate([bolt_gap/2,0,0])
        cylinder(d=bolt_wall,h=bolt_h);
        translate([0,-bolt_wall/2,light_wall/2])
        rotate([-90,0,0])
        cylinder(d=light_wall,h=bolt_wall);

        //translate([0,-bolt_wall/2,light_wall/2])
        //rotate([-90,0,0])
        //translate([0,0,light_wall_h])
        //cylinder(d1=shade1_wall,d2=shade2_wall,h=shade_h);
    }
    translate([0,-bolt_wall/2,light_wall/2])
    rotate([-90,0,0])
    negative_space();
    translate([-bolt_gap/2,0,-pad])
    cylinder(d=bolt,h=bolt_h*2+padd);
    translate([bolt_gap/2,0,-pad])
    cylinder(d=bolt,h=bolt_h*2+padd);
    translate([-500,-500,-400])
    cube([1000,1000,400]);
}

difference() {
    translate([0,-bolt_wall/2,light_wall/2])
    rotate([-90,0,0])
    difference() {
        union() {
            cylinder(d=light_wall,h=light_wall_h);
            translate([0,0,light_wall_h])
            cylinder(d1=shade1_wall,d2=shade2_wall,h=shade_h);
        }
        negative_space();
    }
    translate([-500,-500,-400])
    cube([1000,1000,400]);
}
