pin=2.54; // width between pins
size=pin*.70; // font size
height=5*34/35*35/38;  // width of tape, adjusted to match printable area
// this should match 6mm tape for Brother ptouch 2
// extra will be clipped to this height
end=0.3; // how thick end lines are
// end lines are required for consistent scaling by taper 
REVERSE=1; // add as arg to label to flip order
scl=50; // how large to scale up (makes printing cleaner)
font="Roboto Mono:Bold";
zero=0.01;  // how thick preview is

linear_extrude(height=zero)
spaced() {
	// add stuff here for previews
	esp32_poe_iso();
	wemos_d1_mini();
	esp32_cam();
	bme680();
	audio_sensor();
	ltr390();
	pir();
	motion_leds();
	ftdi();
}

// RENDER svg2png
module wemos_d1_mini() {
	label([
	  "5v", "GND", "D4", "D3", "D2", "D1", "RX", "TX",
	  "RST", "A0", "D0", "D5", "D6", "D7", "D8", "3v3"
	]);
}

// RENDER svg2png
module bme680() {
	label([
		"VIN", "3Vo", "GND", "SCK", "SDO", "SDI", "CS"
	]);
}

// RENDER svg2png
module audio_sensor() {
	label([
		"D0", "+", "G", "A0",
	]);
}

// RENDER svg2png
module ltr390() {
	label([
		"VIN", "3Vo", "GND", "SCL", "SDA", "INT",
	]);
}

// RENDER svg2png
module pir() {
	label([ 
		"VCC", "OUT", "GND",
	]);
}

// RENDER svg2png
module motion_leds() {
	label([
		"+", "-", " ",
		"+", "-", " ",
		"+", "-", " ",
	]);
}

// RENDER svg2png
module ftdi() {
	label([
		"DIR", "RX", "TX", "VCC", "CTS", "GND"
	]);
}

// RENDER svg2png
module esp32_cam() {
	label([
		"GND", "UOT", "UOR",  "VCC",  "GND",  "IO0", "IO16", "3v3", "---", 
		"5v", "GND", "IO12", "IO13", "IO15", "IO14", "IO2", "IO4",
	], size=pin*0.5);
}

// RENDER svg2png
module esp32_poe_iso() {
	label([
		"13", "14", "15", "16", "32", "33", "34", "35", "36", "39",
		"5v", "3v3", "GND", "EN", "0", "1", "2", "3", "4", "5",
	]);
}

module spaced() {
    for ( i= [0:1:$children-1])
    translate([0,height*1.5*i*scl,0])
    children(i);
}           

module label(pins, reverse=0, size=size) {
	//color("black")
	module txt(n) {
            rotate([0,0,-90])
            text(pins[n], valign="center", halign="left", size=size, font=font);
        }
	scale(scl) {
		intersection() {
			translate([0,-height])
			square([len(pins)*pin, height]);
			for(n=[0:1:len(pins)-1]) {
				if(reverse) {
					translate([pin*n+pin/2,0])
					txt(n);
				} else {
					translate([pin*len(pins)-(pin*n+pin/2),0])
					txt(n);
				}
			}
		}
		*translate([0,-height])
		#square([len(pins)*pin, height]);
		translate([-end/2-pin/2,-height])
		square([end,height]);
		translate([len(pins)*pin+pin/2-end/2,-height])
		square([end,height]);
	}
}
