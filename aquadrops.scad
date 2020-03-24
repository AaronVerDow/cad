//sheet(194.5, 24, 148, 210);
sheet(169, 21, 128, 181);


module sheet(ring_measured, holes, sheet_x, sheet_y) {

    hole_x=4;
    hole_y=5;
    hole=[hole_x, hole_y];
    hole_gap=ring_measured/(holes-1)-hole_y;
    sheet=[sheet_x,sheet_y];
    from_edge=2.5;
    ring_total=ring_measured+hole_y;

    difference() {
        square(sheet);
        translate([from_edge,-ring_total/2+sheet_y/2])
        for(i=[0:hole_gap+hole_y:ring_total]){
            translate([0,i])
            square(hole);
        }
    }
}
