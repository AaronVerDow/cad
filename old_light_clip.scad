socket=39;
socket_wall=5;
socket_h=3;

bulb=65;
pad=0.1;
$fn=90;

clip=20;
clip_x=bulb;
clip_y=7;
clip_z=50;
clip_wall=2;

module socket(padding=0, wall=0) {
    translate([0,0,-padding])
    cylinder(d=socket+wall*2,h=socket_h+padding*2);
}

module curve() {
    r=clip_z-socket_h;
    #scale([1,(clip_y+clip_wall)/r,1])
    translate([-clip_wall-pad,clip_y-r,clip_z])
    rotate([0,90,0])
    cylinder(r=r,h=clip_x+clip_wall*2+pad*2);
}

module clip(padding=0, wall=0) {
        translate([-clip_x/2,bulb/2+clip_wall,0])
        difference() {
            translate([-wall,-wall,-padding])
            cube([clip_x+wall*2,clip_y+wall*2,clip_z+padding*2]);
            if (wall==clip_wall) {
                hull() {
                    translate([0,-clip_y,0])
                    curve();
                    curve();
                }
            }
        }
}

module connection() {
    difference() {
        hull() {
            socket(wall=socket_wall);
            clip(wall=clip_wall);
        }
        translate([0,0,socket_h])
        hull() {
            socket(wall=socket_wall+pad);
            clip(wall=clip_wall+pad);
        }
    }
}

module positive() {
    socket(wall=socket_wall);
    clip(wall=clip_wall);
    connection();
}

module negative() {
    socket(padding=pad);
    clip(padding=pad);
}

module assembled() {
    difference() {
        positive();
        negative();
    }
}

assembled();
