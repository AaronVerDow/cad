$fn=120;
x = 130;
y = 80;
z = 90;
wall = 10;
pad = 0.1;
slots = 4;
spikes = slots+1;
slot_w = (x-spikes*wall)/slots;
echo("Slot width is ", slot_w);

module cut_slots() {
	for(i=[1:slots]) {
		translate([(slot_w+wall)*i-slot_w,-pad,wall+slot_w/2])
		cube([slot_w,wall+pad*2,z-wall+pad-slot_w/2]);
		translate([(slot_w+wall)*i-slot_w/2,-pad,wall+slot_w/2])
		rotate([-90,0,0])
		cylinder(r=slot_w/2,h=wall+pad*2);
	}
}

module round_spikes() {
	for(i=[0:slots]) {
		translate([wall/2+i*(slot_w+wall),0,z])
		rotate([-90,0,0])
		cylinder(r=wall/2,h=wall);
	}
}

union() {
	difference() {
		cube([x,y,z]);
		translate([-pad,wall,wall])
		cube([x+pad*2,y-wall*2,z-wall+pad]);
		translate([wall,wall,-pad])
		cube([x-wall*2,y-wall*2,wall+pad*2]);
		cut_slots();
		translate([0,y-wall,0])
		cut_slots();
	}

	translate([0,y-wall,0])
	round_spikes();
	round_spikes();
}
