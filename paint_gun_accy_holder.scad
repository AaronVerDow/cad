//bathroom holder
qtip=40;
boxes = [
	[qtip],// qtips
	[4,44], // multi wrench
	[20,40],// stirrers
	[12,27],	// 13mm wrench
	[20], // toothbrush
	[20], 	// marker
	//[47,15], // tip
	//[47,15], // tip
	//[12], 	//	adjustment knob 
	//[7],		// spring	
];
// pen 4
// tip tip 12.5

z = 90;
edge = 10;

$fn=90;



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

// i3
wall=0.35;
screw=3;
head=10;
screw_offset=z/5;
qtip_h=50;

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
    translate([qtip/2,qtip/2,0])
    cylinder(d=qtip,h=z-qtip_h);
}

module fine() {
    $fn=200;
    assembled();
}

display="";
if (display == "") assembled();
if (display == "bathroom_holder.stl") fine();
