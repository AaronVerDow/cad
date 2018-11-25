socket=34.5;
$fn=90;
socket_channel=39;
socket_channel_w=13.5;
extrusion_width=1.2;
width=socket_channel_w+extrusion_width*4;
v_gap=0.5;
tightness=0.5;

height=20;
screw=5;
screw_head=10;
screw_h=27;
wall=15;
walll=wall*2;

pad=0.1;
padd=pad*2;


module body() {
    translate([0,0,socket/2+height])
    rotate([-90,0,0])
    cylinder(d=socket+walll,h=width,$fn=6);

    translate([-socket/2-wall,0,0])
    cube([socket+walll,width,height+socket/2]);
}

module socket() {
    translate([0,-pad,socket/2+height])
    rotate([-90,0,0]) {
        cylinder(d=socket,h=width+padd);
        translate([0,0,width/2-socket_channel_w/2])
        cylinder(d=socket_channel,h=socket_channel_w);
    }
}

module screw() {
    translate([socket/2+wall/2,width/2,-pad]) {
        cylinder(d=screw,h=height+socket+walll+padd);
        translate([0,0,screw_h])
        cylinder(d=screw_head,h=height+socket+walll+padd);
    }
}

module screws() {
    screw();
    mirror([1,0,0])
    screw();
}

module insert() {
    translate([-socket/2,-pad,-pad])
    cube([socket,width+padd,height+socket/2+pad]);
    translate([-socket_channel/2,width/2-socket_channel_w/2,-pad])
    cube([socket_channel,socket_channel_w,height+socket/2+pad]);
}

module main() {
    difference() {
        body();
        socket();
        screws();
    }
}

module inside() {
    intersection() {
        main();
        insert();
    }
}


module outside() {
    difference() {
        main();
        insert();
    }
}

outside();
//inside();
