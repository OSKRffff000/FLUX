// Truco HESOYAM: solo disponible en la pantalla de titulo (primer menu, en menos de 3 segundos)
if (state == "menu") {
    if (keyboard_string != cheat_last_ks) {
        var _new_len = string_length(keyboard_string);
        var _old_len = string_length(cheat_last_ks);
        if (_new_len > _old_len) {
            var _added = string_copy(keyboard_string, _old_len + 1, _new_len - _old_len);
            for (var _k = 1; _k <= string_length(_added); ++_k) {
                var _ch = string_lower(string_char_at(_added, _k));
                if (_ch >= "a" && _ch <= "z") {
                    array_push(cheat_history, {char: _ch, time: current_time});
                }
            }
        }
        cheat_last_ks = keyboard_string;
        if (string_length(keyboard_string) > 100) keyboard_string = string_copy(keyboard_string, 50, 50);
    }
    if (keyboard_check_pressed(vk_anykey)) {
        var _ch = string_lower(keyboard_lastchar);
        if (_ch >= "a" && _ch <= "z") {
            var _hlen = array_length(cheat_history);
            if (_hlen == 0 || cheat_history[_hlen - 1].char != _ch || cheat_history[_hlen - 1].time != current_time) {
                array_push(cheat_history, {char: _ch, time: current_time});
            }
        }
    }
    if (array_length(cheat_history) >= 7) {
        var _hlen = array_length(cheat_history);
        var _word = "";
        for (var _w = _hlen - 7; _w < _hlen; ++_w) _word += cheat_history[_w].char;
        if (_word == "hesoyam") {
            var _elapsed = cheat_history[_hlen - 1].time - cheat_history[_hlen - 7].time;
            if (_elapsed <= 3000) {
                coins += 25000;
                skill_points += 50;
                notice = "HESOYAM activado: +25000 Creditos | +50 Puntos";
                flux_play_sfx(snd_menu_seleccion, 10);
                save_progress();
                cheat_history = [];
                keyboard_string = "";
                cheat_last_ks = "";
            }
        }
    }
    while (array_length(cheat_history) > 0 && current_time - cheat_history[0].time > 4000) {
        array_delete(cheat_history, 0, 1);
    }
} else {
    // Si no esta en el menu de titulo, limpiar el buffer para que no se active fuera de el
    if (array_length(cheat_history) > 0) cheat_history = [];
    cheat_last_ks = keyboard_string;
}

if (!device_mouse_check_button_pressed(0, mb_left)) exit;
switch (state) {
    case "menu":
    case "menu_transition":break; // Controlados por obj_menu_manager.
    case "dead":
        if (flux_click_inside(160,550,400,80)) start_run();
        else if (flux_click_inside(160,660,400,80)) { state="tree"; notice=""; }
        break;

    case "tree": break; // Entrada y cámara pertenecen a obj_menu_arbol.
    case "evolution":
        if(flux_click_inside(90,850,240,80)) {
            evolution=evolution_pending; evolution_deferred=false;
            state=evolution_return; rebuild_stats(); save_progress();
        } else if(flux_click_inside(390,850,240,80)) {
            evolution_deferred=true;state=evolution_return;save_progress();
        }
        break;
    case "shop":
        for (var _p=0; _p<array_length(pets); ++_p)
            if (flux_click_inside(460,300+_p*220,230,65)) buy_pet(_p);
        if (flux_click_inside(160,1090,400,70)) { state="menu"; notice=""; }
        break;
}
