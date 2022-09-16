bulb=80;
bulb_h=150;
bulb_base=25;
bulb_base_h=30;
bulb_offset=12;
zero=0.01;

socket=40;
socket_h=60;
socket_flange=socket+8;
socket_flange_h=3;
socket_flange_offset=23;

tube=bulb*1.5;
tube_h=bulb_h*1.8;
tube_wall=1;
pad=0.1;

height=tube/4*3;

hole=tube*0.7;
hole_w=tube_h-hole-tube_h/4;

socket_offset=35;

socket_hole=socket*1.1;
socket_hole_flange=socket_hole+20;

tube_gap=0.5;

track=30;
inner_track=tube-tube_wall*2-tube_gap*2;


module track(extra=0) {
	color("white")
	place_socket() {
		hull() {
			cylinder(d=inner_track+extra,h=track);
			cylinder(d=socket_hole_flange+extra,h=socket_offset);
		}
	}
}

track_wall=3;

translate([-pad,0])
difference() {
	track();
	translate([-track_wall,0])
	track(-track_wall*2);
}

_black=250;
black=[_black,_black,_black];

module dirror_z(z=0) {
	children();
	translate([0,0,z])
	mirror([0,0,1])
	children();

}

module dirror_y(y=0) {
	children();
	translate([0,y,0])
	mirror([0,1])
	children();

}

module dirror_x(x=0) {
	children();
	translate([x,0])
	mirror([1,0])
	children();

}

module place_socket(z=0) {
	translate([z,0,height])
	rotate([0,90])
	children();
}

place_socket()
difference() {
	cylinder(d=tube,h=tube_h);
	translate([0,0,-tube_wall])
	cylinder(d=tube-tube_wall*2,h=tube_h);

	translate([0,0,tube_h/2])
	hull()
	dirror_z()
	translate([0,0,hole_w/2])
	rotate([0,-90,0])
	cylinder(d=hole,h=tube);

}

place_socket(socket_offset) {
	socket();
	bulb();
}

module socket() {
	color("darkgray") {
		translate([0,0,socket/2+socket_flange_offset-socket_h]) { 
			cylinder(d=socket,h=socket_h-socket/2);
			sphere(d=socket);
		}
		cylinder(d=socket_flange,h=socket_flange_h);
	}
}

module bulb() {
	translate([0,0,-bulb_offset]) {
		color("silver")
		cylinder(d=bulb_base,h=bulb_base_h);
		color("white")
		hull() {
			translate([0,0,bulb_h-bulb/2])
			sphere(d=bulb);

			translate([0,0,bulb_base_h])
			cylinder(d=bulb_base,h=zero);
		}
	}
}

