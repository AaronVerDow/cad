include<threads.scad>;
height=50;
base=150;
top=25;
stopper=20;
stopper_h=10;
stopper_pitch=2.5;

$fn=200;

cut=base*0.8;
cut_d=base/3-5;
cuts=3;
pad=0.1;

base_angle=atan(height/(base/2-top/2));
top_angle=90-base_angle;

function inset(wall) = wall/sin(base_angle)+wall/tan(base_angle);

module trim_top(h) {
    translate([0,0,height-h])
    cylinder(d=base,h=height);
}

module base(wall=0) {
    difference() {
        translate([0,0,wall])
        cylinder(d2=top-inset(wall)*2,d1=base-inset(wall)*2,h=height);
        for(r=[0:360/cuts:359])
        rotate([0,0,r-90])
        hull() {
            translate([base/2+cut/2-cut_d,0,-pad])
            cylinder(d=cut+wall*2,h=height+pad*2);

            translate([base/2+cut/2,0,-pad])
            cylinder(d=cut+wall*2,h=height+pad*2);
        }
    }
}

max_overhang=60;

module stopper_shadow() {
    adj=height-stopper_h;
    opp=tan(max_overhang)*adj; 
    cylinder(d1=stopper+opp*2,d2=stopper,h=adj);
}



difference() {
    base();
    difference() {
        intersection() {
            base(2);
            stopper_shadow();
        }
        trim_top(stopper_h);
    }
    translate([0,0,height-stopper_h-pad])
    metric_thread(stopper,stopper_pitch,stopper_h+pad*2,internal=true);
}

