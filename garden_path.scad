led_count=4;
strip_width=9;
strip_height=3;
between_cut_lines=54;

visor_width=2;
visor_height=10;
base_height=2;

pad=0.1;
padd=pad*2;

zip_width=4;
//solid piece above zip ties
zip_gap=3;
zip_step=1;

end_cap=0;

garden_height=5;
garden_length=40;
garden_width=10;
garden_angle=atan(garden_width/2/garden_length);
garden_other_angle=atan(garden_height/garden_length);

length=between_cut_lines*led_count+end_cap*2;

module anti_cap() {
    translate([-end_cap-pad,-pad,-pad])
    cube([pad+end_cap*2,strip_width+padd+visor_width*2,visor_height+base_height+padd]);
}

difference() {
    translate([-end_cap,0,0]) 
    union() {
        cube([length,strip_width+visor_width*2,visor_height+base_height]);
        for (i=[0:zip_step:led_count-1]) {
            translate([-zip_width/2+between_cut_lines/2+between_cut_lines*i,-garden_length,0]) {
                difference() {
                    cube([garden_width,garden_length,garden_height]);
                    rotate([garden_other_angle,0,0])
                    cube([garden_width,garden_length*1.5,garden_height]);
                    translate([0,0,-pad]) {
                        translate([garden_width/2,0,0])
                        rotate([0,0,-garden_angle])
                        cube([garden_width,garden_length*2,garden_height+padd]);
                        translate([garden_width/2,0,0])
                        rotate([0,0,garden_angle])
                        translate([-garden_width,0,0])
                        cube([garden_width,garden_length*2,garden_height+padd]);
                    }
                }
            }
        }
    }
    translate([-pad-end_cap,visor_width,base_height])
    union() {
        cube([length+padd,strip_width,visor_height+pad]);
        //#cube([length+padd,strip_width,strip_height]);

    }

    //anti_cap();
}
