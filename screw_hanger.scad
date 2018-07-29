// printer options
extrusion_width=1.2;
layer_h=0.4;

// options
screw=6; // diameter of hole for screw threads
screw_head=9.5; // outer diameter of screw head
screw_head_lip=1; // height of outer lip of screw head

height=58; // total height of hanger
wall=extrusion_width; // how thick the wall of the shaft should be
head_d=3; // diameter of circle that goes around the edge of the screw head
base=20; // diameter of base
base_h=layer_h*2; // height of base (does not include rounding to shaft)

//calcualted 
$fn=90;
pad=0.1;
padd=pad*2;
body=screw+wall*2;
head_r=head_d/2;
screw_head_h=(screw_head-screw)/2;
base_r=(base-body)/2;
total_base_h=base_h+base_r;

module complete() {
    complete_no_base();
    base();
}

module complete_no_base() {
    difference() {
        body();
        screw();
    }
}

module body() {
    head();
    shaft();
}

module head() {
    hull() {
        head_3d();
        translate([0,0,head_r])
        cylinder(h=head_r*1.5,d=body);
    }
}

module head_3d() {
    translate([0,0,head_d/2])
    rotate_extrude(angle=360, convexity=2) {
        head_2d();
    }
}

module head_2d() {
    translate([body/2,0,0])
    circle(d=head_d);
}

module shaft() {
    translate([0,0,head_r])
    cylinder(h=height-head_r,d=body);
}

module screw_shaft() {
    cylinder(h=height+pad,d=screw);
}

module screw_head() {
    // top lip
    translate([0,0,-pad])
    cylinder(d=screw_head,h=screw_head_lip+pad);

    // slice in between to make preview cleaner
    translate([0,0,screw_head_lip-pad])
    cylinder(d=screw_head-padd,h=padd);
    
    // angled part 
    translate([0,0,screw_head_lip])
    cylinder(h=screw_head_h+pad,d2=screw,d1=screw_head);
}

module screw() {
    screw_head();
    screw_shaft();
}

module base() {
    difference() {
        base_positive();
        screw();
    }
}

module base_positive() {
    translate([0,0,height-total_base_h])
    rotate_extrude(angle=360, convexity=2)
    difference() {
        square([base/2,total_base_h]);
        translate([base/2,0])
        circle(base_r);
    }
}

module spaced() {
    for ( i= [0:1:$children-1])
    translate([0,base*i,0])
    children(i);
}

module label(string) {
    translate([base,-screw_head/2,0])
    linear_extrude(pad)
    text(string, height=screw_head);
    children();
}

module timeline() {
    spaced() {
        label("to_print") to_print() complete();
        label("complete") complete();
        label("complete_no_base") complete_no_base();
        label("head")
        difference() {
            head();
            #screw();
        }
        label("head_3d")
        difference() {
            head_3d();
            #screw();
        }
        label("head_2d")
        union() {
            head_2d();
            #screw();
        }
        label("screw")screw();
        label("screw_head")screw_head();
    }
}

module to_print() {
    translate([0,0,height])
    mirror([0,0,1])
    children();
}

// https://www.thingiverse.com/thing:2985920
display="";
if (display == "") timeline();
if (display == "screw_hanger.stl") to_print() complete();
if (display == "screw_hanger_no_base.stl") to_print() complete_no_base();
