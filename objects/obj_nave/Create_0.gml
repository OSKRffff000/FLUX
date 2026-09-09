gm = global.flux;
orbit_angle = 0; orbit_direction = 0;
hit_radius = 8; shot_timer = 0;

buffs=[];
for(var _i=0;_i<FluxBuff.Count;++_i) array_push(buffs,{remaining:0,duration:1});
shield_charges=0; bombard_timer=0; laser_on=false;
buff_active=function(_kind) { return buffs[_kind].remaining>0; };
apply_buff=function(_kind) {
    var _duration=gm.stats.duration;
    if(_kind==FluxBuff.Fantasma) _duration*=0.6;
    buffs[_kind].duration=_duration;buffs[_kind].remaining=_duration;
    if(_kind==FluxBuff.Escudo) shield_charges=1; // Nunca acumula salud.
    if(gm.evolution==4) {
        var _wave=instance_create_depth(x,y,-30,obj_onda);_wave.cleans=true;_wave.limit=1500;
    }
};
lethal_hit=function(_source) {
    if(buff_active(FluxBuff.Fantasma)) return false;
    if(shield_charges>0 && buff_active(FluxBuff.Escudo)) {
        shield_charges=0;buffs[FluxBuff.Escudo].remaining=0;
        if(instance_exists(_source)) with(_source) instance_destroy();
        flux_burst(x,y,c_white,24);return false;
    }
    if(!instance_exists(obj_secuencia_muerte)) instance_create_depth(0,0,-1000,obj_secuencia_muerte);
    return true;
};
fire_bullet=function(_x,_y,_missile) {
    var _p=instance_create_depth(_x,_y,-5,obj_disparo);
    _p.heading=point_direction(_x,_y,gm.center_x,gm.center_y);
    _p.damage=gm.stats.damage*(random(1)<gm.stats.crit ? 2 : 1);
    _p.piercing=buff_active(FluxBuff.Perforante);_p.missile=_missile;
    if(_missile) { _p.velocity=380;_p.radius=6;_p.damage*=2; }
    return _p;
};
x = gm.center_x + lengthdir_x(gm.orbit_radius, orbit_angle);
y = gm.center_y + lengthdir_y(gm.orbit_radius, orbit_angle);
prev_x = x; prev_y = y;
