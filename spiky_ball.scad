d=100;

point=1;
base=d/2;

fn=16;


for(x=[0:360/fn:359]) {
    rotate([x])
    for(y=[0:360/fn:359]) {
        rotate([0,y])
        for(z=[0:360/fn:359]) {
            rotate([0,0,z])
            cylinder(d1=base,d2=point, h=d/2);
        }
    }
}
