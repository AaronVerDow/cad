tooth_x=15;
tooth_y=5;
tooth_z=8;

mouth_z=13;

shell_pad=1;

top=55;
magnet=10.5;
magnet_h=3.5;

wall=2;
walll=wall*2;

pad=0.1;
padd=pad*2;

shell1=20-tooth_x+magnet;
shell2=20;
$fn=90;

difference() {
    union() {
        difference() {
                hull() {
                    translate([-tooth_x/2-wall,0,0])
                    cube([tooth_x+walll,tooth_y+wall,tooth_z]);
                    translate([0,0,-magnet/2])
                    rotate([-90,0,0])
                    //cylinder(d=magnet+walll,h=magnet_h+wall);
                    cylinder(d=magnet+walll,h=tooth_y+wall);
                    translate([0,0,top+tooth_z+magnet/2+wall])
                    rotate([-90,0,0])
                    //cylinder(d=magnet+walll,h=magnet_h+wall);
                    cylinder(d=magnet+walll,h=tooth_y+wall);
                }
            translate([0,shell2/2-shell_pad,tooth_z])
            cylinder(d2=shell1,d1=shell2,h=top+magnet/2+wall);
        }
        translate([0,0,top+tooth_z+magnet/2+wall])
        rotate([-90,0,0])
        //cylinder(d=magnet+walll,h=magnet_h+wall);
        cylinder(d=magnet+walll,h=tooth_y+wall);
    }
    difference() {
        hull() {
            translate([-tooth_x/2,-pad,-pad])
            cube([tooth_x,tooth_y+pad,tooth_z+padd]);
            translate([0,-pad,top+tooth_z+magnet/2+wall])
            rotate([-90,0,0])
            cylinder(d=magnet,h=magnet_h+pad);
        }
        translate([0,0,top+tooth_z+magnet/2+wall])
        rotate([-90,0,0])
        //cylinder(d=magnet+walll,h=magnet_h+wall);
        cylinder(d=magnet+walll,h=tooth_y+wall);
    }
    translate([0,-pad,-magnet/2])
    rotate([-90,0,0])
    cylinder(d=magnet,h=magnet_h+pad);
    translate([0,-pad,top+tooth_z+magnet/2+wall])
    rotate([-90,0,0])
    cylinder(d=magnet,h=magnet_h+pad);
}

