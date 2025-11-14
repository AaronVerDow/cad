lines=5; // how many times to repeat the text
size=20;
gap=1.2;

// NOPREVIEW

module label(message) {
    for (i=[0:1:lines-1])
    translate([0,i*size*gap,0])
    text(message, font="Ubuntu: Bold", size=size);
}

// RENDER svg2png
module games(){
    label("games");
}

// RENDER svg2png
module susan(){
    label("susan");
}

// RENDER svg2png
module doorbell(){
    label("doorbell");
}

// RENDER svg2png
module ap(){
    label("ap");
}

// RENDER svg2png
module tv(){
    label("tv");
}

// RENDER svg2png
module titanic(){
    label("titanic");
}

// RENDER svg2png
module files(){
    label("files");
}

// RENDER svg2png
module modem(){
    label("modem");
}
