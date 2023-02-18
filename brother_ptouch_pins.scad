pin=2.54;
size=pin*.60;
height=5*34/35*35/38;  // width of tape

end=1;

// wemos D1 mini
ins=[
  "5v", "GND", "D4", "D3", "D2", "D1", "RX", "TX",
  "RST", "A0", "D0", "D5", "D6", "D7", "D8", "3v3"
];

// BME680
efefpins = [
  "VIN", "3Vo", "GND", "SCK", "SDO", "SDI", "CS"
];

// audio sensor
ypins = [
  "D0", "+", "G", "A0",
  "D0", "+", "G", "A0",
  "D0", "+", "G", "A0",
];

//LTR390
spins = [
  "VIN", "3Vo", "GND", "SCL", "SDA", "INT",
];

// pir
ipins = [ 
  "VCC", "OUT", "GND",
];

// leds
epins = [
  "+", "-", " ",
  "+", "-", " ",
  "+", "-", " ",
];

pins=[];


// RENDER svg
module ftdi() {
	pins=["DIR", "RX", "TX", "VCC", "CTS", "GND"];
	label(pins);
}

// RENDER svg
module esp32_cam() {
pins = [
  "GND", "UOT", "UOR",  "VCC",  "GND",  "IO0", "IO16", "3v3", "---", 
  "5v", "GND", "IO12", "IO13", "IO15", "IO14", "IO2", "IO4",
];
	label(pins);
}



// RENDER svg
module esp32_poe_iso() {
	label([
	  "13", "14", "15", "16", "32", "33", "34", "35", "36", "39",
	  "5v", "3v3", "GND", "EN", "0", "1", "2", "3", "4", "5",
	]);
}

module label(pins) {
	//color("black")
	scale(50) {
		intersection() {
			translate([0,-height])
			square([len(pins)*pin, height]);
			for(n=[0:1:len(pins)-1]) {
				//translate([pin*len(pins)-(pin*n+pin/2),0])
				translate([pin*n+pin/2,0])
				rotate([0,0,-90])
				text(pins[n], valign="center", halign="left", size=size, font="UbuntuMono:Bold");
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

label(pins);
