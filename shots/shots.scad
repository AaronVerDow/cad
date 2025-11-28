size=20;
gap=1.2;

module row(message) {
    text(message, font="Ubuntu: Bold", size=size, halign="center");
}
module label(message) {
    row(message);
    translate([0,size*gap,0]) {
	row("   NAD+ 20/50 units LH");
	chill(139);
    }
}

// RENDER svg2png
module anastrozole(){
    label("Anastrozole 1x pill");
}

module chill(x=0) {
    offset=107.5;
    translate([-x,size/2])
    scale(0.1)
    translate([-offset, -offset+1])
    import("snowflake.svg");
}

// RENDER svg2png
module testosterone() {
    label("Testosterone 0.75/3 ml Glut");
}

// RENDER svg2png
module gonadorelin() {
    label("   Gonadorelin 25/50 units LH");
    chill(181.5);
}


// RENDER svg2png
module mic() {
    label("MIC+ 100/100 units Glut");
}

mic();
