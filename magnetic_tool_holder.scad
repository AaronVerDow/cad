magnet=10.1;
magnet_h=3.2;
magnets=7;

magnet_wall=10;

backing=10;

x=230;
y=magnet_wall*2+magnet;
z=magnet_h+backing;

magnet_screw=3.5;


pad=0.1;

magnet_gap=x/magnets;

screw_gap=x/(magnets/2);

$fn=90;


screw=5;
screw_head=10;


module blocky() {

    difference() {
        linear_extrude(height=z)
        square([x,y]);
        for(i=[magnet_gap/2:magnet_gap:x])
        translate([i,y/2,0]) {
            translate([0,0,z-magnet_h])
            cylinder(d=magnet,h=magnet_h+pad);
            translate([0,0,-pad])
            cylinder(d=magnet_screw,h=z+pad*2);
        }

        for(i=[screw_gap/2:screw_gap:x])
        translate([i,y/2,0]) {
            translate([0,0,-pad])
            cylinder(d=screw,h=z+pad*2);
            translate([0,0,z-screw_head/2-pad])
            cylinder(d1=screw-pad*2,d2=screw_head+pad*2,h=screw_head/2+pad*2);
        }
    }
}

grip=0.6;

magnet_top_wall=0.5;

module pad_positive() {

    cylinder(d1=magnet_wall*2+magnet,d2=magnet+magnet_top_wall*2,h=magnet_h+grip);
}

module magnet() {
            translate([0,0,grip])
            cylinder(d=magnet,h=magnet_h+pad);
            translate([0,0,-pad])
            cylinder(d=magnet_screw,h=magnet_h+grip+pad*2);
}


difference() {
    hull()
    for(i=[magnet_gap/2:magnet_gap:x])
    translate([i,0])
    pad_positive();
    for(i=[magnet_gap/2:magnet_gap:x])
    translate([i,0])
    magnet();
}
