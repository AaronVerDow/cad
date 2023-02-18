

height=100;

gap=height*1.2;
arrow=height;
font_size=height;

arrow_x=arrow;
arrow_y=arrow;


arrow_tail_ratio=0.6;
arrow_point_ratio=0.6;
arrow_point=arrow_x*arrow_point_ratio;
arrow_body_x=arrow_x-arrow_point;
arrow_body_y=arrow_y*arrow_tail_ratio;

module txt(txt) {
    text(txt,valign="center",halign="center",size=font_size,font=font);
}


zero=0.01;

font="Roboto Mono:Bold";

module arrow() {
    translate([0,-arrow_body_y/2])
    square([arrow_body_x,arrow_body_y]);
    module dirror() { children(); mirror([0,1]) children(); }
    hull() {
        dirror()
        translate([arrow_body_x+zero/2,arrow_y/2-zero/2])
        circle(d=zero);
        translate([arrow_x-zero/2,0])
        circle(d=zero);
    }
}

module dirror() { children(); mirror([1,0]) children(); }

plus=height*0.5;
plus_w=plus*0.25;


module plus() {
    minus();
    rotate([0,0,90])
    minus();
}

module minus() {
    square([plus,plus_w],center=true);
}

plus_ratio=1-arrow_point_ratio;


LEFT=-1;
RIGHT=1;
UP=0;

HIDE=0;
SHOW=1;




module label(axis, positive=RIGHT, rotation=UP, zero=HIDE) {
    difference() {
        dirror()
        translate([gap/2,0])
        arrow();
        translate([(-gap/2-arrow_x*plus_ratio)*positive,0])
        plus();

        translate([(gap/2+arrow_x*plus_ratio)*positive,0])
        rotate([0,0,rotation*90])
        minus();
    }

    rotate([0,0,rotation*90])
    txt(axis);
    if( zero == SHOW )
    translate([(gap+arrow_x)*positive,0])
    rotate([0,0,rotation*90])
    txt("0");
}

// RENDER svg
module x_to_right_zero() {
    label("X", positive=RIGHT, rotation=UP, zero=SHOW);
}

// RENDER svg
module y_to_right_zero() {
    label("Y", positive=RIGHT, rotation=UP, zero=SHOW);
}


// RENDER svg
module x_to_right() {
    label("X", positive=RIGHT, rotation=UP, zero=HIDE);
}

// RENDER svg
module y_to_right() {
    label("Y", positive=RIGHT, rotation=UP, zero=HIDE);
}

label("Z");

