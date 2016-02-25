//convert mm to in
in=25.4;                                //fixed

//used to pad negative shapes for cleaner drawings
pad=1.5;                                //arbitrary
padd=pad*2;                             //derived

//gap in between two routed edges
cut_edge_gap=1/16*in;                   //arbitrary
cut_edge_gapp=cut_edge_gap*2;           //derived

//gap in between a routed edge and the flat of the wood
plywood_h_gap=1/8*in;                   //arbitrary
plywood_h_gapp=plywood_h_gap*2;         //derived


back_x=8*in;        

//dimensions of the trailer base
main_x=40.375*in;                       //measured
main_y=48.125*in;                       //measured
main_z=0.75*in;
half_x=main_x/2;                        //derived
half_y=main_x/2;                        //derived
total_w=47*in;                          //arbitrary

//holes for the trailer rail bolts
//this lets the plywood sit flat
rail_hole_side=(3/4-1/16)*in;           //measured
rail_hole_end=15/16*in;                 //measured
rail_hole_center=(24+1/16)*in;          //measured
rail_bolt_d=0.75*in;                    //measured
rail_bolt_r=rail_bolt_d/2;              //derived

//holes for bolting down base plywood
base_bolt_off_center=6*in;              //measured
base_bolt_from_side=4*in;               //measured
base_bolt_d=3/8*in;                     //measured
base_bolt_r=base_bolt_d/2;              //derived
base_bolt_head_depth=0.23*in;           //measured
base_bolt_head_d=base_bolt_d+base_bolt_head_depth*2;        //measured
base_bolt_head_r=base_bolt_head_d/2;    //derived

//slots in the base
//slots are anchored by their center
slot_l=(3+5/8)*in;                      //measured
slot_w=7/8*in;                          //measured
slot_fillet=(1/8)*in;                   //arbitrary
slot_to_edge=slot_w/2+1/16*in;          //measured
side_slot_from_end=6.9375*in;           //measured
end_slot_from_side=7.1875*in;           //measured
center_slot_from_end=23.6875*in;        //measured

//front extension
front_y=12*in;                          //arbitrary
front_x=8*in;                           //arbitrary
front_opp=front_y;                      //derived
front_adj=(main_x-front_x)/2;           //derived
front_hyp=sqrt(front_opp*front_opp+front_adj*front_adj);    //derived
front_angle=atan(front_opp/front_adj);  //derived

echo ("Total length: ", (main_y+front_y+back_x)/in);
echo ("Total width: ", (main_x+wheel_x*2)/in);

//wheel well cutouts
//wheel_x is calculated due to plywood size
wheel_x=(total_w-main_x)/2;             //arbitrary
wheel_y=(15+7/8)*in;                    //measured
wheel_z=(2+5/8)*in;                     //measured
wheel_from_end=(11+15/16)*in;           //measured
//angled pieces leading up to wheel well
back_wheel_opp=wheel_x;                                                                 //derived
back_wheel_adj=wheel_from_end+back_x;                                                   //derived
back_wheel_hyp=sqrt(back_wheel_opp*back_wheel_opp+back_wheel_adj*back_wheel_adj);       //derived
back_wheel_angle=atan(back_wheel_opp/back_wheel_adj);                                   //derived
front_wheel_opp=wheel_x;                                                                //derived
front_wheel_adj=main_y-wheel_from_end-wheel_y;                                          //derived
front_wheel_hyp=sqrt(front_wheel_opp*front_wheel_opp+front_wheel_adj*front_wheel_adj);  //derived
front_wheel_angle=atan(front_wheel_opp/front_wheel_adj);                                //derived

//router bit diameter
router_d=1/8*in;                        //measured
router_r=router_d/2;                    //fixed

//holes for motorcycle chock mounts
chock_z=5/16*in;                        //measured
chock_big_d=2*in;                       //measured
chock_big_r=chock_big_d/2;              //derived
chock_bolt_d=1/4*in;                    //measured
chock_bolt_r=chock_bolt_d/2;            //derived
chock_bolt_gap=(1+5/16)*in/2;           //measured

//bike chock sizes
grom_chock_x=8*in;
grom_chock_y=7*in;
grom_l=66*in;
fifty_chock_x=(5+5/8)*in;
fifty_chock_y=7*in;
fifty_l=64*in;

//countersinks for tie downs
tie_d=0.25*in;                          //measured
tie_l=1.25*in;                          //measured
tie_w=(1+5/8)*in;                       //measured
tie_hole_d=3/8*in;                      //measured
tie_hole_r=tie_hole_d/2;                //derived
//tie down locations
tie_from_side=2.3*in;                   //arbitrary
tie_handlebars=45*in;                   //arbitrary
tie_fifty=fifty_l-48*in-back_x;         //arbitrary
tie_grom=-1.5*in;                       //arbitrary
tie_front_from_center=21*in/2;          //arbitrary
tie_front=main_y+3*in;                  //arbitrary


side_h=12*in;

tounge_bolt_gap=3.5*in;
tounge_top=main_x+back_x+front_y-2*in;
tounge_bottom=main_x+back_x+front_y-8*in;

bike_lock_w=1.5*in;
bike_lock_l=3*in;
bike_lock_gap=6*in;
bike_lock_y=main_y-4*in;
bike_lock_fillet=1/4*in;

overlap=3*in;
overlap_opp=overlap;
overlap_adj=side_h;
overlap_angle=atan(overlap_opp/overlap_adj);
overlap_h=side_h*2/3;

side_z=main_z;
end_z=side_z;
side_l=main_y+back_x-slot_to_edge+end_z/2+overlap;

//distance from bottom side of bed to center of bolt hole
spike_bolt_d=base_bolt_d;
spike_bolt_r=spike_bolt_d/2;
spike_bolt_depth=(1+3/16)*in;
spike_l=slot_l-cut_edge_gapp;
spike_point_difference=0.75*in;
spike_point_d=spike_l-spike_point_difference*2;
spike_point_r=spike_point_d/2;
spike_max_d=2*in;

spike_opp=spike_point_difference;
spike_adj=spike_bolt_depth;
spike_hyp=sqrt((spike_opp*spike_opp)+(spike_adj*spike_adj));
spike_angle=atan(spike_opp/spike_adj);
back_spike_bolt_depth=(3/16+1/8)*in;

end_w=main_x-(slot_to_edge-side_z/2)*2+overlap*2;
echo("end_w: ", end_w/in);
end_h=side_h;

pat_d=2*in;
pat_r=pat_d/2;
pat_delta=4*in;
pat_l=30;
pat_h=9;
wall=1.5*in;

strap_hole_d=0.5*in;
strap_hole_r=strap_hole_d/2;
strap_wall=3/4*in+strap_hole_r;
strap_fillet=1/8*in;

back_strap_hole_count=7;
back_strap_gap=main_x/back_strap_hole_count;




module rail_bolt(x,y) {
    translate([x,y,-pad])
    cylinder(r=rail_bolt_r,h=main_z+padd);
}

module bolt(x,y) {
    translate([x,y,-pad])
    cylinder(r=base_bolt_r,h=main_z+padd);
    translate([x,y,main_z-base_bolt_head_depth])
    cylinder(r1=base_bolt_r,r2=base_bolt_head_r+pad,h=base_bolt_head_depth+pad);
}

module corner(x,y){
    translate([x,y,-pad])
    cylinder(r=router_r,h=main_z+padd);
}

module slot(x,y) {
    translate([-slot_w/2+x,-slot_l/2+y,0]) {
        translate([0,0,-pad])
        cube([slot_w,slot_l,main_z+padd]);
        translate([0,0,main_z-slot_fillet])
        minkowski() {
            cylinder(r1=0,r2=main_z,h=main_z);
            cube([slot_w,slot_l,main_z]);
        }
        corner(0,0);
        corner(slot_w,0);
        corner(0,slot_l);
        corner(slot_w,slot_l);
    }
}

module rotated_slot(x,y) {
    rotate([0,0,90])
    slot(y,-x);
}

module wheel_well(x){
    translate([x,wheel_from_end,-pad])
    cube([wheel_x,wheel_y,wheel_z]);
}

module wheel_wells(){
    wheel_well(main_x);
    wheel_well(-wheel_x);
}

module tie_down(x,y){
    translate([-tie_w/2+x,-tie_l/2+y,0]) {
        hull() {
            translate([tie_w/2,0,main_z-tie_d])
            cylinder(r1=tie_w/2,r2=tie_w/2+tie_hole_d+pad,h=tie_d+pad);
            translate([tie_w/2,tie_l,main_z-tie_d])
            cylinder(r1=tie_w/2,r2=tie_w/2+tie_hole_d+pad,h=tie_d+pad);
        }
        translate([tie_w/2,0,-pad])
        cylinder(r=tie_hole_r,h=main_z+padd);
        translate([tie_w/2,tie_l,-pad])
        cylinder(r=tie_hole_r,h=main_z+padd);
    }
}

module chock_hole(x,y){
    translate([x,y,main_z-chock_z])
    cylinder(r=chock_big_r,h=chock_z+pad);

    translate([x-chock_bolt_gap,y,-pad])
    cylinder(r=chock_bolt_r,h=main_z+padd);
    translate([x+chock_bolt_gap,y,-pad])
    cylinder(r=chock_bolt_r,h=main_z+padd);
    translate([x,y,-pad])
    cylinder(r=chock_bolt_r,h=main_z+padd);
    
}

module chock(x,y,l) {
    translate([half_x,-back_x+l,0]) {
        chock_hole(-x/2,0);
        chock_hole(x/2,0);
        chock_hole(-x/2,-y);
        chock_hole(x/2,-y);
    }
}

module grom_chock() {
    chock(grom_chock_x,grom_chock_y,grom_l);
}

module fifty_chock() {
    chock(fifty_chock_x,fifty_chock_y,fifty_l);
}

module tounge_bolts(y) {
    bolt(half_x-tounge_bolt_gap/2,y);
    bolt(half_x+tounge_bolt_gap/2,y);
}

module bike_lock_hole() {
    hull() {
        translate([half_x,(bike_lock_l-bike_lock_w)/2,-pad])
        cylinder(r=bike_lock_w/2,h=main_z+padd);
        translate([half_x,-(bike_lock_l-bike_lock_w)/2,-pad])
        cylinder(r=bike_lock_w/2,h=main_z+padd);
    }
}
module bike_lock(x,y) {
    translate([x,y,0]) {
        bike_lock_hole();
        translate([0,0,main_z+padd-bike_lock_fillet])
        minkowski() {
            bike_lock_hole();
            cylinder(r1=0,r2=main_z+padd,h=main_z+padd);
        }
    }
}

module bike_locks(y) {
    bike_lock(-bike_lock_gap/2,y);
    bike_lock(bike_lock_gap/2,y);
}

module spike(y) {
    translate([0,y,-main_z])
    difference() {
        union() {
            translate([0,-spike_l/2,0])
            cube([side_z,spike_l,main_z]);


            minkowski() {
                intersection() {
                    translate([0,spike_point_r-spike_l/2,0])
                    rotate([spike_angle,0,0])
                    translate([0,0,-spike_hyp])
                    cube([side_z/2,spike_l,spike_hyp]);
                    
                    translate([0,-spike_point_r+spike_l/2,0])
                    rotate([-spike_angle,0,0])
                    translate([0,-spike_l,-spike_hyp])
                    cube([side_z/2,spike_l,spike_hyp]);
                }
                rotate([0,90,0])
                cylinder(r=spike_point_r,h=side_z/2);
            }
        }
        translate([-pad,0,-spike_bolt_depth])
        rotate([0,90,0])
        cylinder(r=spike_bolt_r,h=side_z+padd);
        translate([-pad,0,-back_spike_bolt_depth])
        rotate([0,90,0])
        cylinder(r=spike_bolt_r,h=side_z+padd);
        translate([-pad,-slot_l/2,-spike_point_d-spike_max_d])
        cube([side_z+padd,slot_l,spike_point_d]);
    }
}

module rotated_spike(y) {
    rotate([0,0,90])
    spike(-y);
}

module end_cuts() {
    translate([-pad,main_y+back_x-plywood_h_gap-end_z/2-slot_to_edge,overlap_h-cut_edge_gap])
    cube([side_z+padd,end_z+plywood_h_gap*2,side_h-overlap_h+cut_edge_gap+pad]);
    translate([-pad,back_x+slot_to_edge-end_z/2-plywood_h_gap,overlap_h-cut_edge_gap])
    cube([side_z+padd,end_z+plywood_h_gap*2,side_h-overlap_h+cut_edge_gap+pad]);
    translate([-pad,back_x+center_slot_from_end-end_z/2-plywood_h_gap,overlap_h-cut_edge_gap])
    cube([side_z+padd,end_z+plywood_h_gap*2,side_h-overlap_h+cut_edge_gap+pad]);
    translate([-pad,overlap-plywood_h_gap,overlap_h-cut_edge_gap])
    cube([side_z+padd,end_z+plywood_h_gap*2,side_h-overlap_h+cut_edge_gap+pad]);
}

module pattern() {
    translate([0,pat_delta/2,pat_delta/2])
    for(pat_x=[0:pat_delta:side_h]){
        for(pat_y=[0:pat_delta:main_y+back_x]){
            translate([-pad,pat_y,pat_x])
            rotate([0,90,0])
            cylinder(r=pat_r,h=side_z+padd);
        }
    }
    for(pat_x=[0:pat_delta:side_h]){
        for(pat_y=[0:pat_delta:main_y+back_x]){
            translate([-pad,pat_y,pat_x])
            rotate([0,90,0])
            cylinder(r=pat_r,h=side_z+padd);
        }
    }
}

module side_pattern() {
    difference() {
        intersection() {
            pattern();
            translate([-pad,wall,wall])
            cube([side_z+padd,side_l-wall*2-overlap,side_h-wall*2]);
        }
        minkowski() {
            end_cuts();
            rotate([0,90,0])
            cylinder(r=wall,h=side_z);
        }
    }
}

module side(where){
    translate([where-side_z/2,0,main_z]) {
        translate([0,-back_x,0])
        difference() {
            cube([side_z,side_l,side_h]);
            translate([-pad,side_l-overlap,0])
            rotate([-overlap_angle,0,0])
            cube([side_z+padd,overlap*2,side_h*2]);
            end_cuts();
            side_pattern();
        }
        spike(side_slot_from_end);
        spike(main_y-side_slot_from_end);
    }
}

module end_pattern() {
    intersection() {
        translate([overlap+wall,-pad,wall])
        cube([end_w-overlap*2-wall*2,end_z+padd,end_h-wall*2]);
        translate([overlap,end_z,0])
        rotate([0,0,-90])
        pattern();
    }
}

module end(y) {
    translate([slot_to_edge-side_z/2-overlap,y-end_z/2,main_z]) {
        difference() {
            cube([end_w,end_z,end_h]);
            translate([overlap,-pad,0])
            rotate([0,-overlap_angle,0])
            translate([-overlap*2,0,0])
            cube([overlap*2,end_z+padd,end_h*2]);
            translate([end_w-overlap,-pad,0])
            rotate([0,overlap_angle,0])
            cube([overlap*2,end_z+padd,end_h*2]);
            translate([overlap+slot_to_edge-side_z/2-plywood_h_gap*2,-pad,0])
            cube([side_z+plywood_h_gap*2,end_z+padd,overlap_h+cut_edge_gap]);

            translate([slot_to_edge,-pad,0])
            cube([overlap,end_z+padd,wheel_z]);
            translate([main_x-slot_to_edge+overlap,-pad,0])
            cube([overlap,end_z+padd,wheel_z]);

            //cut end for wheel well clearance
            translate([overlap+main_x-side_z/2-plywood_h_gap*2-slot_to_edge,-pad,0])
            cube([side_z+plywood_h_gapp,end_z+padd,overlap_h+cut_edge_gap]);
            end_pattern();
        }
        rotated_spike(end_slot_from_side+overlap-slot_to_edge+side_z/2);
        rotated_spike(main_x-end_slot_from_side+overlap-slot_to_edge+side_z/2);
    }
}

module strap_hole(x,y) {
    translate([x,y,-pad])
    cylinder(r=strap_hole_r,h=main_z+padd);
    translate([x,y,main_z-strap_fillet])
    cylinder(r1=strap_hole_r,r2=strap_hole_r+strap_fillet+pad,h=strap_fillet+pad);
}

module back_strap_holes() {
    translate([-back_strap_gap/2,0,0])
    for(x=[back_strap_gap:back_strap_gap:back_strap_gap*back_strap_hole_count]) {
        strap_hole(x,-back_x+strap_wall);
    }
}

module base() {
    difference(){
        union() {
            cube([main_x,main_y,main_z]);
            translate([0,main_y,0]) {
                translate([half_x-front_x/2,0,0])
                cube([front_x,front_y,main_z]);

                rotate([0,0,front_angle])
                translate([0,-front_hyp,0])
                difference() {
                    cube([front_hyp,front_hyp,main_z]);
                    strap_hole(back_strap_gap/2,front_hyp-strap_wall);
                    strap_hole(back_strap_gap/2+back_strap_gap,front_hyp-strap_wall);
                    strap_hole(back_strap_gap/2+back_strap_gap*2,front_hyp-strap_wall);
                }

                translate([main_x,0,0])
                rotate([0,0,-front_angle])
                translate([-front_hyp,-front_hyp,0])
                difference() {
                    cube([front_hyp,front_hyp,main_z]);
                    strap_hole(front_hyp-back_strap_gap/2,front_hyp-strap_wall);
                    strap_hole(front_hyp-back_strap_gap/2-back_strap_gap,front_hyp-strap_wall);
                    strap_hole(front_hyp-back_strap_gap/2-back_strap_gap*2,front_hyp-strap_wall);
                }
            }
            //back_xeft_angle
            translate([0,-back_x,0])
            rotate([0,0,back_wheel_angle])
            difference() {
                cube([back_wheel_hyp,back_wheel_hyp,main_z]);
                strap_hole(strap_wall,back_wheel_hyp-back_strap_gap/2);
                strap_hole(strap_wall,back_wheel_hyp-back_strap_gap/2-back_strap_gap);
            }

            //back_right_angle
            translate([main_x,-back_x,0])
            rotate([0,0,-back_wheel_angle])
            translate([-back_wheel_hyp,0,0])
            difference() {
                cube([back_wheel_hyp,back_wheel_hyp,main_z]);
                strap_hole(back_wheel_hyp-strap_wall,back_wheel_hyp-back_strap_gap/2);
                strap_hole(back_wheel_hyp-strap_wall,back_wheel_hyp-back_strap_gap/2-back_strap_gap);
            }

            //front left
            translate([0,main_y,0])
            rotate([0,0,-front_wheel_angle])
            translate([0,-front_wheel_hyp,0])
            difference() {
                cube([back_wheel_hyp,back_wheel_hyp,main_z]);
                strap_hole(strap_wall,back_strap_gap/2);
                strap_hole(strap_wall,back_strap_gap/2+back_strap_gap);
            }

            //front right
            translate([main_x,main_y,])
            rotate([0,0,front_wheel_angle])
            translate([-front_wheel_hyp,-front_wheel_hyp,0])
            difference() {
                cube([back_wheel_hyp,back_wheel_hyp,main_z]);
                strap_hole(back_wheel_hyp-strap_wall,back_strap_gap/2);
                strap_hole(back_wheel_hyp-strap_wall,back_strap_gap/2+back_strap_gap);
            }

            //back_extension
            translate([0,-back_x,0])
            cube([main_x,back_x,main_z]);
        }
        rail_bolt(rail_hole_side,rail_hole_end);
        rail_bolt(main_x-rail_hole_side,rail_hole_end);
        rail_bolt(rail_hole_side,main_y-rail_hole_end);
        rail_bolt(main_x-rail_hole_side,main_y-rail_hole_end);
        rail_bolt(rail_hole_side,rail_hole_center);
        rail_bolt(main_x-rail_hole_side,rail_hole_center);

        bolt(half_x,rail_hole_end);
        bolt(half_x,main_y-rail_hole_end);
        bolt(half_x,rail_hole_center);

        bolt(half_x+base_bolt_off_center,rail_hole_end);
        bolt(half_x+base_bolt_off_center,main_y-rail_hole_end);
        bolt(half_x+base_bolt_off_center,rail_hole_center);

        bolt(half_x-base_bolt_off_center,rail_hole_end);
        bolt(half_x-base_bolt_off_center,main_y-rail_hole_end);
        bolt(half_x-base_bolt_off_center,rail_hole_center);

        bolt(main_x-base_bolt_from_side,rail_hole_end);
        bolt(main_x-base_bolt_from_side,main_y-rail_hole_end);
        bolt(main_x-base_bolt_from_side,rail_hole_center);

        bolt(base_bolt_from_side,rail_hole_end);
        bolt(base_bolt_from_side,main_y-rail_hole_end);
        bolt(base_bolt_from_side,rail_hole_center);

        slot(slot_to_edge,main_y-side_slot_from_end);
        slot(main_x-slot_to_edge,main_y-side_slot_from_end);
        slot(slot_to_edge,side_slot_from_end);
        slot(main_x-slot_to_edge,side_slot_from_end);

        rotated_slot(end_slot_from_side,slot_to_edge);
        rotated_slot(main_x-end_slot_from_side,slot_to_edge);

        rotated_slot(end_slot_from_side,main_y-slot_to_edge);
        rotated_slot(main_x-end_slot_from_side,main_y-slot_to_edge);

        rotated_slot(end_slot_from_side,center_slot_from_end);
        rotated_slot(main_x-end_slot_from_side,center_slot_from_end);

        rotated_slot(end_slot_from_side,-back_x+overlap+slot_w/2-(slot_w/2-end_z/2));
        rotated_slot(main_x-end_slot_from_side,-back_x+overlap+slot_w/2-(slot_w/2-end_z/2));

        wheel_wells();

        tie_down(tie_from_side,tie_handlebars);
        tie_down(main_x-tie_from_side,tie_handlebars);
        tie_down(tie_from_side,tie_grom);
        tie_down(main_x-tie_from_side,tie_grom);
        tie_down(tie_from_side,tie_fifty);
        tie_down(main_x-tie_from_side,tie_fifty);
        tie_down(half_x-tie_front_from_center,tie_front);
        tie_down(half_x+tie_front_from_center,tie_front);

        grom_chock();
        fifty_chock();
        bike_locks(bike_lock_y);
        back_strap_holes();

        tounge_bolts(tounge_top);
        tounge_bolts(tounge_bottom);
    }
}

color("cyan") side(slot_to_edge);
color("cyan") side(main_x-slot_to_edge);
color("lime") end(main_y-slot_to_edge);
//color("lime") end(slot_to_edge);
//color("lime") end(center_slot_from_end);
color("lime") end(-back_x+overlap+end_z/2);
base();
