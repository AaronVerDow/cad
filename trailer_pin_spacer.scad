h=16;
bar=14;
outer_d=35;

base_lip=3;
top_lip=base_lip;

inner_d=bar+top_lip*2;

pad=0.1;
$fn=200;

difference() {
    hull() {
        cylinder(d=inner_d,h=h);
        cylinder(d=outer_d,h=base_lip);
    }
    translate([0,0,-pad])
    cylinder(d=bar,h=h+pad*2);

}
