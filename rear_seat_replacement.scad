main_r=1;
seat_x=46;
seat_y=main_r+0.1;
trunk_x=38;
trunk_y=22;
total_y=43;
gap_x=trunk_x;
gap_y=14;
gas_x=3;
gas_y=11.5;
gas_y_delta=5.5;
pad=0.1;

gas_r=1.5;
gas_tail=1;
$fn=60;

module main() {
    hull(){
        translate([-seat_x/2+main_r,trunk_y+gap_y])
        square([seat_x-main_r*2, seat_y-main_r]);
        translate([-gap_x/2+main_r,trunk_y])
        square([gap_x-main_r*2, gap_y]);
    }
    translate([-trunk_x/2+main_r,main_r])
    square([trunk_x-main_r*2, trunk_y]);
}

module old_main() {
    hull(){
        translate([-seat_x/2,trunk_y+gap_y])
        square([seat_x, seat_y]);
        translate([-gap_x/2,trunk_y])
        square([gap_x, gap_y]);
    }
    translate([-trunk_x/2,0])
    square([trunk_x, trunk_y]);
}


module cut() {
    translate([trunk_x/2-gas_x,gas_y_delta]) {
        hull() {
            translate([gas_x,0])
            square([gas_x+pad,gas_y]);
            translate([gas_r,gas_y-gas_r])
            circle(r=gas_r);
            translate([gas_r,gas_r+gas_tail])
            circle(r=gas_r);
        }
    }
}
//translate([0,0,10])
//color("lime")
//old_main();

difference() {
    minkowski() {
        main();
        circle(r=main_r);
    }
    cut();
}
