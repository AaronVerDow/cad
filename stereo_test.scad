text="Aaron";

light=50;
y=150;
seat=300;

shell=50;
wall=0.3;

$fn=100;

ends=3;

translate([0,0,light])
color("white")
sphere(d=5);


module ball() {
    difference() {
        translate([0,0,light])
        difference() {
            sphere(d=shell);
            sphere(d=shell-wall*2);
        }
        cuts();
        translate([0,0,-shell+light-shell/2+ends])
        cylinder(d=shell,h=shell);
        translate([0,0,light+shell/2-ends])
        cylinder(d=shell,h=shell);
    }
}

ball();

module cuts() {
    linear_extrude(height=light,scale=0.01)
    shadow();
}
module shadow() {
    translate([0,-y/2,0])
    text("Aaron",halign="center",font="Yep");
    mirror([0,1,0])
    translate([0,-y/2,0])
    text("Susan",halign="center",font="Yep");
}
