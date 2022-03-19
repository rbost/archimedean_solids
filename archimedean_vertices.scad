// LICENSE: CC Attribution 4.0 International
// Construct vertices for archimedean solids
// Heavily inspired by a similar project for platonic solids: https://www.prusaprinters.org/prints/78213-platonic-solid-vertices/files


// Some parameters might need some ad-hoc manual tweaking (the geometry is pretty hard and annoying to do thouroughly)


length = 9;
diameter = 9.3;

radius = diameter/2;
thickness = 1;
center_offset=1.5*radius;
$fn = 25; // cylinder hole precision

pentagon_angle = 108;
hexagon_angle = 120;
octagon_angle = 135;
decagon_angle = 144;

// Snub cube
//angle_3_3 = 153.23;
//angle_3_4 = 142.98;
//draw_vertex(68,24,[[90,angle_3_4],[60,angle_3_4],[60,angle_3_3],[60,angle_3_3],[60,angle_3_3]]);

// Snub dodecahedron
//angle_3_3 = 164.18;
//angle_3_5 = 152.93;
//draw_vertex(77,18,[[pentagon_angle,angle_3_5],[60,angle_3_5],[60,angle_3_3],[60,angle_3_3],[60,angle_3_3]]);

// Cube
//draw_vertex(52,45,[[90,90],[90,90],[90,90]]);



// Icosahedron
//angle = acos(-sqrt(5)/3);
//draw_vertex(60,21,[[60,angle],[60,angle],[60,angle],[60,angle],[60,angle]]);

// Dodecaedron
//angle = acos(-1/sqrt(5));
//draw_vertex(68,31,[[pentagon_angle,angle],[pentagon_angle,angle],[pentagon_angle,angle]]);


// Tetraedron
//angle = acos(1/3);
//draw_vertex(38,45,[[60,angle],[60,angle],[60,angle]]);

// Rhombicuboctahedron
//draw_vertex(67.5,22.5,[[90,144.74],[90,135],[90,135],[60,144.74]]);

// Rhombicosidodecahedron
//angle_4_5 = 148.28;
//angle_3_4 = 159.09;
//draw_vertex(77,19,[[108,angle_4_5],[90,angle_4_5],[60,angle_3_4],[90,angle_3_4]]);

// Truncated cuboctahedron
angle_4_6 = acos(-sqrt(6)/3);
angle_4_8 = acos(-sqrt(2)/3);
angle_6_8 = acos(-sqrt(3)/3);
draw_vertex(73,45,[[octagon_angle,angle_6_8],[90,angle_4_8],[hexagon_angle,angle_4_6]]);


// Truncated icosahedron
//draw_vertex(79,21,[[120,142.62],[120,138.189685],[108,142.62]]);
    

// Icosidodecahedron
//angle = 142.62;
//draw_vertex(72,25,[[108,angle],[60,angle], [108,angle], [108,angle]]);


// Truncated dodecahedron
//angle_10_10 = 116.57;
//angle_3_10 = 142.62;
//draw_vertex(80,30,[[decagon_angle,angle_3_10],[decagon_angle,angle_10_10], [60,angle_3_10]]);

// Cuboctahedron
//angle = 125.26;
//draw_vertex(60,35,[[90,angle],[60,angle], [90,angle], [60,angle]]);

//Truncated octahedron
//angle_46 = acos(-1/sqrt(3));
//angle_66 = acos(-1/3);
//draw_vertex(73,36,[[120,angle_46],[120,angle_66], [90,angle_46]]);

////////////////////////////////////////////////////////////////////////

module hole()
{
    ext_radius = radius + thickness;
    translate([0,0,center_offset])
        cylinder(h = length+20, r = radius);
    translate([radius/2,-radius/2,center_offset])
        cube([length,radius,length+center_offset], center=false);
}

module support()
{
    ext_radius = radius + thickness;
//    translate([0,0,-2])
//            cylinder(h = length, r = ext_radius);
//        translate([-ext_radius,-1.5*ext_radius,-2])
//            cube([2*ext_radius,3*ext_radius,length], center=false);   
    
    scale([1,1.2,1])cylinder(h = length+center_offset, r = ext_radius);
//    translate([radius,-radius,0])
//        cube([length,2*radius,length+center_offset], center=false);

}

MODE_HOLE=1;
MODE_SUPPORT=2;

module construct(mode)
{
    if(mode == MODE_HOLE)
    {
        hole();
    }else if(mode == MODE_SUPPORT)
    {
        support();
    }
}

module process_list_3(mode,list)
{
rotate([0,0,-(180-list[0][1])/2]) 
    construct(mode);
rotate ([list[0][0],0,0]) 
{
rotate ([0,0,(180-list[1][1])/2]) construct(mode);
rotate ([0,0,180-list[1][1]]) rotate ([list[1][0],0,0]) 
{
rotate ([0,0,(180-list[2][1])/2]) 
    construct(mode);
}
}
}

module process_list_4(mode,list)
{
rotate([0,0,-(180-list[0][1])/2]) 
    construct(mode);
rotate ([list[0][0],0,0]) 
{
rotate ([0,0,(180-list[1][1])/2]) construct(mode);
rotate ([0,0,180-list[1][1]]) rotate ([list[1][0],0,0]) 
{
rotate ([0,0,(180-list[2][1])/2]) 
    construct(mode);

rotate ([0,0,180-list[2][1]]) rotate ([list[2][0],0,0]) 
{
    rotate ([0,0,(180-list[3][1])/2])
    construct(mode);
}
}
}
}

module process_list_5(mode,list)
{
rotate([0,0,-(180-list[0][1])/2]) 
    construct(mode);
rotate ([list[0][0],0,0]) 
{
rotate ([0,0,(180-list[1][1])/2]) construct(mode);
rotate ([0,0,180-list[1][1]]) rotate ([list[1][0],0,0]) 
{
rotate ([0,0,(180-list[2][1])/2]) 
    construct(mode);

rotate ([0,0,180-list[2][1]]) rotate ([list[2][0],0,0]) 
{
    rotate ([0,0,(180-list[3][1])/2])
    construct(mode);
    rotate ([0,0,180-list[3][1]]) rotate ([list[3][0],0,0]) 
{
    rotate ([0,0,(180-list[4][1])/2])
    construct(mode);
}
}
}
}
}

module process_supports(list)
{
    if(len(list) == 3) {
            process_list_3(MODE_SUPPORT,list);
    }else if(len(list) == 4) {
            process_list_4(MODE_SUPPORT,list);
    }else if(len(list) == 5) {
            process_list_5(MODE_SUPPORT,list);
    }
}
module process_holes(list)
{
    if(len(list) == 3) {
            process_list_3(MODE_HOLE,list);
    }else if(len(list) == 4) {
            process_list_4(MODE_HOLE,list);
    }else if(len(list) == 5) {
            process_list_5(MODE_HOLE,list);
    }
}

module center_cylinder()
{
    size = 1.5*length;
//    translate([-size/2,-size/2,-radius-thickness])
//     cube([size,size,length],center=false);
//    cylinder(h = 100, r = 2);
}

module center_hole()
{
    cylinder(h = 4*length, r = radius, center=true);

}


module draw_vertex(base_y_rot,base_z_rot,list)
{
    last_dihedral = list[len(list)][1];
    intersection(){
    difference(){
                rotate([0,-base_y_rot,0]) rotate([0,0,base_z_rot]) 
        difference(){
            union(){
                rotate([0,0,-base_z_rot]) rotate([0,base_y_rot,0]) %center_cylinder();
                process_supports(list);
                }
            process_holes(list);
        }
    center_hole();
        }
        z_offset = (radius+thickness)*sin(base_y_rot)-1.5;
        max_x = (radius+thickness)*sin(base_y_rot) + (length+center_offset)*cos(base_y_rot);
        translate([-2*length,-2*length,-z_offset])
        #cube([4*length,4*length,max_x+z_offset]);
    }
}
