gm=global.flux;radius=62;
// Balance: 600, 768, 984, 1259... puntos. Sin depender del daño del jugador.
base_hp=50;health_multiplier=1.28;
max_hp=ceil(base_hp*power(health_multiplier,min(gm.stage-1,200)));hp=max_hp;
var _hue=gm.last_planet_hue<0 ? irandom(255) : (gm.last_planet_hue+irandom_range(35,220)) mod 256;
gm.last_planet_hue=_hue;image_blend=make_color_hsv(_hue,255,255);
// alarm[0] bombea el reloj en segundos para respetar pausa y Distorsión.
attack_state="cooldown";cooldown=0.8;pattern=-1;last_pattern=-1;
pattern_remaining=0;fire_timer=0;phase=random(360);spin_sign=choose(-1,1);
projectile_speed=min(320,155+gm.stage*6);
spiral_arms=min(8,4+floor((gm.stage-1)/3));
spiral_interval=max(0.10,0.22-(gm.stage-1)*0.008);
geyser_interval=max(0.32,0.65-(gm.stage-1)*0.015);
laser_ids=[];alarm[0]=1;
emit_bullet=function(_heading,_speed,_colour,_curve) {
    var _p=instance_create_depth(x+lengthdir_x(radius+8,_heading),y+lengthdir_y(radius+8,_heading),-3,obj_proyectil_espiral);
    _p.heading=_heading;_p.velocity=_speed;_p.turn_rate=_curve;
    _p.image_blend=_colour;_p.tint=_colour;
    flux_burst(_p.x,_p.y,_colour,2);
};

// Sprites: se usan los nombres existentes en este proyecto.
sprite_index=choose(spr_planeta1,spr_planeta2,spr_planeta3,spr_planeta4,spr_planeta5,spr_planeta6);
image_index=0;image_speed=1;
planet_scale=(radius*2)/max(sprite_get_width(sprite_index),sprite_get_height(sprite_index));
// Compensa incluso spr_planeta6, cuyo origen está en (0,0).
planet_offset_x=(sprite_get_xoffset(sprite_index)-sprite_get_width(sprite_index)*0.5)*planet_scale;
planet_offset_y=(sprite_get_yoffset(sprite_index)-sprite_get_height(sprite_index)*0.5)*planet_scale;
hit_timer=0;hit_duration=0.12;
receive_damage=function(_damage) {
    if(_damage<=0 || hp<=0) return;
    hp=max(0,hp-_damage);
    // No reiniciar continuamente: también parpadea bajo un láser sostenido.
    if(hit_timer<=0) hit_timer=hit_duration;
};
