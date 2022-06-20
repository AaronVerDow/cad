// 2.29x0.380
// 2.280 0.430 front
//hub_h=11.5; // too tall?
hub_h=11.3; 


// hub=58.1; // old printer.  Too tight
// hub=58.3; // too tight
// hub=58.6; // good fit 
hub=58.5; // ran until 6/2022

// rim=73.2; // old printer. Too loose
// rim=73.7; // too tight
// rim=73.4; // works, hard to remove
//rim=73.3; // ran until 6/2022
rim=73.37;

pad=0.1;
padd=pad*2;
$fn=800;

inner_edge=1;
outer_edge=1;

// flange=2.7; // too big?
flange=2.5;

difference() {
    // outside
    union() {
        translate([0,0,hub_h-outer_edge])
        cylinder(d1=rim,d2=rim-outer_edge*2,h=outer_edge);
        cylinder(d=rim,h=hub_h-outer_edge);
        cylinder(d1=rim+flange*2,d2=rim-padd,h=flange+pad);
    }

    // hub
    translate([0,0,-pad])
    cylinder(d=hub,h=hub_h+padd);

    translate([0,0,-pad])
    cylinder(d1=hub+inner_edge*2+padd,d2=hub-padd, h=padd+inner_edge);
}
