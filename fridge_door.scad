max_x=23;
max_y=4.5;
cut_x=18.5;
cut_y=0.75;
corner=1;
$fn=120;


co2_x=2;
co2_y=2+cut_y;

difference() {
    translate([corner,corner])
    minkowski(){
        square([max_x-corner*2,max_y-corner]);
        circle(r=corner);
    }
    translate([-cut_x/2+max_x/2,0])
    square([cut_x,cut_y]);
    translate([0,max_y])
    square([max_x,corner]);

    translate([co2_x,co2_y])
    square([max_x-co2_x*2,max_y-co2_y]);
}
