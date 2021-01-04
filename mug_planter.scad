top=100;
base=80;
height=60;

airgap=5;
base_offset=5;

side_wall=0.5;
base_wall=0.6;

airgap_wall=1;

drain=5;

evap=10;

$fn=190;

module holes(hole,gap,max_x,max_y) {

    translate([-max_x/2+max_x%gap/2,-max_y/2+max_y%gap/2]) {

        for(x=[0:gap:max_x])
        for(y=[0:gap:max_y])
        translate([x,y])
        circle(d=hole);

        translate([gap/2,gap/2])
        for(x=[0:gap:max_x])
        for(y=[0:gap:max_y])
        translate([x,y])
        circle(d=hole);
    }
}

module body(r=0,z=0) {
    difference() {
        cylinder(d1=base+r*2,d2=top+r*2,h=height+z);
        hull() {
            translate([base/2,0])
            #cylinder(d=evap-r*2,h=0.01);
            translate([top/2,0,height])
            #cylinder(d=evap-r*2,h=0.01);
        }
    }
}

module diff(z) {
    cylinder(d=top,h=z);
}


color("cyan")
difference() {
    body();
    difference() {
        body(-side_wall);
        diff(airgap+base_wall);
    }
    diff(airgap);

    linear_extrude(height=height)
    intersection() {
        holes(drain,drain*3,base,base);
        circle(d=base);
    }


}


module cross() {
    children();
    rotate([0,0,90])
    children();
}

cross()
translate([0,0,airgap/2])
cube([base-base_offset*2,airgap_wall,airgap],center=true);
