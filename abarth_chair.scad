seat_x=500;
seat_y=200;
seat_z=100;
seat_angle=5;

back_x=seat_x;
back_y=700;
back_angle=seat_angle+5;

in=25.4;
wood=in/2;

module wood(height=wood) {
    linear_extrude(height=height)
    children();
}

rotate([-seat_angle,0])
translate([-seat_x/2,-seat_y,-wood])
wood()
square([seat_x,seat_y]);

rotate([90-back_angle,0])
translate([-back_x/2,0,-wood])
wood()
square([back_x,back_y]);
