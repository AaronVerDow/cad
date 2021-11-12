use <joints.scad>;
in=25.4;
ft=12*in;
top_x=1800;
top_y=1100;
top_z=1.5*in;

top=710;

top_inset=1*in;
top_wood=in*0.75;

leg_end=150; // space for leg at end of table

leg_middle=400; // space for leg at middle of table

leg_x=80;
//leg_y=top_y-leg_end*2;
//leg_y=top_y*0.55;
leg_y=1100*0.55;
leg_z=top-top_wood;

echo(leg_y=leg_y);
echo(leg_z=leg_z);

leg_gap=top_x-leg_end*2-leg_x*2;

echo(leg_gap=leg_gap);

wood=in/2;
side_wood=wood;

top_gap=0;
side_gap=in/2;

hide=wood/2;

grass_wood=wood;

leg_wood=wood;

edge=4*in;

lip=in/2;
lip_z=in/2;

led_channel=2*in;

grass_x=top_x-edge*2;
grass_y=top_y-edge*2;
grass_z=top_z-top_wood-top_gap;

glass_x=grass_x+lip*2;
glass_y=grass_y+lip*2;
glass_z=in/4;

channel_x=grass_x+led_channel*2;
channel_y=grass_y+led_channel*2;
channel_z=grass_z-glass_z-lip_z; //-glass_z-grass_z-lip_z;


zero=0.001;

skirt=50;
skirt_offset=skirt;

skirt_x_x=top_x-skirt_offset*2-top_wood*2;
skirt_y_x=top_y-skirt_offset*2;
skirt_z=skirt;
echo(skirt_z=skirt_z);
spine_x=skirt_x_x;

echo(surface=top);
echo(knee_hits_at=top-top_wood-skirt);


spine=skirt;
spine_tooth=skirt_z*3;

module dirror_y(y=0) {
    children();
    translate([0,y])
    mirror([0,1])
    children();
}


module dirror_x(x=0) {
    children();
    translate([x,0])
    mirror([1,0])
    children();
}

grass_round=in/2;

text("zoom out",valign="center",halign="center");

pad=0.1;

r=50;

module top() {
    offset(r)
    offset(-r)
    square([top_x,top_y],center=true);
}

color("saddlebrown")
translate([0,0,top-top_wood])
linear_extrude(height=top_wood)
*top();

module spine() {
    square([spine_x,spine]);
    dirror_x(spine_x)
    translate([spine_x/2+leg_gap/2+wood,0])
    square([leg_x-wood*2,spine_tooth]);
}

module wood(height=wood) {
    linear_extrude(height=height)
    children();
}

color("chocolate")
dirror_y()
translate([-spine_x/2,-top_y/2+leg_middle,top-top_wood])
rotate([-90,0,0])
wood(top_wood)
spine();


module skirt_x(){
    square([skirt_x_x,skirt_z]);
}

color("chocolate")
dirror_y()
translate([-skirt_x_x/2,skirt_offset-top_y/2,top-top_wood])
rotate([-90,0,0])
wood(top_wood)
skirt_x();

module skirt_y() {
    square([skirt_y_x,skirt_z]);
}

color("peru")
dirror_x()
translate([-skirt_x_x/2,skirt_offset-top_y/2,top-top_wood])
rotate([-90,0,90])
wood(top_wood)
skirt_y();

bit=in/4;
pintail_ear=bit;

function segment_radius(height, chord) = (height/2)+(chord*chord)/(8*height);

module leg_preview() {
    leg();
    color("red")
    translate([0,0,1])
    leg_pockets();

    color("lime")
    leg_anchor();
}

module leg_anchor() {
    dirror_x(leg_y)
    dirror_y(leg_z)
    translate([-20,-20])
    circle(d=10);
}

//!leg_face();

!leg_preview();

// RENDER svg
module anchored_leg() {
    leg();
    leg_anchor();
}

// RENDER svg
module anchored_leg_pockets() {
    leg_pockets();
    leg_anchor();
}


// RENDER svg
module leg() {
    foot=leg_x;
    chord=top-top_wood-skirt-foot*2;
    height=chord*0.4;
    radius=segment_radius(height, chord);
    difference() {
        square([leg_y,leg_z]); 

        dirror_x(leg_y)
        translate([-pad,top-top_wood+pad])
        rotate([0,0,-90])
        negative_slot(wood+pad,spine+pad,pintail_ear);

        dirror_x(leg_y)
        translate([leg_y/2-top_y/2+leg_middle,top-top_wood+pad])
        rotate([0,0,-90])
        dirror_y(top_wood)
        negative_slot(top_wood,spine+pad,pintail_ear);

        r=20;
        offset(r)
        offset(-r)
        translate([leg_y/2,leg_z])
        square([light_x,light_y*2],center=true);
    }
}

base_offset=30;

module leg_assembly() {
    color("tan")
    dirror_x()
    translate([-leg_x/2,-leg_y/2,0])
    rotate([90,0,90])
    //wood(leg_x/2)
    wood()
    difference() {
        leg();
        leg_pockets();
    }

    dirror_y()
    color("sandybrown")
    translate([0,leg_y/2,leg_z/2])
    rotate([90,0])
    wood()
    leg_face();

    translate([0,0,base_offset])
    wood()
    base(leveler_hole);

    translate([0,0,stabalizer_offset])
    wood()
    base(leveler_bolt);

    //wood() base_flat();

}


dirror_x()
translate([leg_x/2+leg_gap/2,0])
leg_assembly();

leg_pins=4;
gap=in/8;


module leg_pockets() {
    dirror_x(leg_y)
    translate([-pad-bit,0])
    negative_tails(leg_z-spine,wood+pad+bit,leg_pins,gap,0,pintail_ear);

    module base_pockets(z) {
        translate([wood,wood+z]) rotate([0,0,-90]) dirror_x(wood) {
            negative_pins(base_y,wood,base_pins,gap,0,pintail_ear);

            dirror_y(base_y)
            translate([0,bit*4-gap])
            rotate([0,0,-90])
            negative_slot(wood,bit*4,pintail_ear);
        }
    }
    base_pockets(base_offset);
    base_pockets(stabalizer_offset);
}

//!leg_face();
// RENDER svg
module leg_face() {
    x=(top_x-leg_gap-leg_x-skirt_offset*2-top_wood*2)/2;

    translate([0,leg_z/2-skirt_z]) {
        square([x,skirt_z]);
        ramp=x*1.5;
        hull() {
            translate([-ramp,skirt_z-zero])
            square([ramp,zero]);
            translate([-leg_x/2,0])
            square([leg_x/2,zero]);
        }
    }
    difference() {
        square([leg_x-hide*2,leg_z],center=true);
        dirror_x()
        translate([-leg_x/2,-leg_z/2-pad])
        negative_pins(leg_z-spine,wood+pad,leg_pins,gap,0,pintail_ear);
    }
}

leveler_gap=leg_y-leg_x;
leveler_hole=10;
leveler_bolt=8;
base_y=leg_y-wood*2;

leveler_stablizer=50;  // how long to grip the bolt

stabalizer_offset=base_offset+leveler_stablizer-wood;

base_pins=3;
//!base();

light_x=100; 
light_y=skirt;

// RENDER svg
module base_bottom() {
    base(leveler_hole);
}

// RENDER svg
module base_top() {
    base(leveler_bolt);
}


module base(hole=0) {
    difference() {
        square([leg_x-hide*2,base_y],center=true); 
        dirror_y()
        translate([0,leveler_gap/2])
        circle(d=hole);

        dirror_x()
        translate([-pad-leg_x/2,-base_y/2])
        negative_tails(base_y,wood+pad,base_pins,gap,0,pintail_ear);
    }
}
