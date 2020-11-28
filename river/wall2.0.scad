//Customizable Stone Wall
//Created by Ari M. Diacou, January 2014 (updated February, 2014)
//Shared under Creative Commons License: Attribution-ShareAlike 3.0 Unported (CC BY-SA 3.0) 
//see http://creativecommons.org/licenses/by-sa/3.0/

function arc_angle(t,r) = t/(PI/180*r);
function arc_x(t,r) = r-sin(arc_angle(t))*r;
function arc_y(t,r) = cos(arc_angle(t))*r;

// preview[view:south east, tilt:side]
/*[Wall]*/
//Length of a stone
U=3;
//Thickness of wall
V=2;
//Height of a stone
W=1;
//Number of stones along wall
num_x=5;
//The wall height in number of stones
num_z=3;
//A way to save the arrangement of stones
master_seed=14;
//Higher angles make more wedge-shaped stones, lower angles produce blocks. Reccomend 5-30 (zero crashes).
maximum_rotation_angle=12;
//Higher rotation angles might need more compression
z_compression=0.9;
//Number of cubes that make up a block
n=8; 
//A way to reduce the abilty of higher n to chop up a block (should be -2 to 0)
power=0;

pad=0.1;


/*[Mortar]*/
//Do you want mortar between the stones?
mortar=1; //[1,0]
//What percentage of a brick do you want the mortar in the running direction?
u_adjust=-0.15;
//How much of the wall's thickness do you want the mortar to take up?
v_ratio=0.5;

/*[Base]*/
//Do you want a base for the wall
base=1; //[1,0]
//What percentage of a brick do you want the base to extend from the wall in the running direction?
bx_adjust=0.1;
//What percentage of a brick do you want the base to extend in the front and back of the wall?
by_adjust=0.1;
//What percentage of a brick do you want the base's height to be?
bz=.5;

/*[Hidden]*/
dimensions=[U,V,W];
half_dimensions=[U/2,V,W];

big_fn=400;

path();

module path() {
    wall(5, 20)
    wall(5, 10, 1)
    wall(5, 30, 1)
    wall(10,10,1);
}

module rock(unit_dimension, max_rotation, seed){
	random=rands(-1,1,n*3,seed);
		intersection(){
			intersection_for(i=[0:n-1]){
				rotate([	max_rotation*random[3*i+0]*pow(i,power),
							max_rotation*random[3*i+1]*pow(i,power),
							max_rotation*random[3*i+2]*pow(i,power)])
					cube(unit_dimension, center=true);
					}
			}	
	}

module pie_slice(r, start_angle, end_angle) {
    // http://forum.openscad.org/Creating-pie-pizza-slice-shape-need-a-dynamic-length-array-td3148.html
    R = r * sqrt(2) + 1;
    a0 = (4 * start_angle + 0 * end_angle) / 4;
    a1 = (3 * start_angle + 1 * end_angle) / 4;
    a2 = (2 * start_angle + 2 * end_angle) / 4;
    a3 = (1 * start_angle + 3 * end_angle) / 4;
    a4 = (0 * start_angle + 4 * end_angle) / 4;
    if(end_angle > start_angle)
        intersection() {
        circle(r);
        polygon([
            [0,0],
            [R * cos(a0), R * sin(a0)],
            [R * cos(a1), R * sin(a1)],
            [R * cos(a2), R * sin(a2)],
            [R * cos(a3), R * sin(a3)],
            [R * cos(a4), R * sin(a4)],
            [0,0]
       ]);
    }
}


module wall(num_x, radius, direction=0){
    mortar_z=W*(num_z-1)*z_compression;

    //#circle(r=radius,$fn=big_fn);
    mirror([0,direction])
    translate([0,radius])
    union() {
        difference(){
            for(z=[0:num_z-1]){
                for(x=[0:num_x-1]){
                    if(half_condtion(x, z, num_x)){
                        color("SlateGray")
                        rotate([0,0,arc_angle(U*(x+0.5-0.25),radius)])
                        translate([0,-radius,z*W*z_compression]) 
                        rock(half_dimensions,maximum_rotation_angle,num_x*z+x+master_seed);
                    } else {
                        color("SlateGray")
                        rotate([0,0,arc_angle(U*(x+0.5-0.25*(1+pow(-1,z))),radius)])
                        translate([0,-radius,z*W*z_compression]) 
                        rock(dimensions,maximum_rotation_angle,num_x*z+x+master_seed);
                    }
                }
            }
            translate([-0.25*U,-V/1.3,-W])
            cube([U*num_x,V*1.5,W]);
        }

        //translate([(-u_adjust)*U,-V*v_ratio/2,0])
        //color("silver")
        //cube([(num_x-0.5+2*u_adjust)*U,V*v_ratio,mortar_z]);

        if(mortar==1)
        color("silver")
        intersection() {
            difference() {
                cylinder(r=radius+V*v_ratio/2,h=mortar_z,$fn=big_fn);
                translate([0,0,-pad])
                cylinder(r=radius-V*v_ratio/2,h=mortar_z+pad*2,$fn=big_fn);
            }

            translate([0,0,-pad*2])
            linear_extrude(height=mortar_z+pad*4)
            rotate([0,0,-90])
            pie_slice(radius*2,arc_angle(U*0.25,radius),arc_angle((num_x-1+0.25)*U,radius));
        }

        if(base==1)
        color("green")
        translate([0,0,-W*(bz-0.01)])
        intersection() {
            difference() {
                cylinder(r=radius+V*(1+2*by_adjust)/2,h=W*bz,$fn=big_fn);
                translate([0,0,-pad])
                cylinder(r=radius-V*(1+2*by_adjust)/2,h=W*bz+pad*2,$fn=big_fn);
            }

            translate([0,0,-pad*2])
            linear_extrude(height=W*bz+pad*4)
            rotate([0,0,-90])
            pie_slice(radius*2,arc_angle(-bx_adjust*U,radius),arc_angle(U*(num_x-0.5+2*bx_adjust),radius));
        }


        //translate([-bx_adjust*U,-(.5+by_adjust)*V,-W*(bz-0.01)])
        //cube([U*(num_x-0.5+2*bx_adjust),V*(1+2*by_adjust),W*bz]);
    }
    mirror([0,direction])
    translate([0,radius])
    rotate([0,0,arc_angle(U*(num_x-0.5),radius)])
    translate([0,-radius])
    children();
}

function half_condtion(i, j, num_i)=((i==0 && j%2==0) || (i==num_i-1 && j%2==1));

