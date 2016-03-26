drill=true;
pocket=false;
fillet=false;
3d=true;
2d=false;
patterns=true;
//convert mm to in
//in=25.4;                                //fixed
//$fn=120;
in=25.4;

//used to pad negative shapes for cleaner drawings
pad=1.5;                                //arbitrary
padd=pad*2;                             //derived

//gap in between two routed edges
cut_edge_gap=1/16*in;                   //arbitrary
cut_edge_gapp=cut_edge_gap*2;           //derived

//gap in between a routed edge and the flat of the wood
plywood_h_gap=1/8*in;                   //arbitrary
plywood_h_gapp=plywood_h_gap*2;         //derived


//distance to extend the back 
back_y=8*in;                            //arbitrary

//dimensions of the trailer base
main_x=40.375*in;                       //measured
main_y=48.125*in;                       //measured
main_z=0.5*in;
half_x=main_x/2;                        //derived
half_y=main_x/2;                        //derived
total_w=47*in;                          //arbitrary

//holes for the trailer rail bolts
//this lets the plywood sit flat
rail_hole_side=(14/16)*in;           //not tested
rail_hole_end=17/16*in;                 //measured
rail_hole_center=(24+1/16)*in;          //measured
rail_bolt_d=(1+1/8)*in;                    //measured
rail_bolt_r=rail_bolt_d/2;              //derived

//holes for bolting down base plywood
base_bolt_off_center=6*in;              //measured
base_bolt_from_side=4*in;               //measured
base_bolt_d=1/2*in;                     //measured
base_bolt_r=base_bolt_d/2;              //derived
base_bolt_head_depth=0.23*in;           //measured
base_bolt_head_d=base_bolt_d+base_bolt_head_depth*2;        //measured
base_bolt_head_r=base_bolt_head_d/2;    //derived

side_bolt_from_end=(10+7/8)*in;
side_bolt_from_side=(7/8)*in;

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

echo ("Total length: ", (main_y+front_y+back_y)/in);
echo ("Total width: ", (main_x+wheel_x*2)/in);

//wheel well cutouts
//wheel_x is calculated due to plywood size
wheel_x=(total_w-main_x)/2;             //arbitrary
wheel_y=(15+7/8)*in;                    //measured
wheel_z=(2+5/8)*in;                     //measured
wheel_from_end=(11+15/16)*in;           //measured
//angled pieces leading up to wheel well
back_wheel_opp=wheel_x;                                                                 //derived
back_wheel_adj=wheel_from_end+back_y;                                                   //derived
back_wheel_hyp=sqrt(back_wheel_opp*back_wheel_opp+back_wheel_adj*back_wheel_adj);       //derived
back_wheel_angle=atan(back_wheel_opp/back_wheel_adj);                                   //derived
front_wheel_opp=wheel_x;                                                                //derived
front_wheel_adj=main_y-wheel_from_end-wheel_y;                                          //derived
front_wheel_hyp=sqrt(front_wheel_opp*front_wheel_opp+front_wheel_adj*front_wheel_adj);  //derived
front_wheel_angle=atan(front_wheel_opp/front_wheel_adj);                                //derived

//router bit diameter
router_d=1/4*in;                        //measured
router_r=router_d/2;                    //derived

//holes for motorcycle chock mounts
chock_z=5/16*in;                        //measured
chock_big_d=2*in;                       //measured
chock_big_r=chock_big_d/2;              //derived
chock_bolt_d=1/4*in;                    //measured
chock_bolt_r=chock_bolt_d/2;            //derived
chock_bolt_gap=(1+5/16)*in/2;           //measured

//bike chock sizes
grom_chock_x=8*in;                      //measured
grom_chock_y=7*in;                      //measured
grom_l=66*in;                           //measured
fifty_chock_x=(5.5)*in;               //measured
fifty_chock_y=7*in;                     //measured
fifty_l=64*in;                          //measured

//countersinks for tie downs
tie_d=0.25*in;                          //measured
tie_l=1.5*in;                          //measured
tie_w=(1+7/8)*in;                       //measured
tie_hole_d=3/8*in;                      //measured
tie_hole_r=tie_hole_d/2;                //derived
//tie down locations
tie_from_side=2.3*in;                   //arbitrary
tie_handlebars=45*in;                   //arbitrary
tie_fifty=fifty_l-48*in-back_y;         //arbitrary
tie_grom=-1.5*in;                       //arbitrary
tie_front_from_center=21*in/2;          //arbitrary
tie_front=main_y+3*in;                  //arbitrary

//bolt holes for securing front to trailer tongue
front_bolt_from_center=3.5*in/2;        //arbitrary
front_bolt_front=main_y+front_y-2*in;   //arbitrary
front_bolt_back=main_y+front_y-8*in;    //arbitrary

//holes to run a bike lock or chain through
bike_lock_w=1.5*in;                     //arbitrary
bike_lock_l=3*in;                       //arbitrary
bike_lock_from_center=6*in/2;           //arbitrary
bike_lock_y=main_y-6*in;                //arbitrary
bike_lock_fillet=1/4*in;                //arbitrary

//trailer sides (applies to end and side)
sides_height=18*in;                     //arbitrary
sides_thick=main_z;                     //arbitrary
//locking pieces between sides
lock=3*in;                              //arbitrary
lock_opp=lock;                          //derived
lock_adj=sides_height;                  //derived
lock_angle=atan(lock_opp/lock_adj);     //derived
//defines how much of the lock stays on side
lock_h=sides_height*2/3;                //arbitrary

side_l=main_y+back_y-slot_to_edge+sides_thick/2+lock;

//spikes at that lock sides to trailer
spike_gap=3/16*in;
spike_bolt_d=base_bolt_d;               //measured
spike_bolt_r=spike_bolt_d/2;            //derived
spike_l=slot_l-cut_edge_gapp-spike_gap*2;           //derived
//how tapered is the spike
spike_point_difference=0.5*in;         //arbitrary
spike_point_d=spike_l-spike_point_difference*2;  //derived
spike_point_r=spike_point_d/2;          //derived
spike_max_depth=2*in;                   //measured


spike_bolt_from_base=(1+3/16)*in;       //measured
spike_opp=spike_point_difference;                               //derived
spike_adj=spike_bolt_from_base;                                 //derived
spike_hyp=sqrt((spike_opp*spike_opp)+(spike_adj*spike_adj));    //derived
spike_angle=atan(spike_opp/spike_adj);                          //derived

end_spike_bolt_from_base=1.5*in;       //measured
end_spike_opp=spike_point_difference;                               //derived
end_spike_adj=end_spike_bolt_from_base;                                 //derived
end_spike_hyp=sqrt((end_spike_opp*end_spike_opp)+(end_spike_adj*end_spike_adj));    //derived
end_spike_angle=atan(end_spike_opp/end_spike_adj);                          //derived
//special holes for ends not on a rail
back_spike_bolt_from_base=1/2*in;                        

end_w=main_x-(slot_to_edge-sides_thick/2)*2+lock*2;
echo("end_w: ", end_w/in);
end_height=sides_height;

//pattern across the sides
pat_d=2*in;
pat_r=pat_d/2;
pat_delta=4*in;
pat_l=30;
pat_h=9;
wall=1.5*in;

//holes along the edges for straps
strap_hole_d=(5/8)*in;
strap_hole_r=strap_hole_d/2;
strap_wall=3/4*in+strap_hole_r;
strap_fillet=1/8*in;
back_strap_hole_count=7;
strap_gap=main_x/back_strap_hole_count;




module rail_bolt(x,y) {
    if(3d)
    translate([x,y,-pad])
    cylinder(r=rail_bolt_r,h=main_z+padd);
    if(2d)
    translate([x,y])
    circle(r=rail_bolt_r);
}

module bolt(x,y) {
    if(3d)
    translate([x,y,-pad])
    cylinder(r=base_bolt_r,h=main_z+padd);
    if(2d)
    translate([x,y])
    circle(r=base_bolt_r);
    if(fillet) {
        if(3d)
        translate([x,y,main_z-base_bolt_head_depth])
        cylinder(r1=base_bolt_r,r2=base_bolt_head_r+pad,h=base_bolt_head_depth+pad);
    }
}

module corner(x,y){
    if(drill) {
        if(3d)
        translate([x,y,-pad])
        cylinder(r=router_r,h=main_z+padd);
        if(2d)
        translate([x,y])
        circle(r=router_r);
    }
}

module slot_corners() {
    corner(router_r/2,router_r/2);
    corner(slot_w-router_r/2,router_r/2);
    corner(router_r/2,slot_l-router_r/2);
    corner(slot_w-router_r/2,slot_l-router_r/2);
}
module slot_hole() {
    if(3d)
    translate([0,0,-pad])
    cube([slot_w,slot_l,main_z+padd]);
    if(2d)
    square([slot_w,slot_l]);
    if(fillet) {
        if(3d)
        translate([0,0,main_z-slot_fillet])
        minkowski() {
            cylinder(r1=0,r2=main_z,h=main_z);
            cube([slot_w,slot_l,main_z]);
        }
        if(2d)
        minkowski() {
            circle(r=main_z);
            square([slot_w,slot_l]);
        }
    }
}
module slot(x,y) {
    translate([-slot_w/2+x,-slot_l/2+y,0]) {
        slot_hole();
        slot_corners();
    }
}

module rotated_slot(x,y) {
    rotate([0,0,90])
    slot(y,-x);
}

module wheel_well(x){
    if(3d)
    translate([x,wheel_from_end,-pad])
    cube([wheel_x,wheel_y,wheel_z]);
    if(2d)
    translate([x,wheel_from_end])
    square([wheel_x,wheel_y]);
}

module wheel_wells(){
    wheel_well(main_x);
    wheel_well(-wheel_x);
}

module tie_hole(y) {
    if(3d)
    translate([0,y,-pad])
    cylinder(r=tie_hole_r,h=main_z+padd);
    if(2d)
    translate([0,y])
    circle(r=tie_hole_r);
}

module tie_countersink(y) {
    translate([0,y,main_z-tie_d])
    if(fillet) {
        if(3d)
        cylinder(r1=tie_w/2,r2=tie_w/2+tie_hole_d+pad,h=tie_d+pad);
        if(2d)
        circle(r=tie_w/2+tie_hole_d+pad);
    } else {
        if(3d)
        cylinder(r=tie_w/2,h=tie_d+pad);
        if(2d)
        circle(r=tie_w/2);
    }
}


module tie_down(x,y){
    translate([x,-tie_l/2+y,0]) {
        if(3d) {
            hull() {
                tie_countersink(0);
                tie_countersink(tie_l);
            }
            tie_hole(0);
            tie_hole(tie_l);
        }
        if(2d) {
            difference() {
                hull() {
                    tie_countersink(0);
                    tie_countersink(tie_l);
                }
                tie_hole(0);
                tie_hole(tie_l);
            }
        }
    }
}

module chock_bolt(x) {
    if(drill) {
        if(3d)
        translate([x,0,-pad])
        cylinder(r=chock_bolt_r,h=main_z+padd);
        if(2d)
        translate([x,0])
        circle(r=chock_bolt_r);
    }
}

module chock_bolts() {
    chock_bolt(0);
    chock_bolt(chock_bolt_gap);
    chock_bolt(-chock_bolt_gap);
}

module chock_hole(x,y){
    translate([x,y,0]) {
        if(3d) {
            translate([0,0,main_z-chock_z])
            cylinder(r=chock_big_r,h=chock_z+pad);
            chock_bolts();
        }
        if(2d) {
            difference() {
                circle(r=chock_big_r);
                chock_bolts();
            }
        }
    }
}

module chock(x,y,l) {
    translate([half_x,-back_y+l,0]) {
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

module front_bolts(y) {
    bolt(half_x-front_bolt_from_center,y);
    bolt(half_x+front_bolt_from_center,y);
}

module bike_lock_hole(y) {
    if(3d)
    translate([half_x,y,-pad])
    cylinder(r=bike_lock_w/2,h=main_z+padd);
    if(2d)
    translate([half_x,y])
    circle(r=bike_lock_w/2);
}

module bike_lock_holes() {
    hull() {
        bike_lock_hole((bike_lock_l-bike_lock_w)/2);
        bike_lock_hole(-(bike_lock_l-bike_lock_w)/2);
    }
}
module bike_lock(x,y) {
    translate([x,y,0]) {
        bike_lock_holes();
        if(fillet) {
            if(3d)
            translate([0,0,main_z+padd-bike_lock_fillet])
            minkowski() {
                bike_lock_holes();
                cylinder(r1=0,r2=main_z+padd,h=main_z+padd);
            }
            if(2d)
            minkowski() {
                bike_lock_holes();
                circle(r2=main_z+padd);
            }
        }
    }
}

module bike_locks(y) {
    bike_lock(-bike_lock_from_center,y);
    bike_lock(bike_lock_from_center,y);
}

module end_spike_positive() {
    //square piece inside base
    if(3d)
    translate([-main_z,-spike_l/2,0])
    cube([main_z,spike_l,sides_thick]);
    if(2d)
    translate([-main_z,-spike_l/2])
    square([main_z,spike_l]);
    minkowski() {
        intersection() {
            translate([-main_z,spike_point_r-spike_l/2,0])
            rotate([0,0,-end_spike_angle])
            translate([-end_spike_hyp,0,0]) {
                if(3d)
                cube([end_spike_hyp,spike_l,sides_thick/2]);
                if(2d)
                square([end_spike_hyp,spike_l]);
            }
            
            translate([-main_z,-spike_point_r+spike_l/2,0])
            rotate([0,0,end_spike_angle])
            translate([-end_spike_hyp,-spike_l,0]) {
                if(3d)
                cube([end_spike_hyp,spike_l,sides_thick/2]);
                if(2d)
                square([end_spike_hyp,spike_l]);
            }
        }
        if(3d)
        cylinder(r=spike_point_r,h=sides_thick/2);
        if(2d)
        circle(r=spike_point_r);
    }
}


module spike_positive() {
    //square piece inside base
    if(3d)
    translate([-main_z,-spike_l/2,0])
    cube([main_z,spike_l,sides_thick]);
    if(2d)
    translate([-main_z,-spike_l/2])
    square([main_z,spike_l]);
    minkowski() {
        intersection() {
            translate([-main_z,spike_point_r-spike_l/2,0])
            rotate([0,0,-spike_angle])
            translate([-spike_hyp,0,0]) {
                if(3d)
                cube([spike_hyp,spike_l,sides_thick/2]);
                if(2d)
                square([spike_hyp,spike_l]);
            }
            
            translate([-main_z,-spike_point_r+spike_l/2,0])
            rotate([0,0,spike_angle])
            translate([-spike_hyp,-spike_l,0]) {
                if(3d)
                cube([spike_hyp,spike_l,sides_thick/2]);
                if(2d)
                square([spike_hyp,spike_l]);
            }
        }
        if(3d)
        cylinder(r=spike_point_r,h=sides_thick/2);
        if(2d)
        circle(r=spike_point_r);
    }
}

module spike_bolt_hole(x) {
    if(3d)
    translate([x-main_z,0,-pad])
    cylinder(r=spike_bolt_r,h=sides_thick+padd);
    if(2d)
    translate([x-main_z,0])
    circle(r=spike_bolt_r);
}

module end_spike(y) {
    translate([0,y,0])
    difference() {
        end_spike_positive();
        spike_bolt_hole(-end_spike_bolt_from_base);
        spike_bolt_hole(-back_spike_bolt_from_base);
    }
}

module spike(y) {
    translate([0,y,0])
    difference() {
        spike_positive();
        spike_bolt_hole(-spike_bolt_from_base);
        if(3d)
        translate([-spike_point_d-spike_max_depth-main_z,-slot_l/2,-pad])
        cube([spike_point_d,slot_l,sides_thick+padd]);
        if(2d)
        translate([-spike_point_d-spike_max_depth-main_z,-slot_l/2])
        square([spike_point_d,slot_l]);
    }
}

module rotated_spike(y) {
    rotate([0,0,90])
    spike(-y);
}

module rotated_end_spike(y) {
    rotate([0,0,90])
    end_spike(-y);
}

module side_lock(y) {
    if(3d)
    translate([lock_h-cut_edge_gap,y,-pad])
    cube([sides_height-lock_h+cut_edge_gap+pad,sides_thick+plywood_h_gapp,sides_thick+padd]);
    if(2d)
    translate([lock_h-cut_edge_gap,y])
    square([sides_height-lock_h+cut_edge_gap+pad,sides_thick+plywood_h_gapp]);
}

module side_locks() {
    side_lock(main_y+back_y-plywood_h_gap-sides_thick/2-slot_to_edge);
    side_lock(back_y+slot_to_edge-sides_thick/2-plywood_h_gap);
    side_lock(back_y+center_slot_from_end-sides_thick/2-plywood_h_gap);
    side_lock(lock-plywood_h_gap);
}

module pattern() {
    translate([pat_delta/2,pat_delta/2,0])
    for(pat_x=[0:pat_delta:sides_height]){
        for(pat_y=[0:pat_delta:main_y+back_y]){
            if(3d)
            translate([pat_x,pat_y,-pad])
            cylinder(r=pat_r,h=sides_thick+padd);
            if(2d)
            translate([pat_x,pat_y])
            circle(r=pat_r);
        }
    }
    for(pat_x=[0:pat_delta:sides_height]){
        for(pat_y=[0:pat_delta:main_y+back_y]){
            if(3d)
            translate([pat_x,pat_y,-pad])
            cylinder(r=pat_r,h=sides_thick+padd);
            if(2d)
            translate([pat_x,pat_y])
            circle(r=pat_r);
        }
    }
}

module side_pattern() {
    difference() {
        intersection() {
            pattern();
            if(3d)
            translate([wall,wall,-pad])
            cube([sides_height-wall*2,side_l-wall*2-lock,sides_thick+padd]);
            if(2d)
            translate([wall,wall])
            square([sides_height-wall*2,side_l-wall*2-lock]);
        }
        if(3d)
        minkowski() {
            side_locks();
            cylinder(r=wall,h=sides_thick);
        }
        //WTF OpenScad
        if(2d) {
            minkowski() {
                side_lock(main_y+back_y-plywood_h_gap-sides_thick/2-slot_to_edge);
                circle(r=wall);
            }
            minkowski() {
                side_lock(back_y+slot_to_edge-sides_thick/2-plywood_h_gap);
                circle(r=wall);
            }
            minkowski() {
                side_lock(back_y+center_slot_from_end-sides_thick/2-plywood_h_gap);
                circle(r=wall);
            }
            minkowski() {
                side_lock(lock-plywood_h_gap);
                circle(r=wall);
            }
        }
    }
}

module draw_side(x){
    translate([x+sides_thick/2,0,main_z])
    rotate([0,-90,0])
    side();
}

module side(){
    translate([0,-back_y,0])
    difference() {
        if(3d)cube([sides_height,side_l,sides_thick]);
        if(2d)square([sides_height,side_l]);
        if(3d)
        translate([0,side_l-lock,-pad])
        rotate([0,0,lock_angle]) 
        cube([sides_height*2,lock*2,sides_thick+padd]);
        if(2d)
        translate([0,side_l-lock])
        rotate([0,0,lock_angle]) 
        square([sides_height*2,lock*2]);
        side_locks();
        if(patterns)
        side_pattern();
    }
    spike(side_slot_from_end);
    spike(main_y-side_slot_from_end);
}

module end_pattern() {
    difference() {
        intersection() {
            union() {
                if(3d)
                translate([lock+wall,wall,-pad])
                cube([end_w-lock*2-wall*2,end_height-wall*2,sides_thick+padd]);
                if(2d)
                translate([lock+wall,wall])
                square([end_w-lock*2-wall*2,end_height-wall*2]);
            }
            translate([lock,0,0])
            mirror([0,1,0])
            rotate([0,0,-90])
            pattern();
        }
        minkowski() {
            circle(r=wall);
            end_lock(lock+slot_to_edge-sides_thick/2-plywood_h_gap*2);
        }
        minkowski() {
            //end_locks();
            //dammit openscad
            end_lock(lock+main_x-sides_thick/2-plywood_h_gap*2-slot_to_edge);
            circle(r=wall);
        }
    }
}

module draw_end(y) {
    translate([0,y+sides_thick/2,main_z])
    rotate([90,0,0])
    end();
}

module end_lock(x) {
    if(3d)
    translate([x,-pad,-pad])
    cube([sides_thick+plywood_h_gap*2,lock_h+cut_edge_gap+pad,sides_thick+padd]);
    if(2d)
    translate([x,-pad,0])
    square([sides_thick+plywood_h_gap*2,lock_h+cut_edge_gap+pad]);
}

module end_locks(){
    end_lock(lock+slot_to_edge-sides_thick/2-plywood_h_gap*2);
    end_lock(lock+main_x-sides_thick/2-plywood_h_gap*2-slot_to_edge);
}

module end() {
    translate([slot_to_edge-sides_thick/2-lock,0,0]) {
        difference() {
            if(3d)
            cube([end_w,end_height,sides_thick]);
            if(2d)
            square([end_w,end_height]);
            //near angle cut
            if(3d)
            translate([lock,0,-pad])
            rotate([0,0,lock_angle])
            translate([-lock*2,0,0])
            cube([lock*2,end_height*2,sides_thick+padd]);
            if(2d)
            translate([lock,0,0])
            rotate([0,0,lock_angle])
            translate([-lock*2,0,0])
            square([lock*2,end_height*2]);
            //far angle cut
            if(3d)
            translate([end_w-lock,0,-pad])
            rotate([0,0,-lock_angle])
            cube([lock*2,end_height*2,sides_thick+padd]);
            if(2d)
            translate([end_w-lock,0,0])
            rotate([0,0,-lock_angle])
            square([lock*2,end_height*2]);

            end_locks();

            //cut end for wheel well clearance
            if(3d)
            translate([slot_to_edge,0,-pad])
            cube([lock,wheel_z,sides_thick+padd]);
            if(2d)
            translate([slot_to_edge,0,0])
            square([lock,wheel_z]);
            if(3d)
            translate([main_x-slot_to_edge+lock,0,-pad])
            cube([lock,wheel_z,sides_thick+padd]);
            if(2d)
            translate([main_x-slot_to_edge+lock,0,0])
            square([lock,wheel_z]);

            if(patterns)
            end_pattern();
        }
        rotated_end_spike(end_slot_from_side+lock-slot_to_edge+sides_thick/2);
        rotated_end_spike(main_x-end_slot_from_side+lock-slot_to_edge+sides_thick/2);
    }
}

module strap_hole(x,y) {
    if(3d)
    translate([x,y,-pad])
    cylinder(r=strap_hole_r,h=main_z+padd);
    if(2d)
    translate([x,y])
    circle(r=strap_hole_r);
    if(fillet) {
        translate([x,y,main_z-strap_fillet])
        cylinder(r1=strap_hole_r,r2=strap_hole_r+strap_fillet+pad,h=strap_fillet+pad);
    }
}

module back_strap_holes() {
    translate([-strap_gap/2,0,0])
    for(x=[strap_gap:strap_gap:strap_gap*back_strap_hole_count]) {
        strap_hole(x,-back_y+strap_wall);
    }
}

module base() {
    difference(){
        union() {
            if(3d)
            cube([main_x,main_y,main_z]);
            if(2d)
            square([main_x,main_y]);
            translate([0,main_y,0]) {
                if(3d)
                translate([half_x-front_x/2,0,0])
                cube([front_x,front_y,main_z]);
                if(2d)
                translate([half_x-front_x/2,0,0])
                square([front_x,front_y]);

                rotate([0,0,front_angle])
                translate([0,-front_hyp,0])
                difference() {
                    if(3d)
                    cube([front_hyp,front_hyp,main_z]);
                    if(2d)
                    square([front_hyp,front_hyp]);
                    strap_hole(strap_gap/2,front_hyp-strap_wall);
                    strap_hole(strap_gap/2+strap_gap,front_hyp-strap_wall);
                    strap_hole(strap_gap/2+strap_gap*2,front_hyp-strap_wall);
                }

                translate([main_x,0,0])
                rotate([0,0,-front_angle])
                translate([-front_hyp,-front_hyp,0])
                difference() {
                    if(3d)
                    cube([front_hyp,front_hyp,main_z]);
                    if(2d)
                    square([front_hyp,front_hyp]);
                    strap_hole(front_hyp-strap_gap/2,front_hyp-strap_wall);
                    strap_hole(front_hyp-strap_gap/2-strap_gap,front_hyp-strap_wall);
                    strap_hole(front_hyp-strap_gap/2-strap_gap*2,front_hyp-strap_wall);
                }
            }
            //back_yeft_angle
            translate([0,-back_y,0])
            rotate([0,0,back_wheel_angle])
            difference() {
                if(3d) cube([back_wheel_hyp,back_wheel_hyp,main_z]);
                if(2d) square([back_wheel_hyp,back_wheel_hyp]);
                strap_hole(strap_wall,back_wheel_hyp-strap_gap/2);
                strap_hole(strap_wall,back_wheel_hyp-strap_gap/2-strap_gap);
            }

            //back_right_angle
            translate([main_x,-back_y,0])
            rotate([0,0,-back_wheel_angle])
            translate([-back_wheel_hyp,0,0])
            difference() {
                if(3d) cube([back_wheel_hyp,back_wheel_hyp,main_z]);
                if(2d) square([back_wheel_hyp,back_wheel_hyp]);
                strap_hole(back_wheel_hyp-strap_wall,back_wheel_hyp-strap_gap/2);
                strap_hole(back_wheel_hyp-strap_wall,back_wheel_hyp-strap_gap/2-strap_gap);
            }

            //front left
            translate([0,main_y,0])
            rotate([0,0,-front_wheel_angle])
            translate([0,-front_wheel_hyp,0])
            difference() {
                if(3d) cube([front_wheel_hyp,front_wheel_hyp,main_z]);
                if(2d) square([front_wheel_hyp,front_wheel_hyp]);
                strap_hole(strap_wall,strap_gap/2);
                strap_hole(strap_wall,strap_gap/2+strap_gap);
            }

            //front right
            translate([main_x,main_y,0])
            rotate([0,0,front_wheel_angle])
            translate([-front_wheel_hyp,-front_wheel_hyp,0])
            difference() {
                if(3d) cube([front_wheel_hyp,front_wheel_hyp,main_z]);
                if(2d) square([front_wheel_hyp,front_wheel_hyp]);
                strap_hole(front_wheel_hyp-strap_wall,strap_gap/2);
                strap_hole(front_wheel_hyp-strap_wall,strap_gap/2+strap_gap);
            }

            //back_extension
            if(3d)
            translate([0,-back_y,0])
            cube([main_x,back_y,main_z]);
            if(2d)
            translate([0,-back_y,0])
            square([main_x,back_y]);
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

        bolt(side_bolt_from_side,side_bolt_from_end);
        bolt(main_x-side_bolt_from_side,side_bolt_from_end);
        bolt(side_bolt_from_side,main_y-side_bolt_from_end);
        bolt(main_x-side_bolt_from_side,main_y-side_bolt_from_end);

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

        rotated_slot(end_slot_from_side,-back_y+lock+slot_w/2-(slot_w/2-sides_thick/2));
        rotated_slot(main_x-end_slot_from_side,-back_y+lock+slot_w/2-(slot_w/2-sides_thick/2));

        #wheel_wells();

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

        front_bolts(front_bolt_front);
        front_bolts(front_bolt_back);
    }
}

test_x=13*in;
test_y=6*in;

module testing() {
    difference() {
        translate([0,-test_y/2,0])
        cube([test_x,test_y,main_z]);
        translate([1*in,0,0])
        rail_bolt(0,0);
        translate([3*in,0,0])
        tie_down(0,0);
        translate([5*in,0,0])
        bolt(0,0);
        translate([7.5*in,0,0])
        slot(0,0);
        translate([10*in,0,0])
        chock_hole(0,0);
        translate([12*in,0,0])
        strap_hole(0,0);
    }
}

plywood_x=4*12*in+1*in;
plywood_y=8*12*in+1*in;
plywood_z=0.75*in;

module plywood() {
    cube([plywood_x,plywood_y,plywood_z]);
}

module base_bottom() {
    difference(){
        translate([wheel_x,back_y,0])
        base();
        translate([0,-pad,pad])
        plywood();
    }
}
//base_bottom();
//translate([wheel_x,back_y,0])
//base();

//translate([0,0,-0.75*in])color("magenta") plywood();

//side();
//end();

//color("cyan") draw_side(slot_to_edge);
//color("cyan") draw_side(main_x-slot_to_edge);
//color("lime") draw_end(main_y-slot_to_edge);
//color("lime") draw_end(slot_to_edge);
//color("lime") draw_end(center_slot_from_end);
//color("lime") draw_end(-back_y+lock+sides_thick/2);
hook_wall=6*in;
hook_end=4.5*in;
hook_grip=8*in;

axle=wheel_from_end+wheel_y/2;
plywood_center=axle-10*in;

side_to_hook=plywood_x/2-main_x/2+end_slot_from_side;
side_to_end=9*in;
front_to_hook=plywood_y/2-main_y+side_slot_from_end+plywood_center;
front_to_end=18*in;
back_to_hook=plywood_y/2+side_slot_from_end-plywood_center;
back_to_end=12*in;

back_ply_opp=hook_wall/2;
back_ply_adj=back_to_hook+hook_end-side_slot_from_end-back_y;
back_ply_angle=atan(back_ply_opp/back_ply_adj);

side_ply_opp=hook_wall/2;
side_ply_adj=side_to_hook+hook_end-end_slot_from_side;
side_ply_angle=atan(side_ply_opp/side_ply_adj);

front_ply_opp=hook_wall/2;
front_ply_adj=front_to_hook+hook_end-side_slot_from_end;
front_ply_angle=atan(front_ply_opp/front_ply_adj);

module hook(to_hook,to_end) {
    difference() {
        union() {
            translate([0,to_hook,0])
            cube([hook_wall+hook_grip,hook_end,sides_thick]);
            translate([0,-to_end,0])
            cube([hook_wall,to_end+to_hook,sides_thick]);
        }
        translate([0,to_hook+hook_end,-pad])
        rotate([0,0,-lock_angle])
        cube([(hook_wall+hook_grip)*2,hook_end*2,sides_thick+padd]);
    }
}
module side_hook_slot(y) {
        translate([-pad,y-sides_thick/2-plywood_h_gap,-pad])
        cube([hook_wall/2+cut_edge_gap+pad,sides_thick+plywood_h_gapp,sides_thick+padd]);
}

module end_hook_slot(y) {
        translate([hook_wall/2-cut_edge_gap,y-sides_thick/2-plywood_h_gap-slot_to_edge,-pad])
        cube([hook_wall/2+cut_edge_gap+pad,sides_thick+plywood_h_gapp,sides_thick+padd]);
}

module front_hook() {
    spike(0);
    difference() {
        hook(front_to_hook,front_to_end);
        side_hook_slot(side_slot_from_end-slot_to_edge);
        translate([0,side_slot_from_end,0])
        rotate([0,0,-front_ply_angle])
        translate([-hook_wall,0,-pad])
        cube([hook_wall,front_ply_adj*1.5,main_z+padd]);
    }
}

module back_hook() {
    spike(0);
    mirror([0,1,0])
    difference() {
        hook(back_to_hook,back_to_end);
        side_hook_slot(side_slot_from_end-slot_to_edge);
        translate([0,side_slot_from_end+back_y,0])
        rotate([0,0,-back_ply_angle])
        translate([-hook_wall,0,-pad])
        cube([hook_wall,back_ply_adj*1.5,main_z+padd]);
    }
}

module draw_back_hook(x) {
    translate([sides_thick/2+x,side_slot_from_end,main_z])
    rotate([0,-90,0])
    back_hook(18*in);
}

module draw_front_hook(x) {
    translate([sides_thick/2+x,main_y-side_slot_from_end,main_z])
    rotate([0,-90,0])
    front_hook(18*in);
}
module draw_front_hooks() {
    draw_front_hook(slot_to_edge);
    draw_front_hook(main_x-slot_to_edge);
}

module draw_back_hooks() {
    draw_back_hook(slot_to_edge);
    draw_back_hook(main_x-slot_to_edge);
}

module end_hook() {
    end_spike(0);
    difference() {
        hook(side_to_hook,side_to_end);
        end_hook_slot(end_slot_from_side);
        translate([0,end_slot_from_side,0])
        rotate([0,0,-side_ply_angle])
        translate([-hook_wall,0,-pad])
        cube([hook_wall,side_ply_adj*1.5,main_z+padd]);
    }
}

module side_end_hook(y) {
    translate([end_slot_from_side,sides_thick/2+y,main_z])
    rotate([0,-90,90])
    end_hook();
}
module side_end_hooks() {
    side_end_hook(slot_to_edge);
    side_end_hook(main_y-slot_to_edge);
}
module draw_all_hooks() {
    draw_back_hooks();
    draw_front_hooks();
    side_end_hooks();
    color("cyan")
    translate([-plywood_x/2+main_x/2,plywood_center-plywood_y/2,hook_wall+main_z])
    plywood();
}
//front_hook();
//testing();
//base();
//end_hook();
//end();
projection()
back_hook();
