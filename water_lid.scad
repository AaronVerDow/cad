// cartridge case terminology
mouth=66;
neck=71;
neck_h=25;
shoulder=15; // how high is shoulder
body=84;
body_h=250;
max_h=body_h+shoulder+neck_h;

pad=0.1;

$fn=390;

base=body-pad*2; // base od
base_h=neck_h+shoulder-3; // how far it goes down from mouth opening
lip=1;

cutaway_x=body*1.1;
cutaway_y=body*1.2;
cutaway_z=body*0.7;

lid=base;

pivot_y=5;
lid_h=pivot_y;

screw=2.7;
pivot=pivot_y*2;
pivot_center=10;
pivot_side=10;
pivot_gap=0.3;

pivot_support=20;

stopper=mouth-2;
stopper_h=base_h/2;


module bottle_positive() {
    translate([0,0,-lip-neck_h-pad*3])
    cylinder(d=neck,h=neck_h+pad*3);
    translate([0,0,-lip-neck_h-shoulder])
    cylinder(d2=neck,d1=body,h=shoulder);
    translate([0,0,-lip-neck_h-shoulder-body_h])
    cylinder(d=body,h=body_h);
}

module water(extra=0) {
    h=neck_h+shoulder+body_h*0.8;
    translate([0,0,-h+pad])    
    cylinder(d=mouth+extra,h=h);
}

module bottle() {
    color("silver")
    difference() {
        bottle_positive();
        water();
    }
}

tooth=base_h/2;

module lid() {
    cylinder(d=lid,h=lid_h);
    translate([0,-base/2-pivot_y])
    stopper();
    difference() {
        intersection() {
            translate([0,0,-tooth])
            cylinder(d=base,h=tooth);
            cutaway(1);
        }
        bottle_positive();
    }
}

module stopper() {
    difference() {
        translate([0,base/2+pivot_y,-stopper_h])
        cylinder(d=stopper,h=stopper_h);
        for(a=[0:5:20]) {
            stopper_clearance(a);
        }
    }
}

module stopper_clearance(a=0) {
    echo(a);
    rotate([-a,0])
    difference() {
        translate([0,base/2+pivot_y,-stopper_h*2])
        cylinder(d=stopper*2,h=stopper_h*2);
        translate([0,base/2+pivot_y,0])
        water();
    }

}


module screw() {
    rotate([0,90,0])
    cylinder(d=screw,h=pivot_center+pivot_side*2+pivot_gap*2+3,center=true);
}

module base_positive() {
}


module cutaway(gap=0) {
    translate([0,base/2,0])
    scale([cutaway_x-gap,cutaway_y-gap,cutaway_z-gap])
    sphere(d=1);
}


module base() {
    color("cyan")
    difference() {
        union() {
            translate([0,0,-base_h])
            cylinder(d=base,h=base_h);
            translate([0,-base/2-pivot_y])
            base_pivot();
        }
        bottle_positive();
        water((neck-mouth)/2);
        cutaway();
    }
}
//translate([0,base/2+pivot_y,0]) cutaway(5);


module final_base() {

    color("cyan") {
        translate([0,base/2+pivot_y])
        base();
    }
}
module base_pivot(extra=0) {
    difference() {
        union() {
            hull() {
                bottom()
                _base_pivot(extra);
                intersection() {
                    translate([0,base/2+pivot_y,-pivot_support])
                    cylinder(d=base,h=pivot_support);
                    cube([pivot_center+extra,pivot_y*4,pivot_support*2],center=true);
                }
            }
            _base_pivot(extra);
        }
        screw();
    }


}


module _base_pivot(extra=0) {
    color("cyan")
    rotate([0,90,0])
    cylinder(d=pivot,h=pivot_center+extra,center=true);
}
module final_lid() {
    rotate([0,0,0])
    translate([0,base/2+pivot_y])
    lid();
    difference() {
        dirror_x()
        lid_pivot();
        screw();
    }
}

module bottom() {
    difference() {
        children();
        cylinder(d=1000,h=1000);
    }
}



module top() {
    difference() {
        children();
        translate([0,0,-1000])
        cylinder(d=1000,h=1000);
    }
}


module lid_pivot() {
    hull() {
        top()
        _lid_pivot();
        translate([pivot_center/2+pivot_gap,0])
        cube([pivot_side,pivot_support,lid_h]);
    }
    _lid_pivot();
}
module _lid_pivot() {
        translate([pivot_center/2+pivot_gap,0])
        rotate([0,90,0])
        cylinder(d=pivot,h=pivot_side);
}

module dirror_x() {
    children();
    mirror([1,0,0])
    children();
}



// RENDER stl
module nothing() {
}

module final_final_lid() {
    difference() {
        final_lid();
        rotate([-270,0])
        base_pivot(pivot_gap*2);
    }
}

//final_final_lid();
final_base();
