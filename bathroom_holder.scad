z = 90;

//bathroom holder
boxes = [
    [21], // marker
    [32.5], // flonaise
    [10, 36], // comb
    [55, 30], // toothpaste
    [25], // toothbrush 
    [25], // toothbrush
];

boxes = [
    [194, 26]
];
z = 140;
edge = 10;


//mice
boxes = [
    [93, 17], // keyboard thing
    [62, 40], // mouse
    [40, 20], // fire TV
];
z = 60;

//remotes
boxes = [
    [61, 25], // denon
    [57, 30], // projector
];
z = 80;

// whal peanut electric razor
boxes = [
    [7],       // brush
    [21],       // oil
    [38, 24],   // s4
    [38, 20],   // s3
    [38, 16],   // s2
    [38, 12],   // s1
];
z = 32;



function my_sum(i, total=0) =
    i==0 ?
        total + boxes[0][0] :
        my_sum(i - 1, total + boxes[i][0]);

module all_shapes(move=0, grow=0) {
    for (n = [0:len(boxes)-1]) {
        if (boxes[n][1] == undef) {
            translate([my_sum(n)-boxes[n][0]/2+n*move+move,boxes[n][0]/2,0])
            cylinder(d=boxes[n][0]+grow*2, h=z);
        } else {
            translate([my_sum(n)-boxes[n][0]-grow+n*move+move,-grow,0])
            cube([boxes[n][0]+grow*2, boxes[n][1]+grow*2, boxes[n][2] != undef ? boxes[n][2] : z]);
        }
    }
}

// rostock
wall=1.2;
// i3
wall=0.35;
screw=3;
head=10;
screw_offset=z/5;

module assembled() {
    difference() {
        hull()
        all_shapes(wall*2, wall*2);
        translate([0,0,wall])
        all_shapes(wall*2, 0);
        for (n = [screw_offset, z-screw_offset]) {
            translate([(my_sum(len(boxes)-1)+wall*2*len(boxes)+wall)/2,0,n])
            rotate([-90,0,0]) {
                cylinder(d=head,h=100);
                translate([0,0,-wall*2])
                cylinder(d=screw,h=100);
            }
        }
    }
}

module fine() {
    $fn=200;
    assembled();
}

display="";
if (display == "") assembled();
if (display == "bathroom_holder.stl") fine();
