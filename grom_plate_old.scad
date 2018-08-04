$fn=60;
mount_d=30;
mount_inner_d=22;
mount_hole=9;

plate_hole=6;
filament=1.2;
plate_d=plate_hole+filament*4;
plate_h=mount_d/2-mount_hole/2;

plate_offset=4;

plate_gap=70;

pad=0.1;
padd=pad*2;

sink_d=22;
sink_h=(plate_d-plate_hole)/2+pad;

lip=4;

difference() {
    hull() {
        //far plate
        translate([0,plate_gap+plate_offset,0])
        cylinder(d=plate_d,h=plate_h);
        //near plate
        translate([0,plate_offset,0])
        cylinder(d=plate_d,h=plate_h);
        //mount
        translate([plate_d/2,0,mount_d/2])
        rotate([0,-90,0])
        cylinder(d=mount_inner_d,h=plate_d);
    }

    //near hole
    translate([0,plate_offset,-pad])
    cylinder(d=plate_hole,h=mount_d/2+pad);
    //far hole
    translate([0,plate_gap+plate_offset,-pad])
    cylinder(d=plate_hole,h=mount_d);
    //far flange
    //translate([0,plate_gap,plate_h])
    //cylinder(d1=plate_d-lip,d2=plate_d*3,h=plate_d);

    //mount hole
    translate([plate_d/2+pad,0,mount_d/2])
    rotate([0,-90,0])
    cylinder(d=mount_hole,h=plate_d+padd);

    translate([plate_d/2+pad,0,mount_d/2])
    rotate([0,-90,0])
    cylinder(d=sink_d+padd,h=sink_h);
}
