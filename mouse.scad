max_l=130;
max_w=90;
max_h=60;
pad=0.1;
padd=pad*2;

punch_d=20;
punch_r=punch_d/2;

io_d=15;
io_r=io_d/2;

io_d2=80;
io_r2=io_d2/2;

batt_w=40;
batt_l=55;
diff_h=max_h+padd;

difference() {
    cube([max_w,max_l,max_h]);
    translate([0,0,-pad]) {
        translate([70,75,0])
        cylinder(h=diff_h,r=punch_r);
        translate([20,78,0])
        cylinder(h=diff_h,r1=io_r,r2=io_r2);
        translate([20,8,0])
        rotate([0,0,10])
        cube([batt_w,batt_l,diff_h]);
    }
    translate([max_w,0,max_h])
    rotate([0,-atan(max_h/max_w),0])
    translate([-max_w*2+pad,-pad,0])
    cube([max_w*2,max_l+padd,max_h*2]);
    translate([max_w,0,0])
    rotate([0,-atan(max_h/max_w)+90,0])
    translate([-max_w*2+pad,-pad,0])
    cube([max_w*2,max_l+padd,max_h*2]);
}
