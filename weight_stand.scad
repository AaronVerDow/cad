bar=50;
bar_depth=bar*1;

bar_angle=45;


side_angle=10;
bar_opening=20;

top_gap=300;
bottom_gap=350;

levels=7;

tip=top_gap;

pad=0.1;

inc=(bottom_gap-top_gap)/levels;

in=25.4;
wood=in/2;

hand=200;

function y(n, total=0) = 
    n==0 ?
        total + top_gap :
        y(n-1, total+top_gap+n*inc);




slot=bar_depth+(bar/tan(bar_angle)+pad);

zero=0.01;


module busted() {
    //translate([sin(bar_angle)*bar_depth,0])
    hull() {
        rotate([0,0,-bar_angle])
        translate([-slot,0])
        circle(d=bar);
        circle(d=bar);
    }
}


module bar(){ 

    //rotate([0,0,bar_angle]) {
        //color("blue")
        //square([bar,slot]);

    translate([sin(bar_angle)*bar_depth,0])
    rotate([0,0,bar_angle])
        hull() {
            translate([bar/2,0])
            circle(d=bar);
            translate([bar/2,slot*2])
            circle(d=bar);

            translate([bar/2,0])
            rotate([0,0,-bar_opening])
            translate([0,slot*2])
            circle(d=bar);
        }
}

//!bar();

module dirror_x() {
    children();
    mirror([1,0,0])
    children();
}
module dirror_y() {
    children();
    mirror([0,1,0])
    children();
}



corners=bar/3;


module side() {
    translate([0,y(levels)]) // fix later with trig
    offset(corners)
    offset(-corners)
    difference() {
        hull()
        dirror_x()
        translate([tip/2,0])
        rotate([0,0,side_angle])
        translate([0,-y(levels)])
        square([zero,y(levels)]);
       
        dirror_x()
        translate([-tip/2,0])
        rotate([0,0,-side_angle])
        for(n=[0:1:(levels-1)])
        translate([0,-y(n)])
        bar();
    }
}

dirror_y()
translate([0,hand/2])
rotate([90,0])
linear_extrude(height=wood)
side();
