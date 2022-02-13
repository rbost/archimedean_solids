// LICENSE: CC Attribution 4.0 International
// Construct vertices for archimedean solids
// Heavily inspired by a similar project for platonic solids: https://www.prusaprinters.org/prints/78213-platonic-solid-vertices/files


// Some parameters might need some ad-hoc manual tweaking (the geometry is pretty hard and annoying to do thouroughly)


length = 10;
diameter = 9.3;

radius = diameter/2;
thickness = 1;
center_offset=1.8*radius;
$fn = 25; // cylinder hole precision



// Rhombicuboctahedron
//draw_vertex(67.5,22.5,[[90,144.74],[90,135],[90,135],[60,144.74]]);


// Truncated icosahedron
//draw_vertex(79,21,[[120,142.62],[120,138.189685],[108,142.62]]);
    


// Icosidodecahedron
//angle = 142.62;
//draw_vertex(72,25,[[108,angle],[60,angle], [108,angle], [108,angle]]);

// Cuboctahedron
angle = 125.26;
draw_vertex(60,35,[[90,angle],[60,angle], [90,angle], [60,angle]]);



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

module process_supports(list)
{
    if(len(list) == 3) {
            process_list_3(MODE_SUPPORT,list);
    }else if(len(list) == 4) {
            process_list_4(MODE_SUPPORT,list);
    }
}
module process_holes(list)
{
    if(len(list) == 3) {
            process_list_3(MODE_HOLE,list);
    }else if(len(list) == 4) {
            process_list_4(MODE_HOLE,list);
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
        z_offset = (radius+thickness)*sin(base_y_rot)-3;
        max_x = (radius+thickness)*sin(base_y_rot) + (length+center_offset)*cos(base_y_rot);
        translate([-2*length,-2*length,-z_offset])
        #cube([4*length,4*length,max_x+z_offset]);
    }
}
