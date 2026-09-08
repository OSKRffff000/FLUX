if(global.flux.state!="playing") exit;
if(owner!=noone && !instance_exists(owner)) { instance_destroy();exit; }
if(instance_exists(owner)) { x=owner.x;y=owner.y; }
// Segundos de juego activo sin escalado: carga 2 s y disparo 4 s exactos.
var _dt=delta_time/1000000;prev_heading=heading;sweep_delta=0;
if(telegraph>0) {
    var _charge_dt=min(telegraph,_dt);
    telegraph=max(0,telegraph-_charge_dt);
    _dt-=_charge_dt; // Conserva el sobrante al cruzar la frontera entre fases.
}
if(telegraph<=0 && _dt>0) {
    var _active_dt=min(life,_dt);
    life=max(0,life-_active_dt);
    close_elapsed=min(close_duration,close_elapsed+_active_dt);
    heading=lerp(start_heading,target_heading,close_elapsed/close_duration);
    sweep_delta=heading-prev_heading;
    if(life<=0) { instance_destroy();exit; }
}
end_x=x+lengthdir_x(beam_length,heading);end_y=y+lengthdir_y(beam_length,heading);
image_blend=c_white;tint=c_white;
