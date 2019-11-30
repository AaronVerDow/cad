d=110;
h=110;
wall=1.2;
walll=wall*2;
gap=5;
pad=0.1;
padd=pad*2;
$fn=900;

lip=5;
lip_h=wall;

difference() {
    cylinder(d=d+walll,h=h);
    translate([0,0,wall]) 
    cylinder(d=d,h=h+padd);
    translate([0,0,-pad]) 
    cylinder(d=d-lip*2,h=h+padd);
    translate([0,0,-pad]) 
    cube([d,gap,h+padd]);
}
