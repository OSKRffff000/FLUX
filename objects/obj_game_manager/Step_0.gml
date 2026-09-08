if (!device_mouse_check_button_pressed(0, mb_left)) exit;
switch (state) {
    case "menu":
        if (flux_click_inside(160,440,400,80)) start_run();
        else if (flux_click_inside(160,550,400,80)) { state="tree"; notice=""; }
        else if (flux_click_inside(160,660,400,80)) { state="shop"; notice=""; }
        break;
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
