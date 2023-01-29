in=25.4;
$fn=90;
bit=in/4*1.01;

//inset=150;
inset=100;

total_depth=22*in;
back_wheels=00;

wheelbase=total_depth+back_wheels;

basket_height=150;

shelves=3;

zero=0.001;

curve=800;
bottom_lip=40; // how high is bottom shelf from base

// http://www.harborfreight.com/8-inch-pneumatic-swivel-caster-42485.html
// Mounting pattern 3-3/8 in. L x 2-3/4 in. W
// Mounting plate size (in.) 4-1/2 in. x 4 in.
// Product Height 9-1/2 in.
// front_wheel_plate_x=2.25*in;
// front_wheel_plate_y=(3+3/8)*in;

// https://www.harborfreight.com/8-inch-pneumatic-rigid-caster-42714.html
// Mounting pattern 3-1/4 in. x 2-3/4 in.
// back_wheel_plate_x=3.25*in;
// back_wheel_plate_y=2.75*in;
// wheel_height=9.5*in;
// wheel_wall=20;
// wheel=8*in;
// wheel_thick=2.25*in;

// fixed
// https://www.amazon.com/POWERTEC-17052-Industrial-Caster-4-Inch/dp/B07B7KF2X5/ref=sr_1_15?keywords=Pneumatic+Caster&qid=1674938004&sr=8-15
back_wheel_plate_x=2.87*in;
back_wheel_plate_y=3.35*in;
plate_x_total=3.94*in;
wheel_wall=(plate_x_total-back_wheel_plate_x)/2;

wheel_height=7.6*in;

wheel=6.25*in;
wheel_thick=1.95*in;

// swivel
// https://www.amazon.com/POWERTEC-17050-Swivel-Industrial-Caster/dp/B07B7KJ5QZ/ref=sr_1_16?keywords=Pneumatic+Caster&qid=1674938004&sr=8-16
front_wheel_plate_x=back_wheel_plate_x;
front_wheel_plate_y=back_wheel_plate_y;


base_fillet=80;

pattern_hole=1.5*in;
pattern_gap=2.75*in;
pattern_fn=90;

pattern_wall=1*in;

pad=0.1;

total_height=40*in-wheel_height;
wood=in/2;

total_width=22.75*in-back_wheel_plate_x+wood-wheel_wall*2; // standard


shelf_angle=10;

shelf_gap=(total_height-basket_height-wood-bottom_lip)/(shelves+1);

face_inset=200;
face_angle=atan(face_inset/(total_depth+back_wheels));

echo(shelf_gap=(shelf_gap-wood)/in);

handle_y=80;
handle=1.5*in;
handle_d=handle*1.5;
handle_z=-handle_d/2;

side_offset=wheel_wall*2+100;
side_offset=0;
side_angle=atan(side_offset/total_height);
side_height=total_height/cos(side_angle);



back_angle=atan(inset/total_height);
back_height=total_height/cos(back_angle);

//front_inset=wheel_wall*2;
front_inset=front_wheel_plate_y/2*3;

base_back_wall=tan(back_angle)*wood;
front_angle=atan(front_inset/total_height);


walking_gap=total_width-back_wheel_plate_x+wood-wheel_wall*2;
echo(walking_gap=walking_gap/in);


module wheel() {
    color("gray")
    translate([0,0,wheel/2])
    rotate([0,90,0])
    cylinder(d=wheel,h=wheel_thick,$fn=90,center=true);
}

back_axle=back_wheel_plate_y/2+wheel_wall-back_wheels;

dirror_x(total_width)
translate([0,back_axle])
wheel();

dirror_x(total_width)
translate([wheel_wall+front_wheel_plate_x/2-front_wheel_offset,total_depth-wheel_wall-front_wheel_plate_y,0])
wheel();

module wheel_outside() {
	offset(wheel_wall)
	square([back_wheel_plate_x,back_wheel_plate_y],center=true);
}

module dirror_y(y=0) {
    children();
    translate([0,y,0])
    mirror([0,1])
    children();
}

module dirror_x(x=0) {
    children();
    translate([x,0])
    mirror([1,0])
    children();
}

module wood(height=wood) {
    linear_extrude(height=height)
    children();
}

module end(x_angle=0) {
    scale([1,1/cos(x_angle)])
    hull()
    dirror_x(total_width)
    rotate([0,0,side_angle])
    square([zero,side_height]);
}

module side() {
    difference() {
        side_positive_2(); 
        intersection() {
            translate([total_depth/2,side_height-basket_height/2-wood/4])
            pattern();
            difference() {
                offset(-pattern_wall)
                side_positive_2(); 
    
                // back wall
                translate([inset+wood/2,0])  // math harder
                rotate([0,0,back_angle])
                translate([-pattern_wall,0])
                square([pattern_wall*2,side_height]);

                // handle
                translate([-handle_y,side_height+handle_z]) 
                circle(d=handle+pattern_wall*2);
                
                // bottom
                translate([-total_depth,0])
                square([total_depth*2,pattern_wall+wood/2]); // getting lazy here
            }
        }
    }
}

module place_wheel_plate() {
    translate([-back_wheel_plate_x/2,wheel_wall])
    dirror_x(back_wheel_plate_x)
    dirror_y(back_wheel_plate_y)
    children();
}

module wheel_plates() {
    place_wheel_plates()
    circle(d=bit);
}

module place_wheel_plates() {
    dirror_x(total_width)
    translate([wood/2,-back_wheels])
    place_wheel_plate()
    children();

    #dirror_x(total_width)
    translate([back_wheel_plate_x/2+wheel_wall-front_wheel_offset,total_depth-front_wheel_plate_y-wheel_wall*2])
    place_wheel_plate()
    children();
}

module side_positive_2() {
    pad=20;

    hole_z=side_height-zero-basket_height;
    y=hole_z*tan(back_angle);

    guess=wood;

    az=side_height+handle_z-wood;
    ay=handle_y-back_wheels;
    aa=atan(ay/az);
    a=sqrt((az*az)+(ay*ay));
    b=curve+handle_d/2;
    c=curve;
    wtf=((a*a)+(b*b)-(c*c))/(2*a*b);
    final=acos(wtf);

    difference() {
        side_positive();
        hull() {
            translate([inset,0])
            square([total_depth-inset+pad,zero]);
            translate([inset-y,hole_z])
            square([total_depth-inset+pad+y,zero]);
        }
        translate([-handle_y,side_height+handle_z])
        rotate([0,0,90-final+aa])
        translate([-curve-handle_d/2,0])
        circle(r=curve);

    }
}

face_inset=0100;
module side_positive() {
    zero=10;
    offset=back_wheels;
    hull() {

        // top
        translate([0,side_height-zero])
#        square([total_depth/cos(face_angle),zero]);

        // handle
		translate([-handle_y,handle_z+side_height])
		circle(d=handle_d);

        // base
        translate([-offset,wood])
        square([total_depth+offset-front_inset,zero]);
    }
    // wood base
    translate([-offset,0])
    square([total_depth+offset-front_inset,wood+1]);
}

side_positive();

module front_pattern_wall() {
    // basket base
    translate([0,total_height-basket_height-pattern_wall-wood/2])
    square([total_width,pattern_wall*2]);

    // spine
    translate([total_width/2-pattern_wall,0])
    square([pattern_wall*2,total_height-basket_height]);

    // shelves

    dirror_x(total_width)
    for(z=[0:shelf_gap:shelf_gap*(shelves)])
    translate([0,z+bottom_lip])
    rotate([0,0,-shelf_angle])
    translate([0,-pattern_wall+wood/2])
    square([total_width/2,pattern_wall*2]);
}

module front() {
    module positive() {
        end(front_angle);
        square([total_width,total_height]);
    }
    difference() {
        positive();
        intersection() {
            difference() {
                offset(-pattern_wall)
                positive();
                front_pattern_wall();
           }
            translate([total_width/2,total_height-basket_height/2-wood/4])
            pattern(total_height);
        }
    }
}

module base() {
    module positive() {
        difference() {
            translate([-front_wheel_offset,0])
            offset(wheel_wall)
            offset(-wheel_wall)
            square([total_width+front_wheel_offset*2,total_depth]);
            offset(base_fillet)
            offset(-base_fillet)
            difference() {
                translate([0,-base_fillet*2])
                square([total_width,inset-base_back_wall+base_fillet*2]);
                base_wheels();
            }
        }
        base_wheels();
    }
    difference() {
        positive();
        wheel_plates();
    }
}

front_wheel_offset=wheel_wall+1;

module base_wheels() {
    dirror_x(total_width) 
    hull() {
        translate([-front_wheel_offset,-back_wheels])
        offset(wheel_wall)
        offset(-wheel_wall)
        square([wood+front_wheel_offset,total_depth+back_wheels]);

        translate([wood/2,back_axle])
        wheel_outside();
    }
}

module shelf() {
	square([total_width/2-wood/2,total_depth]);
}

module basket_bottom() {
	square([total_width,total_depth]);
}

module back() {
    module positive() {
        end(back_angle);
    }
    difference() {
        positive();
        intersection() {
            pattern();
            difference() {
                offset(-pattern_wall)
                positive();
                scale([1,1/cos(back_angle)])
                front_pattern_wall();
            }
        }
    }
}

module body() {
    hull() {
        translate([-pad,0,total_height])
        cube([total_width+pad*2,total_depth,zero]);
        translate([-pad,inset])
        cube([total_width+pad*2,total_depth-inset-front_inset,zero]);
    }
}

module trim_to_body() {
    intersection() {
        body();
        children();
    }
}

shelf_drop=tan(shelf_angle)*total_depth/2;

module spine() {
    module positive() {
        square([total_height-basket_height,total_depth]);
    }
    difference() {
        positive();
        intersection() {
            pattern();
            difference() {
                offset(-pattern_wall-wood/2)
                positive();
                
                for(z=[0:shelf_gap:shelf_gap*(shelves)])
                translate([z+bottom_lip-shelf_drop-wood,0]) // probably wrong math
                square([pattern_wall*2,total_depth]);

                translate([0,inset+wood/2,0])
                rotate([0,0,-back_angle])
                translate([0,-pattern_wall])
                square([total_height,pattern_wall*2]);
            }
        }
    }
}


primary="tan";
secondary="chocolate";
tertiary="peru";

module place_shelves() {
}

module assembled_frame() {

    color(secondary)
    translate([0,inset])
    rotate([back_angle,0])
    translate([0,wood,0])
    rotate([90,0,0])
    wood()
    back();

    trim_to_body()
    translate([0,0,total_height-wood-basket_height])
    color(tertiary)
    wood()
    basket_bottom();


    trim_to_body()
    color(primary)
    translate([total_width/2+wood/2,0])
    rotate([0,-90])
    wood()
    spine();

    trim_to_body()
    dirror_x(total_width)
    for(z=[0:shelf_gap:shelf_gap*(shelves)])
    translate([0,0,z+bottom_lip])
    rotate([0,shelf_angle,0])
    color(tertiary)
    wood()
    shelf();

    color(tertiary)
    wood()
    base();

    color(secondary)
    translate([0,total_depth-front_inset])
    rotate([90-front_angle,0,0])
    wood()
    front();

    color(primary)
    dirror_x(total_width)
    translate([0,-back_wheels])
    rotate([0,0,-face_angle])
    translate([0,back_wheels])
    rotate([90-side_angle,0,90])
    wood()
    side();

    color(tertiary)
    translate([wood,-handle_y,total_height+handle_z])
    rotate([0,90,0])
    cylinder(d=handle,h=total_width-wood*2);
}

module pattern(pattern_max=1000) {
    translate([-pattern_gap/2,0])
    dirror_y()
    dirror_x() {
        for(x=[0:pattern_gap:pattern_max])
        for(y=[0:pattern_gap:pattern_max])
        translate([x,y])
        circle(d=pattern_hole,$fn=pattern_fn);

        for(x=[pattern_gap/2:pattern_gap:pattern_max])
        for(y=[pattern_gap/2:pattern_gap:pattern_max])
        translate([x,y])
        circle(d=pattern_hole,$fn=pattern_fn);
    }
}
    
translate([0,0,wheel_height])
assembled_frame();
