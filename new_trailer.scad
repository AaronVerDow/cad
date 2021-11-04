in=25.4;
ft=12*in;
frame_x=1015;
frame_y=923;
frame_beam=866;  // top beam
point=1761; //back of trailer to point
frame_bow=point-frame_beam;
bow_angle=atan(frame_bow/(frame_x/2));
bow_beam=(frame_x/2)/cos(bow_angle);
$fn=90;

tip_beam=1489;

use <joints.scad>;

function segment_radius(height, chord) = (height/2)+(chord*chord)/(8*height);

fender_x=185; 
fender_h=108; // height from top surface of frame
fender_y=500; // lenght of fender across top surface of frame
fender_d=segment_radius(fender_h,fender_y)*2;

axle=frame_beam/2; // confirmed with measurements

box_x=frame_x+1.5*in;
box_y=1650;
echo(box_y=box_y);
box_h=450;

base_wood=0.75*in;
side_wood=0.5*in;

cross_frame_width=40;
side_frame_width=36;
tip_frame_width=43;
frame_width=side_frame_width;
frame_height=86;
frame_gauge=3;

tie_down_gap=36;
tie_down_bolt=0.26*in;

// https://mechanicalelements.com/trailer-axle-position/
// weight in lbs

total_weight=600;
target_tongue_load=0.15;

wheel=510;
wheel_w=120;
frame_surface=490; // distance from ground to surface of frame bed
wheel_h=frame_surface-frame_height/2-wheel/2;

FA=(1-target_tongue_load)*total_weight;
L6=11*ft;
WF=197; // website
L4=8.5*ft; // guess
WD=total_weight-WF; // max load

L5=(FA*L6-WF*L4)/WD;

box_center=L6+axle-L5;

pad=0.1;

tongue_width=50;
tongue_height=77;
tongue_depth=2430;



module ground() {
    translate([0,0,-frame_surface-1])
    color("green")
    cylinder(r=tongue_depth*1.5,h=1);
}

bike_gap=10*in;

kayak_x=31*in;
kayak_y=10*ft;
kayak_z=12*in;
//translate([-kayak_x/2,-kayak_y/2]) #cube([kayak_x,kayak_y,kayak_z]);

spike_x=4*in;
spike_gap=in/8;
spike_slot_x=spike_x+spike_gap*2;
spike_y=in*0.75;
spike_z=frame_height+base_wood;
spike_square=base_wood;
spike_round=spike_x*0.2;
spike_tip=spike_x*0.6;

end_spike_gap=box_x/2;

axle_w=37;

tie_plate_x=100;
tie_plate_y=50;

pintail_gap=in/16;
pintail_ear=in/4;
end_pins=4;
//side_pins=6;
box_pins=3;

base_x=48*in;
base_pin_extra=(48*in-box_x)/2;
base_y=box_y+base_pin_extra*2;

echo(base_y=base_y);
echo(base_x=base_x);

overhang=base_y/2-box_center;
echo(overhang=overhang);

//top=frame_x-frame_width*3;
//top=box_h;
top=base_y/3;
top_cutout=box_x-(base_x-box_x);

top_spike=100;
top_spike_h=2*in;

top_spike_side_gap=base_y/8;
top_spike_end_gap=base_x/2;

max_wood=0.78*in;

side_pin_extra=in/2;
side_h=box_h;
side_x=box_y+side_pin_extra*2;
box_edge=box_h;

pattern_wall=2*in;


//side_spike_back=(box_y/2-box_center+axle-fender_y/2)/2+20;
side_spike_axle_offset=335;
side_spike_axle=side_x/2-box_center+axle;

side_spikes=[side_spike_axle+side_spike_axle_offset, side_spike_axle-side_spike_axle_offset, side_x/6*5];

side_spike_from_end=axle-side_spike_axle_offset;
echo(side_spike_from_end=side_spike_from_end);

end_x=box_x+side_pin_extra*2;

strap=2.2*in;
strap_inset=side_pin_extra+0;
strap_thick=in/16;
top_strap=box_edge/7*4;
bottom_strap=box_edge/7*2;

spike_hole=in/2;

pattern_hole=2*in;
pattern_gap=4.25*in;
pattern_fn=45;

lock_x=2.5*in;
lock_y=0.5*in;

plywood_x=4*ft+in;
plywood_y=8*ft;
plywood_z=8*in;

plywood_side_overlap=spike_slot_x;

skirt_h=frame_height+base_wood;
skirt_wood=in/2;
side_skirt=box_y-frame_y-80;
end_skirt=box_x/2-130;

side_skirt_pins=3;
end_skirt_pins=2;

skirt_pin_edge=120;

module kayaks() {
    dirror_x()
    translate([-box_x/2,0])
    rotate([0,-55])
    translate([kayak_x/2,box_center])
    rotate([0,0,180])
    translate([0,-5*in,0])
    scale([56,39,28])
    import("KAYAK_BUENO.stl");
}

module bike() {
    height=3*in;
    translate([0,height/2,-40])
    rotate([90,0,0])
    linear_extrude(height=height)
    import("radrunner.svg");
}

module bikes() {
    translate([0,box_center,base_wood])
    rotate([0,0,90]) {

        translate([0,-bike_gap/2])
        bike();
        translate([0,bike_gap/2])
        rotate([0,0,180])
        bike();
    }
}

module dirror_y(y=0) {
    children();
    translate([0,y])
    mirror([0,1,0])
    children();
}

module dirror_x(x=0) {
    children();
    translate([x,0])
    mirror([1,0,0])
    children();
}

module frame_profile(width=side_frame_width) {
    difference() {
        square([width,frame_height],center=true);
        translate([-frame_gauge,0])
        square([width,frame_height-frame_gauge*2],center=true);
    }
}

module frame_rail(l,width=side_frame_width) {
    color("silver")
    rotate([90,0,-90])
    translate([0,0,-l/2])
    linear_extrude(height=l)
    frame_profile(width);
}

module screws() {
    outer_side_holes=669;
    inner_side_holes=498;
    side_holes_from_edge=19;
    side_holes_from_back=97;
    frame_hole=11;

    beam_holes=812;
    beam_holes_from_back=21.5;
    dirror_y(frame_beam)
    dirror_x()
    translate([beam_holes/2,beam_holes_from_back])
    circle(d=frame_hole);

    tip_bolt=1519;
    tip_bolt_d=35;
    translate([0,tip_bolt])
    circle(d=tip_bolt_d);

    translate([0,outer_side_holes/2+side_holes_from_back,0]) {
        dirror_x()
        dirror_y()
        translate([frame_x/2-side_holes_from_edge,inner_side_holes/2,0])
        circle(d=frame_hole);

        dirror_x()
        dirror_y()
        translate([frame_x/2-side_holes_from_edge,outer_side_holes/2,0])
        circle(d=frame_hole);
    }

    center_holes_from_back=25;
    center_holes=76;

    dirror_y(frame_beam)
    translate([0,center_holes_from_back]) {
        circle(d=frame_hole);
        dirror_x()
        translate([center_holes/2,0])
        circle(d=frame_hole);
    }

    
}

module mending_plate() {
    x=tie_plate_x;
    y=tie_plate_y;
    z=2;
    hole=5;
    offset=9;
    $fn=12;
    center=tie_down_gap;
    module hole() {
        cylinder(d=hole,h=z+pad*2,center=true);
    }   

    translate([0,0,-z/2])
    color("#333333")
    difference() {
        cube([x,y,z],center=true);
        dirror_x()
        dirror_y()
        translate([x/2-offset,y/2-offset])
        hole();

        dirror_x()
        translate([center/2,0])
        hole();
    }
    
}

module tie_down_holes() {
    dirror_y()
    translate([0,tie_down_gap/2,0])
    circle(d=tie_down_bolt);
}

module tie_down(angle=0) {
    color("silver") {
        // https://www.amazon.com/gp/product/B07T42GZTF/ref=ppx_yo_dt_b_asin_title_o01_s00?ie=UTF8&psc=1
        $fn=16;
        strap_d=0.78*in;
        strap_h=0.08*in;
        strap_y=2.16*in;

        ring=0.24*in;

        flat=in; //guess

        difference() {
            hull() {
                translate([0,0,ring/2])
                rotate([0,90])
                cylinder(d=ring+strap_h*2,h=strap_d,center=true);
                cube([strap_d,flat,1],center=true);
            }
            translate([0,0,-strap_y+pad])
            cylinder(d=strap_y,h=strap_y);
        }

        difference() {
            hull()
            dirror_y()
            translate([0,strap_d/2-strap_y/2])
            cylinder(d=strap_d,h=strap_h);

            dirror_y()
            translate([0,strap_d/2-strap_y/2,-pad])
            cylinder(d=tie_down_bolt,h=strap_h+pad*2);
        }

        translate([0,0,ring/2])
        rotate([angle,0]) {

            ring_w=1.5*in;
            ring_h=1.85*in;
            rotate([0,90,0])
            cylinder(d=ring,h=ring_w-ring,center=true);

            dirror_x()
            translate([ring_w/2-ring/2,0,0])
            sphere(d=ring);

            dirror_x()
            translate([ring_w/2-ring/2,0,0])
            rotate([-90,0])
            cylinder(d=ring,h=ring_h-ring_w/2);

            
            translate([0,ring_h-ring_w/2,0])
            difference() {
                rotate_extrude()
                translate([ring_w/2-ring/2,0])
                circle(d=ring);
                rotate([90,0])
                cylinder(d=ring_w*2,h=ring_w*2);
            }
        }
    }
}

module frame() {

    *color("blue")
    translate([0,0,frame_height/2])
    screws();

    dirror_y(frame_beam)
    translate([0,cross_frame_width/2])
    frame_rail(frame_x,cross_frame_width);

    dirror_x()
    translate([frame_x/2-frame_width/2,frame_y/2])
    rotate([0,0,90])
    frame_rail(frame_y);

    dirror_x()
    translate([frame_x/2,frame_y])
    rotate([0,0,90-bow_angle])
    translate([-frame_width/2,bow_beam/2])
    rotate([0,0,90])
    frame_rail(bow_beam);

    color("#333333")
    dirror_x()
    translate([frame_x/2+fender_x/2,axle,-wheel_h])
    rotate([0,90]) {
        cylinder(d=wheel,h=wheel_w,center=true);
    }

    color("silver")
    translate([0,axle,-wheel_h])
    cube([frame_x+fender_x,axle_w,axle_w],center=true);

    color("silver")
    dirror_x()
    translate([frame_x/2+fender_x/2,axle,fender_h+frame_height/2-fender_d/2])
    rotate([0,90])
    difference() {
        cylinder(d=fender_d,h=fender_x,center=true);
        cylinder(d=fender_d-frame_gauge*2,h=fender_x+pad*2,center=true);
        translate([fender_h+frame_height/2,0])
        cube([fender_d,fender_d,fender_x+pad*2],center=true);
    }
    
    color("silver")
    translate([-tongue_width/2,tip_beam,-tongue_height/2])
    cube([tongue_width,tongue_depth,tongue_height]);

    translate([0,tip_frame_width/2+tip_beam,0])
    frame_rail(300,tip_frame_width);
}

module base() {
    color("tan")
    translate([0,box_center])
    linear_extrude(height=base_wood)
    difference() {
        cutable_base();

        translate([-base_x/2,-base_y/2])
        dirror_x(base_x)
        translate([base_x/2-frame_x/2-fender_x,base_y/2-fender_y/2-box_center+axle])
        square([fender_x,fender_y]);
    }
}

*mdx_cutsheet();
cutgap=in;
module mdx_cutsheet() {
    translate([0,-base_y/2])
    cutable_base();
    gap=skirt_h+base_wood+in;
    //translate([0,gap,-end_skirt])
}

module skirt_cutsheet() {

    translate([base_x/2-side_skirt-cutgap,gap*2,0])
    mirror([1,0])
    end_skirt();

    translate([base_x/2-side_skirt,gap*2,0])
    side_skirt();

    translate([base_x/2-side_skirt-cutgap,gap,0])
    mirror([1,0])
    end_skirt();

    translate([base_x/2-side_skirt,gap,0])
    side_skirt();
}

//!cutable_base();
module cutable_base() {
    module end_spike_slot(y) {
        dirror_x(base_x)
        translate([base_x/2-end_spike_gap/2,y])
        spike_slot();
    }
    translate([-base_x/2,-base_y/2])
    difference() {
        square([base_x,base_y]);


        translate([base_x/2,base_y/2-box_center])
        screws();

        dirror_y(base_y)
        end_spike_slot(base_y/2-box_y/2+side_wood/2);

        end_spike_slot(base_y/2-box_center+frame_beam+max_wood/2);

        //end_spike_slot(base_y/2-box_center+axle+730);
        //end_spike_slot(base_y/2-box_center+axle+1040);

        edge_gap=fender_x/4*3;

        dirror_x(base_x)
        translate([base_x/2-frame_x/2-fender_x+edge_gap,base_y/2-fender_y/2-box_center+axle])
        square([fender_x-edge_gap,fender_y]);
        
        dirror_x(base_x)
        for(y=side_spikes)
        translate([base_x/2-box_x/2+side_wood/2,base_y/2-box_y/2+y-side_wood])
        rotate([0,0,90])
        spike_slot();

        dirror_x(base_x)
        translate([base_x/2+box_x/2-side_wood/2-max_wood/2,base_y/2+box_y/2-side_wood/2-max_wood/2])
        rotate([0,0,180])
        dirror_x(skirt_wood)
        //negative_tails(side_skirt,skirt_wood,side_skirt_pins,pintail_gap,0,pintail_ear);
        dirror_y(side_skirt)
        negative_tails(skirt_pin_edge,skirt_wood,1,pintail_gap,0,pintail_ear);

    
        dirror_x(base_x)
        translate([base_x/2+box_x/2-side_wood/2-max_wood/2,base_y/2+box_y/2-side_wood/2-max_wood/2-skirt_wood])
        rotate([0,0,90])
        dirror_x(skirt_wood)
        dirror_y(end_skirt)
        negative_tails(skirt_pin_edge,skirt_wood,1,pintail_gap,0,pintail_ear);

        translate([base_x/2,0])
        place_tie_downs()
        tie_down_holes();
    }
}

module strap_holes(x,wall=0) {
        *dirror_x(x)
        translate([x/3,bottom_strap,0])
        offset(wall)
        strap_hole();

        dirror_x(x)
        translate([x/3,top_strap,0])
        offset(wall)
        strap_hole();
}

module side_top_spikes(x=0) {
    translate([side_x/2+x,0])
    dirror_x()
    translate([top_spike_side_gap/2,box_h])
    top_spike();
}

module fender() {
	translate([side_x/2-box_center+axle,fender_h-fender_d/2-base_wood])
	circle(d=fender_d);
}

//!side();
module side(top_spikes=0) {

   difference() {
        union() {
            square([side_x,box_edge]);
            for(x=side_spikes)
            translate([x,0])
            spike();
            if(top_spikes) {
                side_top_spikes();
                side_top_spikes(base_y/3);
                side_top_spikes(-base_y/3);
            }
            
        }
        dirror_x(side_x)
        negative_pins(box_edge,side_wood+pad+side_pin_extra,box_pins,pintail_gap,0,pintail_ear);

        dirror_x(side_x)
        *strap(bottom_strap);

        dirror_x(side_x)
        strap(top_strap);

        side_wall=pattern_wall+side_pin_extra+side_wood;
        intersection() {
            translate([side_x/2,box_h/2])
            pattern();
            difference() {
                translate([side_wall,pattern_wall])
                square([side_x-side_wall*2,box_h-pattern_wall*2]);

                strap_holes(side_x,pattern_wall);
                offset(pattern_wall)
                fender();
            }
        }

        fender();


        //translate([base_pin_extra/2,0])
        strap_holes(side_x);

    }
}

module strap_hole() {
    square([strap,strap],center=true);
}

module strap(z=0) {
    translate([0,z-strap/2])
    square([strap_inset,strap]);
}

module strap_preview(z=0) {
    color("yellow")
    translate([0,box_center,z+base_wood]) {
        difference() { 
            cube([box_x+strap_thick*2,box_y+strap_thick*2,strap],center=true);
            cube([box_x,box_y,strap+pad*2],center=true);
            cube([box_x+strap_thick*4,base_y/3,strap+pad*2],center=true);
            cube([end_x/3,box_y+strap_thick*4,strap+pad*2],center=true);
        }
        difference() { 
            cube([box_x-side_wood*2,box_y/3-side_wood*2,strap],center=true);
            cube([box_x-side_wood*2-strap_thick*2,box_y-side_wood*2-strap_thick*2,strap+pad*2],center=true);
        }
        difference() { 
            cube([end_x/3,box_y-side_wood*2,strap],center=true);
            cube([end_x,box_y-side_wood*2-strap_thick*2,strap+pad*2],center=true);
        }
    }
}

module top_spike() {
    translate([-top_spike/2,0])
    square([top_spike,top_spike_h]);
}

stand_spine=5*in;
stand_float=3*in; // how high off ground
stand_pivot=frame_surface*0.7; // how long the thing goes down for pivot 

stand_pivot_x=box_x/2+fender_x-base_x/2+stand_float;

stand_angle=10;


plywood_spike_x=100;
plywood_spike_tip=50;

zero=0.001;

module plywood_spike_line(x) {
	translate([x,plywood_shelf/2])
	square([plywood_spike_x,zero]);	
}

module plywood_spike_tip(x) {
	translate([x,plywood_shelf+plywood_z])
	square([plywood_spike_tip,zero]);	
}

//!plywood_end();
// RENDER svg
module plywood_end() {
	module slot() {
		dirror_x()
		translate([-max_wood/2,-pad])
		negative_slot(plywood_shelf/2+pad,max_wood,pintail_ear);
	}
	difference() {
		translate([end_x/2-plywood_x/2,0])
		dirror_x(plywood_x) {
			hull() {
				translate([0,plywood_shelf-spike_tip])
				square([plywood_x,spike_tip]);
				translate([plywood_x/2-base_x/2,0])
				square([base_x,plywood_shelf]);
				plywood_spike_line(plywood_x);
			}
			hull() {
				plywood_spike_line(plywood_x);
				plywood_spike_tip(plywood_x);
			}
		}
		dirror_x(end_x)
		translate([end_x/2-box_x/2+side_wood/2,0])
		slot();
	}

    translate([end_x/2,0])
    dirror_x()
    translate([end_spike_gap/2,0])
    spike();
 
}

module place_side() {

	dirror_x()
	translate([box_x/2-side_wood,0,base_wood])
    rotate([90,0,90])
    //translate([-end_x/2,0])
    linear_extrude(height=side_wood)
    children();
}

//!plywood_side_front();
// RENDER svg
module plywood_side_front() {
	difference() {
		plywood_side();
		translate([axle+side_spike_axle_offset-plywood_side_overlap/2,plywood_shelf*2])
		rotate([0,0,180])
		square([4000,1000]);
	}
}

//!plywood_side_back();
// RENDER svg
module plywood_side_back() {
	difference() {
		plywood_side();
		translate([axle+side_spike_axle_offset+plywood_side_overlap/2,-plywood_shelf])
		square([4000,1000]);
	}
}


module plywood_side_front() {
	difference() {
		plywood_side();
		translate([axle+side_spike_axle_offset-plywood_side_overlap/2,plywood_shelf*2])
		rotate([0,0,180])
		square([4000,1000]);
	}
}




//!plywood_side();
// RENDER svg
module plywood_side() {
	module slot(x=0) {
		translate([x,0])
		dirror_x()
		translate([max_wood/2,plywood_shelf+pad])
		rotate([0,0,180])
		negative_slot(plywood_shelf/2+pad,max_wood,pintail_ear);
	}
	difference() {
		translate([box_center-plywood_y/2,0]){
			hull() {
				translate([0,plywood_shelf-spike_tip])
				square([plywood_y,spike_tip]);
				translate([plywood_y/2-base_y/2,0])
				square([base_y,plywood_shelf]);
				plywood_spike_line(plywood_y);
			}
			hull() {
				plywood_spike_line(plywood_y);
				plywood_spike_tip(plywood_y);
			}
		}
        //dirror_y(base_y)
        //end_spike_slot(base_y/2-box_y/2+side_wood/2);
        //end_spike_slot(base_y/2-box_center+frame_beam+max_wood/2);
		slot(box_center-box_y/2+side_wood/2);
		slot(box_center+box_y/2-side_wood/2);
		slot(frame_beam+max_wood/2);

		//fender();

		//translate([side_x/2-box_center+axle,fender_h-fender_d/2-base_wood])
		translate([axle,fender_h-fender_d/2-base_wood])
		circle(d=fender_d);
	}
	// holy fuck I need a better system for this
	// look at placment within base
	translate([-overhang+(base_y/2-box_y/2-side_wood),0])
            for(x=side_spikes)
            translate([x,0])
            spike();


}

module plywood() {
	color("blue")
    triple_end()
    plywood_end();

	color("lime")
	place_side()
	plywood_side_front();

	color("red")
	place_side()
	plywood_side_back();
}

//!stand();
module stand() {
    rotate([0,0,stand_angle])
    difference() {
        union() {
            translate([end_x/2-box_x/2,0])
            square([box_x+fender_x+stand_float,stand_spine]);
            translate([end_x/2+base_x/2,-stand_pivot])
            square([stand_pivot_x,stand_pivot]);

            translate([end_x/2,0])
            dirror_x()
            translate([end_spike_gap/2,0])
            spike();
        }
    }
 
}

module stands() {
    place_end()
    stand();
}

//!end();
module end(top_spikes=0) {
    difference() {
        union() {
            square([end_x,box_edge]);

            translate([end_x/2,0])
            dirror_x()
            translate([end_spike_gap/2,0])
            spike();

            if(top_spikes)
            translate([end_x/2-top_spike_end_gap/2,box_h])
            dirror_x(top_spike_end_gap)
            top_spike();
        }

        dirror_x(end_x)
        negative_tails(box_edge,side_wood+pad+side_pin_extra,box_pins,pintail_gap,0,pintail_ear);
        
        dirror_x(end_x)
        *strap(bottom_strap);

        dirror_x(end_x)
        strap(top_strap);
    
        strap_holes(end_x);

        side_wall=pattern_wall+side_pin_extra+side_wood;
        intersection() {
            translate([end_x/2,box_h/2])
            pattern();
            difference() {
                translate([side_wall,pattern_wall])
                square([end_x-side_wall*2,box_h-pattern_wall*2]);
                strap_holes(end_x,pattern_wall);
            }
        }
    }
}



module place_end() {
    color("chocolate")
    translate([0,box_center+box_y/2,base_wood])
    dirror_y(-box_y)
    rotate([90,0])
    translate([-end_x/2,0])
    linear_extrude(height=side_wood)
    children();
}

module triple_end() {
	// same as place end but with middle included

	// fix this mess later
	place_end()
	children();

	//translate([0,box_center+box_y/2,base_wood])
	translate([0,frame_beam+side_wood/2+max_wood/2,base_wood])
	rotate([90,0])
	translate([-end_x/2,0])
	linear_extrude(height=side_wood)
	children();
        //end_spike_slot(base_y/2-box_center+frame_beam+max_wood/2);

}

module box() {
    *strap_preview(bottom_strap);
    strap_preview(top_strap);

    color("sienna")
    dirror_x()
    translate([-box_x/2,box_center,base_wood])
    rotate([90,0,90])
    translate([-side_x/2,0])
    linear_extrude(height=side_wood)
    side();

    place_end()
    end();
} 

module double_box() {
    strap_preview(bottom_strap);
    strap_preview(top_strap);
    color("sienna")
    dirror_x()
    translate([-box_x/2,box_center,base_wood])
    rotate([90,0,90])
    translate([-side_x/2,0])
    linear_extrude(height=side_wood)
    side();

    color("chocolate")
    translate([0,box_center+box_y/2,base_wood])
    dirror_y(-box_y)
    rotate([90,0])
    translate([-end_x/2,0])
    linear_extrude(height=side_wood)
    end();
} 

module spike() {
    extra=5*in;
    mirror([0,1])
    difference() {
        offset(spike_round)
        offset(-spike_round)
        hull() {
            translate([-spike_x/2,-extra])
            square([spike_x,spike_square+extra]);
            translate([-spike_tip/2,0])
            square([spike_tip,spike_z]);
        }
        translate([-spike_x,-extra*2])
        square([spike_x*2,extra*2]);
        translate([0,spike_z/2+base_wood/2])
        circle(d=spike_hole);
    }
}

module pattern() {
    pattern_max=box_x+box_y;
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

module lock() {
    square([lock_x,lock_y],center=true);
}

module plywood_stack() {
    translate([-plywood_x/2,box_center-plywood_y/2])
    cube([plywood_x,plywood_y,plywood_z]);
}

module side_skirt() {
    difference() {
        square([side_skirt,skirt_h]);
        translate([0,base_wood])
        negative_pins(skirt_h-base_wood,skirt_wood,1,pintail_gap,0,pintail_ear);

        mirror([0,1])
        rotate([0,0,-90])
        translate([-pad,0])
        dirror_y(side_skirt)
        negative_pins(skirt_pin_edge,base_wood+pad,1,pintail_gap,0,pintail_ear);

        translate([skirt_pin_edge-pad,-pad])
        square([side_skirt-skirt_pin_edge*2+pad*2,base_wood+pad]);
    }
}

module end_skirt() {
    difference() {
        square([end_skirt,skirt_h]);
        translate([0,base_wood])
        negative_tails(skirt_h-base_wood,skirt_wood,1,pintail_gap,0,pintail_ear);

        mirror([0,1])
        rotate([0,0,-90])
        translate([-pad,0])
        dirror_y(end_skirt)
        negative_pins(skirt_pin_edge,base_wood+pad,1,pintail_gap,0,pintail_ear);

        translate([skirt_pin_edge-pad,-pad])
        square([end_skirt-skirt_pin_edge*2+pad*2,base_wood+pad]);
    }
}

module skirts() {
    color("saddlebrown")
    dirror_x()
    translate([max_wood/2+skirt_wood/2-box_x/2,box_center+box_y/2-side_wood/2-max_wood/2,base_wood])
    rotate([-90,0,-90])
    linear_extrude(height=skirt_wood)
    side_skirt();

    color("saddlebrown")
    dirror_x()
    translate([-box_x/2+skirt_wood/2+max_wood/2,box_center+box_y/2-side_wood/2-skirt_wood-max_wood/2,base_wood])
    rotate([-90,0,0])
    linear_extrude(height=skirt_wood)
    end_skirt();
}


translate([0,0,-frame_height/2])
frame();

plywood_shelf=200;

*#translate([0,0,plywood_shelf+base_wood])
plywood_stack();
*bikes();
*kayaks();
*box();
*ramp();
*ground();
*stands();
plywood();

base();
translate([0,box_center-base_y/2,base_wood])
place_tie_downs()
tie_down();

translate([0,box_center-base_y/2,0])
place_tie_downs()
rotate([0,0,90])
mending_plate();

//!side_cutsheet();
module side_cutsheet() {
    //dirror_y()
    *translate([0,80])
    difference() {
        offset(1)
        side();
        side();
    }

    translate([0,-plywood_y/4])
    *#square([plywood_y,plywood_x]);

    translate([0,-box_h*1.5,0])
    difference() {
        //offset(14)
        end();
        //end();
    }
}

module place_tie_downs() {
    dirror_y(base_y)
    dirror_x()
    translate([base_x/2-tie_plate_y/2,tie_plate_x/2+base_pin_extra+side_wood])
    children();

    dirror_x()
    translate([base_x/2-tie_plate_y/2,base_y/2+100])
    children();

    dirror_y(base_y)
    dirror_x()
    translate([base_x/2-tie_plate_x/2-base_pin_extra-side_wood,tie_plate_y/2])
    rotate([0,0,90])
    children();

}

module top_spike_slot() {
    square([top_spike,side_wood],center=true);
}


module top_3d(pos=1,stack=0) {
    translate([-base_x/2,box_center-base_y/2+base_y-base_y/3*pos,box_h+base_wood+side_wood*stack])
    linear_extrude(height=side_wood)
    top();
}

module fully_covered() {
    color("blue")
    top_3d(3);
    color("lime")
    top_3d(2);
    color("red")
    top_3d();
}

module stacked() {
    color("red")
    top_3d(1,0);
    color("lime")
    top_3d(1,1);
    color("blue")
    top_3d(1,2);
}
*stacked();
*fully_covered();

module top_spike_slots() {
        translate([base_x/2,0])
        dirror_x()
        dirror_y(top)
        translate([top_spike_end_gap/2,base_pin_extra+side_wood/2])
        top_spike_slot();

        translate([0,top/2])
        dirror_x(base_x)
        dirror_y()
        translate([base_pin_extra+side_wood/2,top_spike_side_gap/2])
        rotate([0,0,90])
        top_spike_slot();
}

module spike_slot() {
    dirror_x()
    dirror_y()
    translate([spike_slot_x/2,-max_wood/2])
    rotate([0,0,90])
    negative_slot(spike_slot_x,max_wood,pintail_ear);
}

*top_3d();
module top(cut=1) {
    difference() {
        square([base_x,top]);

        if(cut)
        translate([base_x/2,0])
        circle(d=top_cutout);

        top_spike_slots();
        intersection() {
            difference() {
                offset(-pattern_wall)
                square([base_x,top]);
                offset(pattern_wall)
                top_spike_slots();

                if(cut)
                translate([base_x/2,0])
                circle(d=top_cutout+pattern_wall*2);
            }
            pattern();
        }
    }
}

// RENDER stl
module nothing() {
    echo("nope");
}

skirts();


module ramp() {

    in=25.4;
    ft=12*in;

    width=6*in;
    length=6*ft;

    gate=frame_surface+base_wood;

    ramp_angle=asin(gate/length);

    base_wood=0.75*in;
    side_wood=base_wood;



    module dirror_x(x=0) {
        children();
        translate([x,0])
        mirror([1,0])
        children();
        
    }

    hole=1.5*in;


    bottom_extra=1.5*in;
    top_extra=0.5*in;
    side=5*in;


    side_angle=asin((side-bottom_extra-top_extra)/length);
    side_length=cos(side_angle)*length;

    display_angle=0;
    //display_angle=ramp_angle;
    //display_angle=-side_angle;

    flat=bottom_extra/tan(ramp_angle);

    translate([0,-overhang,base_wood])
    rotate([ramp_angle,0])
    translate([0,-length])
    assembled();

    // this isn't right but it's close enough
    thickest=(side-bottom_extra)/cos(ramp_angle);

    ground_wall=0*in;
    top_wall=0*in;

    joint=length-top_wall-ground_wall;

    module base_positive() {
        translate([side_wood,0])
        square([width,length]);
        translate([0,ground_wall])
        square([width+side_wood*2,joint]);
    }


    pins=10;
    pintail_gap=in/16;
    bit=in/4;
    pintail_ear=bit;

    hole_x=side/2-10;
    hole_y=310;


    module base() {
        difference() {
            base_positive();
            dirror_x(width+side_wood*2)
            translate([0,ground_wall])
            negative_pins(joint,side_wood,pins,pintail_gap,0,pintail_ear);
        }
    }

    module assembled() {
        color("lime")
        rotate([display_angle,0])
        translate([0,0,-base_wood])
        linear_extrude(height=base_wood)
        translate([-width/2-side_wood,0])
        base();

        rotate([display_angle,0])
        dirror_x()
        translate([width/2,0])
        rotate([0,90])
        linear_extrude(height=side_wood)
        side();
    }


    //side();

    tooth=0*in;

    thin=(side-bottom_extra)/cos(ramp_angle);
    module side() {
        difference() {
            hull() {
                rotate([0,0,side_angle])
                translate([-top_extra,0])
                square([side,side_length]);


                translate([0,length])
                rotate([0,0,-ramp_angle])
                translate([-thin,0])
                square([thin,flat]);
                
            }

            x=side*2;

            // gate
            translate([0,length])
            rotate([0,0,-ramp_angle])
            difference() {
                square([x,side_length]);
                translate([0,flat/2])
                square([x,tooth]);
            }

            // ground slice
            rotate([0,0,side_angle-ramp_angle])
            square([x,side_length]);

            translate([0,ground_wall])
            negative_tails(joint,side_wood,pins,pintail_gap,0,pintail_ear);

            pivot=(side-top_extra)/sin(ramp_angle);
            rotate([0,0,side_angle-ramp_angle])
            translate([0,pivot])
            rotate([0,0,90+ramp_angle/2-side_angle])
            translate([0,40])
            circle(d=hole);
        }
    }


    module bleh_side() {

        cut=cos(ramp_angle)*below;
        flat=cut/sin(ramp_angle);

        //flat=5*in;

        extra=cos(ramp_angle)*flat;


        above=1.5*in;
        below=2*in;
        side=above+base_wood+below;

        dirror_x()
        translate([-width/2,0])
        rotate([display_angle,0])
        rotate([0,-90])
        translate([-below-base_wood,0])
        linear_extrude(height=side_wood)
        side();

        module side() {
            difference() {
                square([side,length+extra]);
                translate([below+base_wood,0])
                rotate([0,0,ramp_angle])
                translate([-side,0])
                square([side,length]);

                translate([below,length])
                rotate([0,0,ramp_angle])
                translate([-side,0])
                square([side,length]);
            }
        }
    }

    module triangle() {
        lip=3*in;
        spine_angle=45;
        spine=tan(spine_angle)/(width/2);
        side_below=(width/2)/cos(spine_angle);
        side=side_below+lip;


        dirror_x()
        translate([width/2,0])
        rotate([ramp_angle,0,0])
        rotate([0,-spine_angle,0])
        translate([-side_below,0])
        linear_extrude(height=base_wood)
        square([side,length]);
    }
}
