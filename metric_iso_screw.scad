/*
 *    based on:
 *    polyScrewThread_r1.scad      by aubenc @ Thingiverse
 *    extended:
 *    metric_iso_screw.scad  by stth
 *
 * This script contains the library modules that can be used to generate
 * threaded rods, screws and nuts.
 * 
 * added documentation
 * 
 * added support for stump thread peaks as in ISO Threads, no fillets (round) but flats in the valleys
 *
 * http://www.thingiverse.com/thing:8796
 * http://www.thingiverse.com/thing:269863
 *
 * CC Public Domain
 */

// makes nuts and (negative) inner threads wider,
// screws and outer threads tighter
tolerance = 0.05;

/*
 * creates a thread with on rotation below z = 0 and one rotation above the number of rotations
 * a zylinder fills the thread, if icut>0, the valleys are stump
 * 
 * @param ttn  number of rotations between 0 and ttn*st
 * @param st   thread pitch
 * @param sn   number of shapes per revolution ($fn)
 * @param or   radius of the outer thread peak independent of the icut or ocut
 * @param ir   radius of the inner thread peak independent of the icut or ocut
 * @param icut amount to cut from the inner thread peaks
 * @param $fn  should be 30 minimum (do not use $fs or $fa)
 */
module full_thread(ttn, st, or, ir, icut)
{
	sn = $fn;
	// pitch per rotation
	zt = st/sn;
	// revolution angle of one shape
	lfxy = 360/sn;
	
	if(ir >= 0.2)
	{
		union()
		{
			for(i = [0 : ttn-1])
			{
				for(j = [0 : sn-1])
				{
					assign(
							// j+1 for trigonometric functions
							// rounding errors make ghost shapes if j+1 is used
							j1_a = (j+1) % sn,
							// j+1 for absolute coordinates
							j1_s = j+1
						)
					{
					assign(	
							pt = [
									// lower inner thread peak
									[ir * cos(j*lfxy),    ir * sin(j*lfxy),    (i-1)  *st + j*zt      ],
									[ir * cos(j1_a*lfxy), ir * sin(j1_a*lfxy), (i-1)  *st + j1_s*zt   ],
									// middle outer thread peak
									[or * cos(j*lfxy),    or * sin(j*lfxy),    (i-0.5)*st + j*zt      ],
									[or * cos(j1_a*lfxy), or * sin(j1_a*lfxy), (i-0.5)*st + j1_s*zt   ],
									// upper inner thread peak
									[ir * cos(j*lfxy),    ir * sin(j*lfxy),    i      *st + j*zt      ],
									[ir * cos(j1_a*lfxy), ir * sin(j1_a*lfxy), i      *st + j1_s*zt   ],
								]
						)
					{
						polyhedron(
								points = pt,
								triangles = [
										// below
										[0, 2, 1], [1, 2, 3],
										// above
										[3, 2, 4], [3, 4, 5],
										// right/left
										[5, 1, 3], [0, 4, 2],
										// inner
										[1, 4, 0], [1, 5, 4]
									]
						);
					}
					}
				}
			}
			
			translate([0, 0, -st])
			cylinder(h = (ttn+1)*st, r = ir+icut, center = false);
		}
	}
	else
	{
		echo("ERROR in module full_thread:");
		echo("      Step Degrees too agresive, the thread will not be made!!");
		echo("        try to:");
		echo("        increase de value for the degrees and/or...");
		echo("        decrease the pitch value and/or...");
		echo("        increase the outer diameter value!");
		echo(" ");
	}
}

/*
 * creates the filling shape for a <b>screw</b> thread according to the mode in parameter cs
 *
 * @param cs   decides
 *             -- whether a inner or outer thread is created
 *             and
 *             -- whether a cone-cut at the ends of the thread is applied (for easier handling)
 *             values:
 *             --   -2  for nut: none
 *             --   -1  for screw: only on the head side of the thread
 *             --    0  for screw: none
 *             --    1  for screw: only at the end of the screw
 *             --    2  for screw: at both ends if the thread
 * @param lt   length of thread
 * @param or   radius of outer thread helix independent of the icut or ocut
 * @param ir   radius of inner thread helix independent of the icut or ocut
 * @param st   thread pitch
 * @param ocut amount to cut from the outer thread peaks
 * @param $fn  should be 30 minimum (do not use $fs or $fa)
 */
module thread_shape(cs, lt, or, ir, st, ocut)
{
	if ( cs == 0 )
	{
		cylinder(
				h = lt,
				r = or-ocut,
				center = false
			);
	}
	else
	{
		intersection()
		{
			union()
			{
				translate([0, 0, st/2])
				cylinder(
						h = lt-st+0.005,
						r = or,
						center = false
					);
				
				if ( cs == -1 || cs == 2 )
				{
					cylinder(
							h = st/2,
							r1 = ir,
							r2 = or,
							center = false
						);
				}
				else
				{
					cylinder(
							h = st/2,
							r = or,
							center = false
						);
				}
				
				translate([0, 0, lt-st/2])
				if ( cs == 1 || cs == 2 )
				{
					cylinder(
							h = st/2,
							r1 = or,
							r2 = ir,
							center = false
						);
				}
				else
				{
					cylinder(
							h = st/2,
							r = or,
							center = false
						);
				}
			}
			
			translate([0, 0, -st/2])
			cylinder(
					h = lt+st,
					r = or-ocut,
					center = false
				);
		}
	}
}


/*
 * creates a screw thread and it's filling according to the mode in parameter cs
 *
 * @param od   outer diameter (thread peak to thread peak) independent of the icut or ocut
 * @param st   thread pitch
 * @param lf0  thread angle
 * @param lt   length of thread
 * @param cs   decides
 *             -- if a inner or outer thread is created
 *             and
 *             -- if a cone-cut at the ends of the thread is applied (for easier handling)
 *             values:
 *             --   -2  for nut: none
 *             --   -2  for screw: not even flat ends
 *             --   -1  for screw: only on the head side of the thread
 *             --    0  for screw: none
 *             --    1  for screw: only at the end of the screw
 *             --    2  for screw: at both ends if the thread
 * @param icut amount to cut from the inner thread peaks
 * @param ocut amount to cut from the outer thread peaks
 * @param $fn  should be 30 minimum (do not use $fs or $fa)
 */
module screw_thread_cut(od, st, lf0, lt, cs, icut, ocut)
{
	// need to be calculated before checks!
	
	// radius of outer thread helix
	or = od/2;
	// radius of inner thread helix
	ir = or - st/2*cos(lf0)/sin(lf0);
	// number of revolutions
	ttn = ceil(lt/st) + 1;
	
	
	if ((od <= 0)
			|| (st <= 0)
			|| ((lf0 <= 0) || (lf0 >= 90))
			|| (lt <= 0)
			|| ((cs < -2) || (cs > 2) || (cs != round(cs)))
			|| (icut < 0)
			|| (ocut < 0)
			|| (icut) >= (or-ir)
			|| (ocut) >= (or-ir)
			|| (icut+ocut) > (or-ir)
		)
	{
		if (od <= 0)
		{
			echo("ERROR in module screw_thread_cut:");
			echo("      outer diameter (od) <= 0");
			echo(" ");
		}
		if (st <= 0)
		{
			echo("ERROR in module screw_thread_cut:");
			echo("      thread pitch (st) <= 0");
			echo(" ");
		}
		if ((lf0 <= 0) || (lf0 >= 90))
		{
			echo("ERROR in module screw_thread_cut:");
			echo("      thread angle (st) not between 0 and 90 (non-inclusive)");
			echo("        try 30!");
			echo(" ");
		}
		if (lt <= 0)
		{
			echo("ERROR in module screw_thread_cut:");
			echo("      thread length (lt) <= 0");
			echo(" ");
		}
		if ((cs < -2) || (cs > 2) || (cs != round(cs)))
		{
			echo("ERROR in module screw_thread_cut:");
			echo("      invalid mode (cs)");
			echo("        try -2, -1, 0, 1, or 2!");
			echo(" ");
		}
		
		if (icut < 0)
		{
			echo("ERROR in module screw_thread_cut:");
			echo("      inner thread plane cut (icut) <= 0");
			echo("        try 0 or litte greater!");
			echo(" ");
		}
		if (ocut < 0)
		{
			echo("ERROR in module screw_thread_cut:");
			echo("      outer thread plane cut (ocut) <= 0");
			echo("        try 0 or litte greater!");
			echo(" ");
		}
		if ((icut) >= (or-ir))
		{
			echo("ERROR in module screw_thread_cut:");
			echo("      inner thread plane cut (icut) to big");
			echo("        try 0 or litte greater!");
			echo(" ");
		}
		if ((ocut) >= (or-ir))
		{
			echo("ERROR in module screw_thread_cut:");
			echo("      outer thread plane cut (ocut) to big");
			echo("        try 0 or litte greater!");
			echo(" ");
		}
		if ((icut+ocut) > (or-ir))
		{
			echo("ERROR in module screw_thread_cut:");
			echo("      inner plus outer thread plane cut (icut + ocut) to big");
			echo("        try 0 or litte greater for both");
			echo(" ");
		}
	}
	else
	{
		// end of desaster, now we do it!
		// see calculations above
		
		intersection()
		{
			thread_shape(cs, lt, or, ir, st, ocut);
			
			full_thread(ttn, st, or, ir, icut);
		}
	}
}

/*
 * creates a screw thread and it's filling according to the mode in parameter cs
 * (old interface)
 *
 * @param od   outer diameter (thread peak to thread peak)
 * @param st   thread pitch
 * @param lf0  thread angle
 * @param lt   length of thread
 * @param rs   width of shapes on curved planes
 * @param cs   decides
 *             -- if a inner or outer thread is created
 *             and
 *             -- if a cone-cut at the ends of the thread is applied (for easier handling)
 *             values:
 *             --   -2  for nut: none
 *             --   -2  for screw: not even flat ends
 *             --   -1  for screw: only on the head side of the thread
 *             --    0  for screw: none
 *             --    1  for screw: only at the end of the screw
 *             --    2  for screw: at both ends if the thread
 */
module screw_thread(od, st, lf0, lt, rs, cs)
{
	// number of shapes per revolution
	screw_thread_cut(od, st, lf0, lt, cs, 0, 0,
			$fn = floor(PI*od/rs)
		);
}

/*
 * creates a hexagon head for a screw or a nut
 * 
 * @param hg   height of the head
 * @param df   width across flat (take 0.1 less!)
 * @param $fn  should be 30 minimum (do not use $fs or $fa)
 */
module hex_head(hg, df)
{
	rd0 = df/2/sin(60);
	
	x0 = 0; x1 = df/2; x2 = x1+hg/2;
	y0 = 0; y1 = hg/2; y2 = hg;
	
	intersection()
	{
		cylinder(
				h = hg,
				r = rd0,
				$fn = 6,
				center = false
			);
		
		rotate_extrude(convexity = 10)
		polygon([ [x0, y0], [x1, y0], [x2, y1], [x1, y2], [x0, y2] ]);
	}
}

/*
 * creates cones to cut from thread ends of a nut (for easier handling)
 * 
 * @param chg  height of the cone
 * @param od   outer diameter of the thread
 * @param lf0  angle of the thread to cut (uses same angle for cones)
 * @param hg   height of the thread
 * @param $fn  should be 30 minimum (do not use $fs or $fa)
 */
module hex_countersink_ends(chg, od, lf0, hg)
{
	// overlength of cones
	olen = 0.1;
	
	// lower cone
	translate([0, 0, -olen])
	cylinder(
			h = chg+olen,
			r1 = od/2,
			r2 = od/2 - (chg+olen)*cos(lf0)/sin(lf0),
			center = false
		);
	
	// upper cone
	translate([0, 0, hg-chg+olen])
	cylinder(
			h = chg+olen,
			r1 = od/2 - (chg+olen)*cos(lf0)/sin(lf0),
			r2 = od/2,
			center = false
		);
}

// old old module unchanged
module hex_head_0(hg, df)
{
    cylinder(h = hg, r = df/2/sin(60), $fn = 6, center = false);
}

// old old module unchanged
module hex_screw_0(od, st, lf0, lt, rs, cs, df, hg, ntl, ntd)
{
    ntr = od/2-(st/2)*cos(lf0)/sin(lf0);

    union()
    {
        hex_head_0(hg, df);

        translate([0, 0, hg])
        if ( ntl == 0 )
        {
            cylinder(h = 0.01, r = ntr, center = true);
        }
        else
        {
            if ( ntd == -1 )
            {
                cylinder(h = ntl+0.01, r = ntr, $fn = floor(od*PI/rs), center = false);
            }
            else if ( ntd == 0 )
            {
                union()
                {
                    cylinder(h = ntl-st/2,
                             r = od/2, $fn = floor(od*PI/rs), center = false);

                    translate([0, 0, ntl-st/2])
                    cylinder(h = st/2,
                             r1 = od/2, r2 = ntr, 
                             $fn = floor(od*PI/rs), center = false);
                }
            }
            else
            {
                cylinder(h = ntl, r = ntd/2, $fn = ntd*PI/rs, center = false);
            }
        }

        translate([0, 0, ntl+hg]) screw_thread(od, st, lf0, lt, rs, cs);
    }
}

/*
 * creates a nut
 * 
 * @param df   width across flat (take 0.1 less!)
 * @param hg   height of the nut,
 * @param st   thread pitch
 * @param lf0  thread angle
 * @param od   outer diameter of the thread independent of the icut or ocut
 * @param icut amount to cut from the inner thread peaks
 * @param ocut amount to cut from the outer thread peaks
 * @param $fn  should be 30 minimum (do not use $fs or $fa)
 */
module hex_nut_cut(df, hg, st, lf0, od, icut, ocut)
{
	difference()
	{
		hex_head(hg, df);
		
		hex_countersink_ends(st/2, od, lf0, hg);
		
		screw_thread_cut(od+tolerance, st, lf0, hg, -2, icut, ocut);
	}
}

/*
 * creates a nut
 * (old interface)
 * 
 * @param df   width across flat (take 0.1 less!)
 * @param hg   height of the nut,
 * @param st   thread pitch
 * @param lf0  thread angle
 * @param od   outer diameter of the thread
 * @param rs   width of shapes on curved planes
 */
module hex_nut(df, hg, st, lf0, od, rs)
{
	hex_nut_cut(df, hg, st, lf0, od, 0, 0,
			$fn = floor(PI*od/rs)
		);
}

/*
 * creates a screw
 *
 * @param od   outer diameter (thread peak to thread peak) independent of the icut or ocut
 * @param st   thread pitch
 * @param lf0  thread angle
 * @param lt   length of thread
 * @param cs   create cone-cut at the end of thread (for easier handling)
 *             --   -2  not even flat ends
 *             --   -1  only on the head side of the thread
 *             --    0  none
 *             --    1  only at the end of the screw
 *             --    2  at both ends if the thread
 * @param df   width across flat (take 0.1 less!)
 * @param hg   height of the head,
 * @param ntl  length of the part between head and upper end of thread
 * @param ntd  diameter  of the part between head and upper end of thread
 *             --  > 0  explicit diameter
 *             --    0  use value of parameter od
 *             --   -1  use diameter of the thread valleys
 * @param icut  amount to cut from the inner thread peaks
 * @param ocut  amount to cut from the outer thread peaks
 * @param $fn  should be 30 minimum (do not use $fs or $fa)
 */
module hex_screw_cut(od, st, lf0, lt, cs, df, hg, ntl, ntd, icut, ocut)
{
	ntr = od/2 - (st/2)*cos(lf0)/sin(lf0) + icut;
		
	union()
	{
		hex_head(hg, df);
		
		translate([0, 0, hg])
		if ( ntl == 0 )
		{
			cylinder(
					h = 0.01,
					r = ntr,
					center = true
				);
		}
		else
		{
			if ( ntd == -1 )
			{
				cylinder(
						h = ntl+0.01,
						r = ntr,
						center = false
					);
			}
			else
			{
				if ( ntd == 0 )
				{
					union()
					{
						cylinder(
								h = ntl-st/2,
								r = od/2 - ocut,
								center = false
							);
						
						translate([0, 0, ntl-st/2])
						cylinder(
								h = st/2,
								r1 = od/2 - ocut,
								r2 = ntr, 
								center = false
							);
					}
				}
				else
				{
					cylinder(
							h = ntl,
							r = ntd/2,
							center = false
						);
				}
			}
		}
		
		translate([0, 0, ntl+hg])
		screw_thread_cut(od-tolerance, st, lf0, lt, cs, icut, ocut);
	}
}

/*
 * creates a screw
 * (old interface)
 *
 * @param od   outer diameter (thread peak to thread peak)
 * @param st   thread pitch
 * @param lf0  thread angle
 * @param lt   length of thread
 * @param rs   width of shapes on curved planes
 * @param cs   create cone-cut at the end of thread (for easier handling)
 *             --   -2  not even flat ends
 *             --   -1  only on the head side of the thread
 *             --    0  none
 *             --    1  only at the end of the screw
 *             --    2  at both ends if the thread
 * @param df   width across flat (take 0.1 less!)
 * @param hg   height of the head,
 * @param ntl  length of the part between head and upper end of thread
 * @param ntd  diameter  of the part between head and upper end of thread
 *             --  > 0  explicit diameter
 *             --    0  use value of parameter od
 *             --   -1  use diameter of the thread valleys
 */
module hex_screw(od, st, lf0, lt, rs, cs, df, hg, ntl, ntd)
{
	hex_screw_cut(od, st, lf0, lt, cs, df, hg, ntl, ntd, 0, 0,
			$fn = floor(PI*od/rs)
		);
}

/*
 * returns the thread pitch for an ISO M-Number
 * 
 * @param d    the iso diameter
 */
function get_iso_pitch(d) = lookup(d, 
	[
		[ 1  , 0.25],
		[ 1.2, 0.25],
		[ 1.6, 0.35],
		[ 2  , 0.4 ],
		[ 2.5, 0.45],
		[ 3  , 0.5 ],
		[ 4  , 0.7 ],
		[ 5  , 0.8 ],
		[ 6  , 1   ],
		[ 8  , 1.25],
		[10  , 1.5 ],
		[12  , 1.75],
		[16  , 2   ],
		[20  , 2,5 ],
		[24  , 3   ],
		[30  , 3.5 ],
		[36  , 4   ],
		[42  , 4.5 ],
		[48  , 5   ],
		[56  , 5.5 ],
		[64  , 6   ]
	]
);

/*
 * returns the width across flat (tool size) for an ISO M-Number (take 0.1 less!)
 * 
 * @param d    the iso diameter
 */
function get_iso_waf(d) = lookup(d, 
	[
		[ 1  ,  2  ],
		[ 1.2,  2.5],
		[ 1.6,  3.2],
		[ 2  ,  4  ],
		[ 2.5,  5  ],
		[ 3  ,  5.5],
		[ 4  ,  7  ],
		[ 5  ,  8  ],
		[ 6  , 10  ],
		[ 8  , 13  ],
		[10  , 17  ],
		[12  , 19  ],
		[16  , 24  ],
		[20  , 30  ],
		[24  , 36  ],
		[30  , 46  ],
		[36  , 55  ],
		[42  , 65  ],
		[48  , 75  ],
		[56  , 85  ],
		[64  , 96  ]
	]
);

/*
 * creates an outer (screw) iso screw thread and it's filling according to the mode in parameter cs
 * the fillet in the valleys is not round but a flat.
 * it has the same depht as the lowest part of the round would have.
 *
 * @param d    ISO diameter M<od>
 * @param lt   length of thread
 * @param cs   create cone-cut at the end of thread (for easier handling)
 *             --   -2  not even flat ends
 *             --   -1  only on the head side of the thread
 *             --    0  none
 *             --    1  only at the end of the screw
 *             --    2  at both ends if the thread
 * @param $fn  should be 30 minimum (do not use $fs or $fa)
 */
module screw_thread_iso_outer(d, lt, cs)
{
	// pitch
	st = get_iso_pitch(d);
	
	// thread peak to thread peak (without cuts)
	t = st*cos(30);
	
	// ratio of (height of the 120 degree circle segment) and (its radius)
	// h/r = 2 sin(120°/4)^2 = 0.5
	// hfree_div_r = 0.5;
	
	screw_thread_cut(
			od = d + t/8 - tolerance,
			st = st,
			lf0 = 30,
			lt = lt,
			cs = cs,
			// flat of the nut - height of the arc of the screw
			// t/4 - hfree_div_r*t/6 = t/6
			icut = t/6,
			ocut = t/8
		);
}

/*
 * creates an inner (nut) iso screw thread and it's filling according to the mode in parameter cs
 * the fillet in the valleys is not round but a flat.
 * it has the same depht as the lowest part of the round would have.
 * 
 * it must be cut out of a solid
 *
 * @param d    ISO diameter M<od>
 * @param lt   length of thread
 * @param $fn  should be 30 minimum (do not use $fs or $fa)
 */
module screw_thread_iso_inner(d, lt)
{
	// pitch
	st = get_iso_pitch(d);
	
	// thread peak to thread peak (without cuts)
	t = st*cos(30);
	
	// ratio of (height of the 120 degree circle segment) and (its radius)
	// h/r = 2 sin(120°/4)^2 = 0.5
	// hfree_div_r = 0.5;
	
	screw_thread_cut(
			od = d + t/8 + tolerance,
			st = st,
			lf0 = 30,
			lt = lt,
			cs = 0,
			icut = t/4,
			// flat of the screw - height of the arc of the nut
			// t/8 - hfree_div_r*t/12 = t/12
			ocut = t/12
		);
}

/*
 * creates a screw with hex head an iso thread
 * the fillet in the valleys is not round but a flat.
 * it has the same depht as the lowest part of the round would have.
 *
 * @param d    ISO diameter M<od>
 *             using values between the standardised diameters
 *             may result in strange measures for the width across flat (tool size)
 * @param lt   length of thread
 * @param cs   create cone-cut at the end of thread (for easier handling)
 *             --   -1  only on the head side of the thread
 *             --    0  none
 *             --    1  only at the end of the screw
 *             --    2  at both ends if the thread
 * @param ntl  length of the part between head and upper end of thread
 * @param ntd  diameter  of the part between head and upper end of thread
 *             --  > 0  explicit diameter
 *             --    0  use value of parameter od
 *             --   -1  use diameter of the thread valleys
 * @param hg   height of the head
 * @param $fn  should be 30 minimum (do not use $fs or $fa)
 */
module hex_screw_iso(d, lt, cs, ntl, ntd, hg)
{
	// pitch
	st = get_iso_pitch(d);
	
	// thread peak to thread peak (without cuts)
	t = st*cos(30);
	
	// ratio of (height of the 120 degree circle segment) and (its radius)
	// h/r = 2 sin(120°/4)^2 = 0.5
	// hfree_div_r = 0.5;
	
	hex_screw_cut(
			od = d + t/8,
			st = st,
			lf0 = 30,
			lt = lt,
			cs = cs,
			df = get_iso_waf(d) - 0.1,
			hg = hg,
			ntl = ntl,
			ntd = ntd,
			// flat of the nut - height of the arc of the screw
			// t/4 - hfree_div_r*t/6 = t/6
			icut = t/6,
			ocut = t/8
		);
}

/*
 * creates a hex nut with an iso thread
 * the fillet in the valleys is not round but a flat.
 * it has the same depht as the lowest part of the round would have.
 *
 * @param d    ISO diameter M<od>
 *             using values between the standardised diameters
 *             may result in strange measures for the width across flat (tool size)
 * @param hg   height of the head
 * @param $fn  should be 30 minimum (do not use $fs or $fa)
 */
module hex_nut_iso(d, hg)
{
	// pitch
	st = get_iso_pitch(d);
	
	// thread peak to thread peak (without cuts)
	t = st*cos(30);
	
	// ratio of (height of the 120 degree circle segment) and (its radius)
	// h/r = 2 sin(120°/4)^2 = 0.5
	// hfree_div_r = 0.5;
	
	hex_nut_cut(
			df = get_iso_waf(d) - 0.1,
			hg = hg,
			st = st,
			lf0 = 30,
			od = d+t/8,
			icut = t/4,
			// flat of the screw - height of the arc of the nut
			// t/8 - hfree_div_r*t/12 = t/12
			ocut = t/12
		);
}
