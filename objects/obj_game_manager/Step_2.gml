if(global.pausa) exit; // Conserva cámara, audio y amplitud de shake exactamente.
for(var _voice_i=array_length(sfx_voices)-1;_voice_i>=0;--_voice_i)
    if(!audio_is_playing(sfx_voices[_voice_i])) array_delete(sfx_voices,_voice_i,1);
// End Step: detecta entrar a jugar, morir o regresar a cualquier menú.
sync_music();

// Un único controlador evita duplicar la sacudida por los dos haces.
var _shake=false;var _laser_strength=0;
if(state=="playing") {
    var _disabled=instance_exists(obj_nave) && obj_nave.buff_active(FluxBuff.Apagon);
    if(!_disabled) {
        for(var _i=0;_i<instance_number(obj_laser_planeta);++_i) {
            var _laser=instance_find(obj_laser_planeta,_i);
            if(_laser.telegraph<=0 && _laser.life>0) { _shake=true;_laser_strength=max(_laser_strength,_laser.shake_strength); }
        }
    }
}
if(state!="playing") { reset_camera();exit; }
var _dt=flux_dt();
attack_shake=max(0,attack_shake-24*_dt);attack_flash=max(0,attack_flash-3*_dt);
// Amplitud aditiva acotada, con disipación y retorno suave independientes del láser.
bomb_shake=max(0,bomb_shake-9*_dt);
var _blend=1-exp(-24*_dt);
bomb_offset_x=lerp(bomb_offset_x,random_range(-bomb_shake,bomb_shake),_blend);
bomb_offset_y=lerp(bomb_offset_y,random_range(-bomb_shake,bomb_shake),_blend);
if(bomb_shake<=0 && abs(bomb_offset_x)<0.01 && abs(bomb_offset_y)<0.01) {
    bomb_offset_x=0;bomb_offset_y=0;
}
var _laser_x=(_shake ? random_range(-_laser_strength,_laser_strength) : 0)+random_range(-attack_shake,attack_shake);
var _laser_y=(_shake ? random_range(-_laser_strength,_laser_strength) : 0)+random_range(-attack_shake,attack_shake);
camera_set_view_pos(world_camera,camera_home_x+_laser_x+bomb_offset_x,
    camera_home_y+_laser_y+bomb_offset_y);
