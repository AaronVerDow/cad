x=33.25;
y=45.125;

d=x-32;

$fn=90;

wall=0.75;
wall_d=d+wall*2;

difference() {
    translate([wall_d/2,wall_d/2])
    minkowski() {
        circle(d=wall_d);
        square([x-wall_d+wall*2,y-wall_d+wall*2]);
    }
    translate([d/2+wall,d/2+wall])
    minkowski() {
        circle(d=d);
        square([x-d,y-d]);
    }
}
