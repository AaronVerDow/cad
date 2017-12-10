screw=5;
//esc_x=34;
fudge=2;
esc_x=34+fudge+8;
esc_y=82.5;
esc_z=8;
$fn=90;

rec_x=45;
rec_y=22;
rec_z=5;

wall=4-fudge/2;
walll=wall*2;

pad=0.1;
padd=pad*2;
screw_h=4;

zip_h=wall/2;
zip_w=6;

nut=8.5;

module esc_zip() {
    translate([0,-zip_w/2,0]) {
        translate([pad,0,-pad])
        cube([wall+pad,zip_w,wall+esc_z+padd]);
        translate([wall+esc_x-pad,0,-pad])
        cube([wall+padd,zip_w,wall+esc_z+padd]);
        translate([0,0,-pad])
        cube([esc_x+walll+padd,zip_w,zip_h+pad]);
    }
}


difference() {
    union() {
        hull() {
            cube([esc_x+walll,esc_y,esc_z+wall]);
            translate([-screw/2,esc_y*2/3,0])
            cylinder(h=screw_h,d=screw+walll);
            translate([esc_x+screw/2+wall,esc_y/2,0])
            cylinder(h=screw_h,d=screw+walll);
        }
        translate([wall*3+screw,esc_y*2/3-rec_y/2-wall,0])
        cube([rec_x+wall+esc_x,rec_y+walll,rec_z+wall]);
    }
    translate([wall,-pad,wall])
    cube([esc_x,esc_y+padd,esc_z+pad]);
    translate([-screw/2,esc_y*2/3,-pad]) {
        cylinder(h=esc_z*2,d=screw);
        translate([0,0,screw_h])
        cylinder(h=esc_z*2,d=nut,$fn=6);
        //cylinder(h=esc_z+walll,d1=screw+walll,d2=screw+walll*2+esc_z*2);
    }
    translate([wall+esc_x+screw/2+wall,esc_y*2/3,-pad]) {
        cylinder(h=esc_z*2,d=screw);
        translate([0,0,screw_h])
        cylinder(h=esc_z*2,d=nut,$fn=6);
        //cylinder(h=esc_z+walll,d1=screw+walll,d2=screw+walll*2+esc_z*2);
    }
    translate([esc_x+wall*3+screw,esc_y*2/3-rec_y/2,wall]) {
        cube([rec_x,rec_y,rec_z+pad]);
        translate([rec_x/2-zip_w/2,-wall-pad,-wall-pad]) {
            cube([zip_w,rec_y+walll+padd,zip_h+pad]);
            cube([zip_w,wall+padd,rec_z+wall+padd]);
            translate([0,rec_y+wall,0])
            cube([zip_w,wall+padd,rec_z+wall+padd]);
        }
    }
    translate([0,esc_y/2,0])
    esc_zip();
    translate([0,esc_y/6,0])
    esc_zip();
    translate([0,esc_y/6,0])
    esc_zip();
    translate([0,esc_y/6,0])
    esc_zip();
    translate([0,esc_y-esc_y/6,0])
    esc_zip();
}
