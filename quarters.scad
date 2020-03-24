quarter=24.26;
quarter_depth=2;
text_h=0.3;
gap_x=40;
gap_y=40;
max_x=200;
max_y=200;
z=3;

labels = [
    "lots",
    "of",
    "things"
];

module base() {
    cube([max_x,max_y,z]);
}

module quarter(x,y) {
    translate([x,y,z-quarter_depth])
    cylinder(d=quarter,h=z);
}

module write_text(x,y,text) {
    translate([x,y-quarter/2,z])
    linear_extrude(height=text_h)
    text(text=text, size=5, valign="top", halign="center");
}

module all_text() {
    for(text=labels) {
        
        write_text(gap_x/2,gap_y/2, text);
    }
}

module quarters() {
    for(x=[gap_x/2:gap_x:max_x-gap_x/2]) {
        for(y=[gap_y/2:gap_y:max_y-gap_y/2]) {
            quarter(x,y);
        }
    }
}

difference() {
    base();
    quarters();
}
all_text();
