
module screen(x_size, y_size, opening, thickness, height) {
    step = opening + thickness*2;
    
    for(x = [0:step:x_size]) {
        translate([x, 0, 0])
            cube([thickness, y_size, height]);
    }
    for(y = [0:step:y_size]) {
        translate([0, y, 0])
            cube([x_size, thickness, height]);
    }
}

module pipe(thickness, radius, height) {
    cube_r = radius*1.25;
    // Inner radius, not outer radius
    radius = radius + thickness;
    
    difference() {
        union() {
            // The base
            translate([-cube_r, -cube_r, 0])
                cube([cube_r*2,cube_r*2,thickness]);
            
            // The main wall
            cylinder(height, radius, radius, $fn=100);
            
            // Upper lip
            translate([0,0,height])
                cylinder(thickness, radius+thickness, radius+thickness, $fn=100);
            
            // Lip taper
            cylinder(height, radius/2, radius+thickness, $fn=100);
        }
        
        // Cut out the center
        translate([0,0,-thickness/2]) {
            cylinder(height+thickness*2, radius-thickness, radius-thickness, $fn=100);
            
            // Add screw holes
            for(rot = [0, 90, 180, 270]) {
                rotate([0,0,rot])
                    translate([cube_r -15, cube_r-15, 0])
                    cylinder(thickness*2, 3.175, 3.175, $fn=100);
            }
        }
        
        
    }
}

t = 3.175;
d = 152.4;
m = 15;
union() {
    pipe(t, d/2, d/4);
    screen_d = d+t;
    translate([-screen_d/2, -screen_d/2, 0]) {
        //screen(screen_d, screen_d, 1, .4, .4);
        screen(screen_d, screen_d, 1*m, .4*m, t);
    }
}