alarm[0]=1;
if(gm.state!="playing" || hp<=0) exit;
var _dt=flux_world_dt();
if(attack_state=="cooldown") {
    cooldown-=_dt;if(cooldown>0) exit;
    pattern=last_pattern<0 ? irandom(4) : (last_pattern+irandom_range(1,4)) mod 5;
    last_pattern=pattern;fire_timer=0;attack_clock=0;
    spin_sign=choose(-1,1);phase=random(360);nova_ring=0;
    nova_gap=instance_exists(obj_nave) ? obj_nave.orbit_angle : random(360);
    if(pattern==1) {
        flux_play_sfx(snd_laser,8);launch_laser_star();
        attack_state="active";pattern_remaining=7;
    } else {
        attack_state="warning";
        warning_total=pattern==3 ? 1 : 1.2;warning_remaining=warning_total;
        flux_play_sfx(snd_carga_laser,8);
    }
} else if(attack_state=="warning") {
    warning_remaining=max(0,warning_remaining-_dt);
    if(warning_remaining<=0) {
        attack_state="active";fire_timer=0;
        pattern_remaining=pattern==0 ? 4.5 : (pattern==3 ? 2.6 : 4);
        if(pattern==3) gm.attack_impact(12,c_white,0.45);
    }
} else {
    if(pattern==1) {
        var _alive=false;
        for(var _i=0;_i<array_length(laser_ids);++_i)
            if(instance_exists(laser_ids[_i])) { _alive=true;break; }
        pattern_remaining=_alive ? 1 : 0;
    } else pattern_remaining-=_dt;
    if(pattern_remaining<=0) {
        attack_state="cooldown";cooldown=max(1,1.8-gm.stage*0.035);
        for(var _i=0;_i<array_length(laser_ids);++_i) {
            var _laser=laser_ids[_i];
            if(instance_exists(_laser)) with(_laser) instance_destroy();
        }
        laser_ids=[];
    }
}
