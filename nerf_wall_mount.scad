dart=15;
guard_z=52;
dart_h=guard_z;
dart_wall=1;

darts=12;
dart_gap=dart+dart_wall;

key=7;

key_h=dart_h;


gun_wall=dart_wall;
gun=31;

guard_x=25;
guard_y=11;
guard_h=14;

barrel=23;
barrel_h=guard_z;

pad=0.1;

magnet=10;
magnet_h=3;

magnet_wall=8;
magnet_od=magnet+magnet_wall*2;

$fn=90;


module pie_slice(r, start_angle, end_angle) {
    // http://forum.openscad.org/Creating-pie-pizza-slice-shape-need-a-dynamic-length-array-td3148.html
    R = r * sqrt(2) + 1;
    a0 = (4 * start_angle + 0 * end_angle) / 4;
    a1 = (3 * start_angle + 1 * end_angle) / 4;
    a2 = (2 * start_angle + 2 * end_angle) / 4;
    a3 = (1 * start_angle + 3 * end_angle) / 4;
    a4 = (0 * start_angle + 4 * end_angle) / 4;
    if(end_angle > start_angle)
        intersection() {
        circle(r);
        polygon([
            [0,0],
            [R * cos(a0), R * sin(a0)],
            [R * cos(a1), R * sin(a1)],
            [R * cos(a2), R * sin(a2)],
            [R * cos(a3), R * sin(a3)],
            [R * cos(a4), R * sin(a4)],
            [0,0]
       ]);
    }
}

module inner_tube(d,h,wall) {
    translate([0,0,wall])
    cylinder(d=d,h=h+wall);
}

module tube(d,h,wall) {
    difference() {
        cylinder(d=d+wall*2,h=h+wall);
        inner_tube(d,h,wall);
    }
}

key_angle=75;

dart_hole=dart-5;

module dart() {
    difference() {
        tube(dart,dart_h,dart_wall);
        //translate([-key/2,-dart,dart_h+dart_wall-key_h])
        //cube([key,dart,key_h+pad]);


        translate([0,0,-pad])
        cylinder(d=dart_hole,h=dart_wall+pad*2);
        translate([0,0,-pad])
        rotate([0,0,-90])
        linear_extrude(height=dart_h+pad*2+dart_wall)
        pie_slice(dart,-key_angle/2,key_angle/2);
    }
}


module darts() {
    translate([dart/2,-dart/2-magnet_h])
    for(x=[0:dart_gap:dart_gap*darts-1])
    translate([x,0])
    children();
}

module magnets() {
    translate([dart_gap*(darts-2),0,dart_h/2])
    children();

    //translate([-barrel,0,dart_h/2])
    translate([0,0,dart_h/2])
    children();
    //translate([dart_gap,0,magnet_od/2]) children();

    //translate([dart_gap,0,dart_h-magnet_od/2]) children();
}

module magnet(wall=0,padding=0,backing=0) {
    translate([0,padding])
    rotate([90,0])
    cylinder(d=magnet+wall*2,h=magnet_h+padding+backing);
}

module place_gun() {
    translate([-barrel/2-gun_wall,-gun/2])
    children();
}

module preassembly() {
    place_gun()
    gun();
    darts()
    dart();

    difference() {
        magnets()
            magnet(magnet_wall,0,dart/2);

        darts()
        cylinder(d=dart+dart_wall*2-pad*2,h=dart_h);

        place_gun() {
            inner_tube(barrel,barrel_h,gun_wall);
            guard(gun_wall,pad);
        }

    }


}

screw=2.7;
screw_h=dart/2;

difference() {
    preassembly();
    magnets()
    rotate([90,0])
    translate([0,0,-pad])
    cylinder(d=screw,h=screw_h+pad);

    magnets()
    magnet(0,pad);
}

barrel_hole=dart;

module gun() {
    difference() {
        union() {
            difference() {
                tube(barrel,barrel_h,gun_wall);
                guard(gun_wall,pad);
                inner_guard(gun_wall,pad);
            }
            difference() {
                guard(gun_wall);
                guard(0,pad);
                inner_tube(barrel,barrel_h,gun_wall);
            }
        }
        translate([0,0,-pad])
        cylinder(d=barrel_hole,h=gun_wall+pad*2);
    }
}

function segment_height(radius, chord) = radius*(1-cos(asin(chord/2/radius)));

op=guard_h;
ad=guard_x+segment_height(barrel/2+gun_wall,guard_y+gun_wall*2);
an=atan(op/ad);
cross=cos(an)*op;
hy=ad/cos(an)+1; // close enough

module guard(wall=0,padding=0) {
    difference() {
        translate([-guard_x-barrel/2-wall,-guard_y/2-wall,gun_wall-wall])
        cube([guard_x+barrel/2+wall+padding,guard_y+wall*2,guard_z+wall+padding]);
        inner_guard(wall,padding);
    }
}

module inner_guard(wall,padding) {
    translate([-barrel/2-gun_wall-guard_x+ad,0,gun_wall/cos(an)-wall/cos(an)])
    rotate([0,an])
    translate([-hy,-guard_y/2-wall-pad,-cross])
    cube([hy,guard_y+wall*2+pad*2,cross+pad]);
}
