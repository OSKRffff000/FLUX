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
// 2. Titulo Principal ("FLUX"): imponente, dominante y posicionado en la parte superior derecha
draw_set_font(fnt_born2b);
draw_set_halign(fa_right);
draw_set_valign(fa_top);
var _title_scale=min(10.5,620/max(1,string_width("FLUX")));
var _title_x=675;
var _title_y=45;

// Sombra de profundidad en el titulo
draw_set_color(c_black);
draw_set_alpha(0.85);
draw_text_transformed(_title_x+4,_title_y+4,"FLUX",_title_scale,_title_scale,0);

// Resplandor aditivo ambiental blanco puro (sin tinte azul)
gpu_set_blendmode(bm_add);
draw_set_color(c_white);
draw_set_alpha(0.25);
draw_text_transformed(_title_x,_title_y,"FLUX",_title_scale,_title_scale,0);
gpu_set_blendmode(bm_normal);

// Cuerpo principal blanco puro del titulo
draw_set_color(c_white);
draw_set_alpha(1);
draw_text_transformed(_title_x,_title_y,"FLUX",_title_scale,_title_scale,0);

// 3. Sistema tipografico minimalista alineado a la derecha (fnt_gridlite)
draw_set_font(fnt_gridlite);
draw_set_halign(fa_right);
draw_set_valign(fa_middle);

for(var _i=0;_i<array_length(buttons);++_i) {
    var _b=buttons[_i];
    var _t=_b.anim; // Interpolado suavemente en Step_0 (0 = reposo, 1 = seleccionado)
    
    // Desplazamiento horizontal responsivo: se desliza sutilmente hacia el centro (-16px) al seleccionarse
    var _dx=-16*_t;
    var _tx=_b.rx+_dx;
    var _ty=_b.ry;
    
    // Deteccion de seleccion activa
    var _is_clicked=(_i==clicked_index && click_time<0.38);
    var _pop_factor=1.0;
    
    // Rebote elastico y fogonazo blanco expansivo al seleccionarse
    if(_is_clicked) {
        var _pop_env=clamp(1.0-click_time/0.35,0,1);
        _pop_factor=1.0+0.42*sin(click_time*26)*_pop_env;
        
        // Fogonazo / Destello horizontal expansivo a gran velocidad en blanco puro
        var _flare_t=clamp(click_time/0.25,0,1);
        var _flare_alpha=(1.0-_flare_t)*(1.0-_flare_t);
        if(_flare_alpha>0.01) {
            gpu_set_blendmode(bm_add);
            draw_set_color(c_white);
            
            var _cx=_tx-_b.w*0.45;
            var _hw=lerp(50,420,sqrt(_flare_t));
            var _x1=max(0,_cx-_hw);
            var _x2=min(720,_cx+_hw);
            
            // Banda rectangular delgada difusa de luz blanca
            var _slab_h=lerp(4,24,_flare_t);
            draw_set_alpha(0.45*_flare_alpha);
            draw_rectangle(_x1,_ty-_slab_h*0.5,_x2,_ty+_slab_h*0.5,false);
            
            // Linea horizontal delgada ultra-brillante
            draw_set_alpha(0.95*_flare_alpha);
            draw_line_width(_x1,_ty,_x2,_ty,2);
            
            // Marco rectangular expandiendose a los lados
            var _bx=_flare_t*24;
            draw_set_alpha(0.6*_flare_alpha);
            draw_rectangle(_tx-_b.w-12-_bx,_ty-22-_bx,_tx+20+_bx,_ty+22+_bx,true);
            
            gpu_set_blendmode(bm_normal);
            draw_set_alpha(1);
        }
    }
    
    // Escala dinamica interactiva combinada con el pop elastico
    var _base_scale=1.35;
    var _scale=_base_scale*(1.0+0.16*_t)*_pop_factor;
    
    // Pulso suave de respiracion / brillo continuo en la opcion seleccionada
    var _pulse=(_t>0.01) ? (0.82+0.18*sin(current_time*0.01)) : 1.0;
    
    // Parpadeo rapido de alta frecuencia (strobe de respuesta tactil instantanea)
    var _strobe=true;
    if(_is_clicked && click_time<0.18) {
        _strobe=((floor(click_time*60) mod 2)==0);
    }
    
    // Resplandor holografico blanco puro con mezcla aditiva (bm_add)
    if(_t>0.01 || _is_clicked) {
        gpu_set_blendmode(bm_add);
        draw_set_color(c_white);
        
        var _glow_mult=_is_clicked ? (1.5+(_strobe ? 1.0 : 0.0)) : 1.0;
        
        // Halo exterior blanco puro
        draw_set_alpha(0.35*_t*_pulse*_glow_mult);
        draw_text_transformed(_tx+1,_ty,_b.label,_scale,_scale,0);
        draw_text_transformed(_tx-1,_ty,_b.label,_scale,_scale,0);
        draw_text_transformed(_tx,_ty+1,_b.label,_scale,_scale,0);
        draw_text_transformed(_tx,_ty-1,_b.label,_scale,_scale,0);
        
        // Nucleo brillante blanco puro (sobre-expuesto durante strobe)
        draw_set_alpha(0.75*_t*_pulse*_glow_mult);
        draw_text_transformed(_tx,_ty,_b.label,_scale*1.01,_scale*1.01,0);
        
        // Acento grafico minimalista blanco puro a la derecha
        draw_set_alpha(0.85*_t*_pulse);
        draw_line_width(_b.rx+8,_ty,_b.rx+22,_ty,2);
        
        gpu_set_blendmode(bm_normal);
        draw_set_alpha(1);
    } else {
        // Sombra de lectura suave en reposo
        draw_set_color(c_black);
        draw_set_alpha(0.7);
        draw_text_transformed(_tx+2,_ty+2,_b.label,_scale,_scale,0);
    }
    
    // Texto principal estrictamente blanco puro (c_white)
    draw_set_color(c_white);
    var _text_alpha=_is_clicked ? (_strobe ? 1.0 : 0.6) : lerp(0.72,1.0,_t);
    draw_set_alpha(_text_alpha);
    draw_text_transformed(_tx,_ty,_b.label,_scale,_scale,0);
}
draw_set_alpha(1);
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
if(gm.notice!="" && phase=="idle") {
    draw_set_color(c_white);
    draw_set_font(fnt_gridlite);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_text(360,1220,gm.notice);
}
matrix_set(matrix_world,_matrix);draw_set_font(_font);draw_set_color(_colour);
draw_set_alpha(_alpha);draw_set_halign(_ha);draw_set_valign(_va);
