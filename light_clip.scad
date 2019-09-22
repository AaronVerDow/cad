socket=45;
socket_wall=8;
socket_h=3;

bulb=100;
pad=0.1;
$fn=90;

clip=20;
clip_x=33;
clip_y=45;
clip_z=80;
clip_wall=2;

module socket(padding=0, wall=0) {
    translate([0,0,-padding])
    cylinder(d=socket+wall*2,h=socket_h+padding*2);
}

module clip(padding=0, wall=0, base=0) {
    translate([-clip_x-padding+bulb/2,-padding-clip_y+bulb/2,base])
    cube([clip_x+wall+padding,clip_y+wall+padding,clip_z+padding]);
}

module connection() {
    hull() {
        difference() {
            clip();
            clip(wall=pad, padding=pad, base=socket_h);
        }
        socket(wall=socket_wall);
    }
}

module positive() {
    socket(wall=socket_wall);
    clip(wall=clip_wall);
    connection();
}

module negative() {
    socket(padding=pad);
    clip(padding=pad,base=socket_h);
}

module assembled() {
    difference() {
        positive();
        negative();
    }
}

assembled();
