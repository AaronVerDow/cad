in=25.4;
in=1;
$fn=90;
max_x=28*in;
max_y=18*in;

wall=0.1*in;
water=7.25*in;
food=8*in;
box_x=6*in;

corner=(max_x-(water+food+box_x+wall*4))/8;
echo(corner);


water_x=water/2+corner*2+wall;
water_y=10*in;

food_x=food/2+corner*4+water+wall*2;
food_y=6*in-food/2;

box_y=7*in;
box_tx=food+corner*5+water+wall*3;
box_ty=0*in;

translate([max_y,0,0])
rotate([0,0,90])
minkowski() {
    difference() {
        translate([corner,corner])
        square([max_x-corner*2,max_y-corner*2]);
        hull() {
            translate([water_x,water_y-water/2])
            circle(d=water+corner*2);
            translate([water_x,0])
            circle(d=water+corner*2);
        }
        hull() {
            translate([food_x,food_y])
            circle(d=food+corner*2);
            translate([food_x,0])
            circle(d=food+corner*2);
        }
        translate([box_tx,box_ty])
        square([box_x+corner*2,box_y+corner*2]);
    }
    circle(r=corner);
}
