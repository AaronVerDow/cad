post=13.5;
post_h=40;

base=5;


slot_corner=3;

lip=3;
cap=lip;

slot_x=85.5;
slot_y=27.5;
slot_z=23;
$fn=90;
pad=0.1;


difference() {
    union() {
        linear_extrude(height=slot_z)
        offset(slot_corner)
        offset(-slot_corner)
        square([slot_x,slot_y]);

        linear_extrude(height=cap)
        offset(lip)
        square([slot_x,slot_y]);
    }

    translate([slot_x/2,slot_y/2,-pad])
    cylinder(d=post,h=post_h);
}
