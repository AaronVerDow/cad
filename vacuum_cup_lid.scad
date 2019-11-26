
inner_d2=100;
inner_d1=95;
inner_h=10;
outer_d=105;
outer_h=3;

straw=15;
ring=90;
ring_h=7;
ring_from_lip=2;
total_h=outer_h+inner_h;
pad=0.1;
padd=pad*2;
$fn=200;

module blank() {
    translate([0,0,inner_h])
    cylinder(d=outer_d,h=outer_h);
    difference() {
        cylinder(d1=inner_d1,d2=inner_d2,h=inner_h);
        translate([0,0,inner_h-ring_h-ring_from_lip])
        cylinder(d=inner_d1+inner_d2,h=ring_h);
    }
    translate([0,0,inner_h-ring_h-ring_from_lip])
    cylinder(d=ring,h=ring_h);
}

difference() {
    blank();
    translate([0,0,-pad])
    cylinder(d=straw,h=total_h+padd);
}
