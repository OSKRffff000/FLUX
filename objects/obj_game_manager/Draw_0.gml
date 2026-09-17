draw_clear(c_black);
draw_set_color(c_dkgray);
for (var _i=0; _i<85; ++_i) {
    var _sx=(_i*137+29) mod 720, _sy=(_i*241+17) mod 1280;
    draw_circle(_sx,_sy,1+(_i mod 2),false);
}
if (state == "playing" || state == "dead" || state == "dying") {
    draw_set_color(c_dkgray);
    draw_circle(center_x,center_y,orbit_radius,true);
}
