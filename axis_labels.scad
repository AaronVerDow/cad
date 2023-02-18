height=100;

gap=height*1.2;

zero_gap=height*0.4;
arrow=height;
font_size=height;

arrow_x=arrow;
arrow_y=arrow;

arrow_tail_ratio=0.6;
arrow_point_ratio=0.6;
arrow_point=arrow_x*arrow_point_ratio;
arrow_body_x=arrow_x-arrow_point;
arrow_body_y=arrow_y*arrow_tail_ratio;

plus=height*0.4;
plus_w=plus*0.3;
plus_ratio=1-arrow_point_ratio;

zero=0.01;
font="Roboto Mono:Bold"; // has slash in zero

keyboard_gap=height*1.3;

LEFT=1;
RIGHT=-1;
UP=0;

HIDE=0;
SHOW=1;

module txt(txt) {
    text(txt,valign="center",halign="center",size=font_size,font=font);
}

module arrow() {
    module dirror() {
	children();
	mirror([0,1])
	children();
    }
    union() {
	    translate([0,-arrow_body_y/2])
	    square([arrow_body_x,arrow_body_y]);
	    hull() {
		dirror()
		translate([arrow_body_x+zero/2,arrow_y/2-zero/2])
		circle(d=zero);
		translate([arrow_x-zero/2,0])
		circle(d=zero);
	    }
    }
}

module dirror() {
	children();
	mirror([1,0])
	children();
}

module plus() {
    minus();
    rotate([0,0,90])
    minus();
}

module minus() {
    square([plus,plus_w],center=true);
}

module label(axis, plus=LEFT, text=UP, zero=HIDE, left=SHOW, right=SHOW, gap=gap) {
    module positive() {
        rotate([0,0,text*90])
        txt(axis);

        if(zero)
        translate([(gap/2+arrow_x+zero_gap)*plus,0])
        rotate([0,0,text*90])
        txt("0");

        if(right)
        translate([gap/2,0]) 
        arrow();

        if(left)
        mirror([1,0])
        translate([gap/2,0]) 
        arrow();
    } 
    difference() {
	positive();
        translate([(-gap/2-arrow_x*plus_ratio)*plus,0])
        plus();

        translate([(gap/2+arrow_x*plus_ratio)*plus,0])
        rotate([0,0,text*90])
        minus();
    }

}

// RENDER svg
module x_to_left_zero() {
    label("X", zero=SHOW);
}

// RENDER svg
module y_to_left_zero() {
    label("Y", zero=SHOW);
}

// RENDER svg
module x_to_left() {
    label("X");
}

// RENDER svg
module x_to_right() {
    label("X", plus=RIGHT);
}

// RENDER svg
module y_to_left() {
    label("Y");
}

// RENDER svg
module z() {
    label("Z", text=LEFT);
}

// RENDER svg
module keyboard() {
    rotate([0,0,-90])
    label("Y", plus=LEFT, text=UP, zero=HIDE, gap=gap*0.7);

    translate([keyboard_gap,0])
    label("X", plus=RIGHT, text=RIGHT, zero=HIDE, left=HIDE);

    translate([-keyboard_gap,0])
    label("X", plus=RIGHT, text=RIGHT, zero=HIDE, right=HIDE);
}

module spaced() {
    for ( i= [0:1:$children-1])
    translate([0,height*1.2*i,0])
    children(i);
}

spaced() {
	x_to_right();
	x_to_left();
	x_to_left_zero();
	y_to_left();
	y_to_left_zero();
	z();
}

translate([0,-height*2.5])
keyboard();
