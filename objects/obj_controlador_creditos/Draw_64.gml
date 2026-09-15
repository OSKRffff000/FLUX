if(gm.state!="credits") exit;
var _font=draw_get_font(),_colour=draw_get_color(),_alpha=draw_get_alpha();
var _halign=draw_get_halign(),_valign=draw_get_valign();
draw_set_alpha(1);draw_set_color(make_color_rgb(53,56,62));
var _width=display_get_gui_width(),_height=display_get_gui_height();
draw_rectangle(0,0,_width,_height,false);
var _scale=min(320/sprite_get_width(sprite_index),350/sprite_get_height(sprite_index));
var _sx=_width*0.5+(sprite_get_xoffset(sprite_index)-sprite_get_width(sprite_index)*0.5)*_scale;
var _sy=_height*0.805+(sprite_get_yoffset(sprite_index)-sprite_get_height(sprite_index)*0.5)*_scale;
draw_sprite_ext(sprite_index,image_index,_sx,_sy,_scale,_scale,0,c_white,bob_alpha);
draw_set_color(c_white);draw_set_halign(fa_center);draw_set_valign(fa_middle);
draw_set_font(fnt_born2b);draw_text(_width*0.5,100,"Creditos");
draw_set_font(fnt_gridlite);
draw_text(_width*0.5,165,"Colaboradores");
for(var _i=0;_i<array_length(texts);++_i) {
    var _t=texts[_i];draw_text_transformed(_t.px,_t.py,_t.label,_t.scale,_t.scale,0);
}
draw_set_font(_font);draw_set_color(_colour);draw_set_alpha(_alpha);
draw_set_halign(_halign);draw_set_valign(_valign);
