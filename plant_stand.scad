$fn=200;
d=120;
rotate([0,180,0])
difference() {
    cylinder(d=120,h=230);
    translate([-d/2,d/2-30-16,0])
    cube([d,30,16]);
    translate([-d/2,d/2-16,0])
    #cube([d,16,38]);
}
