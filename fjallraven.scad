x=130;
y=60;
z=100;
r=10;
d=r*2;
wall=3;
d_neg=d-wall*2;
pad=0.1;
padd=pad*2;

opp=y;
adj=z-r;
angle=atan(opp/adj);


minkowski() {
    difference() {
        minkowski() {
            cube([x-d,y-d,z-r]);
            sphere(d=d);
        }
        minkowski() {
            cube([x-d,y-d,z-r]);
            sphere(d=d-padd);
        }
        //trim top
        translate([-r-pad,-r-pad,z-r])
        cube([x+padd,y+padd,r+padd]);

        //trim angle
        //translate([-r-pad,-r,])
        //rotate([-angle,0,0])
        //translate([0,-y-padd,0])
        //cube([x+padd,y+padd,z*2]);

        //back circle
        translate([x/2-r,-r,z-r])
        rotate([-90,0,0])
        scale([1,(z-r)/(x-d)*2,1])
        cylinder(d=x-d,h=y+padd);

        translate([-r-pad,-r,z-r])
        rotate([0,90,0])
        scale([(z-r)/(y-r),1,1])
        cylinder(r=y-r,h=x+padd);
    }
    sphere(d=wall-pad);
}
