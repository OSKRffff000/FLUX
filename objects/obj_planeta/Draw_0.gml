if(gm.state!="playing" && gm.state!="dead" && gm.state!="dying") exit;
var _old_colour=draw_get_color(),_old_alpha=draw_get_alpha();
var _health=clamp(hp/max_hp,0,1);
var _inner=radius+16;
var _outer=lerp(_inner,max(_inner,gm.orbit_radius),_health);
// Banda completa: borde interior fijo y grosor proporcional a la vida.
if(_outer>_inner) {
    draw_set_color(merge_color(make_color_rgb(230,230,230),make_color_rgb(240,90,90),1-_health));
    draw_set_alpha(0.14);
    draw_primitive_begin(pr_trianglestrip);
    for(var _i=0;_i<=128;++_i) {
        var _angle=_i*360/128;
        draw_vertex(x+lengthdir_x(_inner,_angle),y+lengthdir_y(_inner,_angle));
        draw_vertex(x+lengthdir_x(_outer,_angle),y+lengthdir_y(_outer,_angle));
    }
    draw_primitive_end();
}
// Ornamento detrás del sprite mientras exista alguno de los dos haces.
var _laser_visible=false;var _firing=false;var _pulse_time=0;
for(var _i=0;_i<array_length(laser_ids);++_i) {
    if(instance_exists(laser_ids[_i])) {
        var _laser=laser_ids[_i];_laser_visible=true;
        if(_laser.telegraph<=0) { _firing=true;_pulse_time=_laser.close_elapsed; }
    }
}
if(instance_exists(obj_nave) && obj_nave.buff_active(FluxBuff.Apagon)) _laser_visible=false;
if(_laser_visible) {
    var _pulse_radius=radius+12+(_firing ? 10+10*sin(_pulse_time*2*pi*2.5) : 0);
    draw_set_color(c_white);draw_set_alpha(0.22);
    draw_circle(x,y,_pulse_radius,false);
    draw_set_alpha(0.65);flux_arc(x,y,_pulse_radius+2,1,3);
}
// Base con efecto de glitch digital y corrupción de datos (primer segundo) o renderizado normal estable
if(glitch_timer>0) {
    var _cur_scale=planet_scale*glitch_scale_mod;
    var _spr_w=sprite_get_width(sprite_index);
    var _spr_h=sprite_get_height(sprite_index);
    var _draw_ox=x+planet_offset_x+planet_shake_x+glitch_offset_x;
    var _draw_oy=y+planet_offset_y+planet_shake_y+glitch_offset_y;
    var _base_x=_draw_ox-sprite_get_xoffset(sprite_index)*_cur_scale;
    var _base_y=_draw_oy-sprite_get_yoffset(sprite_index)*_cur_scale;
    
    // 1. Corrupción de color y canales desfasados (Chromatic Aberration / Split RGB)
    gpu_set_blendmode(bm_add);
    draw_sprite_ext(sprite_index,image_index,_draw_ox-8,_draw_oy,_cur_scale,_cur_scale,0,c_aqua,0.7);
    draw_sprite_ext(sprite_index,image_index,_draw_ox+8,_draw_oy,_cur_scale,_cur_scale,0,c_fuchsia,0.7);
    gpu_set_blendmode(bm_normal);
    
    // 2. Desplazamiento de bloques horizontales (Slice / Datamoshing de alta intensidad)
    var _slice_count=14;
    var _slice_h=ceil(_spr_h/_slice_count);
    for(var _i=0;_i<_slice_count;++_i) {
        var _top=_i*_slice_h;
        var _h=min(_slice_h,_spr_h-_top);
        if(_h<=0) break;
        var _shift=glitch_slice_shifts[_i];
        var _col=glitch_slice_colors[_i];
        
        // Franja principal desgarrada con tinte estridente / invertido
        draw_sprite_part_ext(sprite_index,image_index,0,_top,_spr_w,_h,
            _base_x+_shift,_base_y+_top*_cur_scale,
            _cur_scale,_cur_scale,_col,1);
            
        // Resplandor desfasado neón en franjas con desgarro pronunciado
        if(abs(_shift)>10) {
            gpu_set_blendmode(bm_add);
            draw_sprite_part_ext(sprite_index,image_index,0,_top,_spr_w,_h,
                _base_x+_shift*1.3,_base_y+_top*_cur_scale,
                _cur_scale,_cur_scale,(_shift>0 ? c_lime : c_yellow),0.6);
            gpu_set_blendmode(bm_normal);
        }
    }
    
    // 3. Píxeles muertos, estática y bloques tipo checkerboard (ajedrezado digital)
    var _prev_c=draw_get_color(),_prev_a=draw_get_alpha();
    
    // Bloques ajedrezados digitales intermitentes (checkerboard)
    var _cb_zones=[
        { bx: x-32+((glitch_seed*17) mod 44), by: y-28+((glitch_seed*31) mod 36), cols: 4, rows: 4, sz: 8 },
        { bx: x-18+((glitch_seed*43) mod 40), by: y-8+((glitch_seed*23) mod 32), cols: 5, rows: 3, sz: 7 }
    ];
    for(var _z=0;_z<array_length(_cb_zones);++_z) {
        var _zone=_cb_zones[_z];
        for(var _cr=0;_cr<_zone.rows;++_cr) {
            for(var _cc=0;_cc<_zone.cols;++_cc) {
                var _is_white=((_cr+_cc+(glitch_seed mod 2)) mod 2 == 0);
                draw_set_color(_is_white ? c_white : c_black);
                draw_set_alpha(0.92);
                draw_rectangle(_zone.bx+_cc*_zone.sz,_zone.by+_cr*_zone.sz,
                    _zone.bx+(_cc+1)*_zone.sz-1,_zone.by+(_cr+1)*_zone.sz-1,false);
            }
        }
    }
    
    // Destellos de píxeles muertos y paquetes de datos corruptos
    var _block_palette=[c_black,c_white,c_black,c_lime,c_fuchsia,c_aqua,c_yellow];
    for(var _b=0;_b<9;++_b) {
        var _ang=((glitch_seed*(13+_b*7)) mod 360);
        var _dist=((glitch_seed*(7+_b*5)) mod (radius-6));
        var _px=x+lengthdir_x(_dist,_ang);
        var _py=y+lengthdir_y(_dist,_ang);
        var _bw=4+((glitch_seed+_b*3) mod 18);
        var _bh=3+((glitch_seed+_b*5) mod 12);
        var _b_color=_block_palette[(_b+glitch_seed) mod array_length(_block_palette)];
        draw_set_color(_b_color);
        draw_set_alpha(0.85);
        draw_rectangle(_px,_py,_px+_bw,_py+_bh,false);
    }
    
    // Líneas horizontales de estática y dropout de señal de video digital
    for(var _ln=0;_ln<3;++_ln) {
        var _ly=y-radius+((glitch_seed*(29+_ln*17)) mod (radius*2));
        var _lx1=x-radius+((glitch_seed+_ln*11) mod 20)-10;
        var _lx2=x+radius+((glitch_seed+_ln*13) mod 20)-10;
        draw_set_color(choose(c_white,c_black,c_aqua));
        draw_set_alpha(0.8);
        draw_line_width(_lx1,_ly,_lx2,_ly,choose(1,2));
    }
    draw_set_color(_prev_c);draw_set_alpha(_prev_a);
} else {
    // Tras 1 segundo: glitch detenido de golpe, sprite vuelve a su aspecto original y limpio (sin filtros de color)
    draw_sprite_ext(sprite_index,image_index,x+planet_offset_x+planet_shake_x,y+planet_offset_y+planet_shake_y,
        planet_scale,planet_scale,0,c_white,1);
}
if(hit_timer>0) {
    var _flash_alpha=0.3*clamp(hit_timer/hit_duration,0,1);
    draw_sprite_ext(sprite_index,image_index,x+planet_offset_x+planet_shake_x,y+planet_offset_y+planet_shake_y,
        planet_scale,planet_scale,0,c_red,_flash_alpha);
}
draw_set_color(_old_colour);draw_set_alpha(_old_alpha);

if(attack_state=="warning") {
    gpu_set_blendmode(bm_add);
    var _charge=1-warning_remaining/max(0.001,warning_total);
    var _pulse=0.35+0.65*abs(sin(attack_clock*20));
    draw_set_color(pattern==3 ? c_white : image_blend);
    draw_set_alpha(0.12+_charge*0.25);draw_circle(x,y,radius+20+_charge*60,false);
    draw_set_alpha(_pulse);flux_arc(x,y,radius+28+12*sin(attack_clock*12),1,5);
    if(pattern==3) {
        draw_set_alpha(0.35+0.65*_pulse);draw_circle(x,y,radius,false);
        // Bordes del sector de escape del próximo tren de anillos.
        for(var _side=-1;_side<=1;_side+=2) {
            var _a=nova_gap+_side*18;
            draw_line_width(x,y,x+lengthdir_x(gm.orbit_radius+60,_a),y+lengthdir_y(gm.orbit_radius+60,_a),3);
        }
    } else {
        for(var _i=0;_i<8;++_i) {
            var _a=phase+_i*45;
            draw_set_alpha(0.2*_pulse);draw_line_width(x,y,x+lengthdir_x(gm.orbit_radius,_a),y+lengthdir_y(gm.orbit_radius,_a),2);
        }
    }
    gpu_set_blendmode(bm_normal);draw_set_color(_old_colour);draw_set_alpha(_old_alpha);
}
