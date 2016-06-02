//find these values in inkscape
max_x = 19.837;
max_y = 80.282;

shelf_from_top = 8;
shelf_from_bottom = 4;

shelves = 6;
shelf_gap = (max_y-shelf_from_top-shelf_from_bottom)/shelves;

plywood = 0.5;

gap = 1/16;
gapp = gap*2;

pad = 0.1;
padd = pad*2;

wall=3;
tab=3;

module inkscape() {
    translate([max_x/2,max_y/2])
    scale([25.4/90, -25.4/90, 1]) union() {
        polygon([[-34.624245,-141.732290],[-24.871105,-128.609398],[-15.741286,-114.525819],[-7.265988,-99.556167],[0.523588,-83.775058],[7.596243,-67.257106],[13.920775,-50.076925],[19.465985,-32.309129],[24.200672,-14.028334],[28.093635,4.690847],[31.113675,23.773799],[33.229590,43.145907],[34.410180,62.732558],[34.624245,82.459136],[33.840584,102.251027],[32.027997,122.033616],[29.155283,141.732290],[-26.607159,141.600028],[-34.624245,141.732290],[-32.784021,138.144433],[-30.779491,133.524406],[-28.314906,126.900132],[-25.587431,118.181473],[-22.794234,107.278292],[-20.132482,94.100454],[-17.799341,78.557820],[-15.991979,60.560254],[-14.907561,40.017620],[-14.743255,16.839780],[-15.696228,-9.063402],[-16.653309,-23.065164],[-17.963647,-37.782063],[-19.651888,-53.225366],[-21.742678,-69.406340],[-24.260663,-86.336253],[-27.230488,-104.026370],[-30.676800,-122.487960],[-34.624245,-141.732290]]);
    }
}

module solid() {
    difference() {
        intersection() {
            rotate_extrude()
            inkscape();
            cube([max_x,max_x,max_y]);
        }
        translate([0,plywood,0])
        shelf_tab_cuts();
        rotate([0,0,90])
        shelf_tab_cuts();
   }
}

module shelf_tab_cuts() {
    rotate([90,0,0])
    linear_extrude(height=plywood+pad)
    difference() {
        union() {
            translate([pad,0])
            inkscape();
            translate([-pad,0])
            inkscape();
        }
        difference() {
            intersection() {
                translate([-wall,0])
                inkscape();
                translate([wall,0])
                inkscape();
            }
            intersection() {
                translate([-wall-tab,0])
                inkscape();
                translate([wall+tab,0])
                inkscape();
            }
        }
    }
}

module shelf(i) {
    projection(cut=true)
    translate([0,0,-i*shelf_gap-shelf_from_bottom])
    solid();
}

module assemble_shelves() {
    for(i=[0:shelves-1]) {
        translate([0,0,i*shelf_gap+shelf_from_bottom])
        linear_extrude(height=plywood)
        shelf(i);
    }
}

module side3d() {
    difference() {
        translate([0,0,-plywood])
        linear_extrude(height=plywood)
        inkscape();
        translate([-gap,0,0])
        rotate([-90,0,0])
        assemble_shelves();
        translate([gap,0,0])
        rotate([-90,0,0])
        assemble_shelves();
    }
}

module side2d() {
    projection()
    side3d();
}

module assemble() {
    color("magenta")
    assemble_shelves();
    rotate([90,0,0])
    side3d();
    translate([plywood,0,0])
    rotate([90,0,90])
    side3d();
}

tree = 3;

module plate() {
    for(i=[0:shelves-1]) {
        translate([0,i*(max_x+tree)])
        shelf(i);
    }
    translate([max_x+tree,0])
    side2d();
    translate([(max_x+tree)*2,0])
    side2d();
}
//plate();
assemble();
