wall=4;
bottle=25;
top_h=40;
angle_h=30;
bottle_h=50;
total_h=top_h+angle_h+bottle_h;
mesh_wall=0.5;
mesh_hole=2;
mesh_h=3;
pad=0.1;
padd=pad*2;
top=100;

mesh_layer_h=0.5;

print_base=80;
print_base_h=0.6;
$fn=120;

translate([0,0,bottle_h+angle_h])
difference() {
    cylinder(d=top,h=top_h);
    translate([0,0,-pad])
    cylinder(d=top-wall*2,h=top_h+padd);
}
translate([0,0,bottle_h])
difference() {
    cylinder(d2=top,d1=bottle,h=angle_h);
    translate([0,0,-pad])
    cylinder(d2=top-wall*2,d1=bottle-wall*2,h=angle_h+padd);
}
bottom_mesh();
difference() {
    union() {
        cylinder(d=bottle,h=bottle_h);
        cylinder(d=print_base,h=print_base_h);
    }
    translate([0,0,-pad])
    cylinder(d=bottle-wall*2,h=bottle_h+padd);
}

module bottom_mesh() {
    for(z=[0:mesh_layer_h*2:mesh_h]) {
        translate([0,0,z+bottle_h-mesh_h]){
            mesh_layer(bottle);
            mesh_cross_layer(bottle);
        }
    }
}

module top_mesh() {
    for(z=[0:mesh_layer_h*2:mesh_h]) {
        translate([0,0,z+bottle_h+angle_h]){
            mesh_layer(top);
            mesh_cross_layer(top);
        }
    }
}

module mesh_cross_layer(d){
    translate([0,0,mesh_layer_h])
    rotate([0,0,90])
    mesh_layer(d);
}

module mesh_layer(d){
    intersection() {
        translate([-d/2,-d/2,0])
        for(x=[0:mesh_hole:d]) {
            translate([x-mesh_wall/2,0,0])
            cube([mesh_wall,d,mesh_layer_h]);
        }
        cylinder(d=d,h=mesh_layer_h);
    }
}

module supports(d) {
    intersection() {
        translate([-d/2,-d/2,bottle_h])
        for(x=[0:mesh_hole*2:d]) {
            for(y=[0:mesh_hole*2:d]) {
                translate([x-mesh_wall/2,y-mesh_wall/2,0])
                cube([mesh_wall,mesh_wall,angle_h]);
            }   
        }
        translate([0,0,bottle_h])
        difference() {
            cylinder(d2=d,d1=bottle,h=angle_h);
            translate([0,0,-pad])
            cylinder(d=bottle-wall*2,h=angle_h+padd);
        }
    }
}
