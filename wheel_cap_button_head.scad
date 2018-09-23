// based on https://www.mcmaster.com/91239a120
od=196;
head_h=56.69;
face=103;
hex=79.3;
lip=8.5;
curve=217;
face_h=203.7;
base_h=147;

big_fn=400;

hex_base=3;
pad=0.1;
padd=pad*2;

actual_od=100;
filament=0.7;


module rounded() {
    translate([0,-base_h-lip])
    intersection() {
        $fn=big_fn;
        translate([0,curve/2,0])
        circle(d=curve);
        translate([-curve/2,base_h+lip])
        square([curve,face_h-base_h-lip]);
    }
}

module rounded_with_lip() {
    hull() {
        rounded();
        translate([0,lip])
        rounded();
    }
}

module head_2d() {
    intersection() {
        rounded_with_lip();
        square([curve,curve]);
    }
}

module head() {
    rotate_extrude($fn=big_fn)
    head_2d();
}

module hex() {
    $fn=6;
    translate([0,0,hex_base+pad])
    cylinder(d=hex,h=face_h-base_h-hex_base+pad);
}

module bolt_not_scaled() {
    difference() {
        head();
        hex();
    }
}

module button() {
    scale(actual_od/od)
    bolt_not_scaled();
}

extrusion_width=0.7;
inner_clip=61;
inner_clip_d=2;
clip_peak=64.5;
clip_peak_h=9;
clip_wall=(clip_peak-inner_clip)/2;
clip_peak_d=inner_clip_d+clip_wall*2;
clip_fillet=4;

mate_pad=4;
mate_h=(clip_wall+clip_fillet)/2+mate_pad;
mate=inner_clip-inner_clip_d+clip_wall*2+mate_pad*1;
mate_inner=inner_clip-clip_fillet*2;

screw_head=10;

$fn=60;

module screw(screw=3, screw_h=20) {
    translate([-mate/2+mate_h,0,0]) {
        translate([0,0,-(screw_head-screw)/2-pad])
        cylinder(d2=screw_head+padd,d1=screw-padd,h=(screw_head-screw)/2+padd);
        translate([0,0,-screw_h-padd])
        cylinder(d=screw,h=screw_h+pad*4);
    }
}

module screws(screw=3, screw_h=20) {
    for(n=[0:360/5:359]) {
        rotate([0,0,n])
        screw(screw, screw_h);
    }
}

module clip_2d() {
    intersection() {
        clip_mink();
        clip_to_keep();
    }
    fillet();
}

module clip_to_keep() {
    difference() {
        square([clip_wall+inner_clip_d/2+pad,clip_peak_h+clip_wall*2]);
        translate([0,clip_peak_h])
        circle(d=inner_clip_d);
    }
}

module clip_mink() {
    minkowski() {
        union() {
            translate([0,clip_peak_h])
            circle(d=inner_clip_d);
            translate([-clip_peak_d,0])
            square([clip_peak_d,clip_peak_h+clip_wall/2]);
        }
        circle(clip_wall);
    }
}

module fillet() {
    translate([-clip_fillet,0])
    difference() {
        translate([0,-pad])
        square(clip_fillet+pad);
        translate([0,clip_fillet])
        circle(clip_fillet);
    }

}

module solid_clip() {
    rotate_extrude($fn=big_fn)
    translate([inner_clip/2-inner_clip_d/2,0])
    clip_2d();
}

test_base=actual_od;
test_base_h=3;

module test_base() {
    translate([0,0,-test_base_h])
    cylinder(d=test_base,h=test_base_h);
}

clip_w=15;
clips=5;

module clip() {
    intersection() {
        for(n=[0:360/5:359]) {
            rotate([0,0,n])
            translate([0,-clip_w/2,-pad])
            cube([actual_od/2,clip_w,clip_peak_h*2]);
        }
        solid_clip();
    }
}

module mate_positive(extra=0) {
    difference() {
        translate([0,0,-mate_h])
        cylinder(d2=mate+extra*2,d1=mate-mate_h*2,h=mate_h+extra,$fn=big_fn);
        translate([0,0,-mate_h-pad])
        cylinder(d2=mate-mate_h*4-padd-extra*2,d1=mate-mate_h*2+padd,h=mate_h+extra+padd,$fn=big_fn);
    }
}

module mate() {
    difference() {
        mate_positive();
        screws();
    }
}

mate_flat=filament*2;

module mount() {
    difference() {
        rotate([180,0,0]) {
            clip();
            mate();
        }
        translate([0,0,mate_h-mate_flat])
        cylinder(d=mate,h=mate_flat);
    }
}

module outer_cap() {
    difference() {
        button();
        rotate([180,0,0]) {
            mate_positive(pad);
            screws();
        }
        lugs();
    }
}

small_cap=73;

module small_cap() {
    difference() {
        scale(small_cap/actual_od)
        button();
        rotate([180,0,0]) {
            mate_positive(pad);
            screws(11);
        }
        lugs();
    }
}

module one_piece() {
    scale(small_cap/actual_od)
    button();
    rotate([180,0,0])
    clip();
}

//one_piece();

lug=25;
lug_h=12;
lug_offset=98;

module lug() {
    translate([lug_offset/2,0,-pad])
    cylinder(d=lug,h=lug_h+pad);
}

module lugs() {
    for(n=[0:360/4:359]) {
        rotate([0,0,n])
        lug();
    }
}

flat=120;
flat_h=24;
flat_round=5;
flat_hex=flat*67/162;

module flat() {
    difference() {
        minkowski() {
            cylinder(d2=flat-flat_round*2,d1=flat-flat_h*2-flat_round*2,h=flat_h-flat_round,$fn=big_fn);
            sphere(d=flat_round);
        }

        rotate([180,0,0]) {
            mate_positive(pad);
            screws(2.8, flat_h-5);
        }
        lugs();
        translate([0,0,hex_base])
        cylinder(d=flat_hex,h=flat_h+pad,$fn=6);
        translate([0,0,-flat_h])
        cylinder(d=flat,h=flat_h);
    }
}


flat();
