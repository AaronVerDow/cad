//http://www.thingiverse.com/thing:20016/#files

length = 420;
height = 85;

bar_d = 7;
bar_r = bar_d / 2;

bend_d = 38;
bend_r = bend_d / 2;

pin_d = bar_d;
pin_buffer = 5;
plate_h = pin_d * 2 + pin_buffer + 4;
pin_delta = 0.9;

bottom_l = length /2 - bend_r - plate_h / 2;

corner_a = atan((height - bend_d)/ bottom_l);

top_l = sqrt((bottom_l + tan(corner_a)*bend_r) * (bottom_l + tan(corner_a)*bend_r) + (height - bend_d)*(height - bend_d));


bend_a = 180 - corner_a;


plate_w = pin_d * 2;

hook_d = 57;
hook_r = hook_d / 2;

module ring(outer, inner) {
	rotate_extrude() translate([inner, 0, 0]) circle(r = outer, $fn = 6);
}

module partial_ring(outer, inner, deg) {
  assign(compliment = 360 - deg) {

    difference() {
      ring(outer, inner);

      if (compliment < 90) {
        translate([0, 0, -outer])
          linear_extrude(height = outer * 2)
            polygon(points = [[0,0],
                              [-(inner + outer), 0], 
                              [-(inner + outer),(inner + outer) * tan(compliment)]]);
      }
      else if (compliment < 180) {
        translate([-(inner + outer), 0, -outer])
          cube(size = [inner + outer, inner + outer, outer*2], center = false);

        translate([0, 0, -outer])
        linear_extrude(height = outer * 2)
          polygon(points = [[0,0],
                            [0, (inner + outer)], 
                            [(inner + outer) * tan(compliment - 90),
				(inner + outer),]]);
      }
      else if (compliment < 270) {
        translate([-(inner + outer), 0, -outer])
          cube(size = [(inner + outer)*2, inner + outer, outer*2], center = false);

        translate([0, 0, -outer])
        linear_extrude(height = outer * 2)
          polygon(points = [[0,0],
                            [(inner + outer), 0], 
                            [(inner + outer),
				-(inner + outer) * tan(compliment - 180)]]);

      }
      else {
        translate([-(inner + outer), 0, -outer])
          cube(size = [(inner + outer)*2, inner + outer, outer*2], center = false);

	translate([0, -(inner + outer), -outer])
	  cube(size = [inner + outer, inner + outer, outer*2], center = false);
	  
        translate([0, 0, -outer])
        linear_extrude(height = outer * 2)
          polygon(points = [[0,0],
                            [0, -(inner + outer)], 
                            [(inner + outer) * tan(90 - (compliment - 180)),
                              -(inner + outer)]]);
      }
    }
  }
}

module pin(height, rad) {
  union() {
    cylinder(h = height, r = rad, center = false, $fn = 20);
    translate([-rad, 0, 0])
      cylinder(h = height, r = 0.5, center = false, $fn = 5);
    translate([rad, 0, 0])
      cylinder(h = height, r = 0.5, center = false, $fn = 5);
    translate([0, -rad, 0])
      cylinder(h = height, r = 0.5, center = false, $fn = 5);
    translate([0, rad, 0])
      cylinder(h = height, r = 0.5, center = false, $fn = 5);
  }
}

module pinplate(plate_t, num_pins, pin_d) {
  assign(plate_w = pin_d * (num_pins * 2),
  
         pin_r = pin_d / 2) {

    difference() {
      union() {
        cube(size = [plate_w, plate_h, plate_t], center=false);
        for (i = [0:num_pins - 1]) {
          translate([pin_d + pin_d * i * 2, pin_d + pin_r + pin_buffer + 2, plate_t])
            pin(plate_t, pin_r);
        }
      }    

      for (i = [0:num_pins - 1]) {
	translate([pin_d + pin_d * i * 2, pin_r + 2, -1])
        cylinder(h = plate_t + 2, r = pin_r+pin_delta, center = false, $fn = 20);

/*	rotate(a = [0, 180, 0])
          pinhole(h = plate_t, r = pin_r, lh = plate_t / 3, lt = 1,
	          t = 0.3, tight = true);*/
      }
    }  
  }
}	   

module hangerside() {
  rotate(a = [270, 0, 0]) {
  cylinder(h=bottom_l, r = bar_r, $fn = 6);

  difference() {
    translate([bend_r, 0, 0])
      rotate(a = [0, corner_a, 0])
      translate([bend_r, 0, 0])
      cylinder(h=top_l, r = bar_r, $fn = 6);

    translate([height - 1 - bar_r, -bar_r, bottom_l - 1])
      cube(size = bar_d + 2);
  }


  translate([bend_r, 0, 0])
    rotate([90, 0, 0]) partial_ring(bar_r, bend_r, bend_a);
  }

  translate([height - bar_r * 3, bottom_l - 1, -bar_r + .5]){
    difference() {
      pinplate(bar_r, 1, pin_d);
      translate([-1, plate_h/2 - bar_r/2 , bar_r/2])
        cube(size = [plate_w + 2, bar_r, bar_r / 2 + 1], center=false);
  }
  linear_extrude(height = bar_r)
     polygon(points = [[0,0], [bar_r * 3, 0], [0, (1/tan(corner_a))* -(bar_r * 3)]]);
  }

  translate([-bar_r, bottom_l - 1, -bar_r + .5])
    pinplate(bar_r, 1, pin_d);
}

module hangerhook() {
  rotate(a = [-90, 0, -90]) {
  translate([0, 0.5, hook_r]) {
    translate([0, 0, hook_r])
      rotate(a = [-90, 0, 0])
      partial_ring(bar_r, hook_r, 180);

    translate([hook_r, 0, -1])
      cylinder(r = bar_r, h = hook_r + 2, $fn = 6);

    rotate(a = [90, 0, 180])
      partial_ring(bar_r, hook_r, 90);
  }
  translate([0, 0, -1])
  cube(size = [plate_h, bar_d, bar_r], center = true);
  translate([0, bar_r/2 + 0.3, -(plate_w + bar_d) / 2 + 1])
    cube(size = [bar_r - 0.5, bar_r - 0.5, plate_w + 3], center = true);
  translate([0, 0, -(plate_w + bar_r + 2)])
    cube(size = [plate_h, bar_d, bar_r], center = true);
  }
}

/**** Uncomment one of either the hanger side or hook ****/


//Uncomment to render a guide outline for mendel bed
module bed_guide() {
	bed_x=180;
	bed_y=190;
	difference() {
	  cube(size = [bed_x, bed_y, 1], center=true);
	  cube(size = [bed_x-2, bed_y-2, 3], center=true);
	}
}

//bed_guide();


//Uncomment to render the hook
//hangerhook();

//Uncomment to render one side
//translate([-93, -65, 0])
  //rotate(a = [0, 0, -33])
  hangerside();

