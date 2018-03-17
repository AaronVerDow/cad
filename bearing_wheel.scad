screws=6;
screw=2.5;
screw_gap=0.8;
head=6;

bearing=22;
bearing_w=7;

wheel=43;
wheel_w=bearing_w;

edge=2*2;

pad=0.1;
padd=pad*2;
$fn=90;

difference () {
    // outer wheel
    translate([0,0,edge/2])
    minkowski() {
        cylinder(d=wheel-edge, h=wheel_w-edge);
        sphere(d=edge);
    }
    translate([0,0,-pad]) {
        // big inner hole
        cylinder(d=bearing, h=wheel_w+padd);
        for(angle=[0:360/screws:359]) {
            rotate([0,0,angle])
            translate([bearing/2+screw/2+screw_gap,0,0]) {
                // screw holes
                cylinder(d=screw, h=wheel_w+padd);

                // visualize screw heads
                difference() {
                    translate([0,0,bearing_w+pad])
                    scale([1,1,0.5])
                    #sphere(d=head);
                    // cut off bottom so the actual wheel is not modified
                    cylinder(d=head+padd, h=wheel_w+pad);
                }
            }
        }
    }
}
