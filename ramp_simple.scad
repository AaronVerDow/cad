x=250;
//big kitchen
y=160;
z=25;
//living room
y=90;
z=12;

d=20;
filament=1.8*2;

pad=0.1;

translate([-x/2,-y/2,0])
difference(){
    cube([x,y,z]);
    rotate([atan(z/y),0,0])
    translate([-x/2,0,pad])
    cube([x*2,y*2,z*2]);
}

circle(d=280);
