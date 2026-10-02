if(global.flux.state!="playing") exit;
if(!instance_exists(owner)) { instance_destroy();exit; }
var _was_warning=telegraph>0;
event_inherited();
if(_was_warning) exit;
if(flux_segment_hit(prev_x-owner.x,prev_y-owner.y,x-owner.x,y-owner.y,owner.radius+radius)) {
    var _angle=point_direction(owner.x,owner.y,prev_x,prev_y);
    var _hit_x=owner.x+lengthdir_x(owner.radius,_angle),_hit_y=owner.y+lengthdir_y(owner.radius,_angle);
    global.flux.attack_impact(14,image_blend,0.62);
    flux_play_sfx(snd_bombas,8);flux_burst(_hit_x,_hit_y,image_blend,45);
    var _wave=instance_create_depth(_hit_x,_hit_y,-35,obj_onda_ataque);
    _wave.tint=image_blend;_wave.limit=420;
    instance_destroy();
}
