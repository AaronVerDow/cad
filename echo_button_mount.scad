// outer diameter of button
edge=75.5;

// diameter of middle 
middle=72;

// how tall feet are 
feet=3.7;

// distance from edge to middle
to_middle=8;

cut_offset=edge/6;

// printer settings
extrusion_width=1.2;
layer_height=0.4;

// thickness of the sides
wall=extrusion_width;
walll=wall*2;

// thickness of back of part
base=wall;

// used for first layer adhesion issues
brim=10;

tack_stem=3;
tack_pad=20;

// pad negative space for clean renders
pad=0.1;
padd=pad*2;

module body(extra=0,padding=0) {
    translate([0,0,feet-padding])
    cylinder(d1=edge+extra,d2=middle+extra-padding*2,h=to_middle+padding*2);
    translate([0,0,-padding])
    cylinder(d=edge+extra,h=feet+padding);
}

module base() {
    translate([0,0,-base])
    cylinder(d=edge+walll,h=base);
}

module tack_hole(y) {
    translate([0,y,-base-pad])
    cylinder(d=tack_stem,h=base+padd,$fn=4);
}

module tack_holes() {
    tack_hole(-edge/2-wall+cut_offset+tack_pad/2);
    mirror([0,1,0])
    tack_hole(-edge/2-wall+cut_offset+tack_pad/2);
}

module cut() {
    translate([-edge/2-wall-pad,-edge-walll-edge/2-wall+cut_offset,-pad-base])
    cube([edge+walll,edge+walll,feet+to_middle+pad*2+base]);
}

module cuts() {
    cut();
    mirror([0,1,0])
    cut();
}

module assembled() {
    difference() {
        union() {
            body(walll,0);
            base();
        }
        body(0,pad);
        cuts();
        tack_holes();
    }
}

module brim() {
    translate([-brim/2-edge/2,-to_middle-feet-brim/2,-edge/2+cut_offset-layer_height-wall])
    cube([edge+brim,to_middle+feet+brim+base,layer_height]);
}

module to_print() {
    $fn=400;
    rotate([90,0,0])
    assembled(); 
}

// https://www.thingiverse.com/thing:2985920
display="";
if (display == "") assembled(); 
if (display == "echo_button_mount.stl") to_print(); 
if (display == "echo_button_mount_with_brim.stl") {
    to_print();
    brim();
}
