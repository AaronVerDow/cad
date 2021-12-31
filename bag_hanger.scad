function segment_radius(height, chord) = (height/2)+(chord*chord)/(8*height);

// 17" Fjallraven laptop bag
height=30;
width=80;
depth=80;
cutout=height/2;
lip_x=5;
lip_y=lip_x;
wall=3;
screw=4.5;

pad=0.1;
zero=0.01;
big_fn=300;
med_fn=50;
mink_fn=18;

screw_y=cutout+(height-cutout)/2;
radius=segment_radius(height, width);
diameter=radius*2;
outer_radius=radius+lip_y;
outer_diameter=outer_radius*2;
slice=atan(width/2/(diameter/2-height))*2; // angle of pie slice

module dirror_x() {
	children();
	mirror([1,0])
	children();
}

module screw(wall,x=0,y=0) {
    translate([x,y,-wall/2-pad])
    cylinder(d=screw,h=wall+pad*2, $fn=med_fn);
}

module profile(wall=wall,depth=depth,lip_x=lip_x,lip_y=lip_y) {
	hull() {
		dirror_x()
		translate([depth/2-lip_x,0])
		circle(d=wall);
	}
	dirror_x()
	hull() {
		translate([depth/2-lip_x,0])
		circle(d=wall);
		translate([depth/2,lip_y])
		circle(d=wall);
	}
}

module extruded_profile(wall=wall, slice=360) {
	translate([0,0,depth/2])
	rotate_extrude(angle=slice, $fn=big_fn)
	rotate([0,0,90])
	translate([0,radius])
	profile(wall);
}

module arc(wall=wall,slice=slice) {
    intersection() {
        translate([width/2,0,0])
        rotate([0,0,-180+(180-slice)/2])
        translate([radius,0])
        extruded_profile(wall, slice);
        // boxes to clip ends
        union() {
            translate([-pad-width/2-wall/2,-pad-wall/2,-pad-wall/2])
            cube([width+wall+pad*2,height+lip_y+pad*2+wall,depth+pad*2+wall]);
            translate([-pad-width/2-wall/2-lip_y,-pad-wall/2,-pad-wall/2])
            cube([width+wall+pad*2+lip_y*2,height+lip_y+pad*2+wall,depth/2+pad*2+wall]);
        }
    }

	intersection() {
        // back
        translate([0,0,-wall/2])
        difference() {
            translate([0,height-radius])
            cylinder(d=diameter+lip_y*2,h=wall, $fn=big_fn);

            cutout_od=segment_radius(cutout,width+lip_y*2)*2;
            translate([0,cutout-cutout_od/2,-pad])
            cylinder(d=cutout_od,h=wall+pad*2, $fn=big_fn);
        }

        // pie slice
        translate([0,height-radius,-wall/2-pad])
        rotate([0,0,(180-slice)/2])
        rotate_extrude(angle=slice, $fn=big_fn)
        square([radius+lip_y, wall+pad*2]);
	}
} 

module simple_arc(wall=wall) {
	difference() {
		arc(wall);
		translate([0,screw_y,-wall/2-pad])
		cylinder(d=screw,h=wall+pad*2, $fn=med_fn);
	}
}

// this takes hours
module fancy_arc(wall=wall) {
	difference() {
		minkowski() {
			arc(zero);
			sphere(d=wall-zero, $fn=mink_fn);
		}
        screw(wall,y=screw_y);
	}
}

module post(wall=wall) {
    extruded_profile();
    difference() {
        cylinder(d=diameter+lip_y*2, h=wall, center=true);
        screw(wall);
    }
}

//post();
//simple_arc();
