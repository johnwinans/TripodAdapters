/**
*
*	A tripod mount adapter for a GoPro Hero2
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


base();
translate([0, 0, 4.9]) goproclamp();

module base()
{
    x = 40;
    y = 35;
    z = 10;
    
    translate([-x/2, -y/2, 0])
    difference()
    {
        cube([40, y, 5]);
        translate([-9, 0, 5.01]) wedge();
        translate([40-5, 0, 5.01]) wedge();
    }
}

module wedge()
{
    difference()
    {
        translate([0, -.5, 0]) rotate([0, 45, 0]) cube([10, 51, 10]);
        translate([0, -.1, 0]) cube([sqrt(100*100+100*100), 52, 10]);
    }
}


module goproclamp(clipon=true)
{
    // the camera dimensions
    x = 61;
    y = 31;
    z = 43;
    wt = 2;     // the wall thickness
    is = wt+5;     // insets
    
    // outer ox dimenstions
    ox = x+2*wt;
    oy = y+2*wt;
    oz = z+2*wt;
    
    translate([-ox/2, -oy/2, 0])
    difference()
    {
        cube([ox, oy, oz]);
        translate([wt, wt, wt]) cube([x, y, z]);    // camera volume
        
        translate([-.5, is, is]) cube([ox+1, oy-is*2, oz-is*2]); // open the ends

        // cut out some room for the mic jack
        translate([ox,12,9])
            rotate([0,90,0]) cylinder(d=10, h=10, $fn=30, center=true);
        
        if (clipon)
        {
            translate([ox-is-2, oy-wt*2-1, oz/2]) cube([2, wt*2+2, oz]);
            translate([is, oy-wt*2-1, oz/2]) cube([2, wt*2+2, oz]);
            translate([wt, wt, wt]) cube([is, y, z+wt+1]);
            translate([ox-is-2, wt, wt]) cube([is, y, z+wt+1]);

        }
        else
        {
            translate([wt, wt, wt]) cube([x, y, z+wt+1]);    
            translate([is, -.5, is+wt]) cube([ox-is*2, oy+1, oz-is*2]); // y
        }
        translate([is, -.5, is]) cube([ox-is*2, oy-wt*2, z]); // lens
    }
}
