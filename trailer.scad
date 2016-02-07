in=25.4;

back_l=8*in;        
max_x=40.375*in; //measured
max_y=48.125*in; //measured
max_z=0.75*in;

x_rail_hole=(3/4-1/16)*in; //measured
y_rail_hole=15/16*in; //measured
center_rail_hole=(24+1/16)*in; //measured
off_center_hole=6*in; //measured
side_hole=4*in;  //measured

rail_bolt_d=0.75*in;  //measured
rail_bolt_r=rail_bolt_d/2;      //fixed

bolt_d=0.5*in; //fixed
bolt_r=bolt_d/2; //fixed
bolt_head_d=1.2*in;
bolt_head_r=bolt_head_d/2; //fixed
bolt_depth=7;

pad=0.5;
padd=pad*2;

slot_l=(3+5/8)*in; //measured
slot_w=7/8*in; //measured

slot_to_edge=slot_w/2+1/16*in; //measured

side_bottom_slot=6.9375*in; //measured
side_top_slot=max_y-side_bottom_slot; //fixed

end_slot_offset=7.1875*in; //measured
center_slot=23.6875*in; //measured

front_l=12*in;
front_w=8*in;
front_adj=(max_x-front_w)/2; //fixed

front_hyp=sqrt(front_l*front_l+front_adj*front_adj); //fixed
front_angle=atan(front_l/front_adj); //fixed

wheel_w=5.75*in; //measured
wheel_l=(15+7/8)*in; //measured
wheel_from_back=(11+15/16)*in;  //measured

back_wheel_opp=wheel_w; //fixed
back_wheel_adj=wheel_from_back+back_l; //fixed
back_wheel_hyp=sqrt(back_wheel_opp*back_wheel_opp+back_wheel_adj*back_wheel_adj); //fixed
back_wheel_angle=atan(back_wheel_opp/back_wheel_adj); //fixed

front_wheel_opp=wheel_w; //fixed
front_wheel_adj=max_y-wheel_from_back-wheel_l; //fixed
front_wheel_hyp=sqrt(front_wheel_opp*front_wheel_opp+front_wheel_adj*front_wheel_adj); //fixed
front_wheel_angle=atan(front_wheel_opp/front_wheel_adj); //fixed

grom_left=max_x/2-15*in;
grom_right=max_x/2+15*in;
grom_top=45*in;
grom_bottom=5*in;

corner_d=1/8*in; //measured
corner_r=corner_d/2; //fixed

module rail_bolt(x,y) {
    translate([x,y,-pad])
    cylinder(r=rail_bolt_r,h=max_z+padd);
}

module bolt(x,y) {
    translate([x,y,-pad])
    cylinder(r=bolt_r,h=max_z+padd);
    //translate([0,0,max_z-bolt_depth])
    translate([x,y,max_z-bolt_depth])
    cylinder(r1=bolt_r,r2=bolt_head_r,h=bolt_depth);
}

module corner(x,y){
    translate([x,y,-pad])
    cylinder(r=corner_r,h=max_z+padd);
}

module slot(x,y) {
    translate([-slot_w/2+x,-slot_l/2+y,0]) {
        translate([0,0,-pad])
        cube([slot_w,slot_l,max_z+padd]);
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
module wheel_well(){
    #cube([wheel_w,wheel_l,max_z*3]);
}

tie_d=0.25*in; //measured
tie_l=1.25*in; //measured
tie_w=2*in; //measured
tie_hole_d=3/8*in; //measured
tie_hole_r=tie_hole_d/2; //measured

module tie_down(x,y){
    translate([-tie_w/2+x,-tie_l/2+y,0]) {
        translate([0,0,max_z-tie_d])
        cube([tie_w,tie_l,tie_d+pad]);    
        translate([tie_w/2,0,max_z-tie_d])
        cylinder(r=tie_w/2,h=tie_d+pad);
        translate([tie_w/2,tie_l,max_z-tie_d])
        cylinder(r=tie_w/2,h=tie_d+pad);
        translate([tie_w/2,0,-pad])
        cylinder(r=tie_hole_r,h=max_z+padd);
        translate([tie_w/2,tie_l,-pad])
        cylinder(r=tie_hole_r,h=max_z+padd);
    }
}

chock_depth=12;
chock_big_d=40;
chock_big_r=chock_big_d/2;
chock_hole_d=16;
chock_hole_r=chock_hole_d/2;
module chock(){
    translate([0,0,max_z-chock_depth])
    cylinder(r=chock_big_r,h=chock_depth+pad);

    translate([0,0,-pad])
    cylinder(r=chock_hole_r,h=max_z+padd);
    
}

difference(){
    union() {
        cube([max_x,max_y,max_z]);
        translate([0,max_y,0]) {
            translate([max_x/2-front_w/2,0,0])
            cube([front_w,front_l,max_z]);

            rotate([0,0,front_angle])
            translate([0,-front_hyp,0])
            cube([front_hyp,front_hyp,max_z]);

            translate([max_x,0,0])
            rotate([0,0,-front_angle])
            translate([-front_hyp,-front_hyp,0])
            cube([front_hyp,front_hyp,max_z]);
        }
        //back_left_angle
        translate([0,-back_l,0])
        rotate([0,0,back_wheel_angle])
        cube([back_wheel_hyp,back_wheel_hyp,max_z]);

        //back_right_angle
        translate([max_x,-back_l,0])
        rotate([0,0,-back_wheel_angle])
        translate([-back_wheel_hyp,0,0])
        cube([back_wheel_hyp,back_wheel_hyp,max_z]);

        //front left
        translate([0,max_y,0])
        rotate([0,0,-front_wheel_angle])
        translate([0,-front_wheel_hyp,0])
        cube([front_wheel_hyp,front_wheel_hyp,max_z]);

        //front right
        translate([max_x,max_y,])
        rotate([0,0,front_wheel_angle])
        translate([-front_wheel_hyp,-front_wheel_hyp,0])
        cube([front_wheel_hyp,front_wheel_hyp,max_z]);

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

    translate([max_x,wheel_from_back,-pad])
    wheel_well();
    translate([-wheel_w,wheel_from_back,-pad])
    wheel_well();

    tie_down(grom_left,grom_top);
    tie_down(grom_right,grom_top);
    tie_down(grom_left,grom_bottom);
    tie_down(grom_right,grom_bottom);
}
