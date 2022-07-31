$fn=90;
in=25.4;
strap=(1+5/8)*in;

button_hole=3/16*in;
button_slot=1;
button_slot_h=5/8*in;

flat=strap/3*2;

wing_h=strap/2;
wing=flat-wing_h;

// extra material to account for fold, may be trimmed
wing_extra=in/4;

line=3;

module dirror_x() {
	children();
	mirror([1,0])
	children();
}

module body() {
	circle(d=strap);
	translate([-strap/2,0])
	square([strap,flat]);

	dirror_x()
	difference() {
		translate([strap/2,0])
		square([strap/2+wing_extra,wing+wing_h]);

		hull() {
			translate([strap,0])
			circle(r=wing_h);
			translate([strap+wing_extra*2,0])
			circle(r=wing_h);
		}
	}
}

module slot() {
	circle(d=button_hole); hull() {
		translate([0,button_slot_h])
		circle(d=button_slot);
		circle(d=button_slot);
	}

}

module twod() {
	difference() {
		body();
		slot();
	}
}

module line() {
	difference() {
		offset(line/2)
		children();
		offset(-line/2)
		children();
	}
}

//line() body();
//slot();

linear_extrude(height=0.6)
twod();
