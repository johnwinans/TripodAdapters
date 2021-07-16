/**
*
*	A tripod mount adapter for an LG G6 (with a protective cover on it)
*
*    Copyright (C) 2021 John Winans
*
*    This program is free software: you can redistribute it and/or modify
*    it under the terms of the GNU General Public License as published by
*    the Free Software Foundation, either version 3 of the License, or
*    (at your option) any later version.
*
*    This program is distributed in the hope that it will be useful,
*    but WITHOUT ANY WARRANTY; without even the implied warranty of
*    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
*    GNU General Public License for more details.
*
*    You should have received a copy of the GNU General Public License
*    along with this program.  If not, see <https://www.gnu.org/licenses/>.
*
*********************************************************************************/


$fn=30;


// change these dimensions to match your phone:
phone_x = 157;       // the long dimension (height) of the phone (including protector case)
phone_y = 13;        // the thickness of the phone (including the protector case)
phone_z = 80;        // the short dimension (width) of the phone (including the protector case)


holder(phone_x, phone_y, phone_z);



/*
* The complete bracket for holding an LG G6 phone on a 
* quick-release tripod.
****************************************************************/
module holder(x, y, z)
{
    base(y+6);
    translate([0,0,10]) camera(x, y, z);  
    supports(y); 
}

/*
* Custom easy break-off support material.
****************************************************************/
module supports(width)
{
    half=157/2;
    w = half*.7;
    y=1;
    h=7;
    
    for ( x = [ -half, .3*half ] )
    {
        translate([x, -y/2, 0]) cube([w,y,h]);
        
        for ( s = [ x : w/5 : x+w ] )
            translate([s-.5, -width/2, 0]) cube([1,width,h]);
    }
}

/**
* This is a base that fits into a tripod quick-release plate 
* such as the ZOMEi Z818, Q666, etc.
****************************************************************/
module base(y)
{
    x = 40;
    z = 5;
    wedgecube = sqrt(z*z*2);
    
    translate([-x/2, -y/2, 0])
    difference()
    {
        // that part that goes into the tripod
        cube([x, y, z]);
        // remove some to create the 45-degree wedges
        for ( wcx = [ 0, x ] )
            translate([wcx, -.5, 0]) rotate([0, -45, 0]) cube([wedgecube, y+1, wedgecube]);
    }
}

/**
* This is the 'C-clamp' for the camera/phone
****************************************************************/
module camera(x, y, z)
{
    insets = 7;     // window border insets
    
    wt=3;  // shell/wall thickness

    bx = x+wt*2;
    by = y+wt*2;
    bz = z+wt*2;

    ix = x-insets*2;
    iy = y+wt*2;
    iz = z-insets*2;
    
    translate([0, 0, z/2])
    difference()
    {
        union()
        {
            // the neck that connects the tripod mount
            translate ([0, 0, -z/2]) cube([30,by-1,10], center=true);
            // the main body of the camera-holder
            mblock(bx, by, bz);
        }
        // hollow out the slot to hold the camera
        mblock(x, y, z);

        // remove the top part
        translate([-bx/2-.01, -by/2, 0]) cube([bx+.02,by,bz]);
        // make a window for the screen & camera
        mblock(ix, iy+20, iz);
    }
}

/*
* A cube with rounded corners.
****************************************************************/
module mblock(x, y, z)
{
    mrad = 5;       // the radius of the minkowski sphere
    mx = x-mrad*2;
    my = y-mrad*2;
    mz = z-mrad*2;
    
    translate([-x/2, -y/2, -z/2])
    translate([mrad, mrad, mrad])
    minkowski()
    {
        cube([mx, my, mz]);
        sphere(r=mrad, $fn=60);
    }
}
