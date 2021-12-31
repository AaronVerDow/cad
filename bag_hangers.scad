// RENDER stl
module fjallraven_17() {
    include <bag_hanger.scad>;
    height=30;
    width=80;
    depth=80;
    lip_x=5;
    lip_y=lip_x;
    simple_arc();
}
!fjallraven_17();

module animation() {
    loop=sin(360*$t)/2+0.5;
    include <bag_hanger.scad>;
    height=30-loop*20;
    width=60+loop*20; 
    mirror([0,0,1])
    simple_arc();
}

