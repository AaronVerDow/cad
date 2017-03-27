list_top=5;
lights=6;
light=155/(lights-1);
list_bottom=5;

list_y=list_top+light*lights+list_bottom;

list_x=31;

base_x=50;
base_y1=32;
base_y2=45;

out_r=4;
out_d=out_r*2;
in_r=6;
in_d=in_r*2;
font_size=4;

hole=10;
hole_y=15;

angle=atan((base_y2-base_y1)/base_x);

left_labels=[
    "NAV LT",
    "ANC LT",
    "CRYST LT",
    "TRANS LT",
    "ENG LT",
    "DOCK LT"
];

right_labels=[
    "BLOWER",
    "BILGE",
    "WIPER",
    "DEFOG",
    "ACC",
    "HORN"
];

pad=0.1;

module positive() {
    union() {
        translate([out_r,-out_r])
        minkowski() {
            square([list_x-out_d,list_y]);
            circle(r=out_r);
        }

        translate([out_r,out_r-base_y2])
        minkowski() {
            difference() {
                square([base_x-out_d,base_y2-out_d]);
                rotate([0,0,angle])
                translate([0,-base_y2])
                square([base_x*2,base_y2]);
            }
            circle(r=out_r);
        }

        translate([list_x-in_r,-in_r])
        difference() {
            square([in_d,in_d]);
            translate([in_d,in_d])
            circle(d=in_d);
        }
    }
}

module negative() {
    translate([list_x,-hole_y])
    circle(d=hole);
}

module plate() {
    difference() {
        positive();
        negative();
    }
}

module letters(labels) {
    translate([0,list_bottom+light*lights-light/2])
    for (i=[0:1:lights-1]) {
        translate([list_x/2,-i*light])
        text(labels[i],valign="center",halign="center",size=font_size);
    }
}
plate_h=3;
letter_h=0.5;

module left() {
    difference() {
        linear_extrude(height=plate_h)
        plate();

        translate([0,0,plate_h-letter_h])
        linear_extrude(height=letter_h+pad)
        letters(left_labels);
    }
}

module right() {
    difference() {
        linear_extrude(height=plate_h)
        translate([list_x,0,0])
        mirror([1,0,0])
        plate();

        translate([0,0,plate_h-letter_h])
        linear_extrude(height=letter_h+pad)
        letters(right_labels);
    }
}

//left();
right();
