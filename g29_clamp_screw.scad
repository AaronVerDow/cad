include<threads.scad>;
use<knurledFinishLib_v2.scad>;

thread_h=40;
thread_od=15.75;
pitch=3.5;
thread_size=3.2; // it looks slightly smaller

knob_h=7;
knob=24;

allen=7.27;
allen_h=knob_h*1.5;
pad=0.1;

difference() {
    union() {
        knurl(k_cyl_hg=knob_h,k_cyl_od=knob);
        //cylinder(d=knob,h=knob_h);
        translate([0,0,knob_h])
        metric_thread(thread_od,pitch,thread_h,square=true,thread_size=thread_size);
    }
    translate([0,0,-pad])
    cylinder(d=allen,h=allen_h,$fn=6);
}
