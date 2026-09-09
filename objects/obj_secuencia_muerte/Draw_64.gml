draw_set_color(c_white);draw_set_alpha(1);
if(surface_exists(application_surface)) {
    if(shader_is_compiled(shd_muerte_gris)) shader_set(shd_muerte_gris);
    draw_surface_stretched(application_surface,0,0,720,1280);
    shader_reset();
}
if(elapsed>=1.5) {
    var _top=clamp((elapsed-1.5)/1,0,1);
    var _bottom=clamp((elapsed-2)/1,0,1);
    // Dos polígonos con una junta diagonal común: y=560+x/6.
    var _tx=lerp(-260,0,_top),_ty=lerp(-1500,0,_top);
    draw_set_color(make_color_rgb(18,18,18));
    draw_primitive_begin(pr_trianglefan);
    draw_vertex(-400+_tx,-500+_ty);draw_vertex(1120+_tx,-500+_ty);
    draw_vertex(1120+_tx,560+1120/6+_ty);draw_vertex(-400+_tx,560-400/6+_ty);
    draw_primitive_end();
    if(lower_started) {
        var _bx=lerp(260,0,_bottom),_by=lerp(1500,0,_bottom);
        draw_set_color(make_color_rgb(32,32,32));
        draw_primitive_begin(pr_trianglefan);
        draw_vertex(-400+_bx,560-400/6+_by);draw_vertex(1120+_bx,560+1120/6+_by);
        draw_vertex(1120+_bx,1800+_by);draw_vertex(-400+_bx,1800+_by);
        draw_primitive_end();
    }
}
if(closed) {
    draw_set_color(c_white);draw_set_halign(fa_center);draw_set_valign(fa_top);
    draw_text(360,400,"Nave destruida");draw_set_halign(fa_left);
    flux_button(button_x[0],550,400,80,"Continuar/Reintentar",true);
    if(elapsed>=3.15) flux_button(button_x[1],660,400,80,"Arbol de Mejoras",true);
}
draw_set_alpha(1);draw_set_color(c_white);
