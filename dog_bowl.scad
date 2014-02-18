// 2 Liter Bottle Holder
//
// (c) 2013 Laird Popkin, based on http://www.threadspecs.com/assets/Threadspecs/ISBT-PCO-1881-Finish-3784253-18.pdf.
// Credit to eagleapex for creating and then deleting http://www.thingiverse.com/thing:10489 
// which inspired me to create this.

part="neck"; // "threads" for the part to print, "neck" for the part to subtract from your part
clearance=0.4; // tune to get the right 'fit' for your printer

// Bottle params

bottleID=25.07;
bottleOD=27.4;
bottlePitch=2.7;
bottleHeight=9;
bottleAngle=2;
threadLen=15;

// Computations

threadHeight = bottlePitch/3;
echo("thread height ",threadHeight);
echo("thread depth ",(bottleOD-bottleID)/2);

module bottleNeck() {
	difference() {
		union() {
			translate([0,0,-0.5]) cylinder(r=bottleOD/2+clearance,h=bottleHeight+1);
			}
		union() {
			rotate([0,bottleAngle,0]) translate([-threadLen/2,0,bottleHeight/2]) cube([threadLen,bottleOD,threadHeight]);
			rotate([0,bottleAngle,90]) translate([-threadLen/2,0,bottleHeight/2+bottlePitch/4]) cube([threadLen,bottleOD,threadHeight]);
			rotate([0,bottleAngle,-90]) translate([-threadLen/2,0,bottleHeight/2+bottlePitch*3/4]) cube([threadLen,bottleOD,threadHeight]);
			rotate([0,bottleAngle,180]) translate([-threadLen/2,0,bottleHeight/2+bottlePitch/2]) cube([threadLen,bottleOD,threadHeight]);
			translate([0,0,-bottlePitch]) {
				rotate([0,bottleAngle,0]) translate([-threadLen/2,0,bottleHeight/2]) cube([threadLen,bottleOD,threadHeight]);
				rotate([0,bottleAngle,90]) translate([-threadLen/2,0,bottleHeight/2+bottlePitch/4]) cube([threadLen,bottleOD,threadHeight]);
				rotate([0,bottleAngle,-90]) translate([-threadLen/2,0,bottleHeight/2+bottlePitch*3/4]) cube([threadLen,bottleOD,threadHeight]);
				rotate([0,bottleAngle,180]) translate([-threadLen/2,0,bottleHeight/2+bottlePitch/2]) cube([threadLen,bottleOD,threadHeight]);
				}
			//translate([0,0,bottleHeight/2+bottlePitch/2]) rotate([0,0,90]) cube([10,bottleOD,threadHeight], center=true);
			}
		}
	translate([0,0,-1]) cylinder(r=bottleID/2+clearance,h=bottleHeight+2);
	}

module bottleHolder() {
	difference() {
		cylinder(r=15,h=bottleHeight);
		bottleNeck();
		}
	}


$fn=190;
max_x = 170;
max_y = max_x;
max_z = 45;
wall = 4;
pad = 0.1;

bot_top = 35;
bot_top_r = bot_top/2;
bot_bottom = 90;
bot_bottom_r = bot_bottom/2;

water_top_gap = 12;
water_offset = 0.5;
water_hole = bottleID;
//water_hole = max_z-water_top_gap+water_offset;
water_hole_r = water_hole/2;
lip_gap=2;
water_h = max_z+bottleHeight+lip_gap-water_top_gap;
//water_h = water_hole-water_offset+bottleHeight+2;
corner=20;
module bowl(x,y,z,r) {
	minkowski() {
		cube([x,y,z]);
		cylinder(r=r,h=0.01);
	}
}

translate([corner,corner,0])
difference () {
	bowl(max_x-corner*2,max_y-corner*2,max_z,corner);
	translate([0,0,wall])
	//bowl(max_x-wall*2,max_y-wall*2,max_z-wall+pad,corner-wall);
	bowl(max_x-corner*2,max_y-corner*2,max_z-wall+pad,corner-wall);
}
translate([bot_bottom_r,bot_bottom_r,wall])
difference () {
	cylinder(r2=bot_top_r,r1=bot_bottom_r,h=water_h);
	cylinder(r=bottleID/2,h=water_h+pad);
	translate([0,0,water_h-bottleHeight])
	bottleNeck();
	translate([0,0,water_h-bottleHeight-lip_gap-water_hole_r])
	rotate([90,0,135])
	cylinder(r=water_hole_r,h=bot_bottom_r);

	translate([0,0,water_hole_r-water_offset])
	rotate([90,0,135])
	cylinder(r=water_hole_r,h=bot_bottom_r);
	rotate([0,0,-45])
	translate([-water_hole_r,0,water_hole_r-water_offset])
	cube([water_hole,bot_bottom_r,(water_h-bottleHeight-2-water_hole_r)-(water_hole_r-water_offset)]);
}
