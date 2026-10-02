if(gm.state!="playing" && gm.state!="paused") exit;
var _font=draw_get_font(),_colour=draw_get_color(),_alpha=draw_get_alpha();
var _ha=draw_get_halign(),_va=draw_get_valign();
draw_set_alpha(1);draw_set_color(c_white);
if(gm.state=="playing") {
    draw_set_color(c_black);draw_rectangle(gui_x,gui_y,gui_x+button_width,gui_y+button_height,false);
    draw_set_color(c_white);draw_rectangle(gui_x,gui_y,gui_x+button_width,gui_y+button_height,true);
    draw_rectangle(gui_x+21,gui_y+17,gui_x+28,gui_y+47,false);
    draw_rectangle(gui_x+40,gui_y+17,gui_x+47,gui_y+47,false);
} else {
    var _w=display_get_gui_width(),_h=display_get_gui_height();
    if(sprite_exists(gm.pause_snapshot)) {
        draw_sprite_stretched(gm.pause_snapshot,0,0,0,_w,_h);
    } else { draw_set_color(c_black);draw_rectangle(0,0,_w,_h,false); }
    draw_set_color(c_black);draw_set_alpha(0.8);draw_rectangle(0,0,_w,_h,false);
    draw_set_alpha(1);draw_set_color(c_white);draw_set_font(fnt_gridlite);
    draw_set_halign(fa_center);draw_set_valign(fa_middle);draw_text(360,350,"Pausa");
    flux_button(110,470,500,90,"Continuar / Reanudar",true);
    flux_button(110,600,500,90,"Árbol de Mejoras",true);
    flux_button(110,730,500,90,"Menú Principal",true);
}
draw_set_font(_font);draw_set_color(_colour);draw_set_alpha(_alpha);
draw_set_halign(_ha);draw_set_valign(_va);
