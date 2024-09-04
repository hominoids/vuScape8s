/*
    vuScape8s Library Copyright 2022 Edward A. Kisiel hominoid@cablemi.com
    
    Contributions:
    vent_hex() Copyright 2023 Tomek Szczęsny, mctom @ www.forum.odroid.com

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
    Code released under GPLv3: http://www.gnu.org/licenses/gpl.html

    slab(size, radius)
    slot(hole,length,depth)
    standoff(standoff[radius,height,holesize,supportsize,supportheight,sink,style,i_dia,i_depth])
    button(style, diameter, height)
    button_assembly(style, diameter, height
    button_plunger(style, diameter, height)
    button_top(style, diameter, height)
    button_clip(style)
    vent_hex(cells_x, cells_y, thickness, cell_size, cell_spacing, orientation)
    hk_m1s_case_holes
    hk_m1s_ups()
    proto_m1s()
    proto_ups()
    battery_clip(bat_dia = 18.4)
    battery(type)
    pcb_pad(pads = 1, style = "round")
    led(ledcolor = "red")
    m_insert(type="M3", icolor = "#ebdc8b")
    momentary45x15()
    usbc()
    led(ledcolor = "red")
    header(pins)

*/

use <./fillets.scad>;

/* slab module */
module slab(size, radius) {
    
    x = size[0];
    y = size[1];
    z = size[2];   
    linear_extrude(height=z)
    hull() {
        translate([0+radius ,0+radius, 0]) circle(r=radius);	
        translate([0+radius, y-radius, 0]) circle(r=radius);	
        translate([x-radius, y-radius, 0]) circle(r=radius);	
        translate([x-radius, 0+radius, 0]) circle(r=radius);
    }  
}


/* slot module */
module slot(hole,length,depth) {
    
    hull() {
        translate([0,0,0]) cylinder(d=hole,h=depth);
        translate([length,0,0]) cylinder(d=hole,h=depth);        
        }
    } 


/* standoff module
    standoff(standoff[radius,height,holesize,supportsize,supportheight,sink,style,reverse,insert_e,i_dia,i_depth])
        sink=0 none
        sink=1 countersink
        sink=2 recessed hole
        sink=3 nut holder
        sink=4 blind hole
        
        style=0 hex shape
        style=1 cylinder
*/
module standoff(stand_off){

    radius = stand_off[0];
    height = stand_off[1];
    holesize = stand_off[2];
    supportsize = stand_off[3];
    supportheight = stand_off[4];
    sink = stand_off[5];
    style = stand_off[6];
    reverse = stand_off[7];
    insert_e = stand_off[8];
    i_dia = stand_off[9];
    i_depth = stand_off[10];
    
    adjust = 0.1;
    
    difference (){ 
        union () { 
            if(style == 0 && reverse == 0) {
                rotate([0,0,30]) cylinder(d=radius*2/sqrt(3),h=height,$fn=6);
            }
            if(style == 0 && reverse == 1) {
                translate([0,0,-height]) rotate([0,0,30]) cylinder(d=radius*2/sqrt(3),h=height,$fn=6);
            }
            if(style == 1 && reverse == 0) {
                cylinder(d=radius,h=height,$fn=90);
            }
            if(style == 1 && reverse == 1) {
                translate([0,0,-height]) cylinder(d=radius,h=height,$fn=90);
            }
            if(reverse == 1) {
                translate([0,0,-supportheight]) cylinder(d=(supportsize),h=supportheight,$fn=60);
            }
            else {
                cylinder(d=(supportsize),h=supportheight,$fn=60);
            }
        }
        // hole
        if(sink <= 3  && reverse == 0) {
                translate([0,0,-adjust]) cylinder(d=holesize, h=height+(adjust*2),$fn=90);
        }
        if(sink <= 3  && reverse == 1) {
                translate([0,0,-adjust-height]) cylinder(d=holesize, h=height+(adjust*2),$fn=90);
        }
        // countersink hole
        if(sink == 1 && reverse == 0) {
            translate([0,0,-adjust]) cylinder(d1=6.5, d2=(holesize), h=3);
        }
        if(sink == 1 && reverse == 1) {
            translate([0,0,+adjust-2.5]) cylinder(d1=(holesize), d2=6.5, h=3);
        }
        // recessed hole
        if(sink == 2 && reverse == 0) {
            translate([0,0,-adjust]) cylinder(d=6.5, h=3);
        }
        if(sink == 2 && reverse == 1) {
            translate([0,0,+adjust-3]) cylinder(d=6.5, h=3);
        }
        // nut holder
        if(sink == 3 && reverse == 0) {
            translate([0,0,-adjust]) cylinder(r=3.3,h=3,$fn=6);     
        }
        if(sink == 3 && reverse == 1) {
            translate([0,0,+adjust-3]) cylinder(r=3.3,h=3,$fn=6);     
        }
        // blind hole
        if(sink == 4 && reverse == 0) {
            translate([0,0,2]) cylinder(d=holesize, h=height,$fn=90);
        }
        if(sink == 4 && reverse == 1) {
            translate([0,0,-height-2-adjust]) cylinder(d=holesize, h=height,$fn=90);
        }
        if(insert_e > 0 && reverse == 0) {
            translate([0,0,height-i_depth]) cylinder(d=i_dia, h=i_depth+adjust,$fn=90);
        }
        if(insert_e > 0 && reverse == 1) {
            translate([0,0,-height-adjust]) cylinder(d=i_dia, h=i_depth+adjust,$fn=90);
        }
    }
}


/* buttons */
module button(style, size, radius, pad) {

    diameter = size[0];
    height = size[2];
    gap = 1.5;
    adjust = .01;
    $fn = 90;

    if(style == "recess") {
        difference() {
            union() {
                sphere(d=diameter);
                translate([0,0,-height+3]) cylinder(d=6, h=height-6);
            }
            translate([-(diameter/2)-1,-(diameter/2)-1,0]) cube([diameter+2,diameter+2,(diameter/2)+2]);
            difference() {
                union() {
                    sphere(d=diameter-2);
                }
            }
            translate([-1.75,-1.25,-height-1]) cube([3.5,2.5,height+2]);
            translate([0,0,-(diameter/2)]) cylinder(d=5, h=2);
        }
    }
    if(style == "cutout") {
        difference() {
            translate([-size[0]+2,-3-size[1]/2,0]) slab_r([size[0]+2,size[1]+6,size[2]-2*adjust], [.1,.1,.1,.1]);            
            difference() {
                translate([-size[0]+3,-size[1]/2,-adjust]) 
                    slab_r([size[0],size[1],size[2]], [radius[0],radius[1],radius[2],radius[3]]);
                translate([-size[0]+3+(gap/2),-size[1]/2+(gap/2),-1]) slab_r([size[0]-gap,size[1]-gap,1+size[2]+2*adjust], 
                    [radius[0],radius[1],radius[2]-gap/2,radius[3]-gap/2]);
                translate([-size[0]+3-gap,-1,-1]) cube([gap*2,2,1+height+2*adjust]);
            }
            translate([0,0,2]) sphere(d=3);
        }
        translate([0,0,-pad+adjust]) cylinder(d=3, h=pad);
    }
}


/* button plunger,top,clip */
module button_assembly(style, diameter, height) {

adjust = .01;
$fn = 90;

    if(style == "recess") {
        button_plunger(style, diameter, height);
        button_top(style, diameter, height);
        translate([0,0,-height]) button_clip(style);
    }
}


/* button plunger */
module button_plunger(style, diameter, height) {

adjust = .01;
$fn = 90;

    if(style == "recess") {
        difference() {
            translate([-1.5,-1,-(height)-2]) cube([3,2,height+1]);
            translate([-1.5-adjust,-1.5,-height]) cube([.5,3,1]);
            translate([1+adjust,-1.5,-height]) cube([.5,3,1]);
            translate([-1.5-adjust,-1.5,-4]) cube([.5,3,4]);
            translate([1+adjust,-1.5,-4]) cube([.5,3,4]);
        }
    }
}


/* button top */
module button_top(style, diameter, height) {

adjust = .01;
$fn = 90;

    if(style == "recess") {
        difference() {
            translate([0,0,-3]) cylinder(d=5, h=2.75);
            translate([-1.25,-1.25,-3-adjust]) cube([2.5,2.5,2]);
        }
    }
}


/* button c-clip */
module button_clip(style) {

adjust = .01;
$fn = 90;

    if(style == "recess") {
        difference() {
            cylinder(d=8.5, h=.8);
            translate([-1.5,-1.75,-adjust]) cube([2.75,3.5,1]);
            translate([-.75,-.75,-adjust]) cube([5,1.25,1.25]);
        }
    }
}
// hk vu8s lcd display
module hk_vu8s() {
    
    body_size  = [202, 133, 1.70];
    glass_size = [195.5, 131, 1.75];
    lcd_size   = [183.5,114, body_size[2] + 1];
    view_size  = [172.5, 107.5, .1];

    rb = 5.25;   // body edge radius

    lcd_clearance = [0.15, 0.1, 0];
    pcb_size = [14,24,1.6];
    hole = 4.31;
    spacer_size = [5.5, 1.75+body_size[2], 2.5, 5.5, 1, 0, 1, 1, 0, 0, 0];
    
    $fn = 90;    
    adj = .01;

    // "body"
    color([0.1,0.1,0.1])
    difference(){
        union() {
            slab(body_size, rb);
            translate([(8.25/2),-1.74-(8.25/2),0]) rotate([0,0,90]) slot(8.25,10+(8.25/2),body_size[2]);
            translate([body_size[0]-(8.25/2),-1.74-(8.25/2),0]) rotate([0,0,90]) slot(8.25,10+(8.25/2),body_size[2]);
            translate([(8.25/2),body_size[1]-10,0]) rotate([0,0,90]) slot(8.25,10.75+(8.25/2),body_size[2]);
            translate([body_size[0]-(8.25/2),body_size[1]-10,0]) rotate([0,0,90]) slot(8.25,10.75+(8.25/2),body_size[2]);
        }
        lcd_space = lcd_size + 2*lcd_clearance;
        
        // corner holes
        translate([4, -5, -1]) cylinder(d=hole, h=5);
        translate([4, 143-5, -1]) cylinder(d=hole, h=5);
        translate([202-4, -5, -1]) cylinder(d=hole, h=5);
        translate([202-4, 143-5, -1]) cylinder(d=hole, h=5);

        translate([3.5, 3.5, -1]) cylinder(d=hole, h=5);
        translate([3.5, body_size[1]-3.5, -1]) cylinder(d=hole, h=5);
        translate([111, 3.5, -1]) cylinder(d=hole, h=5);
        translate([111.5, body_size[1]-3.5, -1]) cylinder(d=hole, h=5);

    }
        // standoffs
        color([0.6,0.6,0.6]) {
            translate([4, 3.75, body_size[2]+adj]) standoff(spacer_size);
            translate([3.75, 128.25, body_size[2]+adj]) standoff(spacer_size);
            translate([111.5, 4, body_size[2]+adj]) standoff(spacer_size);
            translate([111.25, 128.75, body_size[2]+adj]) standoff(spacer_size);
        }
    // LCD panel
    color([0.6, 0.6, 0.65])
        translate([10, 9, body_size[2]-lcd_size[2]]+lcd_clearance)
            cube(lcd_size); 

    // Front glass
    // It's actually thinner and glued, but for the sake of simplicity...
    color([0.2, 0.2, 0.2], 0.9)
        translate([3, 1.25, body_size[2] + 0.01])
            slab(glass_size, rb);

    // view area
    color("dimgrey", 0.9)
        translate([14, 12.5, body_size[2] + glass_size[2]- 0.01])
            slab(view_size, .1);

    // PCB stub
    color([0.1,0.1,0.1])
        translate([body_size[0]-25, body_size[1]-30, -2])
            cube([7,7,.1]);
    color([0.1,0.1,0.1])
        translate([body_size[0]-50, body_size[1]-35, -2])
            cube([4,5,.1]);
}



// vent opening
module vent(width,length,height,gap,rows,columns,orientation) {
    
    fillet = width/2;
    adjust = .01;
    $fn=90;
    
    // vertical orientation
    if(orientation == "vertical") { rotate([90,0,0])
        for (r=[0:length+gap:rows*(length+gap)-1]) {
            for (c=[0:width+(2*gap):(columns*(width+(2*gap)))-1]) {
                translate ([c,r,-1]) cube([width,length,height]);
            }
        }        
    }
    // horizontal orientation
    if(orientation == "horizontal") {
        for (r=[0:length+(2*gap):rows*(length+gap)]) {
            for (c=[0:width+(2*gap):(columns*(width+(2*gap)))-1]) {
                translate ([c,r,-1]) cube([width,length,height]);
            }
        }
    }
}

// Hex vent opening
module vent_hex(cells_x, cells_y, thickness, cell_size, cell_spacing, orientation) {
    xs = cell_size + cell_spacing;
    ys = xs * sqrt(3/4);
    rot = (orientation=="vertical") ? 90 : 0;

    rotate([rot,0,0]) translate([cell_size/2, cell_size*sqrt(1/3),-1]) {
        for (ix = [0 : ceil(cells_x/2)-1]) {
            for (iy = [0 : 2 : cells_y-1]) {
                translate([ix*xs, iy*ys,0]) rotate([0,0,90]) 
                    cylinder(r=cell_size/sqrt(3), h=thickness, $fn=6);
            }
        }
            for (ix = [0 : (cells_x/2)-1]) {
                for (iy = [1 : 2 : cells_y-1]) {
                translate([(ix+0.5)*xs, iy*ys,0]) rotate([0,0,90]) 
                    cylinder(r=cell_size/sqrt(3), h=thickness, $fn=6);
            }
        }
    }
}


module hk_m1s_case_holes(type="landscape") {
    
    if(type == "portrait") {
        cylinder(d=3, h=6);
        translate([0,107,0]) cylinder(d=3, h=6);
        translate([58,0,0]) cylinder(d=3, h=6);
        translate([58,107,0]) cylinder(d=3, h=6);
    }
    else {
        cylinder(d=3, h=6);
        translate([0,58,0]) cylinder(d=3, h=6);
        translate([107,0,0]) cylinder(d=3, h=6);
        translate([107,58,0]) cylinder(d=3, h=6);
    }
}


// hk m1s ups
module hk_m1s_ups() {
    
    pcb_size = [115,32,1.62];

    adj = .01;
    $fn = 90;
    
    difference() {
        union() {
            color("#008066") slab(pcb_size,4);
            color("#fee5a6") translate([3.5,3.5,-.1]) cylinder(d=5.5, h=pcb_size[2]+.2);
            color("#fee5a6") translate([3.5,pcb_size[1]-3.5,-.1]) cylinder(d=5.5, h=pcb_size[2]+.2);
            color("#fee5a6") translate([pcb_size[0]-3.5,3.5,-.1]) cylinder(d=5.5, h=pcb_size[2]+.2);
            color("#fee5a6") translate([pcb_size[0]-3.5,pcb_size[1]-3.5,-.1]) cylinder(d=5.5, h=pcb_size[2]+.2);
        }
        color("#fee5a6") translate([3.5,3.5,-1]) cylinder(d=4, h=4);
        color("#fee5a6") translate([3.5,pcb_size[1]-3.5,-1]) cylinder(d=4, h=4);
        color("#fee5a6") translate([pcb_size[0]-3.5,3.5,-1]) cylinder(d=4, h=4);
        color("#fee5a6") translate([pcb_size[0]-3.5,pcb_size[1]-3.5,-1]) cylinder(d=4, h=4);
   }
   // battery and clips
   color("silver") translate([15,5,pcb_size[2]]) rotate([0,0,270]) battery_clip();
   color("silver") translate([80,16,pcb_size[2]]) rotate([0,0,90]) battery_clip();
   translate([13.25,10.5,pcb_size[2]+10.4]) rotate([0,90,0]) battery("18650_convex");
   
   translate([86.75,.5,pcb_size[2]]) momentary45x15();
   translate([97.5,-1,pcb_size[2]]) usbc();
   
   translate([35,28,pcb_size[2]]) led("DodgerBlue");
   translate([40,28,pcb_size[2]]) led("DodgerBlue");
   translate([45,28,pcb_size[2]]) led("DodgerBlue");
   translate([50,28,pcb_size[2]]) led("DodgerBlue");
 
   translate([113,8,pcb_size[2]]) rotate([0,0,90]) led("green");
   translate([113,16,pcb_size[2]])  rotate([0,0,90]) led();
   translate([113,21,pcb_size[2]])  rotate([0,0,90]) led();
   
   translate([78,29,pcb_size[2]]) rotate([0,0,270])header(7);
   translate([78,31.5,pcb_size[2]]) rotate([0,0,270])header(7);
}


// prototype board, ups footprint
module proto_ups() {
    
    pcb_size = [115,32,1.62];

    adj = .01;
    $fn = 90;
    
    union() {
        difference() {
            union() {
                color("#008066") slab(pcb_size,4);
                color("#fee5a6") translate([3.5,3.5,-.1]) cylinder(d=5.5, h=pcb_size[2]+.2);
                color("#fee5a6") translate([3.5,pcb_size[1]-3.5,-.1]) cylinder(d=5.5, h=pcb_size[2]+.2);
                color("#fee5a6") translate([pcb_size[0]-3.5,3.5,-.1]) cylinder(d=5.5, h=pcb_size[2]+.2);
                color("#fee5a6") translate([pcb_size[0]-3.5,pcb_size[1]-3.5,-.1]) cylinder(d=5.5, h=pcb_size[2]+.2);
            }
            color("#fee5a6") translate([3.5,3.5,-1]) cylinder(d=4, h=4);
            color("#fee5a6") translate([3.5,pcb_size[1]-3.5,-1]) cylinder(d=4, h=4);
            color("#fee5a6") translate([pcb_size[0]-3.5,3.5,-1]) cylinder(d=4, h=4);
            color("#fee5a6") translate([pcb_size[0]-3.5,pcb_size[1]-3.5,-1]) cylinder(d=4, h=4);
       }
       // pads
       for(r=[5:2.54:30]) {
        translate([10,r,pcb_size[2]+adj]) pcb_pad(38);
       }
   }
}


// prototype board, m1s footprint
module proto_m1s() {
    
    pcb_size = [90,65,1.62];

    adj = .01;
    $fn = 90;
    
    union() {
        difference() {
            union() {
                color("#008066") slab(pcb_size,2);
                color("#fee5a6") translate([3.5,3.5,-.1]) cylinder(d=4.5, h=pcb_size[2]+.2);
                color("#fee5a6") translate([pcb_size[0]-3.5,3.5,-.1]) cylinder(d=4.5, h=pcb_size[2]+.2);
                color("#fee5a6") translate([17.5,52.5,-.1]) cylinder(d=4.5, h=pcb_size[2]+.2);
                color("#fee5a6") translate([67.5,55.1,-.1]) cylinder(d=4.5, h=pcb_size[2]+.2);
            }
            color("#fee5a6") translate([3.5,3.5,-1]) cylinder(d=3, h=4);
            color("#fee5a6") translate([pcb_size[0]-3.5,3.5,-1]) cylinder(d=3, h=4);
            color("#fee5a6") translate([17.5,52.5,-1]) cylinder(d=3, h=4);
            color("#fee5a6") translate([67.5,55.1,-1]) cylinder(d=3, h=4);
       }
       // pads
       for(r=[7:2.54:32]) {
        translate([10,r,pcb_size[2]+adj]) pcb_pad(28);
       }
   }
}


module battery_clip(bat_dia = 18.4) {
    
    mat = .38;
    width = 9.5;
    tab = 8.9;
    bat_holder = bat_dia+2*mat;
    adj = .1;

    translate([-5.5,0,10.5]) {
        difference() {
            translate([0,width,0]) rotate([90,0,0]) cylinder(d=bat_holder, h=9.5);
            translate([0,width+adj,0]) rotate([90,0,0]) cylinder(d=bat_dia, h=10.5);
            translate([mat/2-11.1/2,-adj,mat-1.3-bat_dia/2]) cube([11.1-mat,width+2*adj,3]);
            translate([0,width+adj,0]) rotate([90,-45,0]) cube([bat_dia,bat_dia,bat_holder]);
        }
        difference() {
            translate([-11.1/2,0,-1.3-bat_dia/2]) cube([11.1,width,3]);
            translate([mat-11.1/2,-adj,mat/2-1.3-bat_dia/2]) cube([11.1-2*mat,width+2*adj,3]);
        }
        difference() {
            translate([-(tab/2),-3.5,-1-bat_dia/2]) rotate([-5,0,0]) cube([tab,3.5,10]);
            translate([-(tab/2)-adj,-3.5+mat,mat-1-bat_dia/2]) rotate([-5,0,0]) cube([tab+2*adj,3.5+mat,10]);
        }    
        translate([0,-2.225,0]) rotate([85,0,0]) cylinder(d=tab, h=mat);
        difference() {
            translate([0,-2.75,0]) sphere(d=3);
            translate([-5,-2.75,-5]) rotate([85,0,0]) cube([tab,10,10]);
        }
    }
}


module battery(type) {

    adj = .01;
    if(type == "18650") {
        difference() {
            cylinder(d=18.4, h=65);
            translate([0,0,65-4]) difference() {
                cylinder(d=18.5, h=2);
                cylinder(d=17.5, h=3);
            }
        }
    }
    if(type == "18650_convex") {
        difference() {
            cylinder(d=18.4, h=68);
            translate([0,0,65-4]) difference() {
                cylinder(d=18.5, h=2);
                cylinder(d=17.5, h=3);
            }
            translate([0,0,65-adj]) difference() {
                cylinder(d=18.5, h=3+2*adj);
                cylinder(d=14.4, h=3+2*adj);
            }
        }
    }
    if(type == "21700") {
        difference() {
            cylinder(d=21, h=70);
            translate([0,0,70-4]) difference() {
                cylinder(d=21.1, h=2);
                cylinder(d=20.1, h=3);
            }
        }
    }
}


// single row pcb pad
module pcb_pad(pads = 1, style = "round") {

    adjust = .01;
    $fn = 90;
    pad_size = 1.25;
    size_y = 2.54;
    size_x = 2.54 * (pads-1);                
    union() {
        for (i=[0:2.54:size_x]) {
            if(style == "round") {
                difference() {
                    color("#fee5a6") translate ([i,0,0]) cylinder(d=pad_size, h=.125);
                    color("dimgray") translate([i,0,-adjust]) cylinder(d=.625, h=.125+2*adjust);
                }
            }
            if(style == "square") {
                difference() {
                    color("#fee5a6") translate ([i-pad_size/2,-pad_size/2,0]) cube([pad_size, pad_size, .125]);
                    color("dimgray") translate([i,0,-adjust]) cylinder(d=.625, h=.125+2*adjust);
                }
            }
        }
    }
}


module m_insert(type="M3", icolor = "#ebdc8b") { //#f4e6c3, #ebdc8b 
    
    odiam = type == "M3" ? 4.2 : 3.5;
    idiam = type == "M3" ? 3 : 2.5;
    iheight = 4;
    
    difference() {
        color(icolor,.6) cylinder(d=odiam, h=iheight);
        color(icolor,.6) translate([0,0,-1]) cylinder(d=idiam, h=iheight+2);
    }
    for(bearing = [0:10:360]) {
        color(icolor) translate([-.25+(odiam/2)*cos(bearing),-.25+(odiam/2)*sin(bearing),iheight-1.5]) 
            rotate([0,0,0]) cube([.5,.5,1.5]);
    }
}


// momentary_4.5x4.5x1.5 button
module momentary45x15() {

    adjust = .01;
    $fn = 90;
    size_x = 4.5;
    size_y = 4.5;        
    size_z = 3.1;        
    union() {
        color("black") translate([0,0,0]) cube([size_x,size_y,3]);
        color("silver") translate([0,0,3-adjust]) cube([size_x,size_y,.1]);
        color("black") translate([2.25,2.25,3.1-adjust]) cylinder(d=2.35,h=1.50);
        color("black") translate([.75,.75,3]) sphere(d=.75);
        color("black") translate([.75,3.75,3]) sphere(d=.75);
        color("black") translate([3.75,.75,3]) sphere(d=.75);
        color("black") translate([3.75,3.75,3]) sphere(d=.75);
    }
}


module usbc() {
    
    $fn=90;
    adj = .01;
    
    // usbc horizontal type
        
        size_x = 9;
        size_y = 7;
        dia = 3.5;
        diam = 3.75;

        rotate([90, 0, 0])  translate([dia/2, dia/2, -size_y]) union() {    
            difference () {
                color("silver")
                hull() {
                    translate([0,0,0]) cylinder(d=dia,h=size_y);
                    translate([size_x-dia,0,0]) cylinder(d=dia,h=size_y);        
                    }
                color("silver") translate([0,0,1])
                hull() {
                    translate([0,0,0]) cylinder(d=3,h=size_y+.2);
                    translate([size_x-dia,0,0]) cylinder(d=3,h=size_y+.2);        
                    }
            }
            color("black") translate([0,-1.2/2,.1]) cube([5.5,1.2,6]);
        }
    }


module led(ledcolor = "red") {
    
    color(ledcolor) cube([3,1.5,.4]);
    color("silver") cube([.5,1.5,.5]);
    color("silver") translate([2.5,0,0]) cube([.5,1.5,.5]);
}


// single row headers
module header(pins) {

    adjust = .01;
    $fn = 90;
    size_x = 2.54;
    size_y = 2.54 * pins;                
    union() {
        color("black") translate([0,0,0]) cube([size_x, size_y, 2.5]);
        for (i=[1:2.54:size_y]) {
            color("silver") translate ([1,i,2.5]) cube([.64,.64,5]);
        }
    }
}       
