$fn=90;
wall=0.6;
back_x=69;
back_y=85;
back_z=12;

bezel_x=40;
bezel_y=23.5;
bezel_z=2;

screen_x=31;
screen_y=14;
screen_x=bezel_x;
screen_y=bezel_y;

bezel_y_offset=-2;
pad=0.1;
padd=pad*2;

button=4;
button_flex=button*1;
button_d=9;
button_gap=1;

button_y=7.5;
button_spacing=12.5;
a=5;
b=a+button_spacing;
c=b+button_spacing;
reset_x=7;
reset_y=19;

module bezel(pad=0,my_wall=0) {
    translate([back_x/2-bezel_x/2-my_wall,back_y/2-bezel_y/2-my_wall+bezel_y_offset,wall])
    cube([bezel_x+my_wall*2,bezel_y+my_wall*2,bezel_z+pad-wall]);
}

module screen_old() {
    translate([0,0,-wall/2])
    minkowski() {
        translate([back_x/2-screen_x/2,back_y/2-screen_y/2+bezel_y_offset,0])
        cube([screen_x,screen_y,wall/2]);
        cylinder(d2=pad,d1=wall*4+padd,h=wall+pad);
    }
}

module screen() {
    translate([back_x/2-screen_x/2,back_y/2-screen_y/2+bezel_y_offset,-pad])
    cube([screen_x,screen_y,wall+padd]);
}


module button_profile_top(extra=0) {
    translate([0,0,-pad]) {
        cylinder(d=button+extra*2,h=wall+padd);
        translate([-button/2-extra,0,0])
        cube([button+extra*2,button_flex,wall+padd]);
    }
}

module button_profile_bottom(extra=0) {
    translate([0,0,-pad]) {
        cylinder(d=button+extra*2,h=wall+padd);
        translate([-button/2-extra,-button_y+wall,0])
        cube([button+extra*2,button_y-wall,wall+padd]);
    }
}
module button_profile(extra=0) {
    //button_profile_bottom(extra);
    button_profile_top(extra);
}

module button_gap(t=0,y=button_y) {
    translate([t,y])
    difference() {
        button_profile(button_gap);
        button_profile();
    }
}

module button(t=0,y=button_y) {
    translate([t,y])
    cylinder(d=button,h=button_d);
}

switch_d=3.3;
module switch(w=0,x=0){
    translate([x,-pad,back_z-switch_d])
    cube([w,wall+padd,switch_d+pad]);

}

module positive() {
    difference() {
        cube([back_x,back_y,back_z]);
        translate([wall,wall,wall])
        cube([back_x-wall*2,back_y,back_z]);
    }
    bezel(0,wall);
    button(a);
    button(b);
    button(c);
    button(reset_x,reset_y);
}

difference() {
    positive();
    bezel(pad);
    screen();
    button_gap(a);
    button_gap(b);
    button_gap(c);
    button_gap(reset_x,reset_y);
    switch(8,18.5);
    switch(8,40);
}
