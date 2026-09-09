if(global.flux.state!="menu") exit;
if(device_mouse_check_button_pressed(0,mb_left) && flux_click_inside(gui_x,gui_y,button_width,button_height)) {
    global.flux.state="settings";global.flux.notice="";
}
