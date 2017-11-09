base=300;
base_h=14;
$fn=200;
gap=1;
lip=4;
wall=2;
z=120;
top=base+gap*2+wall*2;
pad=0.1;
padd=pad*2;

frame=5;

frame_center=100;

difference() {
    union() {
        translate([0,0,-base_h])
        cylinder(d=base,h=base_h);
        translate([0,0,z])
        cylinder(d=top,h=base_h);
        cylinder(d2=top,d1=base,h=z);
    }
    translate([0,0,z-pad])
    cylinder(d=base+gap*2,h=base_h+padd);
    translate([0,0,-pad])
    cylinder(d2=base-lip*2,d1=base-wall*2,h=z+padd);

    translate([0,0,-base_h-pad])
    cylinder(d=base-wall*2,h=base_h+padd);
}

spokes=18;
rings=5;

translate([0,0,-base_h]) {
    cylinder(d=frame_center,h=frame);
    for(i=[0:360/spokes:360]) {
        rotate([0,0,i])
        translate([-base/2+wall,-frame/2,0])
        cube([base-wall*2,frame,frame]);
    }
    ring_diff=(base-frame_center)/rings;
    for(i=[frame_center:ring_diff:base-ring_diff]) {
        difference() {
            cylinder(d=i+frame,h=frame);
            translate([0,0,-pad])
            cylinder(d=i-frame,h=frame+padd);
        }
    }
}

tip_h=z-20;
spoke_h=tip_h-5;
spoke=15;
tip=6.5;
cylinder(d=spoke,h=spoke_h);
cylinder(d=tip,h=tip_h);
