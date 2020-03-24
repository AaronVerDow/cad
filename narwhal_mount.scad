y=52;
x=-3;
z=25.4/8;
z=25.4/8-0.8;;
use <narwhal.scad>;

pad=0.1;
padd=pad*2;

gap=0.1;

inner_h=7;
inner_w=15;

outer_h=28;
outer_w=28;

text_x=-2;
text_y=16;

spacing_x=100;
spacing_y=40;

columns=4;
rows=6;

fins_cut_angle=-35;
fins_offset=[-outer_w-5,y/4,-z/2];

right=[0,0,0];
left=[1,0,0];
in=25.4;

board=[24*in,3*in];


names=[
    [
        ["Joe", 1],
        ["Jane", 1],
        ["Judy", 1],
        ["Mark", 1],
        ["Jynn", 1],
        ["Ryan", 1],
    ], [
        ["Dave", 1],
        ["Mary", 1],
        ["Eric", 1],
        ["Alex", 1],
        ["Aaron", 1],
        ["Chris", 1],
    ], [
        ["Katie", 1],
        ["Daniel", 0.9],
        ["Susan", 0.9],
        ["Hannah", 0.8],
        ["Lauren", 0.8],
        ["Dennis", 0.8],
    ], [
        ["Hannah", 0.8],
        ["Shannon", 0.7],
        ["Meredith", 0.7],
        ["Garrison", 0.7],
        ["Joe", 1],
        ["Aaron", 1],
    ], [
        ["Whitney", 0.7],
        ["Marietta", 0.7],
    ], [
        ["", 1],
        ["", 1],
        ["", 1],
        ["", 1],
        ["Emelia", 0.9],
        ["Chris", 1],
    ],
];
text_scale=1;

fit=0.95;
board_x_offset=10;
board_y_offset=-5;

module narwhal() {
    mirror([1,0,0])
    difference() {
        translate([-x,y/2])
        poly_path3403();
        translate([z,0])
        square([z+gap*2, inner_h/2+(outer_h-inner_h)/4]);
    }
}

module fins() {
    difference() {
        scale([1,outer_h/outer_w])
        circle(d=outer_w,h=z);
        scale([1,inner_h/inner_w])
        circle(d=inner_w);
        translate([-outer_w,-outer_h])
        square([outer_w*2,outer_h]);
        translate([-z/2-gap,inner_h/2+(outer_h-inner_h)/4])
        square([z+gap*2,outer_h]);
    }
}

module name_text(name, size) {
    translate([text_x,text_y])
    scale([size,size])
    text(name, valign="baseline", halign="center");
}

module name(name, size) {
    difference() {
        narwhal();
        name_text(name, size);
    }
}

module names_clumped() {
    translate([0,0,-z/2])
    linear_extrude(height=z)
    narwhal();
    color("magenta")
    translate([0,0,-z/2+pad])
    linear_extrude(height=z)
    for(column=[0:1:columns-1]) {
        for(row=[0:1:rows-1]) {
            name_text(names[column][row][0], names[column][row][1]);
        }
    }
}

module assembled_names() {
    for(column=[0:1:columns-1]) {
        translate([column*spacing_x,0])
        for(row=[0:1:rows-1]) {
            translate([0,row*spacing_y,0]) {
                rotate([90,0,0]) {
                    translate([0,0,-z/2])
                    linear_extrude(height=z)
                    name(names[column][row][0], names[column][row][1]);
                    translate([-z,0,0])
                    rotate([0,90,0])
                    translate([0,0,-z])
                    linear_extrude(height=z)
                    fins();
                }
            }
        }
    }
}


module backing() {
    translate([0,0,-z]) {
        #square(board);
        translate([0, board[1]*1.5])
        #square(board);
    }
}

module board(c) {
    translate([0,-board_y_offset/2,0])
    to_cut_boards(c);
    translate([0,board_y_offset/2,0])
    translate(board)
    rotate([0,0,180])
    to_cut_boards(c+1);
}

module boards() {
    board(0);
    translate([0, board[1]*1.5])
    board(2);
    translate([0, board[1]*3])
    board(4);
}


module to_cut_boards(column) {
    scale([fit,fit,1])
    translate([spacing_x/2+board_x_offset,0])
    for(row=[0:1:rows-1]) {
        translate([row*spacing_x,0]) {
            name(names[column][row][0], names[column][row][1]);
            translate([-outer_w-5,3])
            fins();
        }
    }
}

module to_cut() {
    for(column=[0:1:columns-1]) {
        translate([column*spacing_x,0])
        for(row=[0:1:rows-1]) {
            translate([0,row*spacing_y,0]) {
                name(names[column][row][0], names[column][row][1]);
                translate(fins_offset)
                rotate([0,0,fins_cut_angle])
                fins();
            }
        }
    }
}

module flat_to_cut() {
    projection()
    to_cut();
}

boards();
//assembled();
//assembled_names();

module assembled() {
    rotate([90,0,0]) {
        names_clumped();
        rotate([0,90,0])
        translate([0,0,-z])
        linear_extrude(height=z)
        fins();
    }
}
