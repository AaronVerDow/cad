points=[
    [23,66], // screw
    [23,8], // screw
    [74,85], // screw
    [110,10],
    [127,47], // screw
];

other_points=[
    [130,83],
    [189,8], // screw
    [189,85], // screw
    [260,5], // screw
    [258,66], // screw
];

column=6;

column_h=6;

$fn=90;

connector=column*1.5;
connector_h=column_h/2;

screw=2.5;
zero=0.1;
show_text=1;

module column() {
    cylinder(d1=column*1.5,d2=column, h=column_h);
}

module connector() {
    cylinder(d2=column/2,d1=connector, h=connector_h);
}


module label(text) {
    if(show_text)
    translate([0,0,column_h+1])
    color("lime")
    linear_extrude(height=zero)
    text(str(text),valign="center",halign="center");
}

module body(points) {
    for(n = [0:1:len(points)-2]) {
        translate(points[n]) {
            label(points[n]);
            column();
        }
        translate(points[n+1]) {
            label(points[n+1]);
            column();
        }

        hull() {
            translate(points[n])
            connector();
            translate(points[n+1])
            connector();
        }
        
    };
};

pad=0.1;

module part(points) {

    difference() {
        body(points);
        for(point = points) {
            translate(point)
            translate([0,0,-pad])
            cylinder(d=screw,h=column_h+pad*2);
        }
    }
}

part(points);
part(other_points);
