if(gm.state!="playing") exit;
// Recoger primero permite utilizar un escudo atrapado en este mismo frame.
with(obj_buff) {
    if(flux_segment_hit(prev_x-other.prev_x,prev_y-other.prev_y,x-other.x,y-other.y,radius+other.gm.stats.pickup_radius)) {
        other.apply_buff(kind);flux_burst(x,y,c_white,12);instance_destroy();
    }
}
// Iteración inversa: consumir un escudo puede eliminar el ataque actual.
for(var _i=instance_number(obj_ataque_planeta)-1;_i>=0;--_i) {
    var _a=instance_find(obj_ataque_planeta,_i);
    if(flux_segment_hit(_a.prev_x-prev_x,_a.prev_y-prev_y,_a.x-x,_a.y-y,hit_radius+_a.radius)) {
        if(lethal_hit(_a)) exit;
    }
}
if(!buff_active(FluxBuff.Apagon)) {
    for(var _i=instance_number(obj_laser_planeta)-1;_i>=0;--_i) {
        var _a=instance_find(obj_laser_planeta,_i);
        if(_a.telegraph<=0 && flux_sweep_hit(_a,id)) {
            if(lethal_hit(_a)) exit;
        }
    }
}
