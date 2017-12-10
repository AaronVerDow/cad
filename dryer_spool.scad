wall=2;
spool=50;
spool_h=65;
lip=90;
lip_h=wall;
bearing=22.5;
bearing_h=7;
bearing_diff=20;
walll=wall*2;
pad=0.1;
padd=pad*2;
$fn=200;

difference() {
    union() {
        cylinder(d=spool,h=lip_h+spool_h);
        cylinder(d=lip,h=lip_h);
    }
    translate([0,0,-pad])
    cylinder(d=bearing-walll,h=lip_h+spool_h+padd);

    translate([0,0,-pad])
    cylinder(d=bearing,h=lip_h+spool_h+pad-bearing_diff);

    translate([0,0,lip_h+spool_h-pad-bearing_diff])
    cylinder(d2=bearing-walll,d1=bearing+padd,h=walll);

    translate([0,0,-pad])
    cylinder(d=spool-walll,h=lip_h+spool_h+pad-bearing_diff-bearing_h-(spool-bearing)/2);

    translate([0,0,lip_h+spool_h-bearing_diff-bearing_h-(spool-bearing)/2-pad])
    cylinder(d1=spool-walll+padd,d2=bearing,h=(spool-walll-bearing)/2);
}

