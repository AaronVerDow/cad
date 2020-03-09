in=25.4;

magnet=3/8*in;
magnet_h=1/8*in;
magnet_wall=3;
magnet_z_wall=6;
magnet_z=magnet_h+magnet_z_wall;

pipe_wall=2.5;


// vacuum = 2.5 inch hose
vacuum=2.5*in;
vacuum_magnets=4;

// hose = 4 inch hose
hose=4*in;
hose_magnets=6;

// collector = 5+ inch connector to dust collector
collector=5.5*in;
collector_magnets=8;



pipe_wall=3;


clamp_h=50;

pad=0.1;
padd=pad*2;

screw=3;

guard_lines=6;

guard_rings=2;

guard_thick=1;
guard_deep=clamp_h;
guard_min_deep=5;

grid_gap=30;

not_cut=clamp_h/2;
cut_h=clamp_h-not_cut;

gap=20;

module assembled() {
    
    translate([0,0,40])
    mirror([0,0,1])
    vacuum(-pipe_wall*2,0,40);

    translate([0,0,40+gap]) {

        translate([0,0,magnet_z])
        mirror([0,0,1])
        hose_adapter(vacuum, vacuum_magnets, vacuum);

        rotate([0,0,180/hose_magnets])
        translate([0,0,magnet_z+gap]) {
            translate([0,0,magnet_z])
            mirror([0,0,1])
            hose_grille();
            translate([0,0,magnet_z+gap]) {
                hose(-pipe_wall*2,0,50);
                translate([0,0,50+gap]) {
                    translate([0,0,50])
                    mirror([0,0,1])
                    hose(-pipe_wall*2,0,50);
                    translate([0,0,50+gap]) {

                        translate([0,0,magnet_z])
                        mirror([0,0,1])
                        collector_adapter(hose, hose_magnets, hose);
                        translate([0,0,magnet_z+gap]) {
                            collector(-pipe_wall*2,0,50);
                        }
                    }
                }
            }
        }
    }
}


assembled();

module flange(ring, magnets) {
    hull()
    place_magnets(ring,magnets)
    magnet_wall();
}

module hose_grille() {
    grille(hose, hose_magnets, hose, 15);
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
    cylinder(d=od,h=h);
}

module air(id,h) {
    translate([0,0,-pad])
    cylinder(d=id,h=h+padd);
}

module magnets(ring, magnets) {
    place_magnets(ring,magnets)
    magnet();
}


module vacuum(id,od,h) {
    coupler(vacuum, vacuum_magnets, vacuum+id, vacuum+od, h);
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
            pipe(od,h);
        }
        air(id,h);
        magnets(ring, magnets);
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
        translate([0,0,magnet_z])
        mirror([0,0,1])
        magnets(small_ring,small_magnets);
        air(id,magnet_z);
    }
}


module magnet_wall() {
    cylinder(d=magnet+magnet_wall*2,h=magnet_h+magnet_z_wall);
}

module magnet() {
    translate([0,0,-pad])
    cylinder(d=magnet,h=magnet_h+pad);
    cylinder(d=screw,h=magnet_h*2+magnet_wall*2);
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
