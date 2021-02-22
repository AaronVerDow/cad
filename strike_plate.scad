from_back=25;
x=0;
y=1;
z=2;
deadbolt=[20,30];
deadbolt_offset=[-from_back,300];

latch=[20,30];
latch_offset=[-from_back,deadbolt_offset[y]-100];

wall=80;


body=[80,500];


screw=5; // diameter of hole for screws
screws=5; // how many screws
screw_end_gap=wall/2; // how far are screws placed from the end of the part

// used to space screws
screw_start=screw_end_gap;
screw_end=body[y]-screw_end_gap;
screw_gap=(screw_end-screw_start)/(screws-1);

font_size=body[x]/2;

module deadbolt() {
    translate(deadbolt_offset)
    square(deadbolt,center=true);
}

module latch() {
    translate(latch_offset)
    square(latch,center=true);
}

module body() {
    translate([-body[x],0,0])
    square(body);
        
    hull() {
        offset(wall)
        latch();
        offset(wall)
        deadbolt();
    }
    
}

module strike_plate(offset=0,label="") {
    difference() {
        body();
        translate([0,offset]) {
            latch();
            deadbolt();
        }
        square([wall,body[y]]);

        for(y=[screw_start:screw_gap:screw_end])
        translate([-body[x]/2,y])
        circle(d=screw); 

        if(label)
        translate([-body[x]/2,screw_end_gap+screw_gap/2])
        rotate([0,0,-90])
        #text(label,valign="center",halign="center",size=font_size,font="Impact");
    }
}

strike_plate(10,"+10");
