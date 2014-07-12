$fn=90;
pad=0.1;
padd=pad*2;
box_x=70;
box_y=50;
box_z=120;

lid_h=3;

in_h=20;
in_w=25;
in_up=100;

wall_min=2;

shot_d=60;
shot_r=shot_d/2;

shot_id=52;
shot_ir=shot_id/2;

shot_lip_h=2;

shot_h=40;

notch_l=5;
notch_w=3;
notch_h=10;

tamper_d=50;
tamper_r=tamper_d/2;

actual_notch_w=shot_id+notch_w*2;

trigger_x=30;
trigger_y=5;
trigger_z=0.7;
trigger_y_offset=40;

catch_x=7;
catch_y=3;
catch_offset=2;

pin_d=8;
pin_r=pin_d/2;

pin_gap=0.5;
pin_z_gap=4;
pin_offset=pin_r+pin_gap+wall_min;

view_gap=30;

module base() {
    difference(){
        union() {
            cube([box_x,box_y,in_up]);
            translate([0,0,in_up]) {
                translate([pin_offset,pin_offset,0])
                cylinder(r=pin_r,h=in_h/2);
                translate([box_x-pin_offset,pin_offset,0])
                cylinder(r=pin_r,h=in_h/2);
                translate([pin_offset,box_y-pin_offset,0])
                cylinder(r=pin_r,h=in_h/2);
                translate([box_x-pin_offset,box_y-pin_offset,0])
                cylinder(r=pin_r,h=in_h/2);
            }
        }
        translate([box_x/2,box_y-shot_r,in_up-shot_lip_h])
        cylinder(r=shot_r,h=shot_lip_h+pad+in_h/2);
        translate([box_x/2,box_y-shot_r,-pad])
        cylinder(r=shot_ir,h=in_up+padd);
        translate([box_x/2-actual_notch_w/2,box_y-shot_r-notch_l/2,in_up-shot_lip_h-notch_h])
        cube([actual_notch_w,notch_l,notch_h+pad]);
    }
}

module middle() {
    difference() {
        union() {
            translate([box_x/2,box_y-shot_r,0])
            cylinder(r=shot_r+wall_min,h=in_h);
            cube([box_x,box_y,in_h]);
            translate([0,0,in_h]) {
                translate([pin_offset,pin_offset,0])
                cylinder(r=pin_r,h=lid_h);
                translate([box_x-pin_offset,pin_offset,0])
                cylinder(r=pin_r,h=lid_h);
                translate([pin_offset,box_y-pin_offset,0])
                cylinder(r=pin_r,h=lid_h);
                translate([box_x-pin_offset,box_y-pin_offset,0])
                cylinder(r=pin_r,h=lid_h);
            }
        }
        translate([box_x/2-in_w/2,box_y/2+pad,-pad])
        cube([in_w,box_y/2,in_h+padd]);
        translate([box_x/2,box_y-shot_r,-pad])
        cylinder(r=tamper_r,h=in_h+padd);
        translate([0,box_y,-pad])
        cube([box_x,10,in_h+padd]);

        translate([0,0,-pad]) {
            translate([pin_offset,pin_offset,0])
            cylinder(r=pin_r+pin_gap,h=in_h/2+pin_z_gap);
            translate([box_x-pin_offset,pin_offset,0])
            cylinder(r=pin_r+pin_gap,h=in_h/2+pin_z_gap);
            translate([pin_offset,box_y-pin_offset,0])
            cylinder(r=pin_r+pin_gap,h=in_h/2+pin_z_gap);
            translate([box_x-pin_offset,box_y-pin_offset,0])
            cylinder(r=pin_r+pin_gap,h=in_h/2+pin_z_gap);
        }
    }
}

module lid() {
    difference() {
        union() {
            translate([box_x/2,box_y-shot_r,0])
            cylinder(r=shot_r+wall_min,h=lid_h);
            cube([box_x,box_y,lid_h]);
            translate([box_x/2-trigger_x/2,box_y-trigger_y_offset,lid_h-pad]) 
            difference() {
                    color("cyan")
                    cube([trigger_x,trigger_y,trigger_z+pad]);
                    translate([trigger_x/2+catch_offset,trigger_y/2-catch_y/2,0])
                    cube([catch_x,catch_y,trigger_z+padd]);
            }
        }
        translate([0,box_y,-pad])
        cube([box_x,10,in_h+padd]);
        translate([0,0,-pad]) {
            translate([pin_offset,pin_offset,0])
            cylinder(r=pin_r+pin_gap,h=in_h/2+pin_z_gap);
            translate([box_x-pin_offset,pin_offset,0])
            cylinder(r=pin_r+pin_gap,h=in_h/2+pin_z_gap);
            translate([pin_offset,box_y-pin_offset,0])
            cylinder(r=pin_r+pin_gap,h=in_h/2+pin_z_gap);
            translate([box_x-pin_offset,box_y-pin_offset,0])
            cylinder(r=pin_r+pin_gap,h=in_h/2+pin_z_gap);
        }
    }
}

color("cyan") base();

translate([0,0,in_up+view_gap]) color("magenta") middle();

translate([0,0,in_up+in_h+view_gap*2]) lid(); 

