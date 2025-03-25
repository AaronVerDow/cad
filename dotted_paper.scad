// 148 x 210

x = 148;
y = 210;

dot = 0.3;
$fn=90;

gap = 6;

//square([x, y]);

margin = 10;

// RENDER svg
module dots() {
    intersection() {
	translate([(x%gap)/2,(y%gap)/2])
	for(i=[0:gap:x])
	for(j=[0:gap:y])
	translate([i,j])
	circle(d=dot);

	translate([margin, margin])
	square([x-margin*2,y-margin*2]);
    }
}

dots();
