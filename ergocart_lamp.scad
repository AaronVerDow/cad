post=15;
post_h=40;

base=5;

86x28x23
i3

slot_corner=3;

cap=5;
lip=3;

slot_x=100;
slot_y=30;
slot_z=post_h+base;
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
