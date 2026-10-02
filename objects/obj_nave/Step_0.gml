if(gm.state!="playing") exit;
var _dt=flux_dt(); prev_x=x;prev_y=y;
var _touch=device_mouse_check_button(0,mb_left) && !gm.block_gameplay_touch;
var _left=keyboard_check(vk_left) || (_touch && device_mouse_x(0)<room_width/2);
var _right=keyboard_check(vk_right) || (_touch && device_mouse_x(0)>=room_width/2);
turn_immunity=max(0,turn_immunity-_dt);turn_clean=false;
for(var _e=array_length(turn_echoes)-1;_e>=0;--_e) {
    turn_echoes[_e].life-=_dt;
    if(turn_echoes[_e].life<=0) array_delete(turn_echoes,_e,1);
}
var _input=(_right ? 1 : 0)-(_left ? 1 : 0);
if(_input!=0) {
    if(last_input_direction!=0 && _input!=last_input_direction) {
        turn_immunity=gm.stats.turn_iframes;turn_clean=gm.stats.clean_turn;
        if(gm.stats.turn_trail) array_push(turn_echoes,{px:x,py:y,angle:point_direction(x,y,gm.center_x,gm.center_y),life:0.2});
        if(gm.stats.micro_jump>0) orbit_angle-=last_input_direction*gm.stats.micro_jump/gm.orbit_radius*180/pi;
    }
    last_input_direction=_input;
    angular_velocity=_input*gm.stats.angular_speed;
} else if(gm.stats.coast_brake && !_left && !_right) {
    // Con Gravedad Asistida, reduce 20% por frame equivalente a 60 Hz.
    angular_velocity*=power(0.8,_dt*60);
    if(abs(angular_velocity)<0.05) angular_velocity=0;
} else angular_velocity=0;
orbit_direction=angular_velocity/gm.stats.angular_speed;
orbit_angle=(orbit_angle+angular_velocity*_dt+360) mod 360;
x=gm.center_x+lengthdir_x(gm.orbit_radius,orbit_angle);
y=gm.center_y+lengthdir_y(gm.orbit_radius,orbit_angle);
var _rate=gm.stats.rate*(buff_active(FluxBuff.Frenesi) ? 2 : 1);
laser_on=gm.evolution==1 && instance_exists(obj_planeta);
shot_timer-=_dt;
// Recupera todos los disparos vencidos: Rayo Cinético no queda limitado al framerate.
while(shot_timer<=0) {
    shot_timer+=1/_rate;
    if(laser_on) {
        var _planet=instance_find(obj_planeta,0);
        var _critical=random(1)<gm.stats.crit;
        var _alive=_planet.hp>0;
        _planet.receive_damage(gm.stats.damage*(_critical ? gm.stats.crit_multiplier : 1));
        if(_alive) flux_hit_feedback(_planet.x+lengthdir_x(_planet.radius,orbit_angle),
            _planet.y+lengthdir_y(_planet.radius,orbit_angle),_critical);
    } else if(gm.evolution!=1) {
        var _count=gm.evolution==0 ? 3 : 1;
        var _aim=point_direction(x,y,gm.center_x,gm.center_y);
        for(var _i=0;_i<_count;++_i) {
            var _offset=(_i-(_count-1)*0.5)*14;
            fire_bullet(x+lengthdir_x(_offset,_aim+90),y+lengthdir_y(_offset,_aim+90),gm.evolution==3);
        }
    }
}
if(buff_active(FluxBuff.Bombardeo)) {
    bombard_timer-=_dt;
    if(bombard_timer<=0) {
        bombard_timer=0.18;
        var _angle=random(360);
        var _bomb=fire_bullet(gm.center_x+lengthdir_x(gm.orbit_radius+80,_angle),gm.center_y+lengthdir_y(gm.orbit_radius+80,_angle),false);
        _bomb.is_bomb=true;
    }
} else bombard_timer=0;
