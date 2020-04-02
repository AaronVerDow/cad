in=25.4;
x=(35+3/8)*in;
y=27.75*in;
r=1*in;
$fn=200;

vent_max=18*in;

vent=4.25*in;

vents=3;

vent_y=17.75*in;

vent_gap=(vent_max-(vent*vents))/(vents-1);

bit=0.25*in;

plug_lip=0.5*in;
plug_gap=1/16*in;
cut_gap=bit*3;
module outside_profile() {
    minkowski() {
        square([x-r*2,y-r*2],center=true);
        circle(r=r);
    }
    color("red")
    plugs()
    plug_outside_profile();
}

module inside_profile() {
    for(n=[0:1:vents-1]) {
        translate([(vent+vent_gap)*n-(vent+vent_gap)*vents/2+vent/2+vent_gap/2,-y/2+vent_y])
        circle(d=vent);
    }
}

module pocket() {
    color("blue")
    plugs()
    plug_pocket();
}

module plugs() {
    for(n=[0:1:vents-1]) {
        translate([(vent+cut_gap+plug_lip*2)*n-x/2+vent/2+cut_gap+plug_lip,y/2+vent/2+cut_gap+plug_lip])
        children();
    }
}

module plug_pocket() {
    difference() {
        circle(d=vent+plug_lip*2);
        circle(d=vent-plug_gap*2);
    }
}

module plug_outside_profile() {
    circle(d=vent+plug_lip*2);
}

module assembled() {
    difference() {
        outside_profile();
        inside_profile();
    }
    pocket();
}

module anchor() {
    translate([-x/2,y/2+cut_gap+plug_lip*2+vent])
    circle(d=0.25*in);
}

display="";
if(display=="") {
    assembled();
    anchor();
}
if(display=="window_cover_assembled.svg") assembled();
if(display=="window_cover_pocket.svg") {
    pocket();
    anchor();
}
if(display=="window_cover_outside_profile.svg") {
    outside_profile();
    anchor();
}
if(display=="window_cover_inside_profile.svg") {
    inside_profile();
    anchor();
}
