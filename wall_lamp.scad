socket=35;
socket_flange=55;
wall=5;
socket_grip=wall;
side_wall=wall;
bottom_wall=side_wall;
back_wall=wall;

bulb=65;
//shade=bulb*1.5;
shade=100;
echo(shade=shade);
wall_to_shade=5;
wall_offset=wall_to_shade+shade/2;

shade_height=120;
shade_wall=1;
shade_base=3;

shade_under=10;

shade_total=shade_height+shade_under;


shade_fn=400;
pad=0.1;;


base=socket+20;
base_height=75;

base_cut=wall_offset-side_wall*3;
base_cut_r=base_cut*0.99;

wire=10;

screw=4.5;
screw_offset=wall+10;

$fn=90;

// RENDER stl
module cylinder_shade() {

    module body(extra=0,padding=0) {
        translate([0,0,-shade_under-padding/2])
        cylinder(d=shade+extra,h=shade_total+padding,$fn=shade_fn);
    }
    color("white") { 
        difference() {    
            body();
            body(-shade_wall/2,pad*2);
            translate([0,0,-pad])
            cylinder(d=socket,h=shade_base+pad*2);
            translate([0,-base/2,-shade_under-pad])
            cube([wall_offset,base,shade_under+pad]);
        }
        intersection() {
            body();
            shade_mount();
        }
    }
}

module oval(w,h) {
    scale([1, h/w])
    circle(r=w);
}


mount_spike=shade_height/3*2;


module shade_mount() {
    x=wall_offset-socket_flange/2;
    y=base/2;
    module positive() {
        cylinder(d=base,h=shade_base);
        translate([0,-base/2])
        cube([wall_offset,base,shade_base]);
    }
    difference() {
        positive();
        translate([0,0,-pad])
        cylinder(d=socket,h=shade_base+pad*2);
    }
    hull() {
        linear_extrude(height=zero)
        difference() {
            translate([wall_offset-x,-base/2])
            square([x,base]);
            dirror_y()
            translate([x,-y])
            oval(x,y);
        }
        translate([wall_offset-zero/2,-zero/2])
        cube([zero,zero,mount_spike]);
    }
}

    

wall_shade_back=shade;

zero=0.001;


// RENDER stl
module wall_shade() {
    module body(extra=0) {
        linear_extrude(height=shade_height)
        offset(extra)
        hull() {
            circle(d=shade);
            translate([wall_offset-zero,-wall_shade_back/2])
            square([zero,wall_shade_back]);
        }
    }
    color("white")
    difference() {    
        body();
        translate([0,0,shade_base])
        body(-shade_wall*2);
        translate([0,0,-pad])
        cylinder(d=socket,h=shade_base+pad*2);
    }
}

// RENDER stl
module corner_shade() {
    module body(extra=0) {
        linear_extrude(height=shade_height)
        offset(extra)
        hull() {
            circle(d=shade);
            translate([wall_offset-zero,-wall_shade_back/2])
            square([zero,wall_shade_back/2+wall_offset]);

            translate([wall_offset,wall_offset-zero])
            rotate([0,0,90])
            square([zero,wall_shade_back/2+wall_offset]);
        }
    }
    color("white")
    difference() {    
        body();
        translate([0,0,shade_base])
        body(-shade_wall*2);
        translate([0,0,-pad])
        cylinder(d=socket,h=shade_base+pad*2);
    }
}




module base_positive() {
    difference() {
        translate([0,-base/2])
        cube([wall_offset,base,base_height]);

        translate([-back_wall,side_wall-base/2,bottom_wall])
        cube([wall_offset,base-side_wall*2,base_height-socket_grip-bottom_wall]);

        translate([0,base/2+pad])
        rotate([90,0])
        linear_extrude(height=base+pad*2)
        offset(base_cut_r)
        offset(-base_cut_r)
        square([base_cut*2,(base_height-socket_grip)*2],center=true);
    }

    difference() {
        cylinder(d=base,h=base_height);
        translate([0,0,-socket_grip])
        cylinder(d=base+pad*2,h=base_height);
    }
}

module dirror_y() {
    children();
    mirror([0,1])
    children();
}


// RENDER stl
module base() {
    difference() {
        base_positive();
        cylinder(d=socket,h=base_height+pad);
        screw(screw_offset);
        screw(base_height-screw_offset);

        dirror_y()
        translate([wall_offset+pad,base/2-side_wall-wire/2,base_height-socket_grip-wire/2])
        rotate([0,-90,0])
        cylinder(d=wire,h=back_wall+pad*2);
    }
}



module screw(z=0) {
    translate([wall_offset+pad,0,z])
    rotate([0,-90,0])
    cylinder(d=screw,h=back_wall+pad*2);
}


translate([0,0,-base_height-pad])
base();
cylinder_shade();

