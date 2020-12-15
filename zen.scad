rake_pin=2;
rake_pins=4;
// pin to pin
rake_width=21;
rake_edge=6;

in=25.4;

groove_d=0.25*in;

groove=0.25*in*1.1;

side=rake_edge*2+rake_width*6+groove_d*2;

top_h=12;
base_h=10;
wood=0.5*in;
base_wood=0.25*in;

side_h=top_h+base_wood*2+base_h;

edge=side+wood*2-groove_d*2;

echo("side");
echo(side);
echo(side/in);

echo("edge");
echo(edge);
echo(edge/in);

saw_gap=0.25;

gardens=6;
cnc_edges=6;

total_edges=4*gardens;

cnc_rows=ceil(total_edges/cnc_edges);

cnc=edge*cnc_edges+saw_gap*3;

echo("cnc");
echo(cnc);
echo(cnc/in);


bit=in/4;

cut_gap=bit*3;

module base() {
    square([side,side],center=true);
}

module base_3d() { 
    linear_extrude(height=base_wood)
    base();
}

module side(x=edge) {
    square([x,side_h],center=true);
}

module side_grooves(x=edge) {
    translate([0,-side_h/2+base_wood/2])
    side_groove(x);

    translate([0,side_h/2-base_wood/2-top_h])
    side_groove(x);
}

module side_groove(x=edge) {
    square([x+base_wood*2,groove],center=true);
}


module assembled() {
    for(n=[0:90:359])
    rotate([0,0,n])
    translate([0,-side/2+groove_d,side_h/2])
    rotate([90,0,0])
    difference() {
        linear_extrude(height=wood)
        side();
        linear_extrude(height=groove_d)
        side_grooves();
    }

    color("lime")
    base_3d();
    color("lime")
    translate([0,0,base_wood+base_h]) base_3d();
}

// RENDER svg
module base_cutsheet() {
    gap=side+cut_gap;
    for(y=[0:gap:gap*gardens-1])
    for(x=[0:gap:gap])
    translate([x,y])
    base();
}

anchor=bit;

module cutsheet() {
    gap=side_h+cut_gap;

    translate([-cnc/2-cut_gap,gap*cnc_rows])
    //translate([-cnc/2-cut_gap,-side_h/2-cut_gap])
    circle(d=anchor);
    
    for(y=[0:gap:gap*cnc_rows-1])
    translate([0,y])
    children();
}

// RENDER svg
module side_cutsheet() {
    cutsheet()
    side(cnc);
}

// RENDER svg
module groove_cutsheet() {
    cutsheet()
    side_grooves(cnc);
}



//side_cutsheet();
//translate([0,0,1]) color("red") groove_cutsheet();

//base_cutsheet();

assembled();
