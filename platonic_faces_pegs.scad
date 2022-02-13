// Uni-face; you need more of these to form a pythagoran solid
//           uncomment a proper combination of dihedralAngle
//           and ribCount
// fjkraan@electrickery.nl, 2022-01-16
// Pegs added by R. Bost - 2022

// LICENSE: CC Attribution 4.0 International

ribLength = 50;
ribWidth  = 3; // this looks better for the higher dihedralAngle values
//ribWidth  = 6; //suitable for tetrahedron and cube
//dihedralAngle = acos(1/3); // 70.5;   // tetrahedron
//dihedralAngle = acos(0); // 90;     // cube
//dihedralAngle = acos(-1/3); // 109.5;  // octahedron     
dihedralAngle = acos(-1/sqrt(5)); // 116.6;  // dodecahedron   
//dihedralAngle = acos(-sqrt(5)/3); // 138.2;  // icosahedron    
//ribCount  = 3;  // tetrahedron, octahedron, icosahedron
//ribCount  = 4;  // cube
ribCount  = 5;   // dodecahedron
extraWidth = 3;
ribAngle  = 360 / ribCount;
ribHeight = ribWidth * tan(dihedralAngle / 2);
innerCircleRadius = ribLength / (2 * tan(180/ribCount));

hypothenus = ribWidth/cos(dihedralAngle / 2);

pegWidth = 15;
pegDepth = 2.5;
pegHeight = 2;
pegOffset = ribLength/3;
depthTolerance = 0.1;
widthTolerance = 0.01;

module bar(width, height, length) {
    p1 = [0, 0];
    p2 = [width+extraWidth, 0];
    p3 = [extraWidth, height];
    p4 = [0, height];
    rotate([90, 0, 0])
        linear_extrude(length, slices = 50) polygon([p1, p2, p3, p4]);
}

module corner(width,height, angle)
{
    y_offset = (extraWidth) * (tan(ribAngle / 2));
    cornerMiddle(extraWidth, ribHeight, ribAngle);     
    translate([extraWidth,-ribLength, 0]) {
        corner_side(ribWidth,ribHeight,y_offset);
    }
    translate([extraWidth,y_offset, 0]) {
        corner_side(ribWidth,ribHeight,y_offset);
        cornerBit(ribWidth, ribHeight, ribAngle);
    }   
}


module cornerBit(width, height, angle) {
    totalWidth = width+extraWidth;
  p1 = [0, 0];
  p2 = [width, 0];
  p3 = [width, width * (tan(angle / 2))];
  p4 = [width * (cos(angle)) , width * (sin(angle))];
    
  linear_extrude(height, slices = 50, scale = 0) polygon([p1, p2, p3,p4]); 
}

module cornerMiddle(width, height, angle) {
  p1 = [0, 0];
  p2 = [width, 0];
  p3 = [width, width * (tan(angle / 2))];
  p4 = [width * (cos(angle)) , width * (sin(angle))];
    
  linear_extrude(height, slices = 50) polygon([p1, p2, p3,p4]); 
}
module corner_side(width, height, length) {
    p1 = [0, 0];
    p2 = [width, 0];
    p3 = [0, height];
    p4 = [0, height];
    rotate([90, 0, 0])
        linear_extrude(length, slices = 50) polygon([p1, p2, p3, p4]);
}

module peg(wTolerance,hTolerance,dTolerance)
{
    cube(size = [pegHeight-2*hTolerance,pegWidth-2*wTolerance,pegDepth-2*dTolerance], center = true);
}

for (f = [0 : 1 : ribCount - 1]) {
//for (f = [0 : 1 : 0]) {
    angle = ribAngle * f;
    
    rotate([0, 0, angle]){
        difference(){
        union(){
        translate([innerCircleRadius, ribLength / 2, 0]) {
            bar(ribWidth, ribHeight, ribLength);
            corner(extraWidth, ribHeight, ribAngle);
            
        }
        translate([innerCircleRadius+ribWidth+extraWidth, 0, 0]) {
            rotate([0,dihedralAngle/2,0]){
            translate([-hypothenus/2,pegOffset,pegDepth/2]){
                peg(widthTolerance,widthTolerance,depthTolerance);
            }
            }
        }
        }
    translate([innerCircleRadius+ribWidth+extraWidth, 0, 0]) {
            rotate([0,dihedralAngle/2,0]){
            translate([-hypothenus/2,-pegOffset,-pegDepth/2]){
                peg(0,0,0);
            }
            }
        }
        }
    }
}

