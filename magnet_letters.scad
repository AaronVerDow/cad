size=80;
gap=size/5;
spacing=1;
font="WhoopAss";

magnet=6;
magnet_h=3;
raw_height=size*0.2;

inset=magnet_h;

zero=0.01;

module all() {
	word("NOHEAT",0.9)
	word("EX", 0.9)
	word("LOW")
	word("HANG")
	word("SOME")
	word("ALL")
	word("ASK")
	word("DGAF")
	;
}

//word("EX", 0.9);

all();

border=magnet*1;
maximum=size*20;
pgap=magnet*2;
fmax=floor(maximum/gap)*gap; // make edges even

layer_height=0.2;
slices=floor(raw_height/layer_height);
height=slices*layer_height;

function slice_offset(z)=(height-z)/height*inset*2;

module lines_word(t, spacing=spacing, _offset=0) {
	module my_text(o=0) {
		offset(o)
		text(t, font=font, size=size, spacing=spacing);
	}
	difference() {
		my_text();
		offset(magnet/2-zero/2)
		intersection() {
			difference() {
				my_text(-border);
				my_text(-border-zero);
			}
			translate([_offset,0])
			lines();
		}
	}
	translate([0,-size-gap,0])
	children();
}

pad=0.1;

module word(t, spacing=spacing) {
	module my_text(o=0) {
		offset(o)
		text(t, font=font, size=size, spacing=spacing);
	}
	difference() {
		for(z=[0:height/slices:height])
		translate([0,0,z])
		linear_extrude(height=height/slices)
		offset(-slice_offset(z))
		my_text();

		translate([0,0,-pad])
		linear_extrude(height=magnet_h+pad)
		offset(magnet/2-zero/2)
		intersection() {
			my_text(-border-inset);
			pattern(zero);
		}
	}
	translate([0,-size-gap,0])
	children();
}

module pattern(d=magnet) {
	rotate([0,0,45])
	for(y=[-fmax:pgap:fmax])
	for(x=[-fmax:pgap:fmax])
	translate([x,y])
	circle(d=d);
}

module lines() {
	rotate([0,0,0])
	for(x=[-fmax:pgap:fmax])
	translate([x,0])
	square([zero,fmax*2],center=true);
}
