in=25.4;
ft=12*in;
max_x=4*ft;
max_y=3*ft;
max_z=7*ft;
shelves=6;

shelf_wall=10*in;
shelf_r=6*in;
edge_r=3*in;

left_wall=4*in;
right_wall=left_wall;

curve_y=20*in;
curve_x=max_x-left_wall-right_wall;

wood=0.75*in;

tooth_w=4*in;
tooth_r=tooth_w/2;
tooth_gap=1/16*in;


pin_gap=1/8*in;

side_x=wood;
side_y=max_y;
side_gap=(max_z-wood)/(shelves-1);
side_z=side_gap+wood;

tooth_h=side_z/2;

tooth_offset=side_y/6;


module mirror_x(x) {
    children();
    translate([x,0])
    mirror([1,0])
    children();
}


function segment_radius(height, chord) = (height/2)+(chord*chord)/(8*height);
curve = segment_radius(curve_y,curve_x);

module pin(y=0) {
    translate([0,-tooth_w/2+y])
    square([wood+pin_gap,tooth_w]);
}

module wall() {
            translate([shelf_r+shelf_wall+wood,0])
            minkowski() {
                square([max_x-shelf_wall*2-shelf_r*2-wood*2,max_y-shelf_wall-shelf_r]);
                circle(r=shelf_r);
            }

            difference() {
                translate([shelf_wall+wood-edge_r,-1]) 
                square([max_x-shelf_wall*2-wood*2+edge_r*2,edge_r+1]);
                translate([shelf_wall+wood-edge_r,edge_r]) 
                circle(r=edge_r);
                translate([max_x-shelf_wall-wood+edge_r,edge_r]) 
                circle(r=edge_r);
            }


   
}

module curve() {
    translate([left_wall+curve_x/2,curve_y-curve])
    circle(r=curve,$fn=300);
}

module shelf(bottom=0) {
    difference() {
        square([max_x,max_y]);
        if(!bottom) {
        curve();
        }

        mirror_x(max_x) {
            pin(max_y/2);
            mirror_y(max_y)
            pin(tooth_offset);
        }
    }
}

module shelf_3d(bottom=0) {
    linear_extrude(height=wood)
    shelf(bottom);
}

module shelves_3d() {
    for(z=[side_gap:side_gap:max_z-wood]) {
        translate([0,0,z])
        shelf_3d();
    }
    shelf_3d(1);
}

module side(top=0, bottom=0) {
    translate([side_z,0])
    mirror([1,0])
    difference() {
        union() {
            translate([wood,0])
            square([side_z-wood*2,side_y]);

            translate([side_z-wood,side_y/2])
            tooth();
           
            if(top)
            mirror([1,0])
            translate([0,side_y/2])
            tooth();

            mirror_y(side_y)
            mirror([1,0])
            translate([-wood,tooth_offset])
            tooth();


            if(bottom)
            mirror_y(side_y)
            mirror([1,0])
            translate([-side_z,tooth_offset])
            tooth();
 
        }

        if(!top)
        translate([0,side_y/2])
        tooth(tooth_gap);

        if(!bottom)
        mirror_y(side_y)
        mirror([1,0])
        translate([-side_z,tooth_offset])
        tooth(tooth_gap);

        if(top)
        translate([-side_z,0])
        square([side_z,side_y]);

        if(bottom)
        translate([side_z,0])
        square([side_z,side_y]);
    }
}

module mirror_y(y) {
    children();
    translate([0,y])
    mirror([0,1])
    children();
}


module side_3d(color="lime", z=0, top=0, bottom=0) {
    color(color)
    mirror_x(max_x)
    translate([wood,0,z])
    rotate([0,-90,0])
    linear_extrude(height=wood)
    side(top, bottom);
}


module tooth(extra=0) {
    module dot(x=0,y=0) {
        translate([x,y])
        circle(d=tooth_r+extra);
    }

    hull() {
        dot(-tooth_r, -tooth_w/2+tooth_r/2);
        dot(-tooth_r, tooth_w/2-tooth_r/2);
        dot(wood, -tooth_w/2+tooth_r/2);
        dot(wood, tooth_w/2-tooth_r/2);
        dot(wood+tooth_h-tooth_r/2, 0);
    }
}

module assembled() {
    shelves_3d();
    for(i=[1:1:shelves-3]) {
        if (i%2) {
            side_3d("lime", i*side_gap);
        } else {
            side_3d("blue", i*side_gap);
        }
    }
    side_3d("red",(shelves-2)*side_gap,1,0);
    side_3d("red",0,0,1);
}

//translate([-max_x-side_gap,0])
assembled();
shelf();
