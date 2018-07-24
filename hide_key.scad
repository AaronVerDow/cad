pin=13;
hitch=35;
hitch_r=10;
hitch_d=hitch_r*2;
depth=100;
pin_depth=40;
pad=0.1;
padd=pad*2;
wall=3;
finger=20;

inner_hitch=hitch-hitch_d;
inner_cube=[inner_hitch,inner_hitch,depth/2];
storage_h=depth-pin_depth-wall*2-pin/2;
storage_d=hitch_d-wall*2;
storage=[hitch-wall*2,hitch-wall+pad,depth-pin_depth-wall*2-pin/2];
inner_storage=hitch-wall*2-storage_d;
inner_storage_cube=[inner_storage,hitch,storage_h/2];

module assembled() {
    difference() {
        translate([-inner_hitch/2,-inner_hitch/2,0])
        minkowski() {
            cube(inner_cube);
            cylinder(d=hitch_d, h=depth/2);
        }
        translate([-hitch/2-pad,0,pin_depth])
        rotate([0,90,0])
        cylinder(d=pin,h=hitch+padd);
        translate([-inner_storage/2,0,pin_depth+pin/2+wall])
        minkowski() {
            cube(inner_storage_cube);
            cylinder(d=storage_d, h=storage_h/2);
        }
        difference() {
            sphere(d=finger);
            translate([-hitch/2,0,0])
            cube([hitch,hitch,wall]);
        }
    }
}

module fine() {
    $fn=90;
    assembled();
}

display="";
if (display == "") assembled();
if (display == "hide_key.stl") fine();
