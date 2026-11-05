draw_set_alpha(1); draw_set_color(c_white);
draw_set_halign(fa_left); draw_set_valign(fa_top);
if (state == "paused" || state == "playing" || state == "tree" || state == "dying" || state == "settings" || state == "credits" || state == "menu" || state == "menu_transition") exit;
draw_set_color(c_black); draw_set_alpha(0.94); draw_rectangle(0,0,720,1280,false);
draw_set_alpha(1); draw_set_color(c_white);
if (state != "shop") draw_text(30,60,"FLUX");

switch (state) {
    case "dead":
        draw_text(160,400,"Nave destruida");
        flux_button(160,550,400,80,"Continuar/Reintentar",true);
        flux_button(160,660,400,80,"Ir al Arbol de Mejoras",true);
        break;

    case "evolution":
        draw_text(70,260,"Evolucion disponible: " + evolution_names[evolution_pending]);
        draw_text_ext(70,640,evolution_descriptions[evolution_pending],28,580);
        flux_draw_ship(360,480,evolution_pending,90,4,1);
        flux_button(90,850,240,80,"Aceptar",true);
        flux_button(390,850,240,80,"Posponer",true);
        draw_text(70,980,"Puedes aceptar despues desde el arbol.");
        break;

    case "shop":
        draw_set_font(fnt_gridlite);
        draw_set_halign(fa_left); draw_set_valign(fa_top);
        draw_set_color(c_white); draw_set_alpha(1);
        draw_text_transformed(35, 75, "Tienda de Mascotas", 1.4, 1.4, 0);
        draw_set_color(make_color_rgb(175, 190, 210));
        draw_text(35, 115, "Una mascota equipada a la vez");
        
        // Marcador de creditos ubicado mas abajo para no estorbar con el encabezado
        flux_draw_bar_creditos(105, 480);
        
        var _gui_mx = device_mouse_x_to_gui(0) * 720 / display_get_gui_width();
        var _gui_my = device_mouse_y_to_gui(0) * 1280 / display_get_gui_height();

        for (var _p=0; _p<array_length(pets); ++_p) {
            var _card_y = 175 + _p * 290;
            var _pet = pets[_p];
            var _is_equipped = (equipped_pet == _p);
            
            // Marco contenedor de la tarjeta
            draw_set_color(_is_equipped ? make_color_rgb(22, 32, 46) : make_color_rgb(14, 18, 26));
            draw_set_alpha(0.85);
            draw_rectangle(30, _card_y, 690, _card_y + 265, false);
            draw_set_color(_is_equipped ? c_white : make_color_rgb(50, 65, 85));
            draw_set_alpha(_is_equipped ? 0.9 : 0.45);
            draw_rectangle(30, _card_y, 690, _card_y + 265, true);
            
            // 1. Sprite de mascota grande, detallado y prominente
            var _spr_cx = 125;
            var _spr_cy = _card_y + 132;
            
            // Pedestal holografico
            draw_set_color(_is_equipped ? c_white : make_color_rgb(45, 65, 90));
            draw_set_alpha(_is_equipped ? 0.35 : 0.2);
            draw_circle(_spr_cx, _spr_cy, 72, true);
            draw_circle(_spr_cx, _spr_cy, 68, true);
            
            var _spr = variable_struct_exists(_pet, "sprite") ? _pet.sprite : asset_get_index("Mascota" + _pet.name);
            if (_spr != -1 && sprite_exists(_spr)) {
                var _sw = sprite_get_width(_spr);
                var _sh = sprite_get_height(_spr);
                var _ox = sprite_get_xoffset(_spr);
                var _oy = sprite_get_yoffset(_spr);
                // Escala destacada de 150px (mas del doble del original de 64px)
                var _scale = min(150 / max(1, _sw), 150 / max(1, _sh));
                var _texfilter = gpu_get_texfilter();
                gpu_set_texfilter(false);
                draw_sprite_ext(_spr, 0, _spr_cx - (_sw * 0.5 - _ox) * _scale, _spr_cy - (_sh * 0.5 - _oy) * _scale, _scale, _scale, 0, c_white, 1);
                gpu_set_texfilter(_texfilter);
            } else {
                draw_circle(_spr_cx, _spr_cy, 45, true);
                draw_circle(_spr_cx - 15, _spr_cy - 8, 5, false);
                draw_circle(_spr_cx + 15, _spr_cy - 8, 5, false);
            }
            
            // Informacion textual
            draw_set_font(fnt_gridlite);
            draw_set_halign(fa_left); draw_set_valign(fa_top);
            draw_set_color(c_white); draw_set_alpha(1);
            draw_text_transformed(220, _card_y + 22, _pet.name, 1.4, 1.4, 0);
            
            var _price_text = _pet.owned ? "ADQUIRIDA" : (string(_pet.price) + " CREDITOS");
            draw_set_color(_pet.owned ? make_color_rgb(160, 220, 255) : make_color_rgb(255, 215, 100));
            draw_text(220, _card_y + 64, _price_text);
            
            draw_set_color(make_color_rgb(215, 225, 235));
            draw_set_alpha(0.9);
            draw_text_ext(220, _card_y + 104, _pet.description + (evolution == 2 ? " Nodriza: bono duplicado." : ""), 24, 440);
            
            // 3. Boton de accion (Comprar / Equipar / Equipado)
            var _bx = 440, _by = _card_y + 175, _bw = 225, _bh = 65;
            var _bcx = _bx + _bw * 0.5, _bcy = _by + _bh * 0.5;
            var _btn_hover = point_in_rectangle(_gui_mx, _gui_my, _bx, _by, _bx + _bw, _by + _bh);
            
            if (_is_equipped) {
                // Estado Equipado: Fondo blanco solido con texto oscuro de alto contraste
                draw_set_color(c_white);
                draw_set_alpha(1);
                draw_rectangle(_bx, _by, _bx + _bw, _by + _bh, false);
                draw_rectangle(_bx - 2, _by - 2, _bx + _bw + 2, _by + _bh + 2, true);
                
                draw_set_color(make_color_rgb(10, 15, 24));
                draw_set_font(fnt_gridlite);
                draw_set_halign(fa_center); draw_set_valign(fa_middle);
                draw_text_transformed(_bcx, _bcy, "EQUIPADA", 1.25, 1.25, 0);
            } else if (_pet.owned) {
                // Estado Equipar
                draw_set_color(_btn_hover ? make_color_rgb(32, 48, 70) : make_color_rgb(16, 24, 36));
                draw_set_alpha(0.85);
                draw_rectangle(_bx, _by, _bx + _bw, _by + _bh, false);
                draw_set_color(c_white);
                draw_set_alpha(_btn_hover ? 1.0 : 0.7);
                draw_rectangle(_bx, _by, _bx + _bw, _by + _bh, true);
                
                draw_set_color(c_white);
                draw_set_alpha(1);
                draw_set_font(fnt_gridlite);
                draw_set_halign(fa_center); draw_set_valign(fa_middle);
                draw_text_transformed(_bcx, _bcy, "EQUIPAR", 1.2, 1.2, 0);
            } else {
                // Estado Comprar
                var _can_buy = (coins >= _pet.price);
                draw_set_color(_btn_hover ? make_color_rgb(38, 32, 20) : make_color_rgb(18, 16, 12));
                draw_set_alpha(0.85);
                draw_rectangle(_bx, _by, _bx + _bw, _by + _bh, false);
                draw_set_color(_can_buy ? make_color_rgb(255, 215, 100) : c_gray);
                draw_set_alpha(_btn_hover ? 1.0 : 0.65);
                draw_rectangle(_bx, _by, _bx + _bw, _by + _bh, true);
                
                draw_set_color(_can_buy ? c_white : c_gray);
                draw_set_alpha(1);
                draw_set_font(fnt_gridlite);
                draw_set_halign(fa_center); draw_set_valign(fa_middle);
                draw_text_transformed(_bcx, _bcy, "COMPRAR", 1.2, 1.2, 0);
            }
        }
        
        // Boton Volver al menu con fuente fnt_gridlite
        var _ret_hover = point_in_rectangle(_gui_mx, _gui_my, 160, 1090, 560, 1160);
        draw_set_color(_ret_hover ? make_color_rgb(30, 40, 56) : make_color_rgb(14, 18, 26));
        draw_set_alpha(0.85);
        draw_rectangle(160, 1090, 560, 1160, false);
        draw_set_color(_ret_hover ? c_white : make_color_rgb(140, 160, 185));
        draw_set_alpha(1);
        draw_rectangle(160, 1090, 560, 1160, true);
        
        draw_set_color(c_white);
        draw_set_font(fnt_gridlite);
        draw_set_halign(fa_center); draw_set_valign(fa_middle);
        draw_text_transformed(360, 1125, "VOLVER AL MENU", 1.2, 1.2, 0);
        break;
}

if (notice != "") {
    draw_set_color(c_white);
    draw_set_font(fnt_gridlite);
    draw_set_halign(fa_center); draw_set_valign(fa_middle);
    draw_text(360, 1045, notice);
}
