sponge_x=120;
sponge_y=90;
sponge_z=10;
mount=42;
mount_z=40;
pad=0.1;

difference() {
    hull() {
        cube([sponge_x,sponge_y,sponge_z]);
        translate([sponge_x/2,sponge_y/2,sponge_z])
        cylinder(h=mount_z,d=mount);
    }
    translate([sponge_x/2,sponge_y/2,sponge_z])
    cylinder(h=mount_z+pad,d=mount);
}
