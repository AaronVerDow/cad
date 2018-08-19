extrusion_width=1.2;
pin=14;
layer_h=0.4;
hitch=32;
hitch_r=5;
hitch_d=hitch_r*2;
pin_depth=45+pin/2;
depth=100+pin_depth+pin;
pad=0.1;
padd=pad*2;
wall=extrusion_width*2;
ring_wall=extrusion_width;
ring_offset=3;
finger=20;
raft=40;
ring_support=hitch/4;

storage=hitch-wall*2;
storage_h=depth-pin_depth-wall*2-pin/2; //fill all space
storage_h=80;

module body() {
	inner_hitch=hitch-hitch_d;
	inner_cube=[inner_hitch,inner_hitch,depth/2];
	translate([-inner_hitch/2,-inner_hitch/2,0])
	minkowski() {
		cube(inner_cube);
		cylinder(d=hitch_d, h=depth/2);
	}
}

module pin() {
	translate([-hitch/2-pad,0,pin_depth])
	rotate([0,90,0])
	cylinder(d=pin,h=hitch+padd);
}

module pull() {
	difference() {
		sphere(d=finger);
		translate([-hitch/2,0,0])
		cube([hitch,hitch,wall]);
	}
}
module storage_rotated() {
        rotate([0,0,-90])
        storage();
}

module negative() {
    pin();
    supported_ring();
}

module storage() {
	storage_d=10;

	inner_storage=hitch-wall*2-storage_d;
	inner_storage_cube=[inner_storage,hitch,storage_h-storage_d];

	translate([-inner_storage/2,storage_d/2-hitch/2+wall,pin_depth+pin/2+wall+storage_d/2])
	minkowski() {
		cube(inner_storage_cube);
		sphere(d=storage_d);
	}
}

module supported_ring() {
    difference() {
        ring();
        translate([-hitch/2-padd,0,pin_depth])
        rotate([0,90,0])
        cylinder(d=pin+ring_wall*2,h=hitch+padd-ring_offset);
    }
}
module ring() {
    hull() {
        translate([-hitch/2+hitch/3,0,pin_depth+storage_h])
        rotate([0,90,0])
        cylinder(d=storage,h=hitch*2/3+pad);
        
        translate([-hitch/2+hitch/3,0,pin_depth])
        rotate([0,90,0])
        cylinder(d=storage,h=hitch*2/3+pad);
    }
    hull() {
        translate([-hitch/2-pad,0,pin_depth+storage_h])
        rotate([0,90,0])
        cylinder(d=storage,h=hitch+padd);
        
        translate([-hitch/2-pad,0,pin_depth+storage])
        rotate([0,90,0])
        cylinder(d=storage,h=hitch+padd);
    }

}

module assembled() {
    difference() {
		body();
        negative();
    }
}

module inside_out() {
    #body();
    negative();
}

module timeline() {
	gap=hitch*2;
	module spaced() {
		for ( i= [0:1:$children-1])
		translate([0,gap*i,0])
		children(i);
	}

	module label(string) {
		translate([gap,0,0])
		linear_extrude(pad)
		text(string);
		children();
	}

	spaced() {
		label("with_raft") with_raft();
        label("");
		label("assembled") assembled();
		label("inside_out") inside_out();
		label("pin") #pin();
        label("ring") #ring();
        label("supported_ring") #supported_ring();
	}
}

module fine() {
    $fn=90;
    children();
}

module raft() {
    difference() {
        linear_extrude(layer_h)
        translate([-depth,0,0])
        minkowski() {
            circle(raft);
            square([depth,hitch]);
        }
        translate([0,hitch/2,hitch/2])
        rotate([0,-90,0])
        negative();
    }
}

module with_raft() {
    raft();
    translate([0,hitch/2,hitch/2])
    rotate([0,-90,0])
    assembled();
}

display="";
if (display == "") timeline();
if (display == "hide_key.stl")
rotate([0,-90,0])
fine() assembled();
if (display == "hide_key_on_end.stl") fine() assembled();
if (display == "hide_key_with_raft.stl") fine() with_raft();
