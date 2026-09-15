if(gm.state!="menu" && gm.state!="menu_transition") { was_menu=false;exit; }
var _dt=delta_time/1000000;
if(!was_menu) {
    was_menu=true;phase="idle";phase_time=0;selected=-1;
    planet_x=-200;planet_y=640;planet_radius=450;panel_progress=0;input_ready=false;
    planet_darkness=0;blackout_drawn=false;
    sprite_index=choose(spr_planeta9,spr_planeta10,spr_planeta11);image_index=0;
}
if(phase=="idle") {
    if(!device_mouse_check_button(0,mb_left)) input_ready=true;
    var _mx=device_mouse_x_to_gui(0)*720/display_get_gui_width();
    var _my=device_mouse_y_to_gui(0)*1280/display_get_gui_height();
    selected=-1;
    for(var _i=0;_i<array_length(buttons);++_i) {
        // Área estable: unión de las capas en ambos estados para evitar parpadeos del hover.
        for(var _layer=0;_layer<3;++_layer) {
            if(button_contains(button_vertices(buttons[_i],false,_layer),_mx,_my)
                || button_contains(button_vertices(buttons[_i],true,_layer),_mx,_my)) {
                selected=_i;break;
            }
        }
        if(selected>=0) break;
    }
    if(input_ready && selected>=0 && device_mouse_check_button_pressed(0,mb_left)) {
        phase="anticipation";phase_time=0;gm.state="menu_transition";
        flux_play_sfx(snd_menu_seleccion,10);
    }
    exit;
}
phase_time+=_dt;
if(phase=="anticipation") {
    var _t=clamp(phase_time/0.22,0,1);
    planet_x=lerp(-200,-270,_t*_t);
    if(_t>=1) { phase="acceleration";phase_time=0; }
} else if(phase=="acceleration") {
    var _t=clamp(phase_time/0.65,0,1),_ease=_t*_t*_t;
    planet_x=lerp(-270,360,_ease);
    planet_radius=lerp(450,3000,_ease);
    planet_darkness=_t*_t*(3-2*_t);
    if(_t>=1) { planet_darkness=1;phase="black_hold";phase_time=0;blackout_drawn=false; }
} else if(phase=="black_hold") {
    // El barrido empieza sólo después de presentar un frame completamente negro.
    if(blackout_drawn) { phase="panel";phase_time=0; }
} else if(phase=="panel") {
    panel_progress=clamp(phase_time/0.3,0,1);
    // Mantener el panel completo al menos un Draw antes de ejecutar el destino.
    if(panel_progress>=1) { phase="commit";phase_time=0; }
} else if(phase=="commit") {
    var _action=buttons[selected].action;
    phase="idle";was_menu=false;gm.notice="";
    switch(_action) {
        case "playing":gm.start_run();break;
        case "credits":instance_create_depth(0,0,-130,obj_controlador_creditos);break;
        default:gm.state=_action;break;
    }
}
