function flux_dt() { return min(delta_time / 1000000, 1 / 30); }
// Distancia de un segmento al origen: colisión barrida sin máscaras de sprite.
function flux_segment_hit(_ax, _ay, _bx, _by, _radius) {
    var _dx = _bx - _ax, _dy = _by - _ay;
    var _t = clamp(-(_ax * _dx + _ay * _dy) / max(0.00001, _dx * _dx + _dy * _dy), 0, 1);
    return point_distance(0, 0, _ax + _dx * _t, _ay + _dy * _t) <= _radius;
}
function flux_burst(_x, _y, _colour, _count) {
    repeat (_count) {
        var _p = instance_create_depth(_x, _y, -40, obj_fx);
        _p.tint = _colour;
    }
}
function flux_button(_x, _y, _w, _h, _label, _enabled) {
    draw_set_color(_enabled ? c_white : c_gray);
    draw_rectangle(_x, _y, _x + _w, _y + _h, true);
    draw_set_halign(fa_center); draw_set_valign(fa_middle);
    draw_text(_x + _w / 2, _y + _h / 2, _label);
    draw_set_halign(fa_left); draw_set_valign(fa_top);
}
function flux_inside(_x, _y, _w, _h) {
    var _mx = device_mouse_x_to_gui(0), _my = device_mouse_y_to_gui(0);
    return point_in_rectangle(_mx, _my, _x, _y, _x + _w, _y + _h);
}

// IDs compartidos por recogibles, nave y HUD.
enum FluxBuff { Frenesi, Perforante, Bombardeo, Escudo, Apagon, Fantasma, Tiempo, Iman, Count }
function flux_world_dt() { return flux_dt() * global.flux.world_scale; }
function flux_arc(_x,_y,_radius,_fraction,_width) {
    var _degrees=360*clamp(_fraction,0,1);
    var _steps=ceil(_degrees/5);
    for (var _i=0; _i<_steps; ++_i) {
        var _a=90-min(_degrees,_i*5), _b=90-min(_degrees,(_i+1)*5);
        draw_line_width(_x+lengthdir_x(_radius,_a),_y+lengthdir_y(_radius,_a),
            _x+lengthdir_x(_radius,_b),_y+lengthdir_y(_radius,_b),_width);
    }
}
function flux_buff_icon(_x,_y,_kind,_size) {
    // Glifos monocromáticos independientes de fuentes y sprites.
    var _r=_size*0.5;
    switch (_kind) {
        case FluxBuff.Frenesi:
            for (var _i=-1;_i<=1;_i+=2) {
                draw_line_width(_x+_i*5,_y+_r,_x+_i*5,_y-_r,3);
                draw_line_width(_x+_i*5,_y-_r,_x+_i*5-4,_y-_r+5,2);
            } break;
        case FluxBuff.Perforante:
            draw_circle(_x,_y,_r*0.7,true); draw_line_width(_x-_r,_y,_x+_r,_y,3); break;
        case FluxBuff.Bombardeo:
            for(var _i=-1;_i<=1;++_i) draw_circle(_x+_i*8,_y+abs(_i)*6,3,false); break;
        case FluxBuff.Escudo:
            draw_triangle(_x-_r,_y-_r,_x+_r,_y-_r,_x,_y+_r,true); break;
        case FluxBuff.Apagon:
            draw_line_width(_x-_r,_y-_r,_x+_r,_y+_r,3);
            draw_line_width(_x+_r,_y-_r,_x-_r,_y+_r,3); break;
        case FluxBuff.Fantasma:
            draw_circle(_x,_y-3,_r*0.7,true); draw_line(_x-_r*0.7,_y,_x-_r*0.7,_y+_r); break;
        case FluxBuff.Tiempo:
            draw_circle(_x,_y,_r,true); draw_line(_x,_y,_x,_y-_r*0.7);draw_line(_x,_y,_x+_r*0.6,_y);break;
        case FluxBuff.Iman:
            draw_line_width(_x-_r,_y-_r,_x-_r,_y+_r,3);draw_line_width(_x+_r,_y-_r,_x+_r,_y+_r,3);
            draw_line_width(_x-_r,_y+_r,_x+_r,_y+_r,3);break;
    }
}
function flux_draw_ship(_x,_y,_type,_angle,_scale,_alpha,_split=0) {
    var _sprite=global.flux.ship_sprites[_type+1];
    var _width=sprite_get_width(_sprite),_height=sprite_get_height(_sprite);
    _scale*=global.flux.ship_draw_scale;
    _angle-=90; // El arte apunta arriba; el angulo de disparo usa 0 a la derecha.
    if(_split<=0) {
        // Centrar el lienzo sin cambiar el origen del recurso ni la colision.
        var _ox=(sprite_get_xoffset(_sprite)-_width*0.5)*_scale;
        var _oy=(sprite_get_yoffset(_sprite)-_height*0.5)*_scale;
        draw_sprite_ext(_sprite,0,
            _x+lengthdir_x(_ox,_angle)+lengthdir_x(_oy,_angle-90),
            _y+lengthdir_y(_ox,_angle)+lengthdir_y(_oy,_angle-90),
            _scale,_scale,_angle,c_white,_alpha);
    } else {
        // Muerte: separar las alas usando las dimensiones reales del sprite.
        // draw_sprite_general ignora el origen; cada recorte parte de su esquina.
        var _half=floor(_width*0.5);
        for(var _i=0;_i<2;++_i) {
            var _left=_i*_half,_part_width=(_i==0 ? _half : _width-_half);
            var _side=_i*2-1;
            var _ox=(_left-_width*0.5)*_scale+_side*_split;
            var _oy=-_height*0.5*_scale-_side*2;
            draw_sprite_general(_sprite,0,_left,0,_part_width,_height,
                _x+lengthdir_x(_ox,_angle)+lengthdir_x(_oy,_angle-90),
                _y+lengthdir_y(_ox,_angle)+lengthdir_y(_oy,_angle-90),
                _scale,_scale,_angle,c_white,c_white,c_white,c_white,_alpha);
        }
    }
}
function flux_explosion(_x,_y,_radius) {
    with(obj_ataque_planeta) {
        if(point_distance(x,y,_x,_y)<=_radius+radius) { flux_burst(x,y,tint,4);instance_destroy(); }
    }
    with(obj_laser_planeta) {
        if(flux_segment_hit(x-_x,y-_y,end_x-_x,end_y-_y,_radius+beam_width)) {
            flux_burst((_x+x)*0.5,(_y+y)*0.5,tint,10);instance_destroy();
        }
    }
    var _wave=instance_create_depth(_x,_y,-30,obj_onda);_wave.limit=_radius;
}
// Dos segmentos: intersección o proximidad de cualquiera de sus extremos.
function flux_segments_near(_ax,_ay,_bx,_by,_cx,_cy,_dx,_dy,_r) {
    var _ux=_bx-_ax,_uy=_by-_ay,_vx=_dx-_cx,_vy=_dy-_cy;
    var _den=_ux*_vy-_uy*_vx;
    if(abs(_den)>0.00001) {
        var _wx=_cx-_ax,_wy=_cy-_ay;
        var _t=(_wx*_vy-_wy*_vx)/_den,_u=(_wx*_uy-_wy*_ux)/_den;
        if(_t>=0 && _t<=1 && _u>=0 && _u<=1) return true;
    }
    return flux_segment_hit(_ax-_cx,_ay-_cy,_bx-_cx,_by-_cy,_r)
        || flux_segment_hit(_ax-_dx,_ay-_dy,_bx-_dx,_by-_dy,_r)
        || flux_segment_hit(_cx-_ax,_cy-_ay,_dx-_ax,_dy-_ay,_r)
        || flux_segment_hit(_cx-_bx,_cy-_by,_dx-_bx,_dy-_by,_r);
}

function flux_sweep_hit(_laser,_ship) {
    var _travel=point_distance(_ship.prev_x,_ship.prev_y,_ship.x,_ship.y)
        +abs(_laser.sweep_delta)*pi/180*global.flux.orbit_radius;
    var _samples=max(1,ceil(_travel/2));
    for(var _i=0;_i<=_samples;++_i) {
        var _t=_i/_samples;
        var _sx=lerp(_ship.prev_x,_ship.x,_t),_sy=lerp(_ship.prev_y,_ship.y,_t);
        var _angle=_laser.prev_heading+_laser.sweep_delta*_t;
        var _ex=_laser.x+lengthdir_x(_laser.beam_length,_angle);
        var _ey=_laser.y+lengthdir_y(_laser.beam_length,_angle);
        if(flux_segment_hit(_laser.x-_sx,_laser.y-_sy,_ex-_sx,_ey-_sy,
            _ship.hit_radius+_laser.beam_width*0.5+1)) return true;
    }
    return false;
}

// Recursos reales de Sounds: snd_menu_seleccion, snd_menu y snd_playing.
function flux_click_inside(_x,_y,_w,_h) {
    if(!flux_inside(_x,_y,_w,_h)) return false;
    flux_play_sfx(snd_menu_seleccion,10);
    return true;
}

function flux_play_sfx(_sound,_priority) {
    var _voice=audio_play_sound(_sound,_priority,false);
    audio_sound_gain(_voice,global.vol_sfx,0);
    array_push(global.flux.sfx_voices,_voice);
    return _voice;
}
