width=50;
length=width*3;
gap=width/4;

zero=0.01;

$fn=90;

pad=0.1;


// RENDER svg2png
module its_something() {
	circle(d=width);
	difference() {
		hull() {
			circle(d=width);
			translate([length,0])
			circle(d=zero);
		}
		circle(d=width+gap+pad);
	}
}

its_something();
