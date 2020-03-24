esp32_x=80;
esp32_y=20;
esp32_z=3;
esp32=[esp32_x,esp32_y,esp32_z];
esp32_hole_x=75;
esp32_hole_y=15;
esp32_hole=3;

extra=50;

esp32_screen_x=30;
esp32_screen_y=15;
esp32_screen_z=extra;

esp32_screen=[esp32_screen_x,esp32_screen_y,esp32_screen_z];

esp32_screen_x_offset=0;
esp32_screen_y_offset=0;
esp32_screen_offset=[
    esp32_x/2-esp32_screen_x/2+esp32_screen_x_offset,
    esp32_y/2-esp32_screen_y/2+esp32_screen_y_offset,
    0
];

esp32_button=2;
esp32_button_x=60;
esp32_button_y=4;
esp32_button_gap=4;

esp32_usb_x=30;
esp32_usb_y=13;
esp32_usb_z=10;
esp32_usb=[esp32_usb_x,esp32_usb_y,esp32_usb_z];

$fn=90;


cube(esp32);
translate(esp32_screen_offset)
cube(esp32_screen);
cube(esp32_usb);
esp32_screws();
esp32_buttons();


module esp32_screws() {
    translate([esp32_x/2-esp32_hole_x/2,esp32_y/2-esp32_hole_y/2,0]) {
        esp32_screw();
        translate([esp32_hole_x,0,0])
        esp32_screw();
        translate([esp32_hole_x,esp32_hole_y,0])
        esp32_screw();
        translate([0,esp32_hole_y,0])
        esp32_screw();
    }
}

module esp32_screw() {
    cylinder(d=esp32_hole,h=extra);
}

module esp32_buttons() {
    translate([esp32_button_x-esp32_button_gap/2,esp32_button_y,0])
    esp32_button();
    translate([esp32_button_x+esp32_button_gap/2,esp32_button_y,0])
    esp32_button();
}

module esp32_button() {
    cylinder(d=esp32_button,h=extra);
}
