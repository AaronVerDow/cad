include<threads.scad>;
use<knurledFinishLib_v2.scad>;
use<fan_corner_mount.scad>;
zero=0.001;
top_h=zero;
top=15.5;
base=25;
bolt=12;
pitch=2.5;
pivot=25;
bolt_shoulder=bolt+pitch;
bolt_head=bolt_shoulder+3;
base_h=1;
pivot_h=pivot/2+base_h;
pad=0.1;
padd=pad*2;

knob=bolt_head+4;
knob_h=knob/2;


tooth=5;

bolt_shoulder_gap=0.3;
bolt_gap=1;


stopper=20-1;
stopper_pitch=2.5;
stopper_h=10;

//RENDER stl
module base() {
    difference() {
        union() {
            hull() {
                translate([0,0,pivot_h])
                sphere(d=base);
                cylinder(d=base,h=zero);
            }

            translate([tooth/2+pad,0,pivot_h])
            rotate([0,90])
            cylinder(d=bolt_head,h=pivot/2-tooth/2-pad);
        }

        bolt(bolt_shoulder_gap);
        
        translate([-tooth/2,-pivot/2-base/2,pivot_h-pivot/2])
        cube([tooth,base+pivot,pivot+pad]);
    }
    translate([0,0,-stopper_h])
    metric_thread(stopper,stopper_pitch,stopper_h);
}


module top_platform() {
    translate([0,0,pivot_h+pivot/2])
    cylinder(d=top,h=top_h);
}

//RENDER stl
module top() {
    difference() {
        intersection() {
            hull() {
                translate([0,0,pivot_h])
                sphere(d=pivot);
                top_platform();
            }
            translate([-tooth/2,-pivot/2-top/2,pivot_h-pivot/2-pad])
            cube([tooth,pivot+top,pivot+pad*2]);
        } 
        translate([0,0,pivot_h])
        rotate([0,90])
        cylinder(d=bolt_shoulder+bolt_shoulder_gap*2,h=tooth+pad*2,center=true);
    } 
    top_platform();
    translate([0,0,pivot_h+pivot/2+top_h])
    fan_mount();
}


threaded=(pivot-tooth)/2+1;
$fn=50;

//RENDER stl
module bolt(extra=0) {
    translate([-pivot/2,0,pivot_h])
    rotate([0,90]) {

        if(extra){
            translate([0,0,-extra])
            metric_thread(bolt,pitch,threaded+extra,internal=true);
        } else {
            metric_thread(bolt-bolt_gap,pitch,threaded);
        }

        translate([0,0,threaded])
        cylinder(d=bolt_shoulder+extra,h=pivot-threaded+extra);

        if(!extra)
        translate([0,0,pivot])
        knurl(k_cyl_hg=knob_h,k_cyl_od=knob);
    }
}

bolt();

color("lime") top();

color("cyan") base();
