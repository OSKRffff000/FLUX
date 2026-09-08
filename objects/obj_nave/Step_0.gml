if(gm.state!="playing") exit;
var _dt=flux_dt(); prev_x=x;prev_y=y;
var _touch=device_mouse_check_button(0,mb_left);
var _left=keyboard_check(vk_left) || (_touch && device_mouse_x(0)<room_width/2);
var _right=keyboard_check(vk_right) || (_touch && device_mouse_x(0)>=room_width/2);
// Entradas opuestas simultáneas se neutralizan; sin entrada no hay movimiento.
orbit_direction=(_right ? 1 : 0)-(_left ? 1 : 0);
orbit_angle=(orbit_angle+orbit_direction*gm.stats.angular_speed*_dt+360) mod 360;
x=gm.center_x+lengthdir_x(gm.orbit_radius,orbit_angle);
y=gm.center_y+lengthdir_y(gm.orbit_radius,orbit_angle);
var _rate=gm.stats.rate*(buff_active(FluxBuff.Frenesi) ? 2 : 1);
laser_on=gm.evolution==1 && instance_exists(obj_planeta);
if(laser_on) {
    var _planet=instance_find(obj_planeta,0);
    _planet.receive_damage(gm.stats.damage*_rate*(1+gm.stats.crit)*_dt);
}
shot_timer-=_dt;
if(shot_timer<=0) {
    shot_timer+=1/_rate;
    if(gm.evolution!=1) {
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
