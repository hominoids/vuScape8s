/*
    This file is part of SBC Model Framework https://github.com/hominoids/SBC_Model_Framework
    Copyright 2016,2017,2018,2019,2020,2021,2022 Edward A. Kisiel hominoid@cablemi.com

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


*/

// single row pcb pad
module pcb_pad(pads, style) {

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