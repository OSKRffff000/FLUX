if(gm.state!="credits") { instance_destroy();exit; }
var _dt=delta_time/1000000;elapsed+=_dt;
bob_alpha=min(1,bob_alpha+bob_fade_speed*_dt);
if(elapsed>=duration) {
    // Terminar la pista y cualquier efecto pendiente antes de volver a la música del menú.
    if(audio_is_playing(credits_voice)) audio_stop_sound(credits_voice);
    for(var _i=0;_i<array_length(gm.sfx_voices);++_i)
        if(audio_is_playing(gm.sfx_voices[_i])) audio_stop_sound(gm.sfx_voices[_i]);
    gm.sfx_voices=[];gm.state="menu";gm.sync_music();instance_destroy();exit;
}
var _width=display_get_gui_width(),_height=display_get_gui_height();
for(var _i=0;_i<array_length(texts);++_i) {
    var _t=texts[_i];
    _t.px+=_t.vx*_dt;_t.py+=_t.vy*_dt;
    // Esperar hasta que el texto completo quede fuera; conservar la dirección.
    var _wrap_x=0,_wrap_y=0;
    if(_t.px+_t.half_w<0) _wrap_x=-1;
    else if(_t.px-_t.half_w>_width) _wrap_x=1;
    if(_t.py+_t.half_h<0) _wrap_y=-1;
    else if(_t.py-_t.half_h>_height) _wrap_y=1;
    if(_wrap_x!=0 || _wrap_y!=0) {
        var _max_scale=min(1.2,(_width-40)/max(1,_t.base_w));
        _t.scale=random_range(_max_scale*0.5,_max_scale);
        _t.half_w=_t.base_w*_t.scale*0.5;
        _t.half_h=_t.base_h*_t.scale*0.5;
        if(_wrap_x<0) _t.px=_width+_t.half_w;
        else if(_wrap_x>0) _t.px=-_t.half_w;
        else _t.px=clamp(_t.px,-_t.half_w,_width+_t.half_w);
        if(_wrap_y<0) _t.py=_height+_t.half_h;
        else if(_wrap_y>0) _t.py=-_t.half_h;
        else _t.py=clamp(_t.py,-_t.half_h,_height+_t.half_h);
    }
}
