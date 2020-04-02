in=25.4;
$fn=90;
wood=0.5*in;



//bathroom
wall_x=1*in;
wall_y=3*in;
can=10*in;
outer=wall_y+1*in;





module placement(can, wall_x, wall_y, outer) {
    intersection() {
        translate([-outer/2,-outer/2])
        circle(d=can+outer);
        difference() {
            translate([-can/2-wall_x,-can/2-wall_y])
            square([can+wall_x,can+wall_y]);
            circle(d=can);
        }
    }
}

module kitchen() {
    wall=3.5*in;
    can=12.625*in;
    placement(can , wall, wall, wall+1*in);
    translate([can,0])
    children();
}

module bathroom() {
    placement(10*in, 1*in, 3*in, 4*in);
}


module all() {
    kitchen()
    bathroom();
}

display="";
if(display=="") all();
if(display=="trash_placement_kitchen.svg")kitchen();
if(display=="trash_placement_bathroom.svg")bathroom();
