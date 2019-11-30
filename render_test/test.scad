$fn=6;

// put the individual pieces in modules
module ball() {
    sphere(10);
}

module flat() {
    circle(20);
}

module fine() {
    $fn=200;
    ball();
}

// create a view that you want to edit in
module assembled() {
    ball();
    thing();
}

// this variable must be initialized
// the specific name is not important as long as it's consistent
display="";

// call a module for openscad to display when editing
if (display == "") assembled();

// specify output files render_scad.sh will write to and which modules dispaly them
if (display == "test_fine.stl") fine();
if (display == "test_ball.stl") ball();
if (display == "test_flat.dxf") flat();
