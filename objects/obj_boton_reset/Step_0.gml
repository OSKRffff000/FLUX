// Mouse/Tap sin máscara de sprite: dispositivo 0 admite ratón y toque principal.
if(reset_in_progress || !instance_exists(global.flux)) exit;
if(global.flux.state!="menu") exit;
if(device_mouse_check_button_pressed(0,mb_left)
    && flux_click_inside(gui_x,gui_y,button_width,button_height)) {
    reset_in_progress=true;
    if(scr_resetear_progreso()) {
        game_restart();
        exit;
    }
    reset_in_progress=false;
    global.flux.notice="No se pudo eliminar flux_save.ini. Intenta de nuevo.";
}
