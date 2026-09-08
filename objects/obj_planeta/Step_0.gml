if(gm.state!="playing") exit;
hit_timer=max(0,hit_timer-flux_dt());
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

if(attack_state!="active") exit;
var _dt=flux_world_dt();
fire_timer-=_dt;
switch(pattern) {
    case 0: // A: brazos giratorios, proyectiles con una curva ligera.
        phase=(phase+spin_sign*95*_dt+360) mod 360;
        if(fire_timer<=0) {
            fire_timer+=spiral_interval;
            for(var _i=0;_i<spiral_arms;++_i) {
                var _heading=phase+_i*360/spiral_arms;
                emit_bullet(_heading,projectile_speed,image_blend,spin_sign*9);
            }
        }
        break;
    case 1: // B: el objeto láser controla su propio barrido continuo.
        break;
    case 2: // C: salvas de tres tiros que interceptan la órbita futura.
        if(fire_timer<=0 && instance_exists(obj_nave)) {
            fire_timer+=geyser_interval;
            var _ship=instance_find(obj_nave,0);
            var _speed=projectile_speed*1.65;
            // Trayecto radial hasta la órbita. Nave en tiempo normal, bala en tiempo del nivel.
            var _flight=(gm.orbit_radius-radius-8)/(_speed*max(0.01,gm.world_scale));
            var _future=_ship.orbit_angle+_ship.orbit_direction*gm.stats.angular_speed*_flight;
            var _colour=make_color_hsv((gm.last_planet_hue+100) mod 256,255,255);
            for(var _i=-1;_i<=1;++_i) emit_bullet(_future+_i*7,_speed,_colour,0);
        }
        break;
}
