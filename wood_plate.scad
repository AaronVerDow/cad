$fn=45;
h=1;
max_l=215;
max_w=215;
pad=0.1;
padd=pad*2;

screw_l=209;
screw_w=209;

screw_d=3;
screw_r=screw_d/2;

center_l=35;
center_w=35;

cut_l=35;
cut_w=50;

slide_l=30;
slide_w=10;

slide_off_l=35;
slide_off_w=62;


projection()
difference() {
    cube([max_l,max_w,h]);
    translate([0,0,-pad]) {
        translate([(max_l-screw_l)/2,(max_w-screw_w)/2,0])
        cylinder(r=screw_r,h=h+padd);
        translate([(max_l-screw_l)/2+screw_l,(max_w-screw_w)/2,0])
        cylinder(r=screw_r,h=h+padd);
        translate([(max_l-screw_l)/2+screw_l,(max_w-screw_w)/2+screw_w,0])
        cylinder(r=screw_r,h=h+padd);
        translate([(max_l-screw_l)/2,(max_w-screw_w)/2+screw_w,0])
        cylinder(r=screw_r,h=h+padd);

        translate([max_l/2-center_l/2,max_w/2-center_w/2,0])
        cube([center_l,center_w,h+padd]);

        translate([max_l/2-cut_l/2,max_w-cut_w+pad,0])
        cube([cut_l,cut_w,h+padd]);

        translate([slide_off_l,slide_off_w,0])
        cube([slide_l,slide_w,h+padd]);
        translate([max_l-slide_off_l-slide_l,slide_off_w,0])
        cube([slide_l,slide_w,h+padd]);

        translate([slide_off_l,max_w-slide_off_w-slide_w,0])
        cube([slide_l,slide_w,h+padd]);
        translate([max_l-slide_off_l-slide_l,max_w-slide_off_w-slide_w,0])
        cube([slide_l,slide_w,h+padd]);


    }
}
