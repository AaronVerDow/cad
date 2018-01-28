x=200;
y=160;
z=25;

translate([-x/2,-y/2,0])
difference(){
    cube([x,y,z]);
    rotate([atan(z/y),0,0])
    translate([-x/2,0,0])
    cube([x*2,y*2,z*2]);
}

circle(d=280);
