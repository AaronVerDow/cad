in=25.4;
$fn=90;

magnet=10;
magnet_extra=0.2; // make the magnet holes bigger without messing with ring calculation
magnet_h=4.5;
magnet_wall=3;
magnet_z_wall=10-magnet_h;
magnet_z=magnet_h+magnet_z_wall;

pipe_wall=2;


// vacuum = 1 inch hose
vacuum=25.4+pipe_wall*2;
vacuum_magnets=4;

// hose = 4 inch hose
hose=4*in;
hose_magnets=6;

// collector = 5+ inch connector to dust collector
collector=5*in;
collector_magnets=8;


clamp_h=50;

pad=0.1;
padd=pad*2;

screw=2.7;
screw_h=12;

guard_lines=6;

guard_rings=2;

guard_thick=1;
guard_deep=clamp_h;
guard_min_deep=5;

grid_gap=30;

not_cut=clamp_h/2;
cut_h=clamp_h-not_cut;

magnet_z_extra=0.5; // extra for sagging bridges
layer_height=0.2;
screw_bridge_gap=layer_height*1;

magnet_flange=1;
outer_flange=0.4;
air_flange=1;
pipe_flange=1;

dot=2;

flip=1;

gap=20;

display="";

collector_h=50-magnet_z*2;
collector_screw=5;
collector_screw_offset=22;


mz_x=90;
mz_y=90;
mz_z=0.5*in;
mz_tab=29;
mz_tab_h=mz_z;
mz_angle=30;

module mz_wood() {
    translate([0,0,mz_tab_h/2+magnet_z]) {
        cube([mz_x,mz_y,mz_z],center=true);
        cube([mz_x+mz_tab_h*2,mz_tab,mz_z],center=true);
    }
} 

module place_mz_air() {
    translate([0,5,0])
    children();
}

mz_screw=7;
mz_screw_h=magnet_z+mz_z;
mz_screw_head=14;
mz_screw_head_h=(mz_screw_head-mz_screw)/2;
module mz_screw() {
    translate([0,0,-pad*2])
    cylinder(d=mz_screw,h=mz_screw_h+pad*3);
    translate([0,0,-pad])
    cylinder(d2=mz_screw-pad*2,d1=mz_screw_head+pad*2,h=mz_screw_head_h+pad*2);
}


difference() {
    union() {
        place_mz_air()
        flange(hose, hose_magnets);
        mz_wood();
        translate([0,-magnet_z/2,magnet_z/2])
        cube([mz_x+mz_z*2,mz_y+magnet_z,magnet_z],center=true);
    }
    place_mz_air() {
        magnets(hose, hose_magnets);
    }

    intersection() {
        translate([0,0,mz_tab_h/2+magnet_z/2])
        cube([mz_x-pipe_wall*2,mz_y-pipe_wall*2,mz_z+magnet_z+pad*2],center=true);
        place_mz_air()
        air(hose,30);
    }
    // angle slice at bottom
    translate([-mz_x,-mz_y/2,magnet_z])
    rotate([180-mz_angle,0,0])
    translate([0,0,-mz_x])
    cube([mz_x*2,mz_z*2,mz_x*2]);

    double_mirror()
    translate([mz_x/2+mz_z/2,(mz_x-mz_tab)/4+mz_tab/2,0])
    mz_screw();

}

module double_mirror() {
    children();
    mirror([1,0,0])
    children();
    mirror([0,1,0])
    children();
    mirror([1,0,0])
    mirror([0,1,0])
    children();
}


//if (display == "" ) both_hoses_assembled();
//if (display == "" ) assembled();
//if (display == "" ) flex_hose();
if (display == "dust_vacuum_coupler.stl" ) vacuum_coupler();
if (display == "dust_vacuum_to_hose_adapter.stl" ) vacuum_to_hose_adapter();
if (display == "dust_hose_grille.stl" ) hose_grille();
if (display == "dust_flex_hose_coupler.stl" ) flex_hose();
if (display == "dust_hose_to_collector_adapter.stl" ) hose_to_collector_adapter();
if (display == "dust_vacuum_to_collector_adapter.stl" ) vacuum_to_collector_adapter()
if (display == "dust_collector_coupler.stl" ) dust_collector();
if (display == "dust_collector_pipe_test.stl" ) dust_collector_pipe_test();
if (display == "dust_magnet_test.stl" ) magnet_test();

module assembled() {
    vacuum_coupler(flip)
    vacuum_to_collector_adapter(flip)
    dust_collector();
}

module both_hoses_assembled() {
    vacuum_coupler(flip)
    vacuum_to_hose_adapter(flip)
    rotate([0,0,180/hose_magnets])
    hose_grille(flip) 
    flex_hose()
    flex_hose(flip)
    hose_to_collector_adapter(flip)
    dust_collector();
}

module vacuum_coupler(flip=0) {
    // https://www.amazon.com/gp/product/B00LPOUW2Q/
    h=40;
    od=37.5;
    flip(flip, h+magnet_z*2)
    vacuum(vacuum,od,h);
    stack(h+magnet_z*2) children();
}

module flip(flag,z) {
    translate([0,0,z*flag])
    mirror([0,0,flag])
    children();
}

module stack(h) {
    translate([0,0,h+gap])
    children();
}

module vacuum_to_hose_adapter(flip=0) {
    flip(flip, magnet_z)
    hose_adapter(vacuum, vacuum_magnets, vacuum);
    stack(magnet_z) children();
}

module vacuum_to_collector_adapter(flip=0) {
    flip(flip, magnet_z)
    collector_adapter(vacuum, vacuum_magnets, vacuum);
    stack(magnet_z) children();
}

module flex_hose(flip=0) {
    h=30;
    flip(flip,h+magnet_z*2)
    hose(-pipe_wall*2, 0, h);
    stack(h+magnet_z*2) children();
}

module hose_to_collector_adapter(flip=0) {
    flip(flip, magnet_z)
    collector_adapter(hose, hose_magnets, hose);
    stack(magnet_z) children();
}

module dust_collector_pipe_test() {
    pipe_test(collector,collector+pipe_wall*2);
}

module dust_collector(flip=0) {
    h=collector_h;
    flip(flip, h+magnet_z*2)
    difference() {
        collector(0,pipe_wall*2,h);
        translate([0,0,collector_screw_offset])
        rotate([90,0,180/collector_magnets])
        cylinder(d=collector_screw,h=collector);
    }
    stack(magnet_z) children();
}

module pipe_test(id,od) {
    h=5;
    difference() {
        pipe(od,h);
        air(id,h);
    }
}

module edge_dot() {
    translate([magnet/2+magnet_wall,0,magnet_z/2])
    sphere(d=dot);
}

module surface_dot() {
    translate([magnet+magnet_wall,0,0])
    sphere(d=dot);
}


module magnet_test() {
    difference() {
        magnet_wall();
        magnet();
        edge_dot();
    }
}

module flange(ring, magnets) {
    hull()
    place_magnets(ring,magnets)
    magnet_wall();
}

module hose_grille(flip=0) {
    flip(flip, magnet_z)
    grille(hose, hose_magnets, hose, 15);
    stack(magnet_z) children();
}

module grille(ring, magnets, id, gap) {
    color("yellow") {
        difference() {
            flange(ring, magnets*2);
            air(id, magnet_z);
            magnets(ring, magnets);
            translate([0,0,magnet_z])
            mirror([0,0,1])
            rotate([0,0,180/magnets])
            magnets(ring, magnets);
        }
        grid(id, gap);
    }
}

module pipe(od,h) {
    cylinder(d=od,h=h-pipe_flange);
    translate([0,0,h-pipe_flange])
    cylinder(d1=od,d2=od-pipe_flange*2,h=pipe_flange);
}

module air(id,h) {
    translate([0,0,-pad])
    cylinder(d=id,h=h+padd);
    translate([0,0,-pad])
    cylinder(d1=id+air_flange*2+padd,d2=id-padd,h=air_flange+padd);

    translate([0,0,h-air_flange-pad])
    cylinder(d2=id+air_flange*2+padd,d1=id-padd,h=air_flange+padd);
}

module magnets(ring, magnets) {
    place_magnets(ring,magnets)
    magnet();
}


module vacuum(id,od,h) {
    coupler(vacuum, vacuum_magnets, id, od, h);
}

module hose(id,od,h) {
    coupler(hose, hose_magnets, hose+id, hose+od, h);
}

module collector(id,od,h) {
    coupler(collector, collector_magnets, collector+id, collector+od, h);
}

module coupler(ring, magnets, id, od, h) {
    color("red")
    difference () {
        union() {
            hull() {
                flange(ring, magnets);
                pipe(od,magnet_z*2);
            }
            pipe(od,h+magnet_z*2);
        }
        air(id,h+magnet_z*2);
        magnets(ring, magnets);
        place_magnets(ring,magnets/2)
        edge_dot();
    }
}


module vacuum_outer_friction() {
    vacuum(0,pipe_wall*2,30);
}

module vacuum_inner_clamp() {
    vacuum(-pipe_wall*2,0,30);
}

module collector_adapter(ring, magnets, id) {
    adapter(collector, collector_magnets, ring, magnets, id);
}

module hose_adapter(ring, magnets, id) {
    adapter(hose, hose_magnets, ring, magnets, id);
}

module adapter(big_ring, big_magnets, small_ring, small_magnets, id) {
    color("blue")
    difference() {
        flange(big_ring, big_magnets);
        magnets(big_ring, big_magnets);
        place_magnets(big_ring,big_magnets/2)
        edge_dot();
        translate([0,0,magnet_z])
        mirror([0,0,1]) {
            magnets(small_ring,small_magnets);
            air(id,magnet_z);
            place_magnets(small_ring,small_magnets/2)
            surface_dot();
        }
    }
}


module magnet_wall() {
    translate([0,0,outer_flange])
    cylinder(d=magnet+magnet_wall*2,h=magnet_h+magnet_z_wall-outer_flange);
    cylinder(
        d1=magnet+magnet_wall*2-outer_flange*2,
        d2=magnet+magnet_wall*2,
        h=outer_flange
    );
}


module magnet() {
    translate([0,0,-pad])
    cylinder(d=magnet+magnet_extra,h=magnet_h+pad);

    translate([0,0,magnet_h+screw_bridge_gap+magnet_z_extra])
    cylinder(d=screw,h=screw_h-magnet_h-screw_bridge_gap-magnet_z_extra);

    translate([0,0,magnet_h])
    cylinder(d1=magnet+magnet_extra,d2=magnet+magnet_extra-magnet_z_extra*2,h=magnet_z_extra);

    translate([0,0,-pad])
    cylinder(d1=magnet+magnet_extra+magnet_flange*2+padd,d2=magnet+magnet_extra-padd,h=magnet_flange+padd);
}

module place_magnets(pipe,magnets) {
    for(i=[0:360/magnets:359]) {
        rotate([0,0,i])
        translate([pipe/2+magnet/2,0,0])
        children();
    }
}


module guard_line(pipe) {
    translate([0,-guard_thick/2,0])
    cube([pipe/2-pipe_wall/2,guard_thick,guard_deep]);
}

module guard_ring(d) {
    difference() {
        cylinder(d=d*2+guard_thick,h=guard_deep);
        translate([0,0,-pad])
        cylinder(d=d*2-guard_thick,h=guard_deep+padd);
    }
}

module short_guard_line(pipe,r,lines=1) {
    half=pipe/2/(guard_rings*2+1);
    for(i=[0:360/lines:359])
    rotate([0,0,i+360/6/2])
    translate([r,-guard_thick/2,0])
    cube([half*2,guard_thick,guard_deep]);
}

module old_lines() {
    difference() {
        for(i=[0:360/guard_lines:359])
        rotate([0,0,i+360/guard_lines/2])
        guard_line(pipe);
        translate([0,0,-pad])
        cylinder(d=pipe/(guard_rings+1),h=guard_deep+padd);
    }
}
    
module guard(pipe) {
    half=pipe/2/(guard_rings*2+1);
    for(i=[half:half*2:pipe/2-1])
    guard_ring(i);

    short_guard_line(pipe,half,3);
    short_guard_line(pipe,half*3,6);
    //short_guard_line(pipe,half*5,12);
}

module grid_line(pipe) {
    translate([-pipe/2,-guard_thick/2,0])
    cube([pipe,guard_thick,guard_deep]);
}

module mirror_y(y) {
    mirror([0,1,0])
    children();
    children();
}

module crisscross() {
    rotate([0,0,90])
    children();
    children();
}

module grid(pipe,gap) {
    intersection() {
        crisscross()
        mirror_y(0)
        for(x=[0:gap:pipe/2])
        translate([0,x,0])
        grid_line(pipe);
        air(pipe,magnet_z);
    }
}


module ball(pipe,h) {
    d=pipe-pipe_wall*2;
    translate([0,0,h/2])
    scale([1,1,h/d])
    sphere(d=d);
}
