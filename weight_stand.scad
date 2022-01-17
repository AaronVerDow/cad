bar=50;
bar_depth=bar*1.3;

bar_angle=45;


side_angle=17;
bar_opening=20;

top_gap=300;
bottom_gap=500;

levels=7;

tip=top_gap*2.6;

pad=0.1;

inc=(bottom_gap-top_gap)/levels;

in=25.4;
wood=in/2;

hand=200;

big_fn=400;

pi=3.141592653589793238462643383279502884197169399375105820974944592307816406286208998;

base=tip*2.3; // fix with trig
base_extra=150;
base_angle=side_angle;

function y(n, total=0) = 
    n==0 ?
        total + top_gap :
        y(n-1, total+top_gap+n*inc);


function pie_angle(arc,radius) = (arc*180)/(pi*radius);
function chord(radius,angle) = 2*radius*sin(angle/2);
function segment_radius(height, chord) = (height/2)+(chord*chord)/(8*height);

arc=y(levels);
radius=arc*0.8;
angle=pie_angle(arc,radius);
chord=chord(radius,angle);

slot=bar_depth+(bar/tan(bar_angle)+pad);

zero=0.01;

side_height=chord*cos(side_angle);

// stab = stabalizer

stab=1000;
stab_h=side_height/2;
//stab_base=base_extra;
stab_base=wood;
stab_angle=0;
//stab_angle=base_angle;
//stab_angle=8.7;

module curve_bars() {
    rotate([0,0,angle/2])
    translate([-radius,0]) {
        circle(r=radius,$fn=big_fn);
        for(n=[0:1:(levels-1)])
        // translate([0,-y(n)])
        rotate([0,0,-pie_angle(y(n),radius)])
        translate([radius,0])
        bar();
    }
    // translate([0,-chord]) color("lime") square([10,chord]);
}

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

module base() {
    side=side_height*2;  // fix with trig later
    hull()
    dirror_x()
    translate([-base/2,0])
    rotate([0,0,base_angle])
    square([zero,side]);
}


module side() {
    offset(corners)
    offset(-corners) {
        difference() {
            intersection() {
                translate([0,side_height+base_extra])
                hull()
                dirror_x()
                translate([tip/2,0])
                rotate([0,0,side_angle])
                translate([0,-chord])
                square([zero,chord]);
                base();
            }
       
            translate([0,side_height+base_extra])
            dirror_x()
            translate([-tip/2,0])
            rotate([0,0,-side_angle])
            curve_bars();
           
            //dirror_x()
            //translate([-tip/2,0])
            //rotate([0,0,-side_angle])
            //bars();
        }
        intersection() {
            base();
            translate([-base*2,0])
            square([base*4,base_extra+pad]);
        }
    }
}

module bars() {
    for(n=[0:1:(levels-1)])
    translate([0,-y(n)])
    bar();
}

module assembled() {
    color("sienna")
    dirror_y()
    translate([0,hand/2+pad])
    rotate([90,0])
    linear_extrude(height=wood)
    side();

    color("peru")
    dirror_x()
    translate([-hand/2,0])
    rotate([90,0,90])
    linear_extrude(height=hand/2)
    stabalizer();

    color("tan")
    linear_extrude(height=wood)
    bottom();

    color("tan")
    translate([0,0,side_height+base_extra-wood+pad])
    linear_extrude(height=wood)
    top();
}

assembled();

//!stabalizer();

stab_inset=100;

//!stabalizer();

module stabalizer() {
    adj=stab_h-stab_base;
    opp=stab_base*tan(stab_angle)+stab/2-hand/2;
    delta=atan(opp/adj);
    hyp=sqrt((adj*adj)+(opp*opp));
    rad=segment_radius(stab_inset,hyp);

    translate([-hand/2,0])
    square([hand,side_height+base_extra]);

    difference() {
        hull() {
            translate([-hand/2,0])
            square([hand,stab_h]);
            hull() {
                hyp = stab_base/cos(stab_angle);
                dirror_x()
                translate([-stab/2,0])
                rotate([0,0,stab_angle])
                square([zero,hyp]);
            }
        }
        dirror_x()
        translate([hand/2,stab_h])
        rotate([0,0,90+delta])
        translate([-hyp/2,stab_inset-rad])
        circle(r=rad,$fn=big_fn);
    }
}

module bottom() {
    square([base,hand],center=true);
    rotate([0,0,90])
    square([stab,hand],center=true);
}

//top_wall=(stab-hand)/2;
top_wall=200;
top_x=tip+top_wall*2;
top_y=hand+top_wall*2;
top_r=20;

module top() {
    offset(top_r)
    offset(-top_r)
    square([top_x,top_y],center=true);
}
