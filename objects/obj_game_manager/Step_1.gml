world_scale=1;
if(state!="playing") exit;
with(obj_nave) {
    for(var _i=0;_i<FluxBuff.Count;++_i) buffs[_i].remaining=max(0,buffs[_i].remaining-flux_dt());
    if(buffs[FluxBuff.Escudo].remaining<=0) shield_charges=0;
    if(buff_active(FluxBuff.Tiempo)) other.world_scale=0.35;
}
if(planet_delay>=0) {
    planet_delay-=delta_time/1000000; // Un segundo real de juego activo, incluso con distorsión.
    if(planet_delay<=0) {
        planet_delay=-1;
        instance_create_depth(center_x,center_y,10,obj_planeta);
    }
}
