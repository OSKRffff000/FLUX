gm = global.flux;
orbit_angle = 0; orbit_direction = 0;
hit_radius = 8; shot_timer = 0;
angular_velocity=0;last_input_direction=0;turn_immunity=0;turn_clean=false;
turn_echoes=[];
any_buff_active=function() {
    for(var _i=0;_i<FluxBuff.Count;++_i) if(buffs[_i].remaining>0) return true;
    return false;
};

buffs=[];
for(var _i=0;_i<FluxBuff.Count;++_i) array_push(buffs,{remaining:0,duration:1});
shield_charges=0; bombard_timer=0; laser_on=false;
buff_active=function(_kind) { return buffs[_kind].remaining>0; };
apply_buff=function(_kind) {
    var _duration=gm.stats.duration;
    if(_kind==FluxBuff.Fantasma) _duration*=0.6;
    buffs[_kind].duration=_duration;buffs[_kind].remaining=_duration;
    if(_kind==FluxBuff.Escudo) shield_charges=1; // Nunca acumula salud.
    if(gm.stats.pickup_points>0) { gm.coins+=gm.stats.pickup_points;gm.save_progress(); }
    if(gm.evolution==4) {
        var _wave=instance_create_depth(x,y,-30,obj_onda);_wave.cleans=true;_wave.limit=1500;
    }
};
lethal_hit=function(_source) {
    if(buff_active(FluxBuff.Fantasma) || turn_immunity>0 || turn_clean) return false;
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
    _p.critical=random(1)<gm.stats.crit;
    _p.damage=gm.stats.damage*(_p.critical ? gm.stats.crit_multiplier : 1);
    _p.velocity=gm.stats.projectile_speed;
    _p.radius=3*gm.stats.projectile_scale;
    _p.trail=gm.stats.bullet_trail;_p.crit_blink=gm.stats.crit_blink;_p.kinetic=gm.stats.kinetic_line;
    _p.piercing=buff_active(FluxBuff.Perforante);_p.missile=_missile;
    if(_missile) { _p.velocity=380*(1+gm.stats.speed_bonus);_p.radius=6*gm.stats.projectile_scale;_p.damage*=2; }
    return _p;
};
x = gm.center_x + lengthdir_x(gm.orbit_radius, orbit_angle);
y = gm.center_y + lengthdir_y(gm.orbit_radius, orbit_angle);
prev_x = x; prev_y = y;
