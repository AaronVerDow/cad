use <joints.scad>;
in=25.4;
$fn=100;
zero=0.1;

function segment_radius(height, chord) = (height/2)+(chord*chord)/(8*height);


slide_w=5*in;
base_y=500;

curve_r=3*in*12;
base_leg();

module base_leg() {
    slide_top_x=800;
    slide_top_angle=atan(base_y/(slide_top_x));
    slide_top_bar=(slide_top_x)/cos(slide_top_angle);
    a=slide_top_bar;
    b=curve_r+slide_w/2;
    c=curve_r;
    wtf=((a*a)+(b*b)-(c*c))/(2*a*b);
    final=acos(wtf);

    // troubleshooting
    //base_leg(); translate([slide_top_x,0]) #circle(d=20);
    color("lime") translate([0,-10+base_y,1]) rotate([0,0,-slide_top_angle]) square([slide_top_bar,20]);
    
    difference() {
        hull() {
	    translate([slide_top_x,0])
	    #circle(d=slide_w,$fn=100);

            square([zero,base_y]);
        }

        translate([slide_top_x,0])
        rotate([0,0,90-slide_top_angle-final])
        translate([0,curve_r+slide_w/2])
        circle(r=curve_r,$fn=1000);
    }
}
