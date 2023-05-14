//f="Fundamental Rush";
//f="Six Caps";
//f="Fledgling";

//f="Steelfish"; // printed 
f="League Gothic:Condensed Regulator";

// RENDER svg2png
module label() {
	text(
		"@Aaron VerDow",
		valign="bottom",
		halign="center",
		size=23,
		font=f
		
	);
	translate([0,-1])
	text(
		"(502)-712-8945 aaron@verdow.com",
		valign="top",
		halign="center",
		font=f
	);
}

label();
