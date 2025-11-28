size=20;
gap=1.2;

module row(message) {
    text(message, font="Ubuntu: Bold", size=size, halign="center");
}
module label(message) {
    row(message);
    translate([0,size*gap,0])
    row("NAD+ 20/50 units");
}

// RENDER svg2png
module anastrozole(){
    label("Anastrozole 1x pill");
}

anastrozole();
