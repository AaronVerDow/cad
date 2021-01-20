opening=56.5;
echo_od=75.3;

top_wall=0.6;
outer_wall=1;
magnet=10;

magnet_h=3;

screw=2.7;
screw_h=20;

pad=0.1;
layer_height=-pad;

magnets=6;

magnet_outer_wall=1;


magnet_inner_wall=screw/2-magnet/2;
echo_h=26.5+magnet_h; // actually 27, want to make it tight


$fn=290;

difference() {
    hull() {
        cylinder(d=echo_od+outer_wall*2,h=echo_h+top_wall);
        place_magnets()
        cylinder(d=magnet+magnet_outer_wall*2,h=magnet_h); //magnet
    }
    translate([0,0,-pad])
    cylinder(d=echo_od,h=echo_h+pad);
    cylinder(d=opening,h=echo_h+top_wall+pad);

    place_magnets()
    translate([0,0,-pad])
    cylinder(d=magnet,h=magnet_h+pad); //magnet
    
    place_magnets()
    translate([0,0,magnet_h+layer_height])
    cylinder(d=screw,h=screw_h-magnet_h-layer_height);

}

module place_magnets() {
    for(z=[0:360/magnets:359])
    rotate([0,0,z])
    translate([echo_od/2+magnet/2+magnet_inner_wall,0])
    children();
}






