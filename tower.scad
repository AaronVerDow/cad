vt_x=6;
vt_y=3;
max_h=25;
base_h=10;
leg=3;
leg_x=base_h/2;
pad=0.1;
legs=3;
$fn=60;

hull() {
    rotate(15)
    translate([0,0,max_h])
    cube([vt_x,vt_y,1],center=true);
    translate([0,0,base_h])
    cube([vt_x,vt_y,1],center=true);
}

for(i=[0:360/legs:360]) {
    hull() {
        rotate([0,0,i])
        translate([leg_x,0,0])
        cylinder(d=leg,h=pad);
        translate([0,0,base_h])
        cube([vt_x,vt_y,1],center=true);
    }
}
