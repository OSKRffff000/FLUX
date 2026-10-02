if(global.flux.state!="playing") exit;
var _px=x,_py=y;age+=flux_dt();
if(trail) {
    array_push(trail_points,{px:x,py:y});
    if(array_length(trail_points)>6) array_delete(trail_points,0,1);
}
x+=lengthdir_x(velocity*flux_dt(),heading);y+=lengthdir_y(velocity*flux_dt(),heading);
if(instance_exists(obj_planeta)) {
    var _p=instance_find(obj_planeta,0);
    if(hit_planet!=_p && flux_segment_hit(_px-_p.x,_py-_p.y,x-_p.x,y-_p.y,_p.radius+radius)) {
        hit_planet=_p;
        var _was_alive=_p.hp>0;
        _p.receive_damage(damage);flux_burst(x,y,c_white,3);
        if(_was_alive) {
            var _angle=point_direction(_p.x,_p.y,x,y);
            flux_hit_feedback(_p.x+lengthdir_x(_p.radius,_angle),_p.y+lengthdir_y(_p.radius,_angle),critical);
        }
        if(is_bomb) {
            // Primer contacto barrido: evita colocar el efecto dentro del planeta
            // cuando el proyectil avanza varios píxeles durante este frame.
            var _dx=x-_px,_dy=y-_py;
            var _fx=_px-_p.x,_fy=_py-_p.y;
            var _rr=_p.radius+radius;
            var _aa=_dx*_dx+_dy*_dy;
            var _bb=2*(_fx*_dx+_fy*_dy);
            var _cc=_fx*_fx+_fy*_fy-_rr*_rr;
            var _t=0;
            if(_aa>0.000001 && _cc>0)
                _t=clamp((-_bb-sqrt(max(0,_bb*_bb-4*_aa*_cc)))/(2*_aa),0,1);
            var _contact_angle=point_direction(_p.x,_p.y,_px+_dx*_t,_py+_dy*_t);
            var _hit_x=_p.x+lengthdir_x(_p.radius,_contact_angle);
            var _hit_y=_p.y+lengthdir_y(_p.radius,_contact_angle);
            flux_play_sfx(snd_bombas,8);
            global.flux.add_bomb_shake(1.8);
            instance_create_depth(_hit_x,_hit_y,-35,obj_efecto_impacto_bomba);
        }
        if(missile) flux_explosion(x,y,160);
        if(!piercing) { instance_destroy();exit; }
    }
}
if(x< -80 || x>room_width+80 || y< -80 || y>room_height+80) instance_destroy();
