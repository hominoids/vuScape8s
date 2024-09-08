/*
    vuScape8s Case Copyright 2023 Edward A. Kisiel
    hominoid @ www.forum.odroid.com

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

    20231204 Version 1.0    vuScape8s, Odroid-M1s and M1s-UPS integrated Case initial release.
    2024090x Version 2.0    Added Odroid-M2
    
    case_front()
    case_back()
    back_frame()
    sbc_cover()
    ups_cover()
    bracket(side)

*/

use <./lib/fillets.scad>;
use <./lib/vuScape8s_library.scad>;
use <./SBC_Model_Framework/sbc_models.scad>;

/* [View] */
view = "model";  // [model, platter, part]
individual_part = "back"; // [front, back, frame, sbc_cover, ups_cover, ups_button, bracket_left, bracket_right]
vu8s_on = true;
move_front = 0; // [-1:200]
move_back = 0; // [-1:200]
sbc_on = true;
move_sbc_cover = 0; // [-1:200]
ups_on = false;
move_ups_cover = 0; // [-1:200]

/* [Adjustments] */
sbc_model = "m2"; // ["m1s","m2"]
orientation = "landscape"; // [landscape, portrait]
view_angle = 15; // [10:1:23]
view_height = 24; // [10:.5:40]
view_size = [172.5,107.5,.125]; // [1:.125:175]
vu8s_mount = "insert"; // [thruhole, recessed, nut, insert]
sbc_mount = "insert"; // [none, insert, recessed]
right_pillar_mount = "recessed"; // [none, thruhole, recessed]
insert_dia = 4.2; // [2:.1:5] 

/* [Options] */
brackets = true;
backframe = true;
gpio_opening = "default"; // [default,none,open,block,knockout,vent]

top_cover_pattern = "hex_5mm"; //[solid,hex_5mm,hex_8mm,linear_vertical,linear_horizontal]
cooling = "none"; // [default,none,open,fan_open,fan_1,fan_2,fan_hex,vent,vent_hex_5mm,vent_hex_8mm,custom]
fan_size = 0; // [0,25,30,40,50,60,70,80,92]

ups_led_down_light =  false;
ups_location = "none"; // [none, bottom, side]
prototype_m1s_on = false;
prototype_ups_on = false;

/* [Hidden] */
flip_view = false;
wallthick = 2;
floorthick = 1.5;
frontthick = 1.5;
gap = 1;

c_fillet = 4;
fillet = 0;
lcd_size = [202,153,4.45];
//view_size = [172.5,107.5,.125];
pcb_tmaxz = 5.5;
pcb_bmaxz = 0;

width = lcd_size[0]+(2*(wallthick+gap));
depth = lcd_size[1]+(2*(wallthick+gap));
front_height = pcb_tmaxz+frontthick;
back_height = pcb_bmaxz+floorthick;
case_z = back_height+front_height;

top_standoff=[      7.5,   // radius
                    2.5,   // height
                    2.7,   // holesize
                   10,     // supportsize
                    2.5,   // supportheight
                    1,     // 0=none, 1=countersink, 2=recessed hole, 3=nut holder, 4=blind hole
                    1,     // standoff style 0=hex, 1=cylinder
                    0,     // enable reverse standoff
                    0,     // enable insert at top of standoff
                    4.5,   // insert hole dia. mm
                    5.1];  // insert depth mm
                  
bottom_standoff=[ 5.2,     // radius
                    floorthick+1, // height
                    2.7,   // holesize
                   6.2,     // supportsize
                    floorthick+1, // supportheight
                    0,     // 0=none, 1=countersink, 2=recessed hole, 3=nut holder, 4=blind hole
                    0,     // standoff style 0=hex, 1=cylinder
                    0,     // enable reverse standoff
                    0,     // enable insert at top of standoff
                    4.5,   // insert hole dia. mm
                    5.1];  // insert depth mm
                  
adj = .1;
$fn = 90;
cover_offset = sbc_model == "m2" ? 25 : 0;

// model view
if (view == "model" && orientation == "landscape") {
    translate([(width/2),-40,view_height-2+(view_angle-15)]) rotate([90+view_angle,0,180]) {  // landscape
        if(move_front >= 0) {
            color("grey",1) translate([0,0,-move_front]) case_front();
        }
        if(move_back >= 0) {
            color("dimgrey",1) translate([0,0,front_height-(back_height/2)+move_back+adj]) case_back();
        }
        if(vu8s_on == true) {
         translate([gap+wallthick+lcd_size[0],gap+wallthick+10,2.5+frontthick]) rotate([0,180,0]) hk_vu8s();
        }
        if(sbc_on == true) {
         translate([162,115.5,6+front_height]) rotate([0,0,180]) sbc(sbc_model);
        }
        if(move_sbc_cover >= 0 && prototype_m1s_on == false) {
         translate([gap+wallthick+66,gap+wallthick+44.5-cover_offset,front_height+4+move_sbc_cover]) 
            rotate([0,0,0]) sbc_cover();
        }
        if(ups_on == true && sbc_model == "m1s") {
            if(ups_location == "side") {
                translate([16.5,137.25,4+front_height]) rotate([0,0,270]) hk_m1s_ups();
            }
            if(ups_location == "bottom") {
                translate([60,12.5,4+front_height]) hk_m1s_ups();
            }
        }
        if(move_ups_cover >= 0 && sbc_model == "m1s") {
            if(ups_location == "side") {
                translate([13.5,140,4+front_height+move_ups_cover]) rotate([0,0,270]) ups_cover();
            }
            if(ups_location == "bottom") {
                translate([57.25,9.5,4+front_height+move_ups_cover]) ups_cover();
            }
        }
        if(prototype_m1s_on == true && sbc_model == "m1s") {
            translate([72,50.5,18+front_height]) proto_m1s();
        }
        if(prototype_ups_on == true && sbc_model == "m1s") {
            if(ups_location == "side") {
                translate([60,12.5,4+front_height]) proto_ups();
            }
            if(ups_location == "bottom") {
                translate([16.5,137.25,4+front_height]) rotate([0,0,270]) proto_ups();
            }
        }
        if(backframe == true) {
         translate([0,0,front_height+adj]) back_frame();
        }
        if(brackets == true && orientation == "landscape" && flip_view == false) {
         translate([gap+wallthick+8.5,4.5,front_height]) rotate([0,0,0]) bracket("left");
         translate([width-.5,4.5,front_height]) rotate([0,0,0]) bracket("right");
        }
        if(brackets == true && orientation == "landscape" && flip_view == true) {
         translate([gap+wallthick+width-14.5,depth-4.5,front_height]) rotate([0,0,180]) bracket("left");
         translate([.5,depth-4.5,front_height]) rotate([0,0,180]) bracket("right");
        }
        if(brackets == true && orientation == "portrait" && flip_view == false) {
         translate([gap+wallthick+1.5,depth-11.5,front_height]) rotate([0,0,270]) bracket("left");
         translate([2.5,.5,front_height]) rotate([0,0,270]) bracket("right");
        }
        if(brackets == true && orientation == "portrait" && flip_view == true) {
         translate([width+gap+wallthick-7.75,11.5,front_height]) rotate([0,0,90]) bracket("left");
         translate([width-2.5,depth-.5,front_height]) rotate([0,0,90]) bracket("right");
        }
    }
}
if (view == "model" && orientation == "portrait") {
    translate([-(depth/2),-40,view_height-2+(view_angle-15)]) rotate([0,270-view_angle,270]) {  // portrait
        if(move_front >= 0) {
            color("grey",1) translate([0,0,-move_front]) case_front();
        }
        if(move_back >= 0) {
            color("dimgrey",1) translate([0,0,front_height-(back_height/2)+move_back+adj]) case_back();
        }
        if(vu8s_on == true) {
            translate([gap+wallthick+lcd_size[0],gap+wallthick+10,2.5+frontthick]) rotate([0,180,0]) hk_vu8s();
        }
        if(sbc_on == true) {
            translate([162,115.5,6+front_height]) rotate([0,0,180]) sbc(sbc_model);
        }
        if((move_sbc_cover >= 0 && prototype_m1s_on == false) || (move_sbc_cover >= 0 && sbc_model == "m2")) {
            translate([gap+wallthick+66,gap+wallthick+44-cover_offset,front_height+4+move_sbc_cover]) 
                rotate([0,0,0]) sbc_cover();
        }
        if(ups_on == true && sbc_model == "m1s") {
            if(ups_location == "bottom") {
                translate([16.5,137.25,4+front_height]) rotate([0,0,270]) hk_m1s_ups();
            }
            if(ups_location == "side") {
                translate([60,12.5,4+front_height]) hk_m1s_ups();
            }
        }
        if(move_ups_cover >= 0 && sbc_model == "m1s") {
            if(ups_location == "bottom") {
                translate([13.5,140,4+front_height+move_ups_cover]) rotate([0,0,270]) ups_cover();
            }
            if(ups_location == "side") {
                translate([57.25,9.5,4+front_height+move_ups_cover]) ups_cover();
            }
        }
        if(prototype_m1s_on == true && sbc_model == "m1s") {
            translate([72,50.5,18+front_height]) proto_m1s();
        }
        if(prototype_ups_on == true && sbc_model == "m1s") {
            if(ups_location == "side") {
                translate([60,12.5,4+front_height]) proto_ups();
            }
            if(ups_location == "bottom") {
                translate([16.5,137.25,4+front_height]) rotate([0,0,270]) proto_ups();
            }
        }
        if(backframe == true) {
         translate([0,0,front_height]) back_frame();
        }
        if(brackets == true && orientation == "landscape" && flip_view == false) {
         translate([gap+wallthick+8.5,4.5,front_height]) rotate([0,0,0]) bracket("left");
         translate([width-.5,4.5,front_height]) rotate([0,0,0]) bracket("right");
        }
        if(brackets == true && orientation == "landscape" && flip_view == true) {
         translate([gap+wallthick+width-14.5,depth-4.5,front_height]) rotate([0,0,180]) bracket("left");
         translate([.5,depth-4.5,front_height]) rotate([0,0,180]) bracket("right");
        }
        if(brackets == true && orientation == "portrait" && flip_view == false) {
         translate([gap+wallthick+1.5,depth-11.5,front_height]) rotate([0,0,270]) bracket("left");
         translate([2.5,.5,front_height]) rotate([0,0,270]) bracket("right");
        }
        if(brackets == true && orientation == "portrait" && flip_view == true) {
         translate([width+gap+wallthick-7.75,11.5,front_height]) rotate([0,0,90]) bracket("left");
         translate([width-2.5,depth-.5,front_height]) rotate([0,0,90]) bracket("right");
        }
    }
}

// platter view
if (view == "platter") {
    translate([width-2,0,back_height-.5]) rotate([0,180,0]) case_back();
    translate([0,depth+10,0]) case_front();
    translate([width+120,170,13]) rotate([0,180,0]) sbc_cover();
    translate([width+140,270,23]) rotate([0,180,0]) ups_cover();
    translate([width+10,0,0]) back_frame();
    translate([-150,35,12]) rotate([0,270,0]) bracket("left");
    translate([-130,30,0]) rotate([0,90,0]) bracket("right");
    }
    
// part view
if (view == "part") {
    if(individual_part == "front") {
        case_front();
    }
    if(individual_part == "back") {
        translate([width-2,0,back_height-.5]) rotate([0,180,0]) case_back();
    }
    if(individual_part == "frame") {
        translate([-25,-12,0]) back_frame();
    }
    if(individual_part == "sbc_cover") {
        translate([100,12,15]) rotate([0,180,0]) sbc_cover();
    }
    if(individual_part == "ups_cover") {
        translate([120,12,23]) rotate([0,180,0]) ups_cover();
    }
    if(individual_part == "ups_button") {
        translate([1,-1,1]) rotate([90,0,0]) button_plunger("recess", 5, 14.5);
        translate([10,0,3]) button_top("recess", 5, 14.5);
        translate([20,0]) button_clip("recess");
    }
    if(individual_part == "bracket_left") {
        translate([0,20,11]) rotate([0,270,0]) bracket("left");
    }
    if(individual_part == "bracket_right") {
        translate([0,30,0]) rotate([0,90,0]) bracket("right");
    }
}


module case_front() {
    
    union() {
        difference() {
            translate([(width/2),(depth/2),front_height/2]) 
                cube_fillet_inside([width,depth,front_height], 
                    vertical=[c_fillet,c_fillet,c_fillet,c_fillet], top=[0,0,0,0], 
                        bottom=[fillet,fillet,fillet,fillet,fillet], $fn=90);
            translate([(width/2),(depth/2),(front_height/2)+frontthick]) 
                cube_fillet_inside([width-(wallthick*2),depth-(wallthick*2),front_height], 
                    vertical=[c_fillet-1,c_fillet-1,c_fillet-1,c_fillet-1],top=[0,0,0,0],
                        bottom=[fillet,fillet,fillet,fillet,fillet], $fn=90);
            
            // lcd opening
            translate([gap+wallthick+.85+(lcd_size[0]-view_size[0])/2,
                gap+wallthick-.35+(lcd_size[1]-view_size[1])/2,-1]) 
                    slab([view_size[0],view_size[1],4],.5);
            
            // glass indent
            translate([gap+wallthick+3,gap+wallthick+10.5,.5]) slab([196.75, 132.5, 1.75],5.75);     

            // case top corner hole openings
            translate([gap+wallthick+4,gap+wallthick+5,-adj])  cylinder(d=6.7, h=4);
            translate([gap+wallthick+4+194,gap+wallthick+5,-adj]) cylinder(d=6.7, h=4);
            translate([gap+wallthick+4,143+gap+wallthick+5,-adj]) cylinder(d=6.7, h=4);
            translate([gap+wallthick+4+194,143+gap+wallthick+5,-adj]) cylinder(d=6.7, h=4);
        }
        // case top standoffs
        translate([gap+wallthick+4,gap+wallthick+5,0]) standoff(top_standoff);
        translate([gap+wallthick+4+194,gap+wallthick+5,0]) standoff(top_standoff);
        translate([gap+wallthick+4,143+gap+wallthick+5,0]) standoff(top_standoff);
        translate([gap+wallthick+4+194,143+gap+wallthick+5,0]) standoff(top_standoff);
    }
}


module case_back() {
    
    difference() {
        translate([(width/2),(depth/2),0]) 
            cube_fillet_inside([width-(wallthick+gap*2)-1,depth-(wallthick+gap*2)-1,floorthick], 
                vertical=[c_fillet-1,c_fillet-1,c_fillet-1,c_fillet-1], 
                    top=[0,0,0,0], bottom=[0,0,0,0], $fn=90);
        
        // fpc and component indent
        translate([gap-wallthick+60,gap-wallthick+50,back_height-3.435*floorthick-adj])
            rotate([0,0,90]) slab([90, 50, 4], 4);
        
        // hk oem case mount point
        translate([94,54.5,back_height-2*floorthick-adj]) cylinder(d=3, h=6);
        translate([94,112.5,back_height-2*floorthick-adj]) cylinder(d=3, h=6);
        
        // case bottom corner holes
        translate([gap+wallthick+4,gap+wallthick+5,back_height-2*floorthick-adj])  
            cylinder(d=4, h=7);
        translate([gap+wallthick+4+194,gap+wallthick+5,back_height-2*floorthick-adj]) 
            cylinder(d=4, h=7);
        translate([gap+wallthick+4,143+gap+wallthick+5,back_height-2*floorthick-adj]) 
            cylinder(d=4, h=7);
        translate([gap+wallthick+4+194,143+gap+wallthick+5,back_height-2*floorthick-adj]) 
            cylinder(d=4, h=7);
  
        // pillar openings
        translate([width-gap-wallthick-4,gap+wallthick+13.75,back_height-2*floorthick-adj]) 
            cylinder(d=7, h=4);
        translate([width-gap-wallthick-3.75,depth-gap-wallthick-14.75,back_height-2*floorthick-adj]) 
            cylinder(d=7, h=4);
        translate([gap+wallthick+90.75,depth-gap-wallthick-14.25,back_height-2*floorthick-adj]) 
            cylinder(d=7, h=4);
        translate([gap+wallthick+90.5,gap+wallthick+14,back_height-2*floorthick-adj])  
            cylinder(d=7, h=4);

        // fpc slot
        translate([60-gap-wallthick,depth-gap-wallthick-74,back_height-2*floorthick-adj]) 
            rotate([0,0,90]) slot(3.2, 18, 4);
        // vu8s indent   
        translate([gap+wallthick+8.25,gap+wallthick+19.25,-5.25+frontthick]) 
            slab([view_size[0]+11,view_size[1]+6.25,4],.5);
    }
    // bottom standoff
    translate([gap+wallthick+4,gap+wallthick+5,back_height-(2*floorthick)-.5])  
        standoff(bottom_standoff);
    translate([gap+wallthick+4+194,gap+wallthick+5,back_height-(2*floorthick)-.5]) 
        standoff(bottom_standoff);
    translate([gap+wallthick+4,143+gap+wallthick+5,back_height-(2*floorthick)-.5]) 
        standoff(bottom_standoff);
    translate([gap+wallthick+4+194,143+gap+wallthick+5,back_height-(2*floorthick)-.5]) 
        standoff(bottom_standoff);
}


module back_frame() {
     
    pillar_x = 155;
    pillar_y = 130;
    p_width = 8.5;
    p_thick = 4;
    b_color = "grey";
    
    adj = .01;
    $fn = 90;
    
    // accessory frame
    difference() {
        union() {
            // lower bar
            translate([width-gap-wallthick+4-pillar_x/2,gap+wallthick+13.75,p_thick/2]) color(b_color)
                cube_fillet_inside([pillar_x-8,p_width,p_thick], 
                    vertical=[c_fillet,c_fillet,c_fillet,c_fillet], top=[0,0,0,0], bottom=[0,0,0,0], $fn=90);
            // upper bar
            translate([5+width-gap-wallthick-pillar_x/2,gap+wallthick+138,p_thick/2]) color(b_color)
                cube_fillet_inside([pillar_x-10,p_width,p_thick], 
                    vertical=[c_fillet,c_fillet,c_fillet,c_fillet], top=[0,0,0,0], bottom=[0,0,0,0], $fn=90);
            // left sbc bar
            translate([71-gap-wallthick-p_width/2,10+gap+wallthick+pillar_y/2,p_thick/2]) color(b_color) 
                cube_fillet_inside([p_width,pillar_y,p_thick], 
                    vertical=[c_fillet,c_fillet,c_fillet,c_fillet], top=[0,0,0,0], bottom=[0,0,0,0], $fn=90);
            // right sbc bar
            translate([width-30-gap-wallthick-p_width/2,10+gap+wallthick+pillar_y/2,p_thick/2]) color(b_color) 
                cube_fillet_inside([p_width,pillar_y,p_thick], 
                    vertical=[c_fillet,c_fillet,c_fillet,c_fillet], top=[0,0,0,0], bottom=[0,0,0,0], $fn=90);
            if(sbc_model == "m1s") {
               // lower middle bar
                translate([width-gap-wallthick-10-pillar_x/2,gap+wallthick+52,p_thick/2]) color(b_color)
                    cube_fillet_inside([pillar_x-40,p_width,p_thick], 
                        vertical=[c_fillet,c_fillet,c_fillet,c_fillet], top=[0,0,0,0], bottom=[0,0,0,0], $fn=90);
                // upper middle bar
                translate([width-gap-wallthick-10-(pillar_x/2),gap+wallthick+109,p_thick/2]) color(b_color) 
                    cube_fillet_inside([pillar_x-41,p_width,p_thick], 
                        vertical=[c_fillet,c_fillet,c_fillet,c_fillet], top=[0,0,0,0], bottom=[0,0,0,0], $fn=90);
                // bottom sbc stub
                translate([146.25-gap-wallthick-p_width/2,38+gap+wallthick+pillar_y/2,p_thick/2]) color(b_color) 
                    cube_fillet_inside([p_width,10,p_thick], 
                        vertical=[c_fillet,c_fillet,c_fillet,c_fillet], top=[0,0,0,0], bottom=[0,0,0,0], $fn=90);
                translate([96-gap-wallthick-p_width/2,38.5+gap+wallthick+pillar_y/2,p_thick/2]) color(b_color) 
                    cube_fillet_inside([p_width,16,p_thick], 
                        vertical=[c_fillet,c_fillet,c_fillet,c_fillet], top=[0,0,0,0], bottom=[0,0,0,0], $fn=90);
                // ups left stubs
                translate([46.5-gap-wallthick-p_width/2,65.5+gap+wallthick+pillar_y/2,p_thick/2]) color(b_color) 
                    cube_fillet_inside([47,p_width,p_thick], 
                        vertical=[0,c_fillet,c_fillet,0], top=[0,0,0,0], bottom=[0,0,0,0], $fn=90);
                translate([46.5-gap-wallthick-p_width/2,-42+gap+wallthick+pillar_y/2,p_thick/2]) color(b_color) 
                    cube_fillet_inside([47,p_width,p_thick], 
                        vertical=[0,c_fillet,c_fillet,0], top=[0,0,0,0], bottom=[0,0,0,0], $fn=90);
                // ups cover stubs left mount
                translate([39.5-gap-wallthick-p_width/2,72.75+gap+wallthick+pillar_y/2,p_thick/2]) color(b_color) 
                    cube_fillet_inside([p_width,12,p_thick], 
                        vertical=[c_fillet,c_fillet,0,0], top=[0,0,0,0], bottom=[0,0,0,0], $fn=90);
                translate([39.5-gap-wallthick-p_width/2,-49.25+gap+wallthick+pillar_y/2,p_thick/2]) color(b_color) 
                    cube_fillet_inside([p_width,12,p_thick], 
                        vertical=[0,0,c_fillet,c_fillet], top=[0,0,0,0], bottom=[0,0,0,0], $fn=90);
                // ups cover stubs bottom mount
                translate([62.5-gap-wallthick-p_width/2,-39.75+gap+wallthick+pillar_y/2,p_thick/2]) color(b_color) 
                    cube_fillet_inside([12,p_width,p_thick], 
                        vertical=[0,c_fillet,c_fillet,0], top=[0,0,0,0], bottom=[0,0,0,0], $fn=90);
                translate([186.5-gap-wallthick-p_width/2,-39.75+gap+wallthick+pillar_y/2,p_thick/2]) color(b_color) 
                    cube_fillet_inside([12,p_width,p_thick], 
                        vertical=[c_fillet,0,0,c_fillet], top=[0,0,0,0], bottom=[0,0,0,0], $fn=90);
                // sbc standoff
                translate([139,105.5,back_height+1.5])  color(b_color) cylinder(d=7, h=3);
                translate([158.5,54.25,back_height+1.5])  color(b_color) cylinder(d=7, h=3);
                translate([75.5,54,back_height+1.5])  color(b_color) cylinder(d=7, h=3);
                translate([88.75,102.5,back_height+1.5])  color(b_color) cylinder(d=7, h=3);
            }
            if(sbc_model == "m2") {
                // upper middle bar
                translate([width-gap-wallthick-49.5-(pillar_x/2),gap+wallthick+109,p_thick/2]) color(b_color) 
                    cube_fillet_inside([30,p_width,p_thick], 
                        vertical=[c_fillet,c_fillet,c_fillet,c_fillet], top=[0,0,0,0], bottom=[0,0,0,0], $fn=90);
                translate([width-gap-wallthick+37-(pillar_x/2),gap+wallthick+104,p_thick/2]) color(b_color) 
                    cube_fillet_inside([20,p_width,p_thick], 
                        vertical=[c_fillet,c_fillet,c_fillet,c_fillet], top=[0,0,0,0], bottom=[0,0,0,0], $fn=90);
                // top sbc stub
                translate([165.75-gap-wallthick-p_width/2,36+gap+wallthick+pillar_y/2,p_thick/2]) color(b_color) 
                    cube_fillet_inside([p_width,14,p_thick], 
                        vertical=[c_fillet,c_fillet,c_fillet,c_fillet], top=[0,0,0,0], bottom=[0,0,0,0], $fn=90);
                translate([96-gap-wallthick-p_width/2,38.5+gap+wallthick+pillar_y/2,p_thick/2]) color(b_color) 
                    cube_fillet_inside([p_width,13,p_thick], 
                        vertical=[c_fillet,c_fillet,c_fillet,c_fillet], top=[0,0,0,0], bottom=[0,0,0,0], $fn=90);
                // bottom sbc stub
                translate([165.75-gap-wallthick-p_width/2,-43+gap+wallthick+pillar_y/2,p_thick/2]) color(b_color) 
                    cube_fillet_inside([p_width,16,p_thick], 
                        vertical=[c_fillet,c_fillet,c_fillet,c_fillet], top=[0,0,0,0], bottom=[0,0,0,0], $fn=90);
                translate([83-gap-wallthick-p_width/2,-43+gap+wallthick+pillar_y/2,p_thick/2]) color(b_color) 
                    cube_fillet_inside([p_width,16,p_thick], 
                        vertical=[c_fillet,c_fillet,c_fillet,c_fillet], top=[0,0,0,0], bottom=[0,0,0,0], $fn=90);
                // sbc standoff
                translate([158.5,101,back_height+1.5])  color(b_color) cylinder(d=7, h=3);
                translate([158.5,29,back_height+1.5])  color(b_color) cylinder(d=7, h=3);
                translate([75.5,29,back_height+1.5])  color(b_color) cylinder(d=7, h=3);
                translate([88.575,104,back_height+1.5])  color(b_color) cylinder(d=7, h=3);
            }
        }
        
        // bar trim
        translate([width-gap-wallthick-10+adj,gap+wallthick+8.75,-adj]) color(b_color) cube([10,10,2]);
        translate([width-gap-wallthick-10+adj,gap+wallthick+132.75,-adj]) color(b_color) cube([10,10,2]);
        translate([gap+wallthick+55+adj,gap+wallthick+75,9]) rotate([270,0,0]) color(b_color) cylinder(d=16, h=26);
        if(sbc_model == "m1s") {
            translate([gap+wallthick+101+adj,gap+wallthick+57,-adj]) rotate([0,0,0]) color(b_color) slot(12,43,4+(2*adj));
            translate([gap+wallthick+67+adj,gap+wallthick+90.5,-adj]) rotate([0,0,90]) color(b_color) slot(10,7,6);
            translate([gap+wallthick+26.5+adj,gap+wallthick+27.5,-adj]) rotate([0,0,0]) color(b_color) slot(10,6.5,6);
            translate([gap+wallthick+26.5+adj,gap+wallthick+125.5,-adj]) rotate([0,0,0]) color(b_color) slot(10,6.5,6);
            translate([gap+wallthick+163+adj,gap+wallthick+23,-adj]) rotate([0,0,90]) color(b_color) slot(10,6.5,6);
            translate([gap+wallthick+147+adj,gap+wallthick+112.5,-adj]) rotate([0,0,0]) color(b_color) slot(10,11.5,6);
            translate([gap+wallthick+70+adj,gap+wallthick+106,-adj]) rotate([0,0,0]) color(b_color) slot(10,6.5,6);
            translate([gap+wallthick+66+adj,gap+wallthick+23,-adj]) rotate([0,0,90]) color(b_color) slot(10,6.5,6);
        }
        translate([gap+wallthick+100+adj,gap+wallthick+104,-adj]) rotate([0,0,0]) color(b_color) slot(12,22,4+(2*adj));
        if(sbc_model == "m2") {
            translate([gap+wallthick+163+adj,gap+wallthick+33.5,-adj]) rotate([0,0,90]) color(b_color) slot(10,6.5,6);
//            #translate([gap+wallthick+143+adj,gap+wallthick+112.5,-adj]) rotate([0,0,0]) color(b_color) slot(10,11.5,6);
        }
        
        // lower bar holes
        translate([width-gap-wallthick-4,gap+wallthick+13.75,-6]) color(b_color) cylinder(d=3, h=13);
        translate([width-gap-wallthick-4,gap+wallthick+13.75,2]) color(b_color) cylinder(d1=3.2, d2=6.7, h=3);
        translate([gap+wallthick+90.5,gap+wallthick+14,-6]) color(b_color) cylinder(d=3, h=13);
        translate([gap+wallthick+90.5,gap+wallthick+14,2]) color(b_color) cylinder(d1=3.2, d2=6.7, h=3);
        
        // upper bar holes
        translate([width-gap-wallthick-3.75,gap+wallthick+138.25,-6]) color(b_color) cylinder(d=3, h=13);
        translate([width-gap-wallthick-3.75,gap+wallthick+138.25,2]) color(b_color) cylinder(d1=3.2, d2=6.7, h=3);
        translate([gap+wallthick+90.75,gap+wallthick+138.75,-6]) color(b_color) cylinder(d=3, h=13);
        translate([gap+wallthick+90.75,gap+wallthick+138.75,2]) color(b_color) cylinder(d1=3.2, d2=6.7, h=3);
        
        // hk case inserts
        translate([64,54.5,back_height-2*floorthick-adj]) color(b_color) cylinder(d=insert_dia, h=6);
        translate([64,112.5,back_height-2*floorthick-adj]) color(b_color) cylinder(d=insert_dia, h=6);
        translate([171,54.5,back_height-2*floorthick-adj]) color(b_color) cylinder(d=insert_dia, h=6);
        translate([171,112.5,back_height-2*floorthick-adj]) color(b_color) cylinder(d=insert_dia, h=6);
        if(sbc_model == "m1s") {
            // ups inserts bottom mount
            translate([63.5,16,back_height-2*floorthick-adj]) color(b_color) cylinder(d=insert_dia, h=6);
            translate([63.5,41,back_height-2*floorthick-adj]) color(b_color) cylinder(d=insert_dia, h=6);
            translate([171.5,16,back_height-2*floorthick-adj]) color(b_color) cylinder(d=insert_dia, h=6);
            translate([171.5,41,back_height-2*floorthick-adj]) color(b_color) cylinder(d=insert_dia, h=6);
            
            // ups inserts left mount
            translate([gap+wallthick+42,gap+wallthick+130.75,-6]) color(b_color) cylinder(d=insert_dia, h=13);
            translate([gap+wallthick+17,gap+wallthick+130.75,-6]) color(b_color) cylinder(d=insert_dia, h=13);
            translate([gap+wallthick+17,gap+wallthick+22.75,-6]) color(b_color) cylinder(d=insert_dia, h=13);
            translate([gap+wallthick+42,gap+wallthick+22.75,-6]) color(b_color) cylinder(d=insert_dia, h=13);

            // ups cover inserts left mount
            translate([39.5-gap-wallthick-p_width/2,75+gap+wallthick+pillar_y/2,-6]) color(b_color) 
                cylinder(d=insert_dia, h=13);
            translate([39.5-gap-wallthick-p_width/2,-51.75+gap+wallthick+pillar_y/2,-6]) color(b_color) 
                cylinder(d=insert_dia, h=13);
                
            // ups cover inserts bottom mount
            translate([61.5-gap-wallthick-p_width/2,-39.75+gap+wallthick+pillar_y/2,-6]) color(b_color) 
                cylinder(d=insert_dia, h=13);
            translate([188.25-gap-wallthick-p_width/2,-39.75+gap+wallthick+pillar_y/2,-6]) color(b_color) 
                cylinder(d=insert_dia, h=13);
        }
        // bare sbc mount inserts
        if(sbc_model == "m1s") {
            translate([75.5,54,back_height-2*floorthick-adj]) color(b_color) cylinder(d=insert_dia, h=9);
            translate([88.75,102.5,back_height-2*floorthick-adj]) color(b_color) cylinder(d=insert_dia, h=9);
            translate([139,105.5,back_height-2*floorthick-adj]) color(b_color) cylinder(d=insert_dia, h=9);
            translate([158.5,54.25,back_height-2*floorthick-adj]) color(b_color) cylinder(d=insert_dia, h=9);
        }
        if(sbc_model == "m2") {
            translate([158.5,101,back_height-2*floorthick-adj]) color(b_color) cylinder(d=insert_dia, h=9);
            translate([158.5,29,back_height-2*floorthick-adj]) color(b_color) cylinder(d=insert_dia, h=9);
            translate([75.5,29,back_height-2*floorthick-adj]) color(b_color) cylinder(d=insert_dia, h=9);
            translate([88.575,104,back_height-2*floorthick-adj]) color(b_color) cylinder(d=insert_dia, h=9);
        }
    }
    if(view == "model") {
        // hk case inserts
        translate([64,54.5,back_height-1.4]) m_insert();
        translate([64,112.5,back_height-1.4]) m_insert();
        translate([171,54.5,back_height-1.4]) m_insert();
        translate([171,112.5,back_height-1.4]) m_insert();
        if(sbc_model == "m1s") {
            // ups inserts bottom mount
            translate([63.5,16,back_height-1.4]) m_insert();
            translate([63.5,41,back_height-1.4]) m_insert();
            translate([171.5,16,back_height-1.4]) m_insert();
            translate([171.5,41,back_height-1.4]) m_insert();
            
            // ups inserts left mount
            translate([gap+wallthick+42,gap+wallthick+130.75,back_height-1.4]) m_insert();
            translate([gap+wallthick+17,gap+wallthick+130.75,back_height-1.4]) m_insert();
            translate([gap+wallthick+17,gap+wallthick+22.75,back_height-1.4]) m_insert();
            translate([gap+wallthick+42,gap+wallthick+22.75,back_height-1.4]) m_insert();

            // ups cover inserts left mount
            translate([35.25-gap-wallthick,13.25+gap+wallthick,back_height-1.4]) m_insert();
            translate([35.25-gap-wallthick,140+gap+wallthick,back_height-1.4]) m_insert();
            // ups cover inserts bottom mount
            translate([57.25-gap-wallthick,25.25+gap+wallthick,back_height-1.4]) m_insert();
            translate([184-gap-wallthick,25.25+gap+wallthick,back_height-1.4]) m_insert();
        }
        // bare sbc mount inserts
        if(sbc_model == "m1s") {
            translate([75.5,54,back_height+.6]) m_insert();
            translate([88.75,102.5,back_height+.6]) m_insert();
            translate([139,105.5,back_height+.6]) m_insert();
            translate([158.5,54.25,back_height+.6]) m_insert();
        }
        if(sbc_model == "m2") {
            translate([158.5,101,back_height+.6]) m_insert();
            translate([158.5,29,back_height+.6]) m_insert();
            translate([75.5,29,back_height+.6]) m_insert();
            translate([88.575,104,back_height+.6]) m_insert();
        }
    }
}


module sbc_cover() {
    
    sbc_size = sbc_model == "m2" ? [90,90,17] : [90,65,15];
    gap = 2.5;
    width = sbc_size[0]+(2*gap+wallthick);
    depth = sbc_size[1]+(2*gap+wallthick);
    height = sbc_size[2];
    p_thick = 4;
    b_color = "grey";

    difference() {
        union() {
            difference() {
                union() {
                translate([(width/2),(depth/2),height/2]) color(b_color)
                    cube_fillet_inside([width,depth,height], 
                        vertical=[c_fillet,c_fillet,c_fillet,c_fillet], top=[0,0,0,0], 
                            bottom=[fillet,fillet,fillet,fillet,fillet], $fn=90);
                translate([-3.99,7.5+cover_offset,1.5]) color(b_color)
                    cube_fillet_inside([10,8.5,3], 
                        vertical=[0,c_fillet,c_fillet,0], top=[0,0,0,0], bottom=[0,0,0,0], $fn=90);
                translate([-3.99,65.5+cover_offset,1.5]) color(b_color)
                    cube_fillet_inside([10,8.5,3], 
                        vertical=[0,c_fillet,c_fillet,0], top=[0,0,0,0], bottom=[0,0,0,0], $fn=90);
                translate([100.99,7.5+cover_offset,1.5]) color(b_color)
                    cube_fillet_inside([10,8.5,3], 
                        vertical=[c_fillet,0,0,c_fillet], top=[0,0,0,0], bottom=[0,0,0,0], $fn=90);
                translate([100.99,65.5+cover_offset,1.5]) color(b_color)
                    cube_fillet_inside([10,8.5,3], 
                        vertical=[c_fillet,0,0,c_fillet], top=[0,0,0,0], bottom=[0,0,0,0], $fn=90);
                    
                }
                translate([(width/2),(depth/2),(height/2)-1.5]) color(b_color)
                    cube_fillet_inside([width-(wallthick*2),depth-(wallthick*2),height], 
                        vertical=[c_fillet-1,c_fillet-1,c_fillet-1,c_fillet-1],top=[0,0,0,0],
                            bottom=[fillet,fillet,fillet,fillet,fillet], $fn=90);
                
                // top cover openings
                if(sbc_model == "m2" && top_cover_pattern != "solid") {
                    if(top_cover_pattern == "hex_5mm") {
                        translate([10,12+cover_offset-20,height-floorthick]) color(b_color)
                            vent_hex(23,13,floorthick+4,5,1.5,"horizontal");
                    }
                    if(top_cover_pattern == "hex_8mm") {
                        translate([5,12+cover_offset-20,height-floorthick]) color(b_color)
                            vent_hex(18,8,floorthick+4,8,1.5,"horizontal");
                    }
                    if(top_cover_pattern == "linear_vertical") {
                        translate([10,12+cover_offset-20,height-floorthick]) color(b_color)
                            vent(wallthick,75,floorthick+4,1,1,19,"horizontal");
                    }
                    if(top_cover_pattern == "linear_horizontal") {
                        translate([10,12+cover_offset-20,height-floorthick]) color(b_color)
                            vent(73,wallthick,floorthick+4,1,23,1,"horizontal");
                    }
                }
                if(sbc_model == "m1s" && top_cover_pattern != "solid") {
                    if(top_cover_pattern == "hex_5mm") {
                        translate([10,cover_offset+12,height-floorthick]) color(b_color)
                            vent_hex(23,9,floorthick+4,5,1.5,"horizontal");
                    }
                    if(top_cover_pattern == "hex_8mm") {
                        translate([5,cover_offset+15,height-floorthick]) color(b_color)
                            vent_hex(18,6,floorthick+4,8,1.5,"horizontal");
                    }
                    if(top_cover_pattern == "linear_vertical") {
                        translate([10,15+cover_offset,height-floorthick]) color(b_color)
                            vent(wallthick,50,floorthick+4,1,1,20,"horizontal");
                    }
                    if(top_cover_pattern == "linear_horizontal") {
                        translate([10,cover_offset+15,height-floorthick]) color(b_color)
                            vent(78,wallthick,floorthick+4,1,16,1,"horizontal");
                    }
                }
                // case mount holes
                translate([-5,7.5+cover_offset,-adj]) color(b_color) cylinder(d=3.2, h=4);
                translate([-5,65.5+cover_offset,-adj]) color(b_color) cylinder(d=3.2, h=4);
                translate([102,7.5+cover_offset,-adj]) color(b_color) cylinder(d=3.2, h=4);
                translate([102,65.5+cover_offset,-adj]) color(b_color) cylinder(d=3.2, h=4);

                // uart opening
                if(sbc_model == "m1s") {
                    translate([-4,45,-1]) color(b_color) cube([7,12,4]);
                }
                if(sbc_model == "m2") {
                    translate([78,33,14.5]) color(b_color) slab_r([12,8,3], [2,2,2,2]);
                }
            }
            if(cooling == "default" || cooling == "fan_open" || cooling == "fan_1" || cooling == "fan_2" ||cooling == "fan_hex") {
                fansize = fan_size == 0 ? 40 : fan_size;
                translate([17-(fansize-40)/2,33-(fansize-40)/2,15.5]) color(b_color) 
                    slab([fansize+2,fansize,floorthick],2);
            }
            // m2 power button
            if(sbc_model == "m2") {
                translate([87,37,15.5]) color(b_color) button("cutout", [12,8,1.5], [2,2,2,2], .1);
            }
        }
        // sbc openings
        translate([93.5,67.75+cover_offset,floorthick+.5]) color(b_color) rotate([0,0,180]) sbc(sbc_model, cooling, fan_size, gpio_opening, "open", true);
    }
}


module ups_cover() {
    
    sbc_size = [115,32,23];
    wallthick = 1.5;
    gap = 2;
    width = sbc_size[0]+(2*gap+wallthick);
    depth = sbc_size[1]+(2*gap+wallthick);
    height = sbc_size[2];
    p_thick = 4;
    b_color = "grey";
    
    union() {
        difference() {
            union() {
            translate([(width/2),(depth/2),height/2]) color(b_color)
                cube_fillet_inside([width,depth,height], 
                    vertical=[c_fillet,c_fillet,c_fillet,c_fillet], top=[0,0,0,0], 
                        bottom=[fillet,fillet,fillet,fillet,fillet], $fn=90);
            translate([-2.5,(depth/2),1.5]) color(b_color)
                cube_fillet_inside([8.5,8.5,3], 
                    vertical=[0,c_fillet,c_fillet,0], top=[0,0,0,0], bottom=[0,0,0,0], $fn=90);
            translate([123.25,(depth/2),1.5]) color(b_color)
                cube_fillet_inside([8.5,8.5,3], 
                    vertical=[c_fillet,0,0,c_fillet], top=[0,0,0,0], bottom=[0,0,0,0], $fn=90);
            }
            translate([(width/2),(depth/2),(height/2)-1.5]) color(b_color)
                cube_fillet_inside([width-(wallthick*2),depth-(wallthick*2),height], 
                    vertical=[c_fillet-1,c_fillet-1,c_fillet-1,c_fillet-1],top=[0,0,0,0],
                        bottom=[fillet,fillet,fillet,fillet,fillet], $fn=90);
            
            // vent openings
            translate([6,5,height-floorthick]) color(b_color) vent_hex(33, 5, 4, 5, 1.5, "landscape");

            // case hole openings
            translate([-3,(depth/2),-adj]) color(b_color) cylinder(d=3.2, h=4);
            translate([123.75,(depth/2),-adj]) color(b_color) cylinder(d=3.2, h=4);
            
            // header opening
            translate([78,28,0]) color(b_color) cube([23,12,28]);
            
            // led lighting
            if(ups_led_down_light == true && orientation == "landscape") {
                translate([18,-1,-adj]) color(b_color) cube([50,6,3.6]);
            }
            if(ups_led_down_light == true && orientation == "portrait") {
                translate([23,-1,-adj]) color(b_color) cube([73,6,3.6]);
            }
        // usbc opening
        translate([101.75,3,3.75]) rotate([90,0,0]) color(b_color) slot(4.5,6,6);
            
        //button opening
        translate([92.25,6,18]) color(b_color) cylinder(d=11,h=6);    
        }
        
        // header opening support
        translate([77.25,27.5,height-floorthick]) color(b_color)
            difference() {
                cube([25,10,floorthick]);
                translate([1,1,-1]) cube([23,13,floorthick+2]);
        }
        // power button
        translate([92,6,23]) color(b_color) button("recess", [12,5,15], 1,1);
        if(view == "model") {
            translate([92,6,23]) button_assembly("recess",12,14.5);
        }
    }
}



module bracket(side) {

    b_color = "grey";
    
    // left bracket
    if(orientation == "landscape") {
        difference() {
            union() {
                if(side == "left") {
                    translate([-5.5,(depth/2)-13.5-(view_height-18)/2,2]) color(b_color) 
                        cube_fillet_inside([12,depth+view_height,4], 
                            vertical=[0,c_fillet,0,0], top=[0,0,0,0], bottom=[0,0,0,0], $fn=90);
                    if(vu8s_mount != "thruhole") {
                        translate([-4.5,3.5,4-adj]) color(b_color) cylinder(d1=10, d2=8, h=3);
                        translate([-4.5,146.5,4-adj]) color(b_color) cylinder(d1=10, d2=8, h=3);
                    }
                }
                else {
                    translate([-5.5,(depth/2)-13.5-(view_height-18)/2,2]) color(b_color) 
                        cube_fillet_inside([12,depth+view_height,4], 
                            vertical=[c_fillet,0,0,0], top=[0,0,0,0], bottom=[0,0,0,0], $fn=90);
                    if(vu8s_mount != "thruhole") {
                        translate([-6.5,3.5,4-adj]) color(b_color) cylinder(d1=10, d2=8, h=3);
                        translate([-6.5,146.5,4-adj]) color(b_color) cylinder(d1=10, d2=8, h=3);
                    }
                }
                translate([-5.5,-6.25-(view_height-18),42]) rotate([90-view_angle,0,0]) color(b_color)
                    cube_fillet_inside([12,100,4], 
                        vertical=[0,0,0,0], top=[0,0,0,0], 
                            bottom=[8,0,8,0], $fn=90);
                difference() {
                    translate([-11.5,-15,10]) rotate([0,90,0]) color(b_color) cylinder(d=76, h=12, $fn=360);
                    translate([-14,-15,10]) rotate([0,90,0]) color(b_color) cylinder(d=70, h=12+3, $fn=360);
                }
            }
            // trim
            translate([-12,0,-48]) color(b_color) cube([14,38,48]);
            translate([-12,-65,-54.5]) color(b_color) cube([14,70,46]);
            translate([-30,-94-(view_height-18)-(1.4*(view_angle-15)),-10]) 
                rotate([-view_angle,0,0]) color(b_color) cube([50,70,140]);
            
            // corner case holes
            if(side == "left") {
                if(vu8s_mount == "thruhole") {
                    translate([-4.5,3.5,-adj]) color(b_color) cylinder(d=3.2, h=12);
                    translate([-4.5,146.5,-adj]) color(b_color) cylinder(d=3.2, h=12);
                }
                if(vu8s_mount == "insert") {
                    translate([-4.5,3.5,-adj]) color(b_color) cylinder(d=3.2, h=12);
                    translate([-4.5,146.5,-adj]) color(b_color) cylinder(d=3.2, h=12);
                    translate([-4.5,3.5,2]) color(b_color) cylinder(d=insert_dia, h=12);
                    translate([-4.5,146.5,2]) color(b_color) cylinder(d=insert_dia, h=12);
                }
                if(vu8s_mount == "recessed") {
                    translate([-4.5,3.5,-adj]) color(b_color) cylinder(d=3.2, h=12);
                    translate([-4.5,146.5,-adj]) color(b_color) cylinder(d=3.2, h=12);
                    translate([-4.5,3.5,2]) color(b_color) cylinder(d=6, h=12);
                    translate([-4.5,146.5,2]) color(b_color) cylinder(d=6, h=12);
                }
                if(vu8s_mount == "nut") {
                    translate([-4.5,3.5,-adj]) color(b_color) cylinder(d=3.2, h=12);
                    translate([-4.5,146.5,-adj]) color(b_color) cylinder(d=3.2, h=12);
                    translate([-4.5,3.5,2]) color(b_color) cylinder(r=3.3, h=6.1, $fn=6);
                    translate([-4.5,146.5,2]) color(b_color) cylinder(r=3.3, h=6.1, $fn=6);
                }            }
            if(side == "right") {
                if(vu8s_mount == "thruhole") {
                    translate([-6.5,3.5,-adj]) color(b_color) cylinder(d=3.2, h=12);
                    translate([-6.5,146.5,-adj]) color(b_color) cylinder(d=3.2, h=12);
                }
                if(vu8s_mount == "insert") {
                    translate([-6.5,3.5,-adj]) color(b_color) cylinder(d=3.2, h=12);
                    translate([-6.5,146.5,-adj]) color(b_color) cylinder(d=3.2, h=12);
                    translate([-6.5,3.5,2]) color(b_color) cylinder(d=insert_dia, h=12);
                    translate([-6.5,146.5,2]) color(b_color) cylinder(d=insert_dia, h=12);
                }
                if(vu8s_mount == "recessed") {
                    translate([-6.5,3.5,-adj]) color(b_color) cylinder(d=3.2, h=6);
                    translate([-6.5,146.5,-adj]) color(b_color) cylinder(d=3.2, h=6);
                    translate([-6.5,3.5,2]) color(b_color) cylinder(d=6, h=12);
                    translate([-6.5,146.5,2]) color(b_color) cylinder(d=6, h=12);
                }
                if(vu8s_mount == "nut") {
                    translate([-6.5,3.5,-adj]) color(b_color) cylinder(d=3.2, h=12);
                    translate([-6.5,146.5,-adj]) color(b_color) cylinder(d=3.2, h=12);
                    translate([-6.5,3.5,2]) color(b_color) cylinder(r=3.3, h=6.1, $fn=6);
                    translate([-6.5,146.5,2]) color(b_color) cylinder(r=3.3, h=6.1, $fn=6);
                }
                // hk sbc case mount holes
                if(sbc_mount == "recessed") {
                    translate([-6.5,108,-adj]) color(b_color) cylinder(d=3.2, h=14);
                    translate([-6.5,108,1.25]) color(b_color) cylinder(d=9.2, h=14);
                    translate([-16.75,108,1.25]) color(b_color) slot(9.2, 10, 14);
                    translate([-6.5,50,-adj]) color(b_color) cylinder(d=3.2, h=14);
                    translate([-6.5,50,1.25]) color(b_color) cylinder(d=9.2, h=14);
                    translate([-16.75,50,1.25]) color(b_color) slot(9.2, 10, 14);
                }
                if(sbc_mount == "insert") {
                    translate([-6.5,108,-adj]) color(b_color) cylinder(d=insert_dia, h=14);
                    translate([-6.5,50,-adj]) color(b_color) cylinder(d=insert_dia, h=14);
                }

                // right pillar mount holes
                if(right_pillar_mount == "recessed") {
                    translate([-6.5,12.25,-adj]) color(b_color) cylinder(d=3.2, h=14);
                    translate([-6.5,12.25,2]) color(b_color) cylinder(d=9.2, h=14);
                    translate([-16.75,12.25,2]) color(b_color) slot(9.2, 10, 14);
                    translate([-6.25,136.5,-adj]) color(b_color) cylinder(d=3.2, h=14);
                    translate([-6.25,136.5,2]) color(b_color) cylinder(d=9.2, h=14);
                    translate([-16.5,136.5,2]) color(b_color) slot(9.2, 10, 14);
                }
                if(right_pillar_mount == "thruhole") {
                    translate([-6.5,12,-adj]) color(b_color) cylinder(d=3.2, h=14);
                    translate([-6.5,136,-adj]) color(b_color) cylinder(d=3.2, h=14);
                }
            }
        }
        if(view == "model") {
            if(side == "left") {
                if(vu8s_mount == "insert") {
                    translate([-4.5,3.5,3]) m_insert();
                    translate([-4.5,146.5,3]) m_insert();
                }
            }
            if(side == "right") {
                if(vu8s_mount == "insert") {
                    translate([-6.5,3.5,3]) m_insert();
                    translate([-6.5,146.5,3]) m_insert();
                }
                if(sbc_mount == "insert") {
                    translate([-6.5,108,adj]) m_insert();
                    translate([-6.5,50,adj]) m_insert();
                }
            }
        }
    } 
    // portrait bracket
    if(orientation == "portrait") {
        difference() {
            union() {
                if(side == "left") {
                    translate([-5.5,(depth/2)+11-(view_height-18)/2,2]) color(b_color) 
                        cube_fillet_inside([12,width+view_height,4], 
                            vertical=[0,c_fillet,0,0], top=[0,0,0,0], bottom=[0,0,0,0], $fn=90);
                    if(vu8s_mount != "thruhole") {
                        translate([-3.5,2.5,4-adj]) color(b_color) cylinder(d1=9, d2=8, h=3);
                        translate([-3.5,196.5,4-adj]) color(b_color) cylinder(d1=9, d2=8, h=3);
                    }
                }
                else {
                    translate([-5.5,(depth/2)+11-(view_height-18)/2,2]) color(b_color) 
                        cube_fillet_inside([12,width+view_height+4,4], 
                            vertical=[c_fillet,0,0,0], top=[0,0,0,0], bottom=[0,0,0,0], $fn=90);
                    if(vu8s_mount != "thruhole") {
                        translate([-7.5,4.5,4-adj]) color(b_color) cylinder(d1=9, d2=8, h=3);
                        translate([-7.5,198.5,4-adj]) color(b_color) cylinder(d1=9, d2=8, h=3);
                    }
                }
                translate([-5.5,-6.25-(view_height-18),42]) rotate([90-view_angle,0,0]) color(b_color)
                    cube_fillet_inside([12,100,4], 
                        vertical=[0,0,0,0], top=[0,0,0,0], 
                            bottom=[8,0,8,0], $fn=90);
                difference() {
                    translate([-11.5,-15,10]) rotate([0,90,0]) color(b_color) cylinder(d=100, h=12, $fn=360);
                    translate([-14,-15,10]) rotate([0,90,0]) color(b_color) cylinder(d=94, h=12+3, $fn=360);
                }
            }
            // trim
            translate([-12,0,-48]) color(b_color) cube([14,38,48]);
            translate([-12,-65,-54.5]) color(b_color) cube([14,70,46]);
            translate([-30,-94-(view_height-18)-(1.4*(view_angle-15)),-10]) rotate([-view_angle,0,0]) 
              color(b_color) cube([50,70,140]);
            
            // corner case holes
            if(side == "left") {
                if(vu8s_mount == "thruhole") {
                    translate([-3.5,2.5,-6-adj]) color(b_color) cylinder(d=3.2, h=12);
                    translate([-3.5,196.5,-adj]) color(b_color) cylinder(d=3.2, h=12);
                }
                if(vu8s_mount == "insert") {
                    translate([-3.5,2.5,-adj]) color(b_color) cylinder(d=3.2, h=12);
                    translate([-3.5,196.5,-adj]) color(b_color) cylinder(d=3.2, h=12);
                    translate([-3.5,2.5,2]) color(b_color) cylinder(d=insert_dia, h=12);
                    translate([-3.5,196.5,2]) color(b_color) cylinder(d=insert_dia, h=12);
                }
                if(vu8s_mount == "recessed") {
                    translate([-3.5,2.5,-adj]) color(b_color) cylinder(d=3.2, h=12);
                    translate([-3.5,196.5,-adj]) color(b_color) cylinder(d=3.2, h=12);
                    translate([-3.5,2.5,2]) color(b_color) cylinder(d=6, h=12);
                    translate([-3.5,196.5,2]) color(b_color) cylinder(d=6, h=12);
                }
                if(vu8s_mount == "nut") {
                    translate([-3.5,2.5,-adj]) color(b_color) cylinder(d=3.2, h=12);
                    translate([-3.5,196.5,-adj]) color(b_color) cylinder(d=3.2, h=12);
                    translate([-3.5,2.5,2]) color(b_color) cylinder(r=3.3, h=6.1, $fn=6);
                    translate([-3.5,196.5,2]) color(b_color) cylinder(r=3.3, h=6.1, $fn=6);
                }
            }
            if(side == "right") {
                if(vu8s_mount == "thruhole") {
                    translate([-7.5,4.5,-6-adj]) color(b_color) cylinder(d=3.2, h=12);
                    translate([-7.5,198.5,-adj]) color(b_color) cylinder(d=3.2, h=12);
               }
                if(vu8s_mount == "insert") {
                    translate([-7.5,4.5,-adj]) color(b_color) cylinder(d=3.2, h=12);
                    translate([-7.5,198.5,-adj]) color(b_color) cylinder(d=3.2, h=12);
                    translate([-7.5,4.5,2]) color(b_color) cylinder(d=insert_dia, h=12);
                    translate([-7.5,198.5,2]) color(b_color) cylinder(d=insert_dia, h=12);
                }
                if(vu8s_mount == "recessed") {
                    translate([-7.5,4.5,-adj]) color(b_color) cylinder(d=3.2, h=6);
                    translate([-7.5,198.5,-adj]) color(b_color) cylinder(d=3.2, h=6);
                    translate([-7.5,4.5,2]) color(b_color) cylinder(d=6, h=12);
                    translate([-7.5,198.5,2]) color(b_color) cylinder(d=6, h=12);
                }
                if(vu8s_mount == "nut") {
                    translate([-7.5,4.5,-adj]) color(b_color) cylinder(d=3.2, h=12);
                    translate([-7.5,198.5,-adj]) color(b_color) cylinder(d=3.2, h=12);
                    translate([-7.5,4.5,2]) color(b_color) cylinder(r=3.3, h=6.1, $fn=6);
                    translate([-7.5,198.5,2]) color(b_color) cylinder(r=3.3, h=6.1, $fn=6);
                }

            }
        
        }
        if(view == "model") {
            if(side == "left") {
                if(vu8s_mount == "insert") {
                    translate([-3.5,2.5,3]) m_insert();
                    translate([-3.5,196.5,3]) m_insert();
                }
            }
            if(side == "right") {
                if(vu8s_mount == "insert") {
                    translate([-7.5,4.5,3]) m_insert();
                    translate([-7.5,198.5,3]) m_insert();
                }
            }
        }
    }
}