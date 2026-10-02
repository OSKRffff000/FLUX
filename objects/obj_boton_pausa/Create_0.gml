gm=global.flux;
gui_x=628;gui_y=112;button_width=68;button_height=64;
handle_input=function() {
    if(!device_mouse_check_button_pressed(0,mb_left)) return;
    if(gm.state=="playing") {
        if(flux_inside(gui_x,gui_y,button_width,button_height)) {
            gm.begin_pause();
            flux_play_sfx(snd_menu_seleccion,10);
        }
        return;
    }
    if(gm.state!="paused") return;
    if(flux_click_inside(110,470,500,90)) gm.resume_run();
    else if(flux_click_inside(110,600,500,90)) { gm.state="tree";gm.notice=""; }
    else if(flux_click_inside(110,730,500,90)) gm.finish_paused_run();
};
