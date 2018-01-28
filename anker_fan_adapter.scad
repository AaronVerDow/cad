x=169;
y=160;
z=2;
top_left=125-3;
bottom_left=39-3;
top_right=150-3;
bottom_right=87-3;
$fn=200;

wall=5;

pad=0.1;
padd=pad*2;
screw=4;

fan=120;
fan_bolts=105/2;
raise=6;

module hole() {
    translate([0,0,-pad])
    cylinder(d=screw,h=z+padd);
}

module screw() {
    cylinder(d=screw+wall*2,h=z);
}

module fan() {
    translate([0,0,-pad])
    cylinder(d=fan,h=z+padd);
    translate([fan_bolts,fan_bolts,0])
    hole();
    translate([-fan_bolts,fan_bolts,0])
    hole();
    translate([fan_bolts,-fan_bolts,0])
    hole();
    translate([-fan_bolts,-fan_bolts,0])
    hole();
}

difference() {
    hull() {
        cube([x,y,z]);
        translate([0,top_left,0])
        screw();
        translate([0,bottom_left,0])
        screw();
        translate([x,top_right,0])
        screw();
        translate([x,bottom_right,0])
        screw();
    }
    translate([0,top_left,0])
    hole();
    translate([0,bottom_left,0])
    hole();
    translate([x,top_right,0])
    hole();
    translate([x,bottom_right,0])
    hole();
    translate([x/2,y/2+raise,0])
    fan();
}
