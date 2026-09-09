alarm[0]=1;
if(gm.state!="playing" || hp<=0) exit;
var _dt=flux_world_dt();
if(attack_state=="cooldown") {
    cooldown-=_dt;
    if(cooldown>0) exit;
    // Aleatorio sin repetir inmediatamente: A=0, B=1, C=2.
    pattern=last_pattern<0 ? irandom(2) : (last_pattern+irandom_range(1,2)) mod 3;
    last_pattern=pattern;attack_state="active";fire_timer=0;
    spin_sign=choose(-1,1);phase=random(360);
    switch(pattern) {
        case 0: pattern_remaining=4.5;break;
        case 1:
            pattern_remaining=6;
            laser_ids=[];
            // Fijar el ángulo objetivo al anunciar la pinza permite escapar cambiando de lado.
            var _target=instance_exists(obj_nave) ? obj_nave.orbit_angle : random(360);
            flux_play_sfx(snd_laser,8);
            for(var _side=-1;_side<=1;_side+=2) {
                var _laser=instance_create_depth(x,y,20,obj_laser_planeta);
                _laser.owner=id;_laser.telegraph=2;_laser.life=4;
                _laser.target_heading=_target;
                _laser.start_heading=_target+_side*70;
                _laser.heading=_laser.start_heading;
                _laser.prev_heading=_laser.heading;
                _laser.close_duration=4;
                _laser.end_x=x+lengthdir_x(_laser.beam_length,_laser.heading);
                _laser.end_y=y+lengthdir_y(_laser.beam_length,_laser.heading);
                array_push(laser_ids,_laser);
            }
            break;
        case 2: pattern_remaining=4;break;
    }
} else {
    if(pattern==1) {
        // Los haces son dueños del reloj 2 + 4 s: no truncarlos desde Alarm.
        var _alive=false;
        for(var _i=0;_i<array_length(laser_ids);++_i)
            if(instance_exists(laser_ids[_i])) { _alive=true;break; }
        pattern_remaining=_alive ? 1 : 0;
    } else pattern_remaining-=_dt;
    if(pattern_remaining<=0) {
        attack_state="cooldown";cooldown=max(0.65,1.4-gm.stage*0.035);
        for(var _i=0;_i<array_length(laser_ids);++_i) {
            var _laser=laser_ids[_i];
            if(instance_exists(_laser)) with(_laser) instance_destroy();
        }
        laser_ids=[];
    }
}
