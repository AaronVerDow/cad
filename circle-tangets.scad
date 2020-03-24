// Tangent points of two circles
// Sources
// http://www.ambrsoft.com/TrigoCalc/Circles2/Circles2Tangent_.htm
// http://mathworld.wolfram.com/Circle-CircleTangents.html

function sqr(x) = pow(x,2);
function sqrt(x) = pow(x, 1/2);

function getx(c, r, sc, s=1) =	let (cx=c[0], cy=c[1], px=sc[0], py=sc[1]) ((sqr(r)*(px-cx)+(s*r*(py-cy)*sqrt(sqr(px-cx)+sqr(py-cy)-sqr(r)))) /
			(sqr(px-cx)+sqr(py-cy)))
			+cx;

function gety(c, r, sc, s=1) =	let (cx=c[0], cy=c[1], px=sc[0], py=sc[1]) ((sqr(r)*(py-cy)+(s*r*(px-cx)*sqrt(sqr(px-cx)+sqr(py-cy)-sqr(r)))) /
			(sqr(px-cx)+sqr(py-cy)))
			+cy;
			
// Get center of similitude, either internal or external		
// s=-1 for external and 1 for internal
function GetSimCentre (c0, r0, c1, r1, s=-1) = let (a=c0[0], b=c0[1], c=c1[0], d=c1[1]) [(c*r0+s*a*r1)/(r0+s*r1), (d*r0+s*b*r1)/(r0+s*r1)];

// c=centre of circle, r=radius, sc=center of similitude
// s selects which tangent point on circle depending on whether 1 or -1
function GetTangent (c, r, sc, s=1) = [getx(c, r, sc, s), gety(c, r, sc, s=-s)];

// test
$fn = 64;

// Some test circles
c0 = [25, 6];
r0 = 10;
c1 = [5, 22];
r1 = 3;

// Show circles with both internal and etxernal points of similitude
for (whichsc = [-1, 1]) translate ([(r0+r1)*1*whichsc, 0, 0]) {
	// Get center of similitude, either internal or external		
	// s=-1 for external and 1 for internal
	sc = GetSimCentre(c0, r0, c1, r1, s=whichsc); 

	// Points on C0
	t0 = GetTangent(c0, r0, sc, s=1);
	t1 = GetTangent(c0, r0, sc, s=-1);

	// Points on C1
	t2 = GetTangent(c1, r1, sc, s=1);
	t3 = GetTangent(c1, r1, sc, s=-1);

	// Show circles
	linear_extrude (height=1) {
		// translate (c0) circle (r=r0);
		// translate (c1) circle (r=r1);
	}

	/*  Points just for debug
	translate (sc) color ("blue") circle (r=1);
	translate (t0) color ("blue") circle (r=1);
	translate (t1) color ("blue") circle (r=1);
	translate (t2) color ("blue") circle (r=1);
	translate (t3) color ("blue") circle (r=1);
	*/
	
	// Show "fillet" based on point of similitude
	translate ([0, 0, 0.01]) color("red") linear_extrude (height=0.98) polygon ([t0, t2, t3, t1]);
}
