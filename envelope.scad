use <fontmetrics.scad>;
font="Arial";
from=[
	"AARON VERDOW",
	"5353 N LUDLAM AVE",
	"CHICAGO, IL 60630"
];
from_size=3;
from_gap=from_size*0.5;;

to=[
	"NATIONAL PASSPORT PROCESSING CENTER",
	"PO BOX 90955",
	"PHILADELPHIA, PA 19190-0955"
];
to_size=5;
to_gap=to_size*0.5;

x=0;
y=1;
in=25.4;
us_letter=[11*in-0.5,8.5*in];
page=us_letter;

to_width=max([
	for(n=[0:len(to)-1]) 
	measureText(to[n], font=font, size=to_size)
]);

ey=105;
ex=239;

default_line=0.3;

// https://www.uspsdelivers.com/avoid-pitfalls-when-designing-your-direct-mailpiece/
to_x_margin=in/2;
to_x=ex-to_x_margin*2;
to_y_offset=5/8*in;
to_y=2.75*in-to_y_offset;

function y_center(list, size, gap) = (size*len(list) + gap*(len(list)-1))/2-size;

from_y=(ey-to_y-to_y_offset)/2+to_y+to_y_offset;
from_x=to_x_margin;

corner=10;

module sqr(x,y,extra=0, line=default_line) {
	module _sqr(x,y,o=0) {
		offset(o)
		square([x,y]);
	}
	difference() {
		_sqr(x,y,extra);
		_sqr(x,y,extra-line);
	}
}

module sheet(extra=0, line=default_line) {
	translate([0,ey/2-page[y]/2])
	sqr(page[x],page[y],extra,line);
}

module envelope(extra=0,line=default_line) {
	sqr(ex,ey,extra,line);
}

module to_box() {
	translate([to_x_margin,to_y_offset])
	sqr(to_x,to_y);
}

module preview() {
	sheet();
	envelope();
	to_box();
	from();
	to();

}

module print() {
	from();
	to();
	sheet();
}

module alignment() {
	sheet();
	envelope(0,1);
	intersection() {
		translate([0,ey/2-page[y]/2])
		square(page);
		for(n=[-10:10])
		envelope(n,0.1);
	}
	to_box();
	from();
	to();
}

module multiline(lines, size, gap=2){
  union(){
    for (i = [0 : len(lines)-1])
      translate([0 , -i * (size + gap), 0 ]) text(lines[i], font=font, size);
  }
}

module from() {
	translate([from_x,from_y])
	translate([0,y_center(from, from_size, from_gap)])
	multiline(from, from_size, from_gap);
}

module to() {
	translate([ex/2,to_y_offset+to_y/2])
	translate([-to_width/2,y_center(to, to_size, to_gap)])
	multiline(to, to_size, to_gap);
}

module export() {
	rotate([0,0,-90])
	translate([-page[x],(page[y]-ey)/2])
	children();
}

// RENDER fillsvg
module aligner() {
	export()
	alignment();
}

// RENDER fillsvg
module final() {
	export()
	print();
}

preview();
