in=25.4;
drawer_x=400;
drawer_y=600;
drawer_h=1.5*in;
base=in/4;

divider=10;

grip_h=drawer_h-base;
grip_y=50;
grip_x=divider*2;


default_r=7;



module tray(display,x,y,r=default_r) {

    translate([x/2,0])
    if(display=="inside") {
        offset(r)
        square([x-r*2,y-r*2],center=true);
    } else if(display=="grip") {
        square([x+grip_x*2,grip_y],center=true);
    }

    translate([x+divider,0])
    children();
}

module drawer() {
    square([drawer_x,drawer_y],center=true);
}

module trays(display="inside") {
    tray(display,40,100)
    tray(display,40,100)
    tray(display,30,130);
}

module assembled() {
    difference() {
        linear_extrude(height=drawer_h)
        drawer();
        translate([0,0,base])
        linear_extrude(height=drawer_h)
        trays();

        translate([0,0,drawer_h-grip_h])
        linear_extrude(height=drawer_h)
        trays("grip");
    }   
}

assembled();


