var _gm=global.flux;
if(_gm.state!="settings") exit;
if(!device_mouse_check_button_pressed(0,mb_left)) exit;
for(var _i=0;_i<3;++_i) {
    var _yy=340+_i*160;
    var _change=0;
    if(flux_inside(80,_yy,70,70)) _change=-0.1;
    else if(flux_inside(570,_yy,70,70)) _change=0.1;
    if(_change!=0) {
        switch(_i) {
            case 0:global.vol_maestro=clamp(round((global.vol_maestro+_change)*10)/10,0,1);break;
            case 1:global.vol_musica=clamp(round((global.vol_musica+_change)*10)/10,0,1);break;
            case 2:global.vol_sfx=clamp(round((global.vol_sfx+_change)*10)/10,0,1);break;
        }
        _gm.apply_audio_settings();_gm.save_progress();
        flux_play_sfx(snd_menu_seleccion,10);exit;
    }
}
if(flux_click_inside(160,1120,400,70)) { _gm.state="menu";_gm.notice=""; }
