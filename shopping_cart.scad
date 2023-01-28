in=25.4;
$fn=90;

inset=150;

total_depth=22*in;
back_wheels=0;

wheelbase=total_depth+back_wheels;

basket_height=150;

shelves=3;

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
front_wheel_plate_x=2.87*in;
front_wheel_plate_y=3.35*in;


base_fillet=80;
base_back_wall=5; // guess

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

echo(shelf_gap=(shelf_gap-wood)/in);

handle_y=80;
handle=1.5*in;
handle_d=handle*1.5;
handle_z=-handle_d/2;


back_angle=atan(inset/total_height);
back_height=total_height/cos(back_angle);


walking_gap=total_width-back_wheel_plate_x+wood-wheel_wall*2;
echo(walking_gap=walking_gap/in);


module wheel() {
    color("gray")
    translate([0,0,wheel/2])
    rotate([0,90,0])
    cylinder(d=wheel,h=wheel_thick,$fn=90,center=true);
}

dirror_x(total_width)
translate([0,-back_wheels])
wheel();

dirror_x(total_width)
translate([wheel_wall+front_wheel_plate_x/2,total_depth-wheel_wall-front_wheel_plate_y,0])
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

zero=0.00001;
wheel_support_r=wheel_wall;
wheel_support=back_wheel_plate_x/2+wheel_support_r+wood;

curve=800;

module side() {
    difference() {
        side_positive_2(); 
        intersection() {
            translate([total_depth/2,total_height-basket_height/2-wood/4])
            pattern();
            difference() {
                offset(-pattern_wall)
                side_positive_2(); 
    
                // back wall
                translate([inset+wood/2,0])  // math harder
                rotate([0,0,back_angle])
                translate([-pattern_wall,0])
                square([pattern_wall*2,total_height]);

                // handle
                translate([-handle_y,total_height+handle_z]) 
                circle(d=handle+pattern_wall*2);
                
                // bottom
                translate([-total_depth,0])
                square([total_depth*2,pattern_wall+wood/2]); // getting lazy here
            }
        }
    }
}

module side_positive_2() {
    pad=20;

    hole_z=total_height-zero-basket_height;
    y=hole_z*tan(back_angle);

    guess=wood;

    az=total_height+handle_z-wood;
    ay=handle_y-wheel_wall-back_wheel_plate_y/2-back_wheels;
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
        translate([-handle_y,total_height+handle_z])
        rotate([0,0,90-final+aa])
        translate([-curve-handle_d/2,0])
        circle(r=curve);

    }
}

module side_positive() {
    offset=back_wheels+back_wheel_plate_y/2+wheel_wall;
    hull() {
        square([total_depth,total_height]);

		translate([-handle_y,handle_z+total_height])
		circle(d=handle_d);


        translate([-offset,0])
        square([total_depth+offset,zero]);

        translate([wheel_support_r-offset,wheel_support-wheel_support_r])
        circle(r=wheel_support_r);
    }
}

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
    difference() {
        translate([0,-back_wheels])
        square([total_width,total_depth+back_wheels]);
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

module base_wheels() {
    dirror_x(total_width) 
    hull() {
        translate([0,-back_wheels])
        square([wood,total_depth+back_wheels]);
        translate([wood/2,-back_wheels])
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
        square([total_width,back_height]);
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
        cube([total_width+pad*2,total_depth+pad,zero]);
        translate([-pad,inset])
        cube([total_width+pad*2,total_depth+pad-inset,zero]);
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
    translate([0,wood+inset])
    rotate([90+back_angle,0,0])
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
    translate([0,total_depth])
    rotate([90,0,0])
    wood()
    front();

    color(primary)
    dirror_x(total_width)
    rotate([90,0,90])
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
