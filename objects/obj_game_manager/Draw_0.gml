if(!ship_sprites_ready) {
    var _surface=surface_create(64,64);
    if(surface_exists(_surface)) {
        surface_set_target(_surface);
        var _matrix=matrix_get(matrix_world);
        matrix_set(matrix_world,matrix_build_identity());
        draw_set_alpha(1);draw_set_color(c_white);
        for(var _i=0;_i<6;++_i) {
            draw_clear_alpha(c_black,0);flux_ship_shape(32,32,_i-1,0,1);
            ship_sprites[_i]=sprite_create_from_surface(_surface,0,0,64,64,false,false,32,32);
        }
        matrix_set(matrix_world,_matrix);surface_reset_target();surface_free(_surface);
        ship_sprites_ready=true;
    }
}
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
