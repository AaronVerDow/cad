in=25.4;
can=12.625*in;
angle=45;
wall=3.5*in;
r=wall/2;
$fn=90;


module twod() {
    difference() {
        minkowski() {
            circle(d=r*2);
            union() {
                //circle(d=can+wall*2);
                translate([-can/2-wall+r,0])
                square([can+wall*2-r*2,can/2+wall-r]);
                translate([0,-can/2-wall+r])
                square([can/2+wall-r,can+wall*2-r*2]);
            }
        }
        translate([-can/2-wall,-can/2-wall])
        square([can/2+wall,can/2+wall]);
        circle(d=can);
    }
    translate([0,-can/2-wall/2])
    circle(d=wall);
    translate([-can/2-wall/2,0])
    circle(d=wall);
}


wood=0.5*in;


//linear_extrude(height=wood)
twod();
