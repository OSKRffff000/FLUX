if(gm.state!="playing") exit;
hit_timer=max(0,hit_timer-flux_dt());
// Efecto de glitch digital y corrupción de datos (1 segundo exacto usando flux_dt())
if(glitch_timer>0) {
    var _dt=flux_dt();
    glitch_timer=max(0,glitch_timer-_dt);
    if(glitch_timer<=0) {
        // Estabilización de golpe al transcurrir 1 segundo exacto
        glitch_active=false;
        glitch_flash=false;
        glitch_offset_x=0;
        glitch_offset_y=0;
        glitch_scale_mod=1.0;
    } else {
        glitch_step_timer+=_dt;
        if(glitch_step_timer>=glitch_step_interval) {
            glitch_step_timer=0;
            glitch_seed=irandom(10000);
            
            // Fragmentación y desgarro horizontal (slices de datamoshing)
            var _neon_palette=[c_aqua,c_fuchsia,c_lime,c_yellow,c_white,c_black];
            for(var _s=0;_s<16;++_s) {
                if(random(1)<0.65) {
                    glitch_slice_shifts[_s]=choose(-36,-24,-14,14,24,36,-44,48);
                    glitch_slice_colors[_s]=_neon_palette[irandom(array_length(_neon_palette)-1)];
                } else {
                    glitch_slice_shifts[_s]=0;
                    glitch_slice_colors[_s]=c_white;
                }
            }
            // Aberración y desfasamiento global de canales
            glitch_offset_x=choose(-6,6,-3,3,0);
            glitch_offset_y=choose(-3,3,0);
            glitch_scale_mod=1.0+choose(-0.05,0.05,-0.02,0.02,0);
            glitch_flash=choose(true,false);
        }
    }
}
if(hp<=0) {
    gm.skill_points+=1;gm.coins+=20;++gm.stage;gm.save_progress();
    // Puntos adicionales coleccionables: el imán los atrae desde cualquier distancia.
    repeat(8) {
        var _a=random(360);
        instance_create_depth(x+lengthdir_x(80,_a),y+lengthdir_y(80,_a),-4,obj_punto);
    }
    flux_burst(x,y,image_blend,55);
    with(obj_ataque_planeta) instance_destroy();
    with(obj_laser_planeta) instance_destroy();
    gm.planet_delay=1; // El manager sobrevive para crear el sucesor tras 1 segundo.
    instance_destroy();exit;
}


var _dt=flux_world_dt();attack_clock+=_dt;
planet_shake_x=0;planet_shake_y=0;
for(var _i=0;_i<array_length(laser_ids);++_i) {
    if(instance_exists(laser_ids[_i]) && laser_ids[_i].telegraph<=0) {
        if(!instance_exists(obj_nave) || !obj_nave.buff_active(FluxBuff.Apagon)) {
            planet_shake_x=random_range(-4,4);planet_shake_y=random_range(-4,4);
        }
        break;
    }
}
if(attack_state!="active") exit;
fire_timer-=_dt;
switch(pattern) {
    case 0:
        phase=(phase+95*_dt) mod 360;
        if(fire_timer<=0) {
            fire_timer+=spiral_interval;
            for(var _i=0;_i<spiral_arms;++_i) {
                var _a=_i*360/spiral_arms;
                emit_bullet(_a+phase,projectile_speed,image_blend,9);
                emit_bullet(_a-phase+180/spiral_arms,projectile_speed,
                    make_color_hsv((gm.last_planet_hue+110) mod 256,255,255),-9);
            }
        }
        break;
    case 1:break;
    case 2:
        if(fire_timer<=0 && instance_exists(obj_nave)) {
            fire_timer+=max(0.65,geyser_interval);
            var _ship=instance_find(obj_nave,0),_speed=projectile_speed*1.65;
            var _flight=((gm.orbit_radius-radius-8)/_speed+0.55)/max(0.01,gm.world_scale);
            var _future=_ship.orbit_angle+_ship.orbit_direction*gm.stats.angular_speed*_flight;
            for(var _i=-1;_i<=1;++_i) {
                var _angle=_future+_i*7;
                var _p=emit_bullet(_angle,_speed,make_color_hsv((gm.last_planet_hue+100) mod 256,255,255),0);
                _p.telegraph=0.55;
                _p.warning_x=x+lengthdir_x(gm.orbit_radius,_angle);_p.warning_y=y+lengthdir_y(gm.orbit_radius,_angle);
            }
        }
        break;
    case 3:
        if(fire_timer<=0 && nova_ring<4) {
            fire_timer+=0.48;
            var _colour=make_color_hsv((gm.last_planet_hue+nova_ring*40) mod 256,255,255);
            // Sector de escape constante y anunciado: el anillo sigue siendo denso y evitable.
            for(var _i=0;_i<56;++_i) {
                var _angle=_i*360/56;
                if(abs(angle_difference(_angle,nova_gap))<18) continue;
                var _p=instance_create_depth(x+lengthdir_x(radius+10,_angle),y+lengthdir_y(radius+10,_angle),-3,obj_proyectil_supernova);
                _p.heading=_angle;_p.image_blend=_colour;_p.tint=_colour;
                _p.burst_speed=min(520,360+gm.stage*9);_p.pulse_phase=nova_ring*pi*0.5;
            }
            var _wave=instance_create_depth(x,y,-6,obj_onda_ataque);_wave.tint=_colour;
            gm.attack_impact(5,_colour,0.15);++nova_ring;
        }
        break;
    case 4:
        if(fire_timer<=0) {
            fire_timer+=0.65;
            for(var _i=0;_i<2;++_i) {
                var _angle=random(360);
                if(_i==0 && instance_exists(obj_nave)) _angle=obj_nave.orbit_angle+random_range(-25,25);
                var _ux=lengthdir_x(1,_angle),_uy=lengthdir_y(1,_angle);
                var _edge_x=abs(_ux)<0.00001 ? 100000 : ((_ux>0 ? room_width-x : x)/abs(_ux));
                var _edge_y=abs(_uy)<0.00001 ? 100000 : ((_uy>0 ? room_height-y : y)/abs(_uy));
                var _distance=min(_edge_x,_edge_y)+100;
                var _c=instance_create_depth(x+_ux*_distance,y+_uy*_distance,-3,obj_cometa_planeta);
                _c.owner=id;_c.heading=point_direction(_c.x,_c.y,x,y);
                _c.warning_x=x+lengthdir_x(gm.orbit_radius,_angle);_c.warning_y=y+lengthdir_y(gm.orbit_radius,_angle);
                _c.image_blend=make_color_hsv((gm.last_planet_hue+random_range(40,90)) mod 256,255,255);_c.tint=_c.image_blend;
            }
        }
        break;
}
