$fn=120;
glass_x=224;
glass_y=268;

bolt_x=208.7;
bolt_y=bolt_x;

hbp_x=220;
hbp_y=hbp_x;
hbp_z=4;

wall=3;

base_x=225;
base_y=base_x;
base_lip=2;

lip=2;
pad=0.1;
padd=pad*2;

edge_to_hbp=(glass_y-hbp_y)/2;
edge_to_bolt=(glass_y-bolt_y)/2;
side_to_bolt=(glass_x-bolt_x)/2;

block_y=edge_to_bolt+side_to_bolt+wall*2;
block_z=wall+hbp_z+lip;
block_x=side_to_bolt*2+wall*2;

bolt_d=2.8;
bolt_r=bolt_d/2;


module glass() {
    difference() {
        color("cyan")
        translate([glass_x/2-hbp_x/2,glass_y/2-hbp_y/2,-lip])
        cube([hbp_x,hbp_y,lip-pad]);
        #cube([glass_x,glass_y,lip]);
    }
}

module block() {
    translate([0,4,4])
    difference() {
        cube([block_x,block_y,block_z]);
        translate([-pad,-pad,block_z-lip])
        cube([block_x-wall+pad,block_y-wall+pad,lip+pad]);
        translate([-pad,-pad,wall])
        cube([block_x-wall+pad,block_y-edge_to_hbp-wall+pad,hbp_z+pad]);
        translate([-pad,block_y-edge_to_hbp,-pad])
        cube([block_x+padd,edge_to_hbp+pad,block_z-lip-wall+pad]);
        translate([block_x-wall-side_to_bolt,block_y-wall-edge_to_bolt,-pad])
        cylinder(r=bolt_r,h=wall+padd);
    }
}

rotate([0,90,0])
block();

mirror([0,1,0])
rotate([0,90,0])
block();


mirror([1,0,0]) {
    rotate([0,90,0])
    block();

    mirror([0,1,0])
    rotate([0,90,0])
    block();
}
//translate([-glass_x+block_x-wall,-glass_y+block_y-wall,block_z-lip]) glass();
