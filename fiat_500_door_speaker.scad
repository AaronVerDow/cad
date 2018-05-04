$fn=90;
speaker=167-12*2; 
speaker_mounts=160; 
speaker_bolt=3.5;
speaker_bolt_count=4;
speaker_bolt_offset=45;
speaker_lip=167;
speaker_lip_h=3.5;

door_mounts=180;
door_bolt=6;
door_bolt_d=10+door_bolt;
door_bolt_count=3;
door_h=6;
door_bolt_h=door_h;

pad=0.1;
padd=pad*2;

module positive() {
    hull() {
        for(i=[0:360/door_bolt_count:359])
        rotate([0,0,i])
        translate([0,door_mounts/2,0]) {
            cylinder(d=door_bolt_d, h=door_bolt_h);
        }
        cylinder(d=door_mounts,h=door_h);
    }

}

difference() {
    positive();

    // door bolts
    for(i=[0:360/door_bolt_count:359])
    rotate([0,0,i])
    translate([0,door_mounts/2,-pad]) {
        cylinder(d=door_bolt, h=door_bolt_h+padd);
    }

    // speaker hole
    translate([0,0,-pad])
    cylinder(d=speaker,h=door_h+padd);

    // speaker outer lip
    translate([0,0,door_h-speaker_lip_h])
    cylinder(d=speaker_lip,h=speaker_lip_h+pad);

    // speaker bolts
    for(i=[speaker_bolt_offset:360/speaker_bolt_count:359+speaker_bolt_offset])
    rotate([0,0,i])
    translate([0,speaker_mounts/2,-pad]) {
        cylinder(d=speaker_bolt, h=door_bolt_h+padd);
    }
}
