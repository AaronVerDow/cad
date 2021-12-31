function segment_radius(height, chord) = (height/2)+(chord*chord)/(8*height);
function segment_angle(height, chord) = atan(chord/2/(segment_radius(height,chord)-height))*2; // angle of pie slice

// 17" Fjallraven laptop bag
height=30;
width=80;
depth=80;
cutout=height/2;
lip_x=5;
lip_y=lip_x;
wall=3;
screw=4.5;
clip=false;

pad=0.1;
zero=0.01;
big_fn=300;
screw_fn=50;
mink_fn=18;
end_fn=30;

screw_y=cutout+(height-cutout)/2;
radius=segment_radius(height, width);
diameter=radius*2;
outer_radius=radius+lip_y;
outer_diameter=outer_radius*2;
slice=segment_angle(height,width); // angle of pie slice

back_width=width+sin(slice/2)*lip_y*2;
back_offset=cos(slice/2)*lip_y;
back_height=height-back_offset;

cutout_diameter=segment_radius(cutout-back_offset,back_width)*2;
cutout_slice=segment_angle(cutout-back_offset,back_width);

module dirror_x() {
	children();
	mirror([1,0])
	children();
}

module screw(wall,x=0,y=0) {
    translate([x,y,-wall/2-pad])
    cylinder(d=screw,h=wall+pad*2, $fn=screw_fn);
}

module profile(wall=wall,flat=true) {
    module node() {
        if(flat) {
            circle(d=wall);
        } else { 
            sphere(d=wall, $fn=end_fn);
        }
    }
	hull() {
		dirror_x()
		translate([depth/2-lip_x,0])
        node();

        
	}
	dirror_x()
	hull() {
		translate([depth/2-lip_x,0])
        node();
		translate([depth/2,lip_y])
        node();
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
        union() {
            translate([width/2,0,0])
            rotate([0,0,-180+(180-slice)/2])
            translate([radius,0])
            extruded_profile(wall, slice);

            // arc ends
            dirror_x()
            translate([0,-radius+height,depth/2])
            rotate([0,0,slice/2])
            translate([0,radius])
            rotate([90,90,90])
            profile(wall, flat=false);
        }
        // boxes to clip ends
        
        if(clip)
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

            translate([0,cutout-cutout_diameter/2,-pad])
            cylinder(d=cutout_diameter,h=wall+pad*2, $fn=big_fn);
        }

	}

    translate([back_width/2,back_offset])
    rotate([0,0,90-cutout_slice/2])
    translate([-cutout_diameter/2,0])
    rotate_extrude(angle=cutout_slice,$fn=big_fn)
    translate([cutout_diameter/2,0])
    circle(d=wall, $fn=end_fn);
} 

module simple_arc(wall=wall) {
	difference() {
		arc(wall);
        screw(wall, y=screw_y);
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
