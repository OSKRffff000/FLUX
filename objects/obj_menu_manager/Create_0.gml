gm=global.flux;
sprite_index=choose(spr_planeta9,spr_planeta10,spr_planeta11);
image_index=0;image_speed=1;
phase="idle";phase_time=0;selected=-1;was_menu=false;input_ready=false;
clicked_index=-1;click_time=999;
planet_x=-200;planet_y=640;planet_radius=450;panel_progress=0;
planet_darkness=0;blackout_drawn=false;
stars=[];
for(var _i=0;_i<80;++_i) {
    array_push(stars,{px:irandom(719),py:irandom(1279),size:choose(1,1,2),shade:choose(c_white,c_ltgray,c_gray)});
}
buttons=[];
var _labels=["Jugar","Arbol de Mejoras","Mascotas","Configuracion","Creditos"];
var _actions=["playing","tree","shop","settings","credits"];
var _start_y=680;
var _step_y=92;
draw_set_font(fnt_gridlite);
for(var _i=0;_i<5;++_i) {
    var _lbl=_labels[_i];
    var _w=max(260,string_width(_lbl)*1.55);
    array_push(buttons,{
        label:_lbl,
        action:_actions[_i],
        rx:670,
        ry:_start_y+_i*_step_y,
        w:_w,
        anim:0
    });
}

button_contains=function(_btn,_mx,_my) {
    if(is_struct(_btn)) {
        return (_mx >= (_btn.rx - _btn.w - 50) && _mx <= 720 && _my >= (_btn.ry - 38) && _my <= (_btn.ry + 38));
    }
    if(is_array(_btn)) {
        var _positive=false,_negative=false;
        var _count=array_length(_btn);
        for(var _i=0;_i<_count;++_i) {
            var _a=_btn[_i],_b=_btn[(_i+1) mod _count];
            var _cross=(_b[0]-_a[0])*(_my-_a[1])-(_b[1]-_a[1])*(_mx-_a[0]);
            if(_cross>0) _positive=true;
            if(_cross<0) _negative=true;
        }
        return !(_positive && _negative);
    }
    return false;
};
