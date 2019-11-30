// based on https://www.mcmaster.com/91239a120
use <metric_iso_screw.scad>

// actual od of button head
button=104;

// od of button head in drawing
button_drawing=196;

// used to translate measurements for button
button_scale=button/button_drawing;

//head_h=56.69*button_scale;
//face=103*button_scale;
button_hex=79.3*button_scale;

// how much solid material under hex in button
button_hex_base=3;

// thickness of flat lip at base of button
button_lip=8.5*button_scale;

// diameter of circle that makes up the main face 
button_curve=217*button_scale;


// distance from back of button curve to face of button
button_face_h=203.7*button_scale;

// distance from back of button curve to back of button
button_base_h=147*button_scale;

// fn used for big circles
big_fn=400;
big_fn=100;

// used to pad negative space for clean rednering in OpenSCAD
pad=0.1;
padd=pad*2;

// printer settings (used in some places for cleaner slicing)
extrusion_width=0.7;
layer_h=0.4;

// outer diameter of metal ring that suppors stock Konig wheel caps
metal_ring=61;

// diameter of wire in the metal ring
metal_ring_d=2;

// diameter of clip at its widest point
clip_peak=64.5;

// how high the clip peak is from the inner face of the rim 
clip_peak_h=9;
clip_peak_h=7;

// how thick the thinnest part of the clip should be
clip_wall=(clip_peak-metal_ring)/2;

// calculated diameter of clip peak
clip_peak_d=metal_ring_d+clip_wall*2;

// rounded piece to support clip arms
clip_fillet=4;

// diameter of base of clips
clip_base=metal_ring-metal_ring_d+clip_wall*2;

// extra thickness on top of clip base for ring
mount_wall=4;

// calculated height of ring
mount_h=(clip_wall+clip_fillet)/2+mount_wall;

// outer diameter of ring
mount=clip_base+mount_wall;

// head of screw used to join clip to cap
screw_head=10;

// holes that screw threads into 
screw_threaded=2.8;

// holes that screw spins freely in
screw_hole=3.5;

// default screw height
screw_h=20;

flat=120;
flat_h=24;
flat_round=5;
flat_hex=flat*67/162;

nut_base=112;
nut_base_cut=00;
nut_h=25;
nut=50;
nut=64;
nut_fn=300;
nut_fn=60;
nut_visible_screw=10;
nut_threaded_screw=nut_h;
nut_screw_scale=0.98;
nut_screw_grip=7;


$fn=60;


test_base=button;
test_base_h=3;

clip_w=15;
clips=5;


mate_flat=extrusion_width*2;


small_cap=73;


lug=20;
lug_h=11;
lug_offset=98;



module curve() {
    translate([0,-button_base_h-button_lip])
    intersection() {
        $fn=big_fn;
        translate([0,button_curve/2,0])
        circle(d=button_curve);
        translate([-button_curve/2,button_base_h+button_lip])
        square([button_curve,button_face_h-button_base_h-button_lip]);
    }
}

module curve_with_lip() {
    hull() {
        curve();
        translate([0,button_lip])
        curve();
    }
}

module head_2d() {
    intersection() {
        curve_with_lip();
        square([button_curve,button_curve]);
    }
}


module button_hex() {
    hex(button_hex,button_face_h-button_base_h-button_hex_base,button_hex_base);
}

module hex(diameter, height, base_h) {
    $fn=6;
    translate([0,0,base_h+pad])
    cylinder(d=diameter,h=height+pad);
}

module button_negative() {
    mount_positive(pad);
    mount_screws();
    lugs();
    button_hex();
}

module button_positive() {
    rotate_extrude($fn=big_fn)
    head_2d();
}

module button_cap() {
    difference() {
        button_positive();
        button_negative();
    }
}

module button_timeline() {
    spaced() {
        label("button_cap") button_cap();
        label("button_negative") {
            #button_positive();
            button_negative();
        }
        label("button_positive") button_positive();
        //label("button_hex") button_hex();
        label("head_2d") head_2d();
        label("curve_with_lip") curve_with_lip();
        label("curve") curve();
    }
}

module screw(screw=screw_threaded, screw_h=screw_h) {
    translate([-mount/2+mount_h,0,0]) {
        translate([0,0,-pad])
        cylinder(d1=screw_head+padd,d2=screw-padd,h=(screw_head-screw)/2+padd);
        translate([0,0,-padd])
        cylinder(d=screw,h=screw_h+pad*4);
    }
}

module ring_of(count) {
    for(n=[0:360/count:359]) {
        rotate([0,0,n])
        children();
    }
}

module mount_screws(screw=screw_threaded, screw_h=screw_h) {
    ring_of(5) screw(screw, screw_h);
}

module clip_2d() {
    intersection() {
        clip_outline();
        clip_mask();
    }
    clip_fillet();
}

module clip_mask() {
    difference() {
        square([clip_wall+metal_ring_d/2+pad,clip_peak_h+clip_wall*2]);
        ring_slot();
    }
}

module ring_slot() {
    translate([0,clip_peak_h])
    circle(d=metal_ring_d);
}

module clip_seed() {
    ring_slot();
    translate([-clip_peak_d,0])
    square([clip_peak_d,clip_peak_h+clip_wall/2]);
}

module clip_outline() {
    minkowski() {
        clip_seed();
        circle(clip_wall);
    }
}

module clip_fillet() {
    translate([-clip_fillet,0])
    difference() {
        translate([0,-pad])
        square(clip_fillet+pad);
        translate([0,clip_fillet])
        circle(clip_fillet);
    }

}

module clip_3d() {
    rotate([180,0,0])
    rotate_extrude($fn=big_fn)
    translate([metal_ring/2-metal_ring_d/2,0])
    clip_2d();
}

module clip_gap() {
    translate([0,-clip_w/2,-clip_peak_h*2-pad])
    cube([button/2,clip_w,clip_peak_h*2]);
}

module clip_gaps() {
    ring_of(5) clip_gap();
}

module clip_teeth() {
    intersection() {
        clip_gaps();
        clip_3d();
    }
}

module mount_solid(extra=0) {
    translate([0,0,-extra])
    cylinder(d1=mount+extra*2,d2=mount-mount_h*4,h=mount_h*2+extra,$fn=big_fn);
}

module mount_negative(extra=0) {
    translate([0,0,-pad])
    cylinder(
        d1=mount-mount_h*4-padd-extra*2,
        d2=mount+padd+button*2,
        h=mount_h*2+extra+padd+button,
        $fn=big_fn
    );
}
module mount_positive(extra=0) {
    difference() {
        mount_solid(extra);
        mount_negative();
    }
}

module mount() {
    difference() {
        mount_positive();
        mount_screws(screw_hole);
    }
}

module ring_clip() {
    difference() {
        union() {
            clip_teeth();
            mount();
        }
        // flatten edge for printing
        translate([0,0,mount_h-mate_flat])
        cylinder(d=mount,h=mate_flat);
    }
}


module clip_mount_timeline() {
    spaced(button*2, 0) {
        clip_2d_timeline();
        clip_timeline();
        mount_timeline();
    }
}

module clip_timeline() {
    spaced(0,mount) {
        label("ring_clip") ring_clip();
        label("clip_teeth") clip_teeth();
        label("clip_gaps") #clip_gaps();
        label("clip_3d") clip_3d();
    }
}

module mount_timeline() {
    spaced(0,mount) {
        label("mount") mount();
        label("mount_screws") mount_screws();
        label("mount_positive") mount_positive();
        #label("mount_negative") mount_negative();
        label("mount_solid") mount_solid();
    }
}

module clip_2d_timeline() {
    spaced(0, 20) {
        label("clip_2d") clip_2d();
        label("clip_mask") clip_mask();
        label("clip_fillet") clip_fillet();
        label("clip_outline") clip_outline();
        label("clip_seed") clip_seed();
        label("ring_slot") ring_slot();
    }
}

module small_cap() {
    difference() {
        scale(small_cap/button)
        button();
        mount_positive(pad);
        mount_screws(11);
        lugs();
    }
}

module lug() {
    translate([lug_offset/2,0,-pad])
    cylinder(d=lug,h=lug_h+pad);
}

module lugs() {
    ring_of(4)
    lug();
}

module flat_cap() {
    difference() {
        minkowski() {
            cylinder(d2=flat-flat_round*2,d1=flat-flat_h*2-flat_round*2,h=flat_h-flat_round,$fn=big_fn);
            sphere(d=flat_round);
        }

        mount_positive(pad);
        mount_screws(2.8, flat_h-5);
        lugs();
        translate([0,0,button_hex_base])
        cylinder(d=flat_hex,h=flat_h+pad,$fn=6);
        translate([0,0,-flat_h])
        cylinder(d=flat,h=flat_h);
    }
}

module nut_base() {
    translate([0,0,-nut_base_cut*2])
    cylinder(d=nut_base, h=nut_base_cut*2);
}

module nut_negative() {
    nut_base();
    rotate([0,0,15])
    lugs();
    mount_screws(2.8, flat_h-5);
    //mount_solid(pad);
    mount_positive(pad);
}

module nut_positive() {
    translate([0,0,-nut_base_cut])
    hex_nut_iso(d=nut, hg=nut_h+nut_base_cut, $fn=nut_fn);
    nut_unthreaded();
}

module nut_cap() {
    difference() {
        nut_positive();
        nut_negative();
    }
}

nut_small_scale=0.7;

module nut_screw_small() {
    scale(nut_small_scale)
    scale([nut_screw_scale, nut_screw_scale, 1])
    screw_thread_iso_outer( d=nut, lt=nut_visible_screw+nut_threaded_screw, cs=2, $fn=nut_fn);
}

module nut_cap_small() {
    scale(nut_small_scale)
    //nut_positive();
    hex_nut_iso(d=nut, hg=nut_h+nut_base_cut, $fn=nut_fn);
    rotate([0,0,15])
    //#lugs();
    clip_teeth();
    //#nut_screw_small();
}

module nut_cap_screw() {
    difference() {
        intersection() {
            scale([nut_screw_scale, nut_screw_scale, 1])
            screw_thread_iso_outer( d=nut, lt=nut_visible_screw+nut_threaded_screw, cs=2, $fn=nut_fn);
            mount_negative();
        }
        nut_base();
        #nut_unthreaded(pad);
    }
}
module nut_unthreaded(p=0) {
    translate([0,0,-p])
    cylinder(d=nut,h=nut_h-nut_screw_grip+p);
}
module nut_assembled() {
    color("gray")
    nut_cap_screw();
    nut_cap();
}

module nut_timeline() {
	spaced() {
        label("nut_cap_small") nut_cap_small();
        label("nut_assembled") {
            nut_assembled();
            #nut_base();
        }
        label("nut_cap_screw") nut_cap_screw();
        label("nut_cap") nut_cap();
        label("nut_negative") nut_negative();
    }
}

module spaced(x=0,y=button*1.3) {
    for ( i= [0:1:$children-1])
    translate([x*i,y*i,0])
    children(i);
}

module label(string) {
    translate([button*2/3,0,0])
    linear_extrude(pad)
    text(string);
    children();
}


module small_button_cap() {
    scale(small_cap/button)
    difference() {
        button_positive();
        button_hex();
    }
    clip_teeth();
}

module to_print() {
    children();
}

module all_parts() {
	spaced() {
		label("small_button_cap") small_button_cap();
		label("ring_clip") ring_clip();
		label("button_cap") button_cap();
		label("flat") flat_cap();
		label("nut_cap") {
            nut_cap();
            #nut_base();
        }
		//label("nut_negative") nut_negative();
		label("nut_cap_screw") nut_cap_screw();
	}
}

display="";
if (display == "") all_parts();
//if (display == "") button_timeline();
//if (display == "") clip_mount_timeline();
//if (display == "") {
    //nut_timeline();
    //translate([button*2,0,0])
    //mount_timeline();
//}
if (display == "small_button_cap.stl") small_button_cap();
if (display == "ring_clip.stl") ring_clip();
if (display == "button_cap.stl") button_cap();
if (display == "flat_cap.stl") flat_cap();
if (display == "nut_cap.stl") nut_cap();
if (display == "nut_cap_screw.stl") nut_cap_screw();
if (display == "nut_screw_small.stl") nut_screw_small();
if (display == "nut_cap_small.stl") rotate([180,0,0]) nut_cap_small();
