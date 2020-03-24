$fn = 100;

shape = [ [10, 10, 8], [0, 40, 3], [40, 80, 5], [100, 80, 10], [50, 0, 20] ];

linear_extrude (height = 5) rounded_polygon(shape);

function next(i) = (i + 1) % len(shape);

function tangents(i, side) = tangent(shape[i], shape[next(i)], side);

module rounded_polygon(points, radius)
    union () {
        for(i = [0 : len(shape) - 1])
            translate([shape[i].x, shape[i].y]) 
                #circle(shape[i][2]);

        polygon([for(i  = [0 : len(shape) - 1]) for(side = [0, 1]) tangents(i, side)]);
    }


function tangent(p1, p2, side) =
    let (
    r1 = p1[2],
    r2 = p2[2],
    dx = p2.x - p1.x,
    dy = p2.y - p1.y,
    d = sqrt(dx * dx + dy * dy),
    theta = atan2(dy, dx) + acos((r1 - r2) / d),
    xa = p1.x +(cos(theta) * r1),
    ya = p1.y +(sin(theta) * r1),
    xb = p2.x +(cos(theta) * r2),
    yb = p2.y +(sin(theta) * r2)
    )

    side ? [xb, yb] : [xa, ya];

