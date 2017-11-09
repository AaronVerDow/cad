base=264;
base_h=14;
$fn=200;
gap=1;
lip=4;
wall=2;
z=80;
top=base+gap*2+wall*2;
pad=0.1;
padd=pad*2;

spool=220;

frame=5;

frame_center=100;

filament=3;
filament_big=z;

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
    cylinder(d=spool,h=z+padd);

    translate([0,0,-base_h-pad])
    cylinder(d=spool,h=base_h+padd);
    translate([spool/2-filament_big/2,0,z/2])
    rotate([90,0,0])
    cylinder(d2=filament,d1=filament_big,h=base/2-13);
}

spokes=20;
rings=4;

translate([0,0,-base_h]) {
    cylinder(d=frame_center,h=frame);
    for(i=[0:360/spokes:360]) {
        rotate([0,0,i])
        translate([-base/2+wall,-frame/2,0])
        cube([base/2-wall,frame,frame]);
    }
    ring_diff=(spool-frame_center)/rings;
    for(i=[frame_center:ring_diff:spool]) {
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
