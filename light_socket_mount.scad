socket=36;
$fn=90;
socket_channel=39.2;
socket_channel_w=15;
extrusion_width=1.2;
width=socket_channel_w+extrusion_width*8+1;
v_gap=0.5;
tightness=0.5;

height=20;
screw=5;
screw_head=10;
screw_h=28.5;
wall=15;
walll=wall*2;

switch=9;
switch_offset=6;

pad=0.1;
padd=pad*2;

inside_cut_top=7;


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
        translate([0,0,screw_h-(screw_head-screw)/2])
        cylinder(d2=screw_head,d1=screw,h=(screw_head-screw)/2);
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

module switch() {
    translate([-socket/2-wall-pad,width/2-switch_offset,height+socket/2])
    rotate([0,90,0])
    cylinder(d=switch,h=socket+walll+padd);
}

module main() {
    difference() {
        body();
        socket();
        screws();
        switch();
    }
}

module inside() {
    difference() {
        intersection() {
            main();
            insert();
        }
        switch();
        translate([-pad-socket/2-wall,-pad,height+socket/2-inside_cut_top])
        #cube([socket+walll+padd,width+padd,height]);
    }
}


module outside() {
    rotate([180,0,0])
    difference() {
        main();
        insert();
    }
}

//outside();
inside();
