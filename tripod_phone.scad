phone_x=161;
phone_y=10;
phone_z=30;
$fn=90;
in=25.4;

tripod=0.2010*in;

wall=3;
walll=wall*2;

//lip=6.5;
lip=5.5;
lip_corner=5;
lip_bottom=0;

pad=0.1;
padd=pad*2;
charger=20;
charger_center=phone_x/2;

time=sin($t*360)/2+0.5;

bar=22.5;
//mount_wall=7+time*7;
mount_wall=10;
mount_h=40;
mount_tab=9;
mount_gap=4;

bolt=6.5;

mount_x=mount_wall*2+bolt;
mount_y=mount_wall*2+bar;
mount_z=bar+mount_tab*2;

mount_y_offset=7;

mount_corner=10;


bolts=1;
for_bolts=mount_x/(bolts+1);

bolt_head=12;
bolt_head_h=4;

nut=12.5;
nut_h=6;

side_offset=phone_z/4*3;
handlebar_angle=-15;
lazy_offset=0;

mount_z_offset=bolt/2+mount_wall+bolt/2;

module case(phone_x,phone_y,phone_z) {
    translate([-phone_x/2,-wall-phone_y,wall])
    difference() {
        minkowski() {
            cube([phone_x,phone_y,phone_z+lip+wall]);
            sphere(r=wall);
        }
        cube([phone_x,phone_y,phone_z+wall+pad]);
        minkowski() {
            translate([lip+lip_corner,0,lip+lip_corner+lip_bottom])
            cube([phone_x-lip*2-lip_corner*2,pad,phone_z-lip-lip_corner+wall]);
            rotate([90,0,0])
            cylinder(r1=lip_corner,r2=wall+lip_corner,h=wall+padd);
        }
        translate([-wall-pad,-wall-pad,phone_z])
        cube([phone_x+walll+padd,phone_y+walll+padd,lip+walll+pad]);

        translate([phone_x/2,phone_y/2,-wall-pad])
        cylinder(d=tripod,h=wall+padd);
        
        //cube([charger,phone_y,wall+padd]);
        //bolt(side_offset-bar/2-bolt);
        //bolt(side_offset+bar/2+bolt);
    }
}

module back_mount() {
    translate([-mount_x/2,-wall+pad-mount_y_offset,mount_z_offset])
    difference() {
        minkowski() {
            hull() {

                // angled part
                translate([mount_corner,0,-mount_z_offset+mount_corner])
                cube([mount_x-mount_corner*2,pad,mount_z_offset-mount_corner]);

                // top bolt cylinder
                //translate([mount_wall+bolt/2+mount_corner,0,mount_z+bolt/2])
                translate([mount_x/2,0,mount_z+bolt/2])
                rotate([-90,0,0])
                cylinder(d=mount_wall*2+bolt-mount_corner*2,h=mount_y-mount_corner);

                // bottom bolt cylinder
                translate([mount_x/2,0,-bolt/2])
                rotate([-90,0,0])
                cylinder(d=mount_wall*2+bolt-mount_corner*2,h=mount_y-mount_corner);
            }
            sphere(r=mount_corner);
        }

        // bar
        translate([-pad,mount_y/2,mount_z/2])
        rotate([0,90,0])
        cylinder(d=bar,h=mount_x+padd);

        // slit
        translate([-pad,mount_y/2-mount_gap/2,-mount_z_offset])
        cube([mount_x+padd,mount_gap,phone_z]);

        //flatten
        translate([-phone_x/2,-wall-mount_corner,-mount_z_offset]) cube([phone_x,mount_corner+wall+pad+mount_y_offset,mount_z+mount_z_offset*2]);
    }
}

module back_bolts() {
    translate([-mount_x/2,-wall-pad,mount_z_offset])
    //for(x=[for_bolts:for_bolts:for_bolts*bolts]) {
    for(z=[0:mount_z+bolt:mount_z+bolt]) {
        translate([for_bolts,0,mount_z+bolt/2-z])
        rotate([-90,0,0]) {
            cylinder(d=bolt,h=mount_y+padd);
            cylinder(d=bolt_head,h=bolt_head_h);
            rotate([0,0,90])
            translate([0,0,mount_y+padd-nut_h-mount_y_offset])
            cylinder(d=nut,h=nut_h,$fn=6);
        }
    }
}

light_x=91;

light_y=12;
light_z=phone_z;

light_charger_y=light_y-2;
light_charger_z=6;

module assembled() {
    case(phone_x,phone_y,phone_z);
    difference() {
        translate([0,-wall])
        mirror([0,1])
        case(light_x,light_y,light_z);
        translate([light_x/2-pad,light_y/2-light_charger_y/2,light_charger_z+wall])
        #cube([wall+pad*2,light_charger_y,phone_z]);

    }
}


assembled();


module side_mount() {
    translate([phone_x/2,wall+phone_y,-wall])
    case();
    difference() {
        union() {
            hull() {
                translate([-bar/2-mount_wall-lazy_offset,0,side_offset])
                rotate([-90,0,handlebar_angle]) {
                    translate([0,0,-mount_wall])
                    cylinder(d=bar,h=mount_wall);
                    translate([0,0,phone_y])
                    cylinder(d=bar,h=mount_wall);
                }
                translate([-bar/2-mount_wall,0,side_offset])
                rotate([-90,0,0]) {
                    cylinder(d=bar+mount_wall*2,h=phone_y);
                }
                translate([-wall,-wall,0])
                cube([wall,phone_y+wall*2,phone_z]);
            }
        }
        translate([-bar/2-mount_wall-lazy_offset,0,side_offset])
        rotate([-90,0,handlebar_angle])
        translate([0,0,-mount_wall-pad])
        cylinder(d=bar,h=phone_y+mount_wall*2+padd);

        translate([-lazy_offset,0,0])
        rotate([0,0,handlebar_angle])
        translate([-mount_wall-bar/2-mount_gap/2,-mount_wall*2,0])
        cube([mount_gap,phone_y*2+mount_wall*4+padd,phone_z]);
        bolt(side_offset-bar/2-bolt);
        bolt(side_offset+bar/2+bolt);
    }
}

module bolt(z) {
    translate([pad,phone_y/2,z])
    rotate([0,-90,0]) {
        cylinder(d=bolt,h=mount_wall*2+bar+padd);
        cylinder(d=bolt_head,h=bolt_head_h);
        translate([0,0,-phone_x*2])
        
        cylinder(d=bolt_head,h=phone_x*2);
        translate([0,0,mount_wall*2+bar-nut_h])
        cylinder(d=nut,h=nut_h,$fn=6);
    }
}

module bad_supports() {
    intersection() {
        translate([-bar/2-mount_wall,0,side_offset])
        rotate([-90,0,0]) {
            translate([0,0,-mount_wall])
            cylinder(d1=bar,d2=bar+mount_wall*2,h=mount_wall);
            cylinder(d=bar+mount_wall*2,h=phone_y);
            translate([0,0,phone_y])
            cylinder(d2=bar,d1=bar+mount_wall*2,h=mount_wall);
        }
        slits=6;
        fs=(phone_y+mount_wall*2)/(slits+1);
        slit_w=1.0;
        translate([-mount_wall*2-bar-8,-mount_wall,side_offset-mount_gap/2])
        for(y=[fs:fs:fs*slits]) {
            translate([0,y,0])
            cube([mount_wall+bar/2,slit_w,mount_gap]);
        }
    }
}
