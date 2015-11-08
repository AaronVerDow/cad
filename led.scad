led_count=4;
strip_width=11;
strip_height=3;
between_cut_lines=16.8;

visor_width=1;
visor_height=6;
base_height=2;

pad=0.1;
padd=pad*2;

zip_width=4;
//solid piece above zip ties
zip_gap=3;
zip_step=1;

end_cap=5;

length=between_cut_lines*led_count+end_cap*2;

module anti_cap() {
    translate([-end_cap-pad,-pad,-pad])
    cube([pad+end_cap*2,strip_width+padd+visor_width*2,visor_height+base_height+padd]);
}

difference() {
    translate([-end_cap,0,0]) 
    cube([length,strip_width+visor_width*2,visor_height+base_height]);
    translate([-pad-end_cap,visor_width,base_height])
    union() {
        cube([length+padd,strip_width,visor_height+pad]);
        #cube([length+padd,strip_width,strip_height]);
    }
    

    for (i=[0:zip_step:led_count]) {
        translate([-zip_width/2+between_cut_lines*i,-pad,-pad]) {
            cube([zip_width,visor_width+padd,visor_height+base_height-zip_gap+pad]);
            translate([0,strip_width+visor_width,0])
            cube([zip_width,visor_width+padd,visor_height+base_height-zip_gap+pad]);
        }
    }

    //anti_cap();
}
