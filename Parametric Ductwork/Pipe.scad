
thickness = 10; // 3mm in thickness
diameter = 152.4; // 6 inches in diameter
height = 200; // 100mm long

//pipe(thickness, diameter/2, height);
pipe_angle(thickness, diameter/2, 90);
//pipe_lip(thickness, diameter/2);

module pipe_angle(thickness, radius, angle) {
    curve = (radius+thickness)*1.5;
    translate([-curve,0,0])
    rotate([90,0,0])
    union() {
        difference() {
            union() {
                // Outer pipe wall
                rotate_extrude(angle=angle, $fn=angle)
                translate([curve,0,0])
                circle(radius+thickness, $fn=360);
            }
            
            // Cut out the center
            rotate_extrude($fn=100)
            translate([curve,0,0])
            circle(radius, $fn=360);
        }
        
        // Bottom lip
        translate([curve,0,0])
        rotate([-90,0,0])
        pipe_lip(thickness, radius);
        
        // Top lip
        rotate([0,0,angle])
        translate([curve,0,0])
        rotate([90,0,0])
        pipe_lip(thickness, radius);
    }
}

module pipe(thickness, radius, height) {
    cube_r = radius*1.25;
    // Inner radius, not outer radius
    radius = radius + thickness;
    
    difference() {
        union() {
            // The outer wall
            cylinder(height, radius+thickness, radius+thickness, $fn=360);
            
            pipe_lip(thickness, radius);
            
            translate([0,0,height]) rotate([0,180,0])
            pipe_lip(thickness, radius);
        }
        
        max_height = max(cube_r, height)*2.5;
        
        // Cut out the center
        translate([0,0,-max_height]) {
            cylinder(max_height*2, radius, radius, $fn=360);
            
            // Add screw holes
            for(rot = [0, 90, 180, 270]) {
                rotate([0,0,rot])
                translate([cube_r -15, cube_r-15, 0])
                cylinder(thickness*2, 3.175, 3.175, $fn=360);
            }
        }
        
        
    }
}

module pipe_lip(thickness, radius) {
    radius = radius + thickness;
    difference() {
        union() {
            // mass
            cylinder(thickness, radius+thickness, radius+thickness, $fn=360);
        
            // taper
            translate([0,0,thickness])
            cylinder(radius, radius+thickness, 0, $fn=360);
        }
        
        // Cut out the center
        translate([0,0,-0.1])
        cylinder(radius+thickness+0.2, radius, radius, $fn=360);
    }
}