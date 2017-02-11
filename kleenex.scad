gap=0.5;
box_x=5;
box_y=9;

slot_x=2;
slot_y=6.75;

d=1;
$fn=90;

difference() {
    translate([-gap,-gap])
    square([box_x+gap,box_y+gap]);

    //square([box_x,box_y]);

    translate([box_x/2-slot_x/2,box_y/2-slot_y/2])
    translate([d/2,d/2])
    minkowski() {
        circle(d=d);
        square([slot_x-d,slot_y-d]);
    }
}
