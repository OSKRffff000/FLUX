var _dt=delta_time/1000000;elapsed+=_dt;
if(!exploded && elapsed>=1.5) {
    exploded=true;
    with(obj_nave) instance_destroy();
    audio_play_sound(snd_muerte_explosion,10,false);
    repeat(22) instance_create_depth(ship_x,ship_y,-45,obj_fragmento_nave);
    audio_play_sound(snd_panel,9,false);
}
if(!lower_started && elapsed>=2) {
    lower_started=true;audio_play_sound(snd_panel,9,false);
}
if(!closed && elapsed>=3) {
    closed=true;audio_play_sound(snd_panel_cerrado,10,false);
}
if(!device_mouse_check_button(0,mb_left)) input_ready=true;
for(var _i=0;_i<2;++_i) {
    var _start=3+_i*0.15;
    if(elapsed>=_start) {
        // Interpolación exponencial calculada con tiempo absoluto, independiente de FPS.
        button_x[_i]=lerp(-440,160,1-exp(-18*(elapsed-_start)));
        if(abs(button_x[_i]-160)<0.5) { button_x[_i]=160;button_ready[_i]=true; }
    }
}
if(closed && input_ready && device_mouse_check_button_pressed(0,mb_left)) {
    if(button_ready[0] && flux_click_inside(button_x[0],550,400,80)) {
        gm.start_run();exit;
    }
    if(button_ready[1] && flux_click_inside(button_x[1],660,400,80)) {
        gm.state="tree";gm.notice="";
        with(obj_fragmento_nave) instance_destroy();
        instance_destroy();exit;
    }
}
