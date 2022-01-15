d1=12;
d2=12;
d3=8;
d4=16;


// looking at right hand side of bike
//
// d1         d2
//
//     d3
//
// (d4 is sligt bump by screw)

// measuring to outside edges
d1_d2=39-d1/2-d2/2;
d2_d3=32-d2/2-d3/2;
d3_d1=23-d3/2-d1/2;

// d4 is assumed to be tangent to d1 and d3


function law_of_cosines(a,b,c) = acos(((a*a)+(b*b)-(c*c))/(2*a*b));
d1_angle=law_of_cosines(d1_d2, d3_d1, d2_d3);

d4_angle=law_of_cosines(d3_d1,(d1/2+d4/2),(d3/2+d4/2));

module node1(x=0) {
    circle(d=d1-x);
}

module node2() {
    translate([d1_d2,0])
    circle(d=d2);
}

module node3(x=0) {
    rotate([0,0,-d1_angle])
    translate([d3_d1,0])
    circle(d=d3-x);
}

module node4() {
    rotate([0,0,-d1_angle-d4_angle])
    translate([d1/2+d4/2,0])
    circle(d=d4);
}
$fn=200;
difference() {
    union() {
        hull() {
            node1();
            node2();
        }
        hull() {
            node2();
            node3();
        }

        hull() {
            //x=d1/2-sin(d4_angle)*(d1/2);
            // just guessing this for now
            node1(2);
            node2();
            node3(2);
        }
    }   
    node4();
}
