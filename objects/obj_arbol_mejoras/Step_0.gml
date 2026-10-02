if(gm.state!="tree") { was_tree=false;dragging=false;pinching=false;exit; }
if(!was_tree) { was_tree=true;input_ready=false; }
var _down=device_mouse_check_button(0,mb_left);
if(!input_ready) { if(!_down) input_ready=true;exit; }
var _mx=device_mouse_x_to_gui(0),_my=device_mouse_y_to_gui(0);
var _touch2=device_mouse_check_button(1,mb_left);
if(_down && _touch2) {
    var _tx=device_mouse_x_to_gui(1),_ty=device_mouse_y_to_gui(1);
    var _cx=(_mx+_tx)*0.5,_cy=(_my+_ty)*0.5;
    var _span=max(1,point_distance(_mx,_my,_tx,_ty));
    if(pinching) {
        cam_x-=(_cx-last_x)/zoom;cam_y-=(_cy-last_y)/zoom;
        zoom_at(_span/last_pinch,_cx,_cy);
    }
    last_x=_cx;last_y=_cy;last_pinch=_span;pinching=true;dragging=false;exit;
}
if(pinching) { pinching=false;dragging=false;input_ready=false;exit; }
if(_my>175 && _my<790) {
    var _wheel=mouse_wheel_up()-mouse_wheel_down();
    if(_wheel!=0) zoom_at(power(1.15,_wheel),_mx,_my);
}
if(device_mouse_check_button_pressed(0,mb_left)) {
    if(flux_click_inside(20,1130,160,70)) { gm.state=global.pausa ? "paused" : "menu";exit; }
    if(gm.spent_points>=15 && gm.evolution<0 && flux_click_inside(195,1130,315,70)) { gm.evaluate_evolution(true);exit; }
    if(flux_click_inside(530,1130,70,70)) { zoom_at(1/1.2,360,480);exit; }
    if(flux_click_inside(620,1130,70,70)) { zoom_at(1.2,360,480);exit; }
    if(_my>175 && _my<790) { dragging=true;drag_distance=0;last_x=_mx;last_y=_my; }
}
if(dragging) {
    var _dx=_mx-last_x,_dy=_my-last_y;
    drag_distance+=point_distance(0,0,_dx,_dy);
    cam_x-=_dx/zoom;cam_y-=_dy/zoom;last_x=_mx;last_y=_my;
    cam_x=clamp(cam_x,-1400,1400);cam_y=clamp(cam_y,-1400,1400);
    if(!_down) {
        dragging=false;
        if(drag_distance<12 && _my>175 && _my<790) {
            var _wx=cam_x+(_mx-360)/zoom,_wy=cam_y+(_my-480)/zoom;
            for(var _i=0;_i<array_length(nodes);++_i) {
                var _n=nodes[_i];
                var _data=gm.branches[_n.branch].nodes[_n.level];
                if(_data.state=="bloqueado") continue;
                if(flux_hex_contains(_wx-_n.wx,_wy-_n.wy,hex_radius)) {
                    flux_play_sfx(snd_menu_seleccion,10);
                    if(nodo_seleccionado==_i) gm.buy_node(_n.branch,_n.level);
                    else nodo_seleccionado=_i;
                    break;
                }
            }
        }
    }
}
