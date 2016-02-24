//convert mm to in
in=25.4;

back_l=8*in;        
max_x=40.375*in; //measured
max_y=48.125*in; //measured
max_z=0.75*in;
total_w=47*in;

x_rail_hole=(3/4-1/16)*in; //measured
y_rail_hole=15/16*in; //measured
center_rail_hole=(24+1/16)*in; //measured
off_center_hole=6*in; //measured
side_hole=4*in;  //measured

rail_bolt_d=0.75*in;  //measured
rail_bolt_r=rail_bolt_d/2;      //fixed

bolt_d=3/8*in; //fixed
bolt_r=bolt_d/2; //fixed
bolt_depth=0.23*in;//mcmastercarr
bolt_head_d=bolt_d+bolt_depth*2;
bolt_head_r=bolt_head_d/2; //fixed

pad=1.5;
padd=pad*2;

slot_l=(3+5/8)*in; //measured
slot_w=7/8*in; //measured
cut_edge_gap=1/16*in;
cut_edge_gapp=cut_edge_gap*2;
plywood_h_gap=1/8*in;
plywood_h_gapp=plywood_h_gap*2;

slot_to_edge=slot_w/2+1/16*in; //measured
slot_angle=(1/8)*in; //arbitrary

side_bottom_slot=6.9375*in; //measured
side_top_slot=max_y-side_bottom_slot; //fixed

end_slot_offset=7.1875*in; //measured
center_slot=23.6875*in; //measured

front_l=12*in;
front_w=8*in;
front_adj=(max_x-front_w)/2; //fixed

echo ("Total length: ", (max_y+front_l+back_l)/in);

front_hyp=sqrt(front_l*front_l+front_adj*front_adj); //fixed
front_angle=atan(front_l/front_adj); //fixed

wheel_w=(total_w-max_x)/2; //measured
wheel_l=(15+7/8)*in; //measured
wheel_h=(2+5/8)*in; //measured
wheel_from_back=(11+15/16)*in;  //measured

echo ("Total width: ", (max_x+wheel_w*2)/in);

back_wheel_opp=wheel_w; //fixed
back_wheel_adj=wheel_from_back+back_l; //fixed
back_wheel_hyp=sqrt(back_wheel_opp*back_wheel_opp+back_wheel_adj*back_wheel_adj); //fixed
back_wheel_angle=atan(back_wheel_opp/back_wheel_adj); //fixed

front_wheel_opp=wheel_w; //fixed
front_wheel_adj=max_y-wheel_from_back-wheel_l; //fixed
front_wheel_hyp=sqrt(front_wheel_opp*front_wheel_opp+front_wheel_adj*front_wheel_adj); //fixed
front_wheel_angle=atan(front_wheel_opp/front_wheel_adj); //fixed

grom_from_edge=2.3*in;
grom_left=grom_from_edge;
grom_right=max_x-grom_from_edge;
grom_top=45*in;
grom_bottom=-1.5*in;

front_tie_from_center=21*in;
front_tie_from_back=max_y+3*in;

corner_d=1/8*in; //measured
corner_r=corner_d/2; //fixed

tie_d=0.25*in; //measured
tie_l=1.25*in; //measured
tie_w=(1+5/8)*in; //measured
tie_hole_d=3/8*in; //measured
tie_hole_r=tie_hole_d/2; //measured

chock_depth=5/16*in; //measured
chock_big_d=2*in; //measured
chock_big_r=chock_big_d/2; //fixed
chock_bolt_d=1/4*in; //measured
chock_bolt_r=chock_bolt_d/2; //fixed
chock_bolt_gap=(1+5/16)*in/2; //measured

grom_chock_x=8*in;
grom_chock_y=7*in;
grom_chock_l=66*in;
fifty_chock_x=(5+5/8)*in;
fifty_chock_y=7*in;
fifty_chock_l=64*in;
fifty_bottom=fifty_chock_l-48*in-back_l;

side_h=12*in;

tounge_bolt_gap=3.5*in;
tounge_top=max_x+back_l+front_l-2*in;
tounge_bottom=max_x+back_l+front_l-8*in;

bike_lock_w=1.5*in;
bike_lock_l=3*in;
bike_lock_gap=6*in;
bike_lock_y=max_y-4*in;
bike_lock_fillet=1/4*in;

overlap=3*in;
overlap_opp=overlap;
overlap_adj=side_h;
overlap_angle=atan(overlap_opp/overlap_adj);
overlap_h=side_h*2/3;

side_z=max_z;
end_z=side_z;
side_l=max_y+back_l-slot_to_edge+end_z/2+overlap;

//distance from bottom side of bed to center of bolt hole
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

end_w=max_x-(slot_to_edge-side_z/2)*2+overlap*2;
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
back_strap_gap=max_x/back_strap_hole_count;




module rail_bolt(x,y) {
    translate([x,y,-pad])
    cylinder(r=rail_bolt_r,h=max_z+padd);
}

module bolt(x,y) {
    translate([x,y,-pad])
    cylinder(r=bolt_r,h=max_z+padd);
    translate([x,y,max_z-bolt_depth])
    cylinder(r1=bolt_r,r2=bolt_head_r+pad,h=bolt_depth+pad);
}

module corner(x,y){
    translate([x,y,-pad])
    cylinder(r=corner_r,h=max_z+padd);
}

module slot(x,y) {
    translate([-slot_w/2+x,-slot_l/2+y,0]) {
        translate([0,0,-pad])
        cube([slot_w,slot_l,max_z+padd]);
        translate([0,0,max_z-slot_angle])
        minkowski() {
            cylinder(r1=0,r2=max_z,h=max_z);
            cube([slot_w,slot_l,max_z]);
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
    translate([x,wheel_from_back,-pad])
    cube([wheel_w,wheel_l,wheel_h]);
}

module wheel_wells(){
    wheel_well(max_x);
    wheel_well(-wheel_w);
}

module tie_down(x,y){
    translate([-tie_w/2+x,-tie_l/2+y,0]) {
        hull() {
            translate([tie_w/2,0,max_z-tie_d])
            cylinder(r1=tie_w/2,r2=tie_w/2+tie_hole_d+pad,h=tie_d+pad);
            translate([tie_w/2,tie_l,max_z-tie_d])
            cylinder(r1=tie_w/2,r2=tie_w/2+tie_hole_d+pad,h=tie_d+pad);
        }
        translate([tie_w/2,0,-pad])
        cylinder(r=tie_hole_r,h=max_z+padd);
        translate([tie_w/2,tie_l,-pad])
        cylinder(r=tie_hole_r,h=max_z+padd);
    }
}

module chock_hole(x,y){
    translate([x,y,max_z-chock_depth])
    cylinder(r=chock_big_r,h=chock_depth+pad);

    translate([x-chock_bolt_gap,y,-pad])
    cylinder(r=chock_bolt_r,h=max_z+padd);
    translate([x+chock_bolt_gap,y,-pad])
    cylinder(r=chock_bolt_r,h=max_z+padd);
    translate([x,y,-pad])
    cylinder(r=chock_bolt_r,h=max_z+padd);
    
}

module chock(x,y,l) {
    translate([max_x/2,-back_l+l,0]) {
        chock_hole(-x/2,0);
        chock_hole(x/2,0);
        chock_hole(-x/2,-y);
        chock_hole(x/2,-y);
    }
}

module grom_chock() {
    chock(grom_chock_x,grom_chock_y,grom_chock_l);
}

module fifty_chock() {
    chock(fifty_chock_x,fifty_chock_y,fifty_chock_l);
}

module tounge_bolts(y) {
    bolt(max_x/2-tounge_bolt_gap/2,y);
    bolt(max_x/2+tounge_bolt_gap/2,y);
}

module bike_lock_hole() {
    hull() {
        translate([max_x/2,(bike_lock_l-bike_lock_w)/2,-pad])
        cylinder(r=bike_lock_w/2,h=max_z+padd);
        translate([max_x/2,-(bike_lock_l-bike_lock_w)/2,-pad])
        cylinder(r=bike_lock_w/2,h=max_z+padd);
    }
}
module bike_lock(x,y) {
    translate([x,y,0]) {
        bike_lock_hole();
        translate([0,0,max_z+padd-bike_lock_fillet])
        minkowski() {
            bike_lock_hole();
            cylinder(r1=0,r2=max_z+padd,h=max_z+padd);
        }
    }
}

module bike_locks(y) {
    bike_lock(-bike_lock_gap/2,y);
    bike_lock(bike_lock_gap/2,y);
}

module spike(y) {
    translate([0,y,-max_z])
    difference() {
        union() {
            translate([0,-spike_l/2,0])
            cube([side_z,spike_l,max_z]);


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
        cylinder(r=bolt_r,h=side_z+padd);
        translate([-pad,0,-back_spike_bolt_depth])
        rotate([0,90,0])
        cylinder(r=bolt_r,h=side_z+padd);
        translate([-pad,-slot_l/2,-spike_point_d-spike_max_d])
        cube([side_z+padd,slot_l,spike_point_d]);
    }
}

module rotated_spike(y) {
    rotate([0,0,90])
    spike(-y);
}

module end_cuts() {
    translate([-pad,max_y+back_l-plywood_h_gap-end_z/2-slot_to_edge,overlap_h-cut_edge_gap])
    cube([side_z+padd,end_z+plywood_h_gap*2,side_h-overlap_h+cut_edge_gap+pad]);
    translate([-pad,back_l+slot_to_edge-end_z/2-plywood_h_gap,overlap_h-cut_edge_gap])
    cube([side_z+padd,end_z+plywood_h_gap*2,side_h-overlap_h+cut_edge_gap+pad]);
    translate([-pad,back_l+center_slot-end_z/2-plywood_h_gap,overlap_h-cut_edge_gap])
    cube([side_z+padd,end_z+plywood_h_gap*2,side_h-overlap_h+cut_edge_gap+pad]);
    translate([-pad,overlap-plywood_h_gap,overlap_h-cut_edge_gap])
    cube([side_z+padd,end_z+plywood_h_gap*2,side_h-overlap_h+cut_edge_gap+pad]);
}

module pattern() {
    translate([0,pat_delta/2,pat_delta/2])
    for(pat_x=[0:pat_delta:side_h]){
        for(pat_y=[0:pat_delta:max_y+back_l]){
            translate([-pad,pat_y,pat_x])
            rotate([0,90,0])
            cylinder(r=pat_r,h=side_z+padd);
        }
    }
    for(pat_x=[0:pat_delta:side_h]){
        for(pat_y=[0:pat_delta:max_y+back_l]){
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
    translate([where-side_z/2,0,max_z]) {
        translate([0,-back_l,0])
        difference() {
            cube([side_z,side_l,side_h]);
            translate([-pad,side_l-overlap,0])
            rotate([-overlap_angle,0,0])
            cube([side_z+padd,overlap*2,side_h*2]);
            end_cuts();
            side_pattern();
        }
        spike(side_bottom_slot);
        spike(side_top_slot);
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
    translate([slot_to_edge-side_z/2-overlap,y-end_z/2,max_z]) {
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
            cube([overlap,end_z+padd,wheel_h]);
            translate([max_x-slot_to_edge+overlap,-pad,0])
            cube([overlap,end_z+padd,wheel_h]);

            //cut end for wheel well clearance
            translate([overlap+max_x-side_z/2-plywood_h_gap*2-slot_to_edge,-pad,0])
            cube([side_z+plywood_h_gapp,end_z+padd,overlap_h+cut_edge_gap]);
            end_pattern();
        }
        rotated_spike(end_slot_offset+overlap-slot_to_edge+side_z/2);
        rotated_spike(max_x-end_slot_offset+overlap-slot_to_edge+side_z/2);
    }
}

module strap_hole(x,y) {
    translate([x,y,-pad])
    cylinder(r=strap_hole_r,h=max_z+padd);
    translate([x,y,max_z-strap_fillet])
    cylinder(r1=strap_hole_r,r2=strap_hole_r+strap_fillet+pad,h=strap_fillet+pad);
}

module back_strap_holes() {
    translate([-back_strap_gap/2,0,0])
    for(x=[back_strap_gap:back_strap_gap:back_strap_gap*back_strap_hole_count]) {
        strap_hole(x,-back_l+strap_wall);
    }
}

module base() {
    difference(){
        union() {
            cube([max_x,max_y,max_z]);
            translate([0,max_y,0]) {
                translate([max_x/2-front_w/2,0,0])
                cube([front_w,front_l,max_z]);

                rotate([0,0,front_angle])
                translate([0,-front_hyp,0])
                difference() {
                    cube([front_hyp,front_hyp,max_z]);
                    strap_hole(back_strap_gap/2,front_hyp-strap_wall);
                    strap_hole(back_strap_gap/2+back_strap_gap,front_hyp-strap_wall);
                    strap_hole(back_strap_gap/2+back_strap_gap*2,front_hyp-strap_wall);
                }

                translate([max_x,0,0])
                rotate([0,0,-front_angle])
                translate([-front_hyp,-front_hyp,0])
                difference() {
                    cube([front_hyp,front_hyp,max_z]);
                    strap_hole(front_hyp-back_strap_gap/2,front_hyp-strap_wall);
                    strap_hole(front_hyp-back_strap_gap/2-back_strap_gap,front_hyp-strap_wall);
                    strap_hole(front_hyp-back_strap_gap/2-back_strap_gap*2,front_hyp-strap_wall);
                }
            }
            //back_left_angle
            translate([0,-back_l,0])
            rotate([0,0,back_wheel_angle])
            difference() {
                cube([back_wheel_hyp,back_wheel_hyp,max_z]);
                strap_hole(strap_wall,back_wheel_hyp-back_strap_gap/2);
                strap_hole(strap_wall,back_wheel_hyp-back_strap_gap/2-back_strap_gap);
            }

            //back_right_angle
            translate([max_x,-back_l,0])
            rotate([0,0,-back_wheel_angle])
            translate([-back_wheel_hyp,0,0])
            difference() {
                cube([back_wheel_hyp,back_wheel_hyp,max_z]);
                strap_hole(back_wheel_hyp-strap_wall,back_wheel_hyp-back_strap_gap/2);
                strap_hole(back_wheel_hyp-strap_wall,back_wheel_hyp-back_strap_gap/2-back_strap_gap);
            }

            //front left
            translate([0,max_y,0])
            rotate([0,0,-front_wheel_angle])
            translate([0,-front_wheel_hyp,0])
            difference() {
                cube([back_wheel_hyp,back_wheel_hyp,max_z]);
                strap_hole(strap_wall,back_strap_gap/2);
                strap_hole(strap_wall,back_strap_gap/2+back_strap_gap);
            }

            //front right
            translate([max_x,max_y,])
            rotate([0,0,front_wheel_angle])
            translate([-front_wheel_hyp,-front_wheel_hyp,0])
            difference() {
                cube([back_wheel_hyp,back_wheel_hyp,max_z]);
                strap_hole(back_wheel_hyp-strap_wall,back_strap_gap/2);
                strap_hole(back_wheel_hyp-strap_wall,back_strap_gap/2+back_strap_gap);
            }

            //back_extension
            translate([0,-back_l,0])
            cube([max_x,back_l,max_z]);
        }
        rail_bolt(x_rail_hole,y_rail_hole);
        rail_bolt(max_x-x_rail_hole,y_rail_hole);
        rail_bolt(x_rail_hole,max_y-y_rail_hole);
        rail_bolt(max_x-x_rail_hole,max_y-y_rail_hole);
        rail_bolt(x_rail_hole,center_rail_hole);
        rail_bolt(max_x-x_rail_hole,center_rail_hole);

        bolt(max_x/2,y_rail_hole);
        bolt(max_x/2,max_y-y_rail_hole);
        bolt(max_x/2,center_rail_hole);

        bolt(max_x/2+off_center_hole,y_rail_hole);
        bolt(max_x/2+off_center_hole,max_y-y_rail_hole);
        bolt(max_x/2+off_center_hole,center_rail_hole);

        bolt(max_x/2-off_center_hole,y_rail_hole);
        bolt(max_x/2-off_center_hole,max_y-y_rail_hole);
        bolt(max_x/2-off_center_hole,center_rail_hole);

        bolt(max_x-side_hole,y_rail_hole);
        bolt(max_x-side_hole,max_y-y_rail_hole);
        bolt(max_x-side_hole,center_rail_hole);

        bolt(side_hole,y_rail_hole);
        bolt(side_hole,max_y-y_rail_hole);
        bolt(side_hole,center_rail_hole);

        slot(slot_to_edge,side_top_slot);
        slot(max_x-slot_to_edge,side_top_slot);
        slot(slot_to_edge,side_bottom_slot);
        slot(max_x-slot_to_edge,side_bottom_slot);

        rotated_slot(end_slot_offset,slot_to_edge);
        rotated_slot(max_x-end_slot_offset,slot_to_edge);

        rotated_slot(end_slot_offset,max_y-slot_to_edge);
        rotated_slot(max_x-end_slot_offset,max_y-slot_to_edge);

        rotated_slot(end_slot_offset,center_slot);
        rotated_slot(max_x-end_slot_offset,center_slot);

        rotated_slot(end_slot_offset,-back_l+overlap+slot_w/2-(slot_w/2-end_z/2));
        rotated_slot(max_x-end_slot_offset,-back_l+overlap+slot_w/2-(slot_w/2-end_z/2));

        wheel_wells();


        tie_down(grom_left,grom_top);
        tie_down(grom_right,grom_top);
        tie_down(grom_left,grom_bottom);
        tie_down(grom_right,grom_bottom);
        tie_down(grom_left,fifty_bottom);
        tie_down(grom_right,fifty_bottom);
        tie_down(max_x/2-front_tie_from_center/2,front_tie_from_back);
        tie_down(max_x/2+front_tie_from_center/2,front_tie_from_back);

        grom_chock();
        fifty_chock();
        bike_locks(bike_lock_y);
        back_strap_holes();

        tounge_bolts(tounge_top);
        tounge_bolts(tounge_bottom);
    }
}

color("cyan") side(slot_to_edge);
color("cyan") side(max_x-slot_to_edge);
color("lime") end(max_y-slot_to_edge);
//color("lime") end(slot_to_edge);
//color("lime") end(center_slot);
color("lime") end(-back_l+overlap+end_z/2);
base();
