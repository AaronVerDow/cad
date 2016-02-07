$fn=120;
x=28;
y=49;
z=1;

d=40;

hole_d=4.5;
hole_r=hole_d/2;

projection(cut=true){
    cube([x,y,z]);

    translate([x/2-d/2,y/2,0])
    cylinder(h=z,r=hole_r);

    translate([x/2+d/2,y/2,0])
    cylinder(h=z,r=hole_r);
}
