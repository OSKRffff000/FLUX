if(gm.state!="menu" && gm.state!="menu_transition") exit;
var _font=draw_get_font(),_colour=draw_get_color(),_alpha=draw_get_alpha();
var _ha=draw_get_halign(),_va=draw_get_valign(),_matrix=matrix_get(matrix_world);
// Diseño lógico 720 x 1280 ajustado al tamaño completo de la GUI.
matrix_set(matrix_world,matrix_build(0,0,0,0,0,0,display_get_gui_width()/720,display_get_gui_height()/1280,1));
draw_set_alpha(1);draw_set_color(c_black);draw_rectangle(0,0,720,1280,false);
// Estrellas persistentes, detrás de todos los elementos del menú.
for(var _i=0;_i<array_length(stars);++_i) {
    var _star=stars[_i];draw_set_color(_star.shade);
    if(_star.size==1) draw_point(_star.px,_star.py);
    else draw_rectangle(_star.px,_star.py,_star.px+1,_star.py+1,false);
}
draw_set_color(c_white);draw_set_font(fnt_born2b);
draw_set_halign(fa_right);draw_set_valign(fa_top);
var _title_scale=min(3.2,420/max(1,string_width("FLUX")));
draw_text_transformed(680,55,"FLUX",_title_scale,_title_scale,0);
draw_set_font(fnt_gridlite);draw_set_halign(fa_center);draw_set_valign(fa_middle);
for(var _i=0;_i<array_length(buttons);++_i) {
    var _button=buttons[_i],_active=_i==selected;
    // Fondo, medio y frente: tres trapecios independientes hechos con primitivas.
    for(var _layer=2;_layer>=0;--_layer) {
        var _v=button_vertices(_button,_active,_layer);
        var _color=_layer==1 ? c_gray : (_layer==2 ? (_active ? c_black : c_white) : (_active ? c_white : c_black));
        draw_set_color(_color);draw_primitive_begin(pr_trianglefan);
        for(var _j=0;_j<4;++_j) draw_vertex(_v[_j][0],_v[_j][1]);
        draw_primitive_end();
    }
    draw_set_color(_active ? c_black : c_white);
    var _text_scale=min(1,210/max(1,string_width(_button.label)));
    draw_text_transformed(_button.px+130,_button.py+48,_button.label,_text_scale,_text_scale,0);
}
// Sobre botones y título: la expansión del planeta los oculta durante el avance.
var _scale=planet_radius*2/max(sprite_get_width(sprite_index),sprite_get_height(sprite_index));
var _px=planet_x+(sprite_get_xoffset(sprite_index)-sprite_get_width(sprite_index)*0.5)*_scale;
var _py=planet_y+(sprite_get_yoffset(sprite_index)-sprite_get_height(sprite_index)*0.5)*_scale;
var _texfilter=gpu_get_texfilter();
gpu_set_texfilter(false);
draw_sprite_ext(sprite_index,image_index,_px,_py,_scale,_scale,0,c_white,1);
gpu_set_texfilter(_texfilter);
// También cubre los píxeles transparentes del sprite y la interfaz al fondo.
if(planet_darkness>0) {
    draw_set_color(c_black);draw_set_alpha(planet_darkness);
    draw_rectangle(0,0,720,1280,false);draw_set_alpha(1);
}
if(phase=="black_hold" && planet_darkness>=1) blackout_drawn=true;
if(phase=="panel" || phase=="commit") {
    // Paralelogramo sobredimensionado: bordes inclinados y cobertura total al cerrar.
    var _panel_x=lerp(-1300,-240,panel_progress);
    draw_set_color(make_color_rgb(35,37,41));draw_set_alpha(1);
    draw_primitive_begin(pr_trianglefan);
    draw_vertex(_panel_x,-80);
    draw_vertex(_panel_x+1060,-80);
    draw_vertex(_panel_x+1240,1360);
    draw_vertex(_panel_x+180,1360);
    draw_primitive_end();
}
matrix_set(matrix_world,_matrix);draw_set_font(_font);draw_set_color(_colour);
draw_set_alpha(_alpha);draw_set_halign(_ha);draw_set_valign(_va);
