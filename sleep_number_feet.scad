felt=130;
felt_h=5;
pad=0.1;

base=3;
tube=60;

tube_h=tube*1.5;

wall=5;

lip_x=0.6;
lip_z=0.5;

$fn=200;

groove=1.5;
groove_h=groove/2;

spike=1;
spike_h=1;

zero=0.001;

module body() {
	hull() {
		cylinder(d=felt+lip_x*2,h=base+lip_z);
		cylinder(d=tube+wall*2,h=tube_h);
	}
}

module groove(d) {
	//translate([0,0,-pad])
	//cylinder(d1=d+groove/2,d2=d-groove/2,h=groove_h+pad);
	
	translate([0,0,lip_z])
	rotate_extrude()
	translate([d/2,0])
	rotate([0,0,45])
	square([groove,groove],center=true);
	
}

module spike() {
	translate([0,0,lip_z-spike_h])
	cylinder(d2=spike,d1=zero,h=spike_h);
}

difference() {
	body();
	translate([0,0,base])
	cylinder(d=tube,h=tube_h);

	translate([0,0,-pad])
	cylinder(d=felt,h=lip_z+pad);

 	groove(tube);
 	groove(tube/2);
 	groove((felt-tube)/2+tube);
}

//spike();
