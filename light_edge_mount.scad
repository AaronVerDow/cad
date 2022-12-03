socket=35.5;
socket_body=39;
flange=55.5;
offset=40;
zero=0.001;
pad=0.1;
$fn=200;
slope=5; // extra on base of wall

tape=48;  // roll of gaffers tape

flat_width=flange+pad*2;
flat_height=tape+slope;

wall=3; // how thick light holding part is

total_height=flat_height*2+wall;

fillet=18; // roundness of corner

base=1.5; // how thick base is
base_tip=0.5;  // how thick end of base is


screw=4.8;
screw_head=8.5; // drywall screw

screw_head_h=(screw_head-screw)/2;

zip_tie=5;
wire_x=10;
wire_y=5;

edge=20;



wood=25;

difference() {
    hull() {
        cylinder(d=flange,h=wall);
        translate([socket_body/2-zero+wood,-flange/2,0])
        cube([zero,flange,wall]);
    }
    translate([0,0,-pad])
    cylinder(d=socket,h=wall+pad*2);
    translate([socket_body/2+wood/2,0,-pad])
    cylinder(d=screw,h=wall+pad*2);
    translate([socket_body/2+wood/2,0,wall-screw_head_h-pad])
    cylinder(d1=screw-pad*2,d2=screw_head+pad*2,h=screw_head_h+pad*2);
}
