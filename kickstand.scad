max_z=24;
max_x=26;
max_y=235;
$fn=120;

slot_x=8;
slot_y=30;

pad=0.1;
padd=pad*2;

small_hole=10;
large_hole=13;

side_angle=17;
front_angle=20;

pad_x=55;
pad_y=32;
pad_offset=13;

pad_thick=7;

spring=6;
spring_lip=2;
spring_h=10;
spring_support_angle=35;
spring_offset=103;

splint_offset = slot_y+(max_x-slot_x)/2-2;
splint = 4;

difference() {
    translate([0,max_z/2,0])
    union() {
        //main shaft
        translate([max_x/2,0,max_z-max_x/2])
        rotate([-90,0,0])
        cylinder(d=max_x,h=max_y-max_z/2);

        //round end
        translate([0,0,0])
        cylinder(d=max_z,h=max_x);

        //square end
        cube([max_x,slot_y+(max_x-slot_x)/2-max_z/2,max_z]);
    }
    //slot
    translate([max_x/2-slot_x/2,-pad,-pad])
    cube([slot_x,slot_y+pad,max_z+padd]);

    //small hole
    translate([-pad,max_z/2,max_z/2])
    rotate([0,90,0])
    cylinder(d=small_hole,h=max_x+padd);

    //large hole
    translate([-pad,max_z/2,max_z/2])
    rotate([0,90,0])
    cylinder(d=large_hole,h=max_x/2+pad);

    translate([max_x,max_y,0])
    rotate([front_angle,0,side_angle])
    translate([-max_z*2,0,-max_z*2])
    cube([max_z*4,max_z*4,max_z*4]);
    
    translate([0,splint_offset,(max_x-slot_x)/2])
    rotate([0,90,0])
    #cylinder(d=splint,h=max_x+padd);

    translate([0,splint_offset*2,(max_x-slot_x)/2])
    rotate([0,90,0])
    #cylinder(d=splint,h=max_x+padd);

    translate([0,splint_offset*3,(max_x-slot_x)/2])
    rotate([0,90,0])
    #cylinder(d=splint,h=max_x+padd);

    translate([0,splint_offset*4,(max_x-slot_x)/2])
    rotate([0,90,0])
    #cylinder(d=splint,h=max_x+padd);

    translate([0,splint_offset*5,(max_x-slot_x)/2])
    rotate([0,90,0])
    #cylinder(d=splint,h=max_x+padd);
}
difference() {
    difference() {
        translate([max_x,max_y,0])
        rotate([front_angle,0,side_angle])
        translate([pad_x/2-max_x-pad_offset,0,0])
        rotate([90,0,0])
        scale([pad_x/100,pad_y*2/100,1])
        cylinder(d=100,h=pad_thick);

        translate([-max_z*2+max_x-pad_offset,max_y-max_z*2,-max_z*4])
        cube([max_z*4,max_z*4,max_z*4]);
    }
    translate([-max_y*2,-max_y*2,-max_y*4])
    cube(max_y*4);
}

module spring() {
    translate([-spring_h,spring_offset,0]) {
        cube([spring_h,spring/2,spring]);
        translate([0,spring/2,spring/2])
        rotate([0,90,0])
        cylinder(d=spring,h=spring_h);

        difference() {
            rotate([0,0,spring_support_angle])
            translate([0,-spring_h*2,0])
            cube([spring_h,spring_h*2,spring]);
            cube([spring_h*2,spring*2,spring*2]);
        }
        difference() {
            translate([0,spring/2,spring/2])
            rotate([0,-90,0])
            cylinder(d=spring+spring_lip*2,h=spring_lip);
            translate([-spring,-spring+spring/2,-spring_lip*2])
            cube([spring*2,spring*2,spring_lip*2]);
        }
    }
}
