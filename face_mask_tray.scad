x=230;
y=150;
z=50;
$fn=200;
wall=1.2;
walll=wall*2;
z_wall=wall;
pad=0.1;
padd=pad*2;

grip=7;
grip_angle=50;

lip=grip;

lock=4;
lock_delta=0.5;
lock_h=2;
locks=2;

circles=7;
gap=9;

module body() {
    cube([x,y,z]);
}

module tray() {
    difference() {
        body();
        translate([wall,-pad,z_wall])
        cube([x-walll,y-wall+pad,z-z_wall+pad]);
    }
    all_grips();
    all_locks();
    cube([x,wall,lip]);
}

module grip_positive() {
    translate([grip,0,z])
    rotate([0,grip_angle,0])
    translate([-grip,0,-z])
    cube([grip,y,z]);
}

module grip() {
    intersection() {
        grip_positive();
        body();
    }
}

module grips() {
    grip();
    translate([x,0,0])
    mirror([1,0,0]) 
    grip();
}

module all_grips() {
    grips();
    translate([0,0,z+wall-pad])
    mirror([0,0,1]) 
    grips();
}

module lock(delta=0,y=0) {
    translate([grip/2,y,z])
    #cylinder(d=lock+delta,h=lock_h+delta*30);
}

module locks(delta=0) {
    for(i=[y/locks/2:y/locks:y-1]) {
        lock(delta,i);
    }
}

module all_locks(delta=0) {
    locks(delta);
    translate([x,0,0])
    mirror([1,0,0]) 
    locks(delta);
}

module divider() {
    cube([wall,y,z]);
}

module dividers(count=0) {
    for(i=[x/(count+1):x/(count+1):x-1]) {
        translate([i,0,0])
        divider();
    }
}


difference() {
    tray();
    translate([0,0,-z-pad])
    all_locks(lock_delta);

    //translate([grip,0,-pad])
    //linear_extrude(height=wall+padd)
    //circle_pattern(x-grip*2,y);
}

module diamond_pattern() {

}

module pattern_hole(d,x,y) {
    translate([x,y])
    circle(d=d);
}

module circle_pattern(pat_x=100,pat_y=100) {
    circle=pat_x/circles-gap;
    translate([circle/2+gap/2,circle/2+gap/2,0])
    for(x=[0:circle+gap:pat_x-1]){
        for(y=[0:circle+gap:pat_y-1]){
            pattern_hole(circle,x,y);
        }
    }
    translate([circle+gap,circle+gap,0])
    for(x=[0:circle+gap:pat_x-circle-gap-1]){
        for(y=[0:circle+gap:pat_y-1-circle-gap]){
            pattern_hole(circle,x,y);
        }
    }
}

dividers(1);
