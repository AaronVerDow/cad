base=262;
base_h=15;
$fn=300;
z=80;
wall=1.8;
top=264+wall*2;
pad=0.1;
padd=pad*2;

tab_angle=22;
tabs=6;

module spokes() {
    for(i=[0:360/tabs:359]) {
        rotate([0,0,i])
        translate([0,0,-base_h-pad])
        hull() {
            cube([base,pad,base_h+pad]);
            rotate([0,0,tab_angle])
            cube([base,pad,base_h+pad]);
        }
    }
}

first_layer=0.4;
hole=base-60;

difference() {
    union() {
        translate([0,0,-base_h])
        cylinder(d=base,h=base_h);
        translate([0,0,z])
        cylinder(d=top,h=base_h);
        cylinder(d2=top,d1=base,h=z);
    }
    translate([0,0,-base_h+first_layer])
    cylinder(d=base-wall*2,h=base_h);
    
    cylinder(d1=base-wall*2,d2=top-wall*2,h=z+pad);

    translate([0,0,z])
    cylinder(d=top-wall*2,h=base_h+pad);
        
    intersection() {
        translate([0,0,-base_h-pad])
        cylinder(d=base-wall*2,h=base_h+padd);
        spokes();
    }
    translate([0,0,-base_h*2])
    cylinder(d=hole,h=base_h*2);
}
