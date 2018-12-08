// outer diameter of button
edge=75;
edge=75.5;
// diameter of middle 
middle=73;
middle=72;
// how tall feet are 
feet=3.5;
feet=3.7;

// distance from edge to middle
to_middle=10;
to_middle=8;

top_offset=5;
bottom_offset=edge/6;

extrusion_width=0.36;
wall=extrusion_width*2;
extrusion_width=1.2;
layer_height=0.4;
wall=extrusion_width;
walll=wall*2;

tack=11;
tack_h=2;
tack_stem=3;
tack_pad=20;
tack_pad_from_edge=0;
tack_offset=edge/3;
pad=0.1;
padd=pad*2;

base=wall;

$fn=400;

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

module cut_base() {
    difference() {
        base();
        top();
        bottom();
    }
}

module tack_hole(y=tack_offset) {
    translate([0,y,-base-pad])
    cylinder(d=tack_stem,h=base+padd,$fn=4);
}

module round_base() {
    difference() {
        base();
        mirror([0,1,0])
        tack_hole(-edge/2-wall+bottom_offset+tack_pad/2);
        tack_hole(-edge/2-wall+bottom_offset+tack_pad/2);
        bottom();
        mirror([0,1,0])
        bottom();
    }
}

module base_with_tacks() {
    difference() {
        hull() {
            cut_base();
            tacks();
        }
        tack_hole();
        tack_hole(-edge/2+bottom_offset+tack_pad/2);
    }
}

module base_block() {
    hull() {
        translate([0,0,feet+to_middle])
        base_with_tacks();
        base_with_tacks();
    }
}

module assembled() {
    difference() {
        body(walll,0);
        body(0,pad);

        mirror([0,1,0])
        bottom();
        //top();
        bottom();
    }
    round_base();
}


module tacks() {
    translate([0,tack_offset,-base])
    cylinder(d=tack_pad,h=base);
}

module top() {
    translate([-edge/2-wall-pad,+top_offset,-pad-base])
    cube([edge+walll+padd,edge+walll,feet+to_middle+pad*2+base]);
}

module bottom() {
    translate([-edge/2-wall-pad,-edge-walll-edge/2-wall+bottom_offset,-pad-base])
    cube([edge+walll,edge+walll,feet+to_middle+pad*2+base]);
}


rotate([90,0,0])
assembled(); 

brim=10;
module brim() {
    translate([-brim/2-edge/2,-to_middle-feet-brim/2,-edge/2+bottom_offset-layer_height-wall])
    cube([edge+brim,to_middle+feet+brim+base,layer_height]);
}
