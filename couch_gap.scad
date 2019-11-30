d=63;
h=95;
wall=1.78;
walll=wall*2;
gap=0;
pad=0.1;
padd=pad*2;
$fn=900;

lip=15;
lip_h=wall;

zip_w=7;
zip_h=4;
zip_offset=5;

difference() {
    cylinder(d=d,h=h);

    translate([0,0,wall]) 
    cylinder(d=d-walll,h=h+padd);

    translate([0,0,-pad]) 
    cylinder(d=d-lip*2,h=h+padd);
    //translate([0,0,-pad]) 
    //cube([d,gap,h+padd]);

    translate([-d/2-pad,-zip_w/2,h-zip_h-zip_offset])
    cube([d+padd,zip_w,zip_h]);
}
