box_w_bottom=91;
//box_delta=10;
//box_w_top=box_w_bottom+box_delta*2;
box_w_top=101;
box_delta=(box_w_top-box_w_bottom)/2;
box_h=147;
box_l_bottom=85;
box_l_top=box_l_bottom+box_delta;
box_angle=atan(box_delta/box_h);
pad=0.1;
padd=pad*2;

gun_w=30;
gun_l_to_front=55;
gun_l=box_l_bottom-gun_l_to_front;

wall=1.2;

muzzle_w=gun_w-wall;
muzzle_l=50;
muzzle_h=25;


module angled_box(this_l,this_w,this_h) {
    difference() {
        cube([this_l,this_w,this_h]);
        //front angle
        translate([this_l-box_delta,-pad,0])
        rotate([0,box_angle,0])
        cube([box_delta*2,this_w+padd,this_h*2]);
        //near side
        translate([-pad,box_delta,0])
        rotate([box_angle,0,0])
        translate([0,-box_delta*2,0])
        cube([this_l+padd,box_delta*2,this_h*2]);
        //far side
        translate([-pad,this_w-box_delta,0])
        rotate([-box_angle,0,0])
        cube([this_l+padd,box_delta*2,this_h*2]);
    }
}

module gun(this_l,this_w,this_h) {
    difference() {
        cube([this_l,this_w,this_h]);
        //near side
        translate([-pad,box_delta,0])
        rotate([box_angle,0,0])
        translate([0,-box_delta*2,0])
        cube([this_l+padd,box_delta*2,this_h*2]);
    }
}

difference() {
    angled_box(box_l_top,box_w_top,box_h);
    translate([wall,wall,wall])
    angled_box(box_l_top-wall*2,box_w_top-wall*2,box_h-wall+pad);
    translate([-pad,-pad,-pad])
    gun(gun_l+pad,gun_w+pad,box_h+padd);
}
difference() {
    gun(gun_l+wall,gun_w+wall,box_h);
    translate([-pad,-pad,-pad])
    gun(gun_l+pad,gun_w+pad,box_h+padd);
}
translate([-muzzle_l+gun_l,0,0])
difference() {
    gun(muzzle_l+wall,muzzle_w+wall*2,muzzle_h+wall);
    translate([wall,-wall,wall])
    #gun(muzzle_l,muzzle_w+wall*2,muzzle_h+pad);
}

