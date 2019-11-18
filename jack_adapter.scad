groove=12;      // width of groove in middle
groove_h=28;    // groove height 
base_h=7;       // thickness of puck at bottom of groove
puck=79.5;      // main outer diameter of puck
pad=0.1;        // padding negative space for clean cuts
padd=pad*2;
max_z=base_h+groove_h;

side_a=35;      // trim sides
side_b=side_a;
max_x=puck;     // trim width of puck along groove
max_y=side_a+side_b+groove;
edge=5;

extrusion_width=1.2;

screw=5;
screws=4;
screw_h=16;
screw_head=10;
screw_head_h=3;
screw_head_lip=1;

layer_h=0.4;

magnet=10; 
magnet_pad=layer_h; 
magnet_h=max_z-magnet_pad;
magnet_h=10;
magnet_offset=puck/3;
crush_h=magnet_h/2;
crush_wall=extrusion_width;

raft=30;
raft_d=puck+raft*2;


$fn=200;


// big jack
puck=101;      // main outer diameter of puck
puck_rotator=34;
puck_rotator_h=3;
base_h=9;       // thickness of puck at bottom of groove

// accord
groove=12;      // width of groove in middle
groove_h=38;    // to clear
groove_h=22;    // to rest
side_a=50;      // trim sides
side_b=side_a;

//mr2
groove=12;      // width of groove in middle
groove_top=10;      // width of groove in middle
groove_bottom=12;
groove_h=20;    // to rest



module jack_adapter() {
    intersection() {
        difference() { 
            puck();
            negative();
        }
        binding_box();
    }
}

module positive() {
    intersection() {
        puck();
        binding_box();
    }
}

module negative() {
    groove();
    //screws();
    magnets();
    rotator();
}


rotator_forgiveness=2;

module rotator() {
    translate([0,0,-pad])
    cylinder(d=puck_rotator,h=puck_rotator_h+pad);
    translate([0,0,puck_rotator_h])
    cylinder(d1=puck_rotator, d2=puck_rotator-rotator_forgiveness*2, h=rotator_forgiveness);
}

magnet_rotation=30;

module magnets() {
    mirror([1,0,0])
    mirror([0,1,0])
    top_magnet();
    mirror([0,1,0])
    top_magnet();
    mirror([1,0,0])
    top_magnet();
    top_magnet();
    bottom_magnet();
    mirror([0,1,0])
    bottom_magnet();
}

module top_magnet() {
    rotate([0,0,90+magnet_rotation])
    translate([0,-magnet_offset,max_z-magnet_h-magnet_pad-crush_h])
    difference() {
        cylinder(d=magnet,h=magnet_h+crush_h);
        translate([-magnet/2-pad,-crush_wall/2,-pad])
        cube([magnet+pad*2,crush_wall,crush_h+pad]);
    }
}

module bottom_magnet() {
    translate([0,-magnet_offset,magnet_pad])
    difference() {
        cylinder(d=magnet,h=magnet_h+crush_h);
        translate([-magnet/2-pad,-crush_wall/2,magnet_h])
        cube([magnet+pad*2,crush_wall,crush_h+pad]);
    }
}

module binding_box() {
    translate([-max_x/2,-groove/2-side_a,0])
    cube([max_x,max_y,max_z]);
}

module puck() {
    minkowski() {
        cylinder(d=puck-edge*2,h=max_z-edge);
        sphere(d=edge*2);
    }
}


module old_groove() {
    translate([-puck/2-pad,-groove/2,base_h])
    cube([puck+pad*2,groove,groove_h+pad]);
}

module groove() {
    hull() {
        groove_end();
        mirror([1,0,0])
        groove_end();
    }
}

module groove_end() {
    translate([puck/2+groove_bottom/2,0,base_h])
    cylinder(d2=groove_top,d1=groove_bottom,h=groove_h+pad);
}

module screws() {
    for(i=[0:360/screws:359]) {
        rotate([0,0,360/screws/2+i])
        translate([puck/3,0,0]) {
            screw();
       }
    }
}

module screw() {
    cylinder(d=screw,h=screw_h);
    translate([0,0,screw_head_lip])
    cylinder(d1=screw_head,d2=screw,h=screw_head_h);
    translate([0,0,-pad])
    cylinder(d=screw_head,h=screw_head_lip+pad);
}

module raft() {
    difference() {
        cylinder(d=raft_d,h=layer_h);
        translate([0,0,-pad])
        cylinder(d=puck-padd,h=layer_h+padd);
    }
}


module inside_view(){
    $fn=90;
    negative();
    #positive();
}


//jack_adapter();
inside_view();
//raft();
