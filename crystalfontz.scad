screen_x=66;
screen_y=13;
screen_gap_x=6.6;
screen_corner=1;
button=7;
//distance between buttons
button_gap=4.2;
button_corner=1;
$fn=45;

pcb_x=104;
pcb_y=27.5;
pcb_z=20;

gap_y=3;
gap_front=1;
gap_back=3;

total_x=147;
total_y=gap_y*2+pcb_y;
total_z=pcb_z+gap_back+gap_front;

wing_x=(total_x-pcb_x)/2;

front_corner=5;

pad=0.1;
padd=pad*2;

screw=3.5;
screw_h=6;
screw_gap=125;

console_x=screen_x+screen_gap_x+button*2+button_gap;
console_to_end=(total_x-console_x)/2;

fuck_it=2;

rotate([180,0,0])
difference() {
    translate([0,front_corner,0])
    minkowski() {
        cube([total_x/2,total_y-front_corner*2,total_z-front_corner]);
        rotate([0,90,0])
        cylinder(r=front_corner,h=total_x/2);

    }
    //cut off bottom
    translate([-pad,-pad,-front_corner-pad])
    cube([total_x+padd,total_y+padd,front_corner+pad]);

    //hole for PCB
    translate([wing_x,gap_y,-pad])
    cube([pcb_x,pcb_y,pcb_z+gap_back+pad]);

    //hole for screen
    translate([console_to_end+fuck_it,(total_y-screen_y)/2,pcb_z+gap_back-pad])
    minkowski() {
        cube([screen_x,screen_y,gap_front+padd]);
        cylinder(r1=padd,r2=gap_front,h=gap_front+pad);
    }

    translate([console_to_end+screen_x+screen_gap_x+fuck_it,(total_y-button*2-button_gap)/2,pcb_z+gap_back-pad])
    buttons();

    screw_hole(1);
    screw_hole(-1);
}

module screw_hole(x) {
    translate([total_x/2+x*screw_gap/2,total_y/2,-pad])
    cylinder(d=screw,h=screw_h+pad);
}

module buttons() {
    button_hole(0,0);
    button_hole(button+button_gap,0);
    button_hole(0,button+button_gap);
    button_hole(button+button_gap,button+button_gap);
}

module button_hole(x,y) {
    translate([button_corner+x,button_corner+y,0])
    minkowski() {
        cube([button-button_corner*2,button-button_corner*2,gap_front+padd]);
        cylinder(r=button_corner,h=gap_front);
    }

}
