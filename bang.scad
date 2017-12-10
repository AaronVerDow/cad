$fn=200;
gap=0.4;
gapp=gap*2;
pad=0.1;
padd=pad*2;
big_cards=8;
box_x=183-gapp;
box_y=128-gapp;
box_z=43-gap-big_cards;

card_x=55+gapp;
card_y=88+gapp;

shell=10+gapp;
shell_z=30;

cards=3;
shells_x=10;
shells_y=3;

grip=2;

card_wall=(box_x-card_x*cards)/(cards+1);

shelf_y=box_y-card_wall-card_y;

shell_wall=(box_x-shell*shells_x)/(shells_x+1);
shell_y_wall=(shelf_y-shell*shells_y)/(shells_y+1);
shell_grip=12;


difference() {
    cube([box_x,box_y,box_z]);
    for(x=[card_wall:card_x+card_wall:box_x-card_wall*2]) {
        translate([x,box_y-card_y-card_wall,card_wall]) {
            cube([card_x,card_y,box_z+pad]);
            difference() {
                hull() {
                    translate([card_x/2,-card_wall-pad,box_z])
                    rotate([-90,0,0])
                    cylinder(d=card_x/1.5,h=box_x+padd);
                    translate([card_x/2,-card_wall-pad,card_x/1.5/2])
                    rotate([-90,0,0])
                    cylinder(d=card_x/1.5,h=box_x+padd);
                }
                translate([0,-pad-card_wall,0])
                cube([card_x,card_wall+padd,box_z-shell_z+shell_grip-card_wall]);
            }
            hull() {
                translate([card_x/2,card_y,box_z])
                rotate([-90,0,0])
                cylinder(d1=card_x/1.5,d2=card_x/1.5+card_wall*2,h=card_wall+padd);
                translate([card_x/2,card_y,card_x/1.5/2])
                rotate([-90,0,0])
                cylinder(d1=card_x/1.5,d2=card_x/1.5+card_wall*2,h=card_wall+padd);
            }
        }
    }


    for(y=[shell_y_wall+shell/2:shell+shell_y_wall:shelf_y]) {
        for(x=[shell_wall+shell/2:shell+shell_wall:box_x]) {
            translate([x,y,box_z-shell_z])
            cylinder(d=shell,h=box_z);
        }
    }

    translate([-pad,-pad,box_z-shell_z+shell_grip])
    cube([box_x+padd,shelf_y-card_wall+pad,box_z]);

    // axis flange
    translate([-pad,box_y-card_wall-card_y/2,box_z])
    rotate([0,90,0])
    cylinder(d2=box_z*2-card_wall*2,d1=box_z*2,h=card_wall+padd);

    translate([box_x-card_wall-pad,box_y-card_wall-card_y/2,box_z])
    rotate([0,90,0])
    cylinder(d1=box_z*2-card_wall*2,d2=box_z*2,h=card_wall+padd);

    translate([-pad,box_y-card_wall-card_y/2,box_z])
    rotate([0,90,0])
    cylinder(d=box_z*2-card_wall*2,h=box_x+padd);

}
