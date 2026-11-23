var _gm=global.flux;if(_gm.state!="playing") exit;
draw_set_color(c_white);draw_set_alpha(1);draw_set_halign(fa_left);draw_set_valign(fa_top);
draw_text(25,145,"FLUX | Planeta " + string(_gm.stage));

// Barras de recursos en gameplay (esquina superior derecha, debajo del boton de pausa)
flux_draw_bar_creditos(195);
flux_draw_bar_puntos(252);

if (!_gm.tutorial_active) {
    draw_set_color(c_white);draw_set_alpha(1);draw_set_halign(fa_left);draw_set_valign(fa_top);
    draw_text(25,1190,"Manten izquierda/derecha para orbitar. Suelta para parar.");
} else {
    // Interfaz del Tutorial Guiado
    if (_gm.tutorial_rewind_active) {
        var _timer = _gm.tutorial_rewind_timer;
        var _dur = _gm.tutorial_rewind_duration;
        gpu_set_blendmode(bm_add);
        
        // Lineas de escaneo y rebobinado
        var _scan_y = (current_time * 0.45) mod 1280;
        draw_set_color(c_white);
        draw_set_alpha(0.2);
        draw_line_width(0, _scan_y, 720, _scan_y, 4);
        draw_line_width(0, (_scan_y + 640) mod 1280, 720, (_scan_y + 640) mod 1280, 4);
        gpu_set_blendmode(bm_normal);
        
        // Cartel de rebobinado
        draw_set_font(fnt_gridlite);
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        if (floor(current_time / 90) mod 2 == 0) {
            draw_set_color(c_white);
            draw_set_alpha(0.95);
            draw_text_transformed(360, 520, "<< REBOBINANDO <<", 1.4, 1.4, 0);
        }
    } else {
        var _pulse = 0.12 + 0.08 * sin(current_time * 0.007);
        if (_gm.tutorial_state == "phase1_prompt") {
            gpu_set_blendmode(bm_add);
            draw_set_color(c_white);
            draw_set_alpha(_pulse);
            draw_rectangle(0, 0, 360, 1280, false);
            draw_set_alpha(_pulse * 1.8);
            draw_line_width(360, 0, 360, 1280, 2);
            gpu_set_blendmode(bm_normal);
            
            draw_set_font(fnt_gridlite);
            draw_set_halign(fa_center);
            draw_set_valign(fa_middle);
            draw_set_color(c_black);
            draw_set_alpha(0.75);
            draw_roundrect_ext(60, 1030, 660, 1140, 12, 12, false);
            draw_set_color(c_white);
            draw_set_alpha(0.85);
            draw_roundrect_ext(60, 1030, 660, 1140, 12, 12, true);
            draw_set_alpha(1);
            draw_text_transformed(360, 1065, "TUTORIAL: GIRO A LA IZQUIERDA", 1.15, 1.15, 0);
            draw_set_alpha(0.9);
            draw_text(360, 1105, "Manten presionado el lado izquierdo para orbitar.");
        } else if (_gm.tutorial_state == "phase1_dodge") {
            draw_set_font(fnt_gridlite);
            draw_set_halign(fa_center);
            draw_set_valign(fa_middle);
            draw_set_color(c_black);
            draw_set_alpha(0.75);
            draw_roundrect_ext(60, 1030, 660, 1140, 12, 12, false);
            draw_set_color(c_white);
            draw_set_alpha(0.85);
            draw_roundrect_ext(60, 1030, 660, 1140, 12, 12, true);
            draw_set_alpha(1);
            draw_text_transformed(360, 1065, "¡ESQUIVA A LA IZQUIERDA!", 1.15, 1.15, 0);
            draw_set_alpha(0.9);
            draw_text(360, 1105, "Maniobra para esquivar las descargas del planeta.");
        } else if (_gm.tutorial_state == "phase2_prompt") {
            gpu_set_blendmode(bm_add);
            draw_set_color(c_white);
            draw_set_alpha(_pulse);
            draw_rectangle(360, 0, 720, 1280, false);
            draw_set_alpha(_pulse * 1.8);
            draw_line_width(360, 0, 360, 1280, 2);
            gpu_set_blendmode(bm_normal);
            
            draw_set_font(fnt_gridlite);
            draw_set_halign(fa_center);
            draw_set_valign(fa_middle);
            draw_set_color(c_black);
            draw_set_alpha(0.75);
            draw_roundrect_ext(60, 1030, 660, 1140, 12, 12, false);
            draw_set_color(c_white);
            draw_set_alpha(0.85);
            draw_roundrect_ext(60, 1030, 660, 1140, 12, 12, true);
            draw_set_alpha(1);
            draw_text_transformed(360, 1065, "TUTORIAL: GIRO A LA DERECHA", 1.15, 1.15, 0);
            draw_set_alpha(0.9);
            draw_text(360, 1105, "Manten presionado el lado derecho para orbitar.");
        } else if (_gm.tutorial_state == "phase2_dodge") {
            draw_set_font(fnt_gridlite);
            draw_set_halign(fa_center);
            draw_set_valign(fa_middle);
            draw_set_color(c_black);
            draw_set_alpha(0.75);
            draw_roundrect_ext(60, 1030, 660, 1140, 12, 12, false);
            draw_set_color(c_white);
            draw_set_alpha(0.85);
            draw_roundrect_ext(60, 1030, 660, 1140, 12, 12, true);
            draw_set_alpha(1);
            draw_text_transformed(360, 1065, "¡ESQUIVA A LA DERECHA!", 1.15, 1.15, 0);
            draw_set_alpha(0.9);
            draw_text(360, 1105, "Manten el impulso para evitar los proyectiles.");
        } else if (_gm.tutorial_state == "complete") {
            draw_set_font(fnt_gridlite);
            draw_set_halign(fa_center);
            draw_set_valign(fa_middle);
            draw_set_color(c_black);
            draw_set_alpha(0.85);
            draw_roundrect_ext(50, 520, 670, 640, 16, 16, false);
            draw_set_color(c_white);
            draw_set_alpha(1);
            draw_roundrect_ext(50, 520, 670, 640, 16, 16, true);
            
            var _scale = 1.25 + 0.05 * sin(current_time * 0.008);
            draw_text_transformed(360, 560, "¡TUTORIAL COMPLETADO!", _scale, _scale, 0);
            draw_set_alpha(0.9);
            draw_text(360, 605, "Iniciando rondas reales...");
        }
    }
}
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_alpha(1);
draw_set_color(c_white);

if(!instance_exists(obj_nave)) exit;
var _s=instance_find(obj_nave,0),_slot=0;
for(var _i=0;_i<FluxBuff.Count;++_i) {
    var _buff=_s.buffs[_i];if(_buff.remaining<=0) continue;
    var _xx=40+(_slot mod 8)*88,_yy=48;
    draw_set_color(c_dkgray);draw_circle(_xx,_yy,29,true);
    draw_set_color(c_white);flux_buff_icon(_xx,_yy,_i,27);
    // 360° al recoger, 0° al expirar; empieza arriba y se consume en sentido horario.
    flux_arc(_xx,_yy,29,_buff.remaining/_buff.duration,3);
    draw_set_halign(fa_center);draw_text(_xx,_yy+35,string(ceil(_buff.remaining))+"s");
    ++_slot;
}
draw_set_halign(fa_left);
