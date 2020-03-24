// Spline: piece that runs horizonal on the roof.  The tile lips grip this to stay on the roof.

// Spline width.
spline_w = 12.5;

// Spline height above the flat surface of the roof.  This is how much the tiles can grip.
spline_h = 12.5; 

// Gap between each spline.  This should be shorter than the tiles.
spline_gap = 75;

// Height of surface beneath splines.  Used for visualzaion.
surface_h = 1;

pad = 0.1;
padd = pad*2;

module surface(x, y) {
    color("cyan")
    translate([0,0,-surface_h])
    cube([x,y,surface_h]);
}

module spline(width){
    cube([width,spline_w,spline_h]);
}

module splines(x, y) {
    surface(x, y);
    for(n=[0:spline_gap:y]) {
        translate([0,n,0])
        spline(x);
    }
}


//splines(400,spline_gap*4);


module curve(x,y,z,wall) {
    difference() {
        // outer big circle
        scale([1,1,(z+wall*2)/(x+wall)])
        translate([x/2,0,0])
        rotate([-90,0,0])
        cylinder(d=x+wall, h=y); 
        
        // cut out inside
        translate([0,-pad,0])
        scale([1,1,z/(x-wall)])
        translate([x/2,0,0])
        rotate([-90,0,0])
        cylinder(d=x-wall, h=y+padd); 

        // cut off one half
        translate([-pad-wall/2,-pad,0])
        cube([x+wall+padd,y+padd,z+padd]);
   }
}

// Ridge: Convex portion of a tile.
// Valley: Concave portion of a tile.

// Width of the tile.  Actual width will be tile width plus tile wall.
tile_x = 100;

// How long the tile is hanging down the roof.
tile_overlap_y = 20;
tile_y = 100;
tile_max_y = tile_y + tile_overlap_y;

// How thick the tile is in profile.
tile_wall = 4;

// Distance from inside arc of the ridge to inside surface of valley.
tile_z = 30;

// What percentage of tile x belongs to the ridge.
tile_ridge_width_ratio=0.2;
tile_ridge_x = tile_x * tile_ridge_width_ratio;
tile_ridge_x1 = tile_x * tile_ridge_width_ratio;
tile_valley_x = tile_x - tile_ridge_x;

// What percentage of tile overall thickness belongs to the ridge.
tile_ridge_height_ratio=0.5;
tile_ridge_z = tile_z * tile_ridge_height_ratio;
tile_valley_z = tile_z - tile_ridge_z;

lock_x=tile_wall/2;
lock_y=tile_max_y+padd;
lock_z=tile_wall/4;



module lip_lock(x,y,z) {
    translate([0,-pad,0])
    cube([x/2,y+padd,z/2]);
    translate([-x/2,-pad,-z/2])
    cube([x/2,y+padd,z/2]);
}

module tile_positive(){
    curve(tile_valley_x,tile_max_y,tile_valley_z,tile_wall);
    rotate([0,180,0])
    curve(tile_ridge_x,tile_max_y,tile_ridge_z,tile_wall);


    // ridge positive lock
    translate([-tile_ridge_x-lock_x,-pad,-lock_z])
    cube([lock_x,lock_y,lock_z]);

    // valley positive lock
    translate([tile_valley_x,-pad,0])
    cube([lock_x,lock_y,lock_z]);
}

module tile() {
    difference() {
        tile_positive();

        // ridge negative lock
        translate([-tile_ridge_x,-pad,-pad])
        cube([lock_x*2,lock_y,lock_z+pad]);

        // valley negative lock
        translate([tile_valley_x-lock_x*2,-pad,-lock_z])
        cube([lock_x*2,lock_y,lock_z+pad]);
    }
}

tile();
