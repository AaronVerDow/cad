$fn=90;
wall=0.6;
back_x=70;
back_y=80;
back_z=8;

bezel_x=40;
bezel_y=34;
bezel_z=6;

screen_x=35;
screen_y=28;

bezel_y_offset=3;
pad=0.1;
padd=pad*2;

button=4;
button_flex=button*1.5;
button_d=8;
button_gap=1;

button_y=10;
a=10;
b=30;
c=50;

module bezel(pad=0,my_wall=0) {
    translate([back_x/2-bezel_x/2-my_wall,back_y/2-bezel_y/2-my_wall,wall])
    cube([bezel_x+my_wall*2,bezel_y+my_wall*2,bezel_z+pad-wall]);
}

module screen() {
    translate([0,0,-wall/2])
    minkowski() {
        translate([back_x/2-screen_x/2,back_y/2-screen_y/2,0])
        cube([screen_x,screen_y,wall/2]);
        cylinder(d2=pad,d1=wall*4+padd,h=wall+pad);
    }
}

module button_profile_top(extra=0) {
    translate([0,0,-pad]) {
        cylinder(d=button+extra*2,h=wall+padd);
        translate([-button/2-extra,0,0])
        cube([button+extra*2,button_flex,wall+padd]);
    }
}

module button_profile(extra=0) {
    translate([0,0,-pad]) {
        cylinder(d=button+extra*2,h=wall+padd);
        translate([-button/2-extra,-button_y+wall,0])
        cube([button+extra*2,button_y-wall,wall+padd]);
    }
}

module button_gap(t=0) {
    translate([t,button_y])
    difference() {
        button_profile(button_gap);
        button_profile();
    }
}

module button(t=0) {
    translate([t,button_y])
    cylinder(d=button,h=button_d);
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
}

difference() {
    positive();
    bezel(pad);
    screen();
    button_gap(a);
    button_gap(b);
    button_gap(c);
}
