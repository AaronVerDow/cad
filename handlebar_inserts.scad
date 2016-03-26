$fn=120;
total_h=29;
reverse_taper=0.4;
max_d=15.7;
max_r=max_d/2;
min_d=9;
min_r=min_d/2;
large_d=13;
large_r=large_d/2;
pad=0.1;
padd=pad*2;
distance_to_min=15;

throttle_d=18;
throttle_r=throttle_d/2;
throttle_h=10;

gap=0.3;
distance_to_gap=9;

module one_gap() {
    translate([-max_r-pad,-gap/2,distance_to_gap])
    cube([max_d+padd,gap,total_h+padd]);
}

difference() {
    union() {
        translate([0,0,throttle_h])
        cylinder(r1=max_r,r2=max_r-reverse_taper,h=total_h-throttle_h);
        cylinder(r=throttle_r,h=throttle_h);
    }
    translate([0,0,-pad])
    cylinder(r=min_r,h=total_h-distance_to_min+padd);
    translate([0,0,total_h-distance_to_min])
    cylinder(r1=min_r,r2=large_r,h=distance_to_min+pad);
    one_gap();
    rotate([0,0,90])
    one_gap();
}
