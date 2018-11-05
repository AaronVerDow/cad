level=38;
level_h=8;
total_h=130;
wall=5;
walll=wall*2;
pad=0.1;
padd=pad*2;
$fn=200;

base=100;
base_h=total_h-20;

ridge=34;
ridge_h=25;

slot=7;
slot_h=20;

module front() {
    difference() {
        union() {
            cylinder(d=level+walll,h=total_h+level_h);
            //cylinder(d2=level+walll,d1=base,h=base_h);
            cylinder(d=base,h=base_h);
        }

        translate([0,0,level_h+total_h-level_h+pad])
        cylinder(d=level, h=level_h+pad, $fn=6);
    }
}
    //translate([0,0,total_h-level_h+pad])
    //#cylinder(d=level, h=level_h+pad);


difference() {
    cylinder(d=base,h=total_h+ridge_h);
    translate([-base/2-pad,-ridge/2,total_h])
    cube([base+padd,ridge,ridge_h+pad]);

    translate([-base/2-pad,ridge/2+slot,total_h-slot_h])
    cube([base+padd,base/2,ridge_h+slot_h+pad]);
}
