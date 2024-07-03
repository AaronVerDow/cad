x=400;
y=500;

// 55 x 260
utensil_width=55;

// utensil_height=(y-wall*3)/2;
utensil_slots=5;
wall=5;

max_slots=floor(x/(utensil_width+wall));
slot=(x-wall)/max_slots-wall;

utensil_height=y-slot*3-wall*5;

z=50;


base=5;
module body() {
    square([x,y]);
}

in=25.4;

bit=3/4*in;

module slot(x, y) {
    //square([x,y]);
    translate([bit/2,bit/2,bit/2])
    minkowski() {
        cube([x-bit,y-bit,z-bit]);
        sphere(d=bit, $fn=20);
    }


}

module slots(count, height) {
    slot_x=(x-wall)/count-wall;
    echo(slot_x=slot_x);
    slot_y=height;

    for(i=[0:1:count-1])
    translate([i*(slot_x+wall)+wall,0,0])
    slot(slot_x, slot_y);

    translate([0,height+wall])
    children();
}

difference() {
    //linear_extrude(height=z)
    //body();
    cube([x,y,z]);

    translate([0,wall,base])
    //linear_extrude(height=z)
    slots(2, slot)
    slots(max_slots, utensil_height)
    slots(1, slot)
    slots(1, slot);
}
