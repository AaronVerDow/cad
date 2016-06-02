//find these values in inkscape
max_x = 18.665;
max_y = 80.282;

shelf_from_top = 4;
shelf_from_bottom = 4;

shelves = 7;
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
  scale([25.4/90, -25.4/90, 1])
  {
      polygon([[-31.267068,-141.732290],[-32.391164,-141.699563],[-32.512460,-141.656532],[-31.198744,-141.593839],[5.523896,-141.118150],[11.370560,-134.756413],[16.372503,-128.876297],[20.581918,-123.413658],[24.050998,-118.304351],[26.831936,-113.484231],[28.976924,-108.889152],[30.538157,-104.454970],[31.567826,-100.117540],[32.118125,-95.812716],[32.241246,-91.476354],[31.989383,-87.044308],[31.414728,-82.452435],[29.505815,-72.532622],[26.932050,-61.203756],[24.110976,-47.952677],[21.460137,-32.266225],[20.329038,-23.349371],[19.397076,-13.631239],[18.716445,-3.047684],[18.339337,8.465440],[18.317945,20.972277],[18.704462,34.536973],[19.551082,49.223671],[20.909996,65.096518],[22.833398,82.219659],[25.373480,100.657238],[28.582437,120.473400],[32.512460,141.732290],[-23.249983,141.600028],[-31.267068,141.732290],[-31.299085,106.589590],[-31.267068,-141.732290]]);
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
