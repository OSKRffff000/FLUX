global.flux = id;
global.pausa=false;block_gameplay_touch=false;
global.vol_maestro=1;global.vol_musica=1;global.vol_sfx=1;
sfx_voices=[];
display_set_gui_size(720, 1280);
randomize();
state = "menu";
center_x = 360; center_y = 610; orbit_radius = 245;
coins = 0; skill_points = 0; spent_points = 0; stage = 1;
equipped_pet = -1; evolution = -1;

world_scale=1; planet_delay=-1; last_planet_hue=-1;
evolution_pending=-1; evolution_deferred=false; evolution_return="tree";
evolution_names=["Arsenal Pesado","Nucleo Energetico","Nave Nodriza","Bombardero Orbital","Cosechador Cosmico"];
evolution_descriptions=["Tres balas simultaneas hacia el planeta.","Laser continuo dirigido al centro.","Duplica las bonificaciones de la mascota equipada.","Misiles: explosion de radio 160 que destruye lasers.","Recoger buffs crea una onda que limpia proyectiles."];
buff_names=["Frenesi de Fuego","Municion Perforante","Bombardeo Aleatorio","Escudo de Energia","Apagon Defensivo","Fase Fantasma","Distorsion Temporal","Super Iman"];
notice = "";
branches=flux_upgrade_catalog();
upgrades_bought=0;
pets = [
    {name:"Eco", price:60, description:"Aumenta el dano de cada disparo un 15%.", stat:"damage", bonus:0.15, owned:false},
    {name:"Pulso", price:90, description:"Aumenta la frecuencia de disparo un 20%.", stat:"rate", bonus:0.20, owned:false},
    {name:"Luna", price:75, description:"Prolonga los potenciadores temporales un 30%.", stat:"duration", bonus:0.30, owned:false}
];
save_progress = function() {
    ini_open("flux_save.ini");
    ini_write_real("audio","master",global.vol_maestro);
    ini_write_real("audio","music",global.vol_musica);
    ini_write_real("audio","sfx",global.vol_sfx);
    ini_write_real("tree","version",2);
    ini_write_real("player", "coins", coins);
    ini_write_real("player", "points", skill_points);
    ini_write_real("player", "pet", equipped_pet);
    ini_write_real("player","evolution",evolution);
    ini_write_real("player","deferred",evolution_deferred);
    for (var _b = 0; _b < 5; ++_b)
        for (var _n = 0; _n < array_length(branches[_b].nodes); ++_n)
            ini_write_real("tree", string(_b)+"_"+string(_n), branches[_b].nodes[_n].purchased);
    for (var _p = 0; _p < array_length(pets); ++_p)
        ini_write_real("pets", string(_p), pets[_p].owned);
    ini_close();
};
rebuild_stats = function() {
    // Valores absolutos de cada nivel sobre la base; efectos secundarios se heredan.
    stats={damage:1,rate:4,angular_speed:65,crit:0,duration:6,pickup_radius:22,
        damage_bonus:0,size_bonus:0,interval_reduction:0,speed_bonus:0,orbit_bonus:0,
        duration_bonus:0,spawn_bonus:0,pickup_area:1,crit_multiplier:2,impact_shake:0,
        bullet_trail:false,kinetic_line:false,turn_iframes:0,turn_trail:false,
        coast_brake:false,clean_turn:false,micro_jump:0,crit_blink:false,
        crit_drop_chance:0,crit_flash:false,pickup_points:0,double_buff_chance:0,buff_double_points:false};
    spent_points=0;upgrades_bought=0;
    for(var _b=0;_b<array_length(branches);++_b) {
        branches[_b].spent=0;
        for(var _n=0;_n<array_length(branches[_b].nodes);++_n) {
            var _node=branches[_b].nodes[_n];
            var _open=_n==0 || branches[_b].nodes[_n-1].purchased;
            _node.state=_node.purchased ? "comprado" : (_open ? "disponible" : "bloqueado");
            if(!_node.purchased) continue;
            ++upgrades_bought;branches[_b].spent+=_node.cost;
            var _keys=variable_struct_get_names(_node.effect);
            for(var _k=0;_k<array_length(_keys);++_k)
                variable_struct_set(stats,_keys[_k],variable_struct_get(_node.effect,_keys[_k]));
        }
        spent_points+=branches[_b].spent;
    }
    stats.damage=1+stats.damage_bonus;
    stats.rate=4/max(0.05,1-stats.interval_reduction);
    stats.angular_speed=65*(1+stats.orbit_bonus);
    stats.duration=6*(1+stats.duration_bonus);
    stats.projectile_speed=650*(1+stats.speed_bonus);
    stats.projectile_scale=1+stats.size_bonus;
    stats.pickup_radius=(22+14)*sqrt(stats.pickup_area)-14;
    stats.buff_spawn_multiplier=1+stats.spawn_bonus;
    if(equipped_pet>=0) {
        var _pet=pets[equipped_pet];var _bonus=_pet.bonus*(evolution==2 ? 2 : 1);
        switch(_pet.stat) {
            case "damage":stats.damage*=1+_bonus;break;
            case "rate":stats.rate*=1+_bonus;break;
            case "duration":stats.duration*=1+_bonus;break;
        }
    }
    global.mejoras_adquiridas=upgrades_bought;
    global.estadisticas_nave=stats;
};

evaluate_evolution = function(_offer) {
    if(spent_points<15 || evolution>=0) { evolution_pending=-1; return; }
    var _best=0;
    for(var _b=1;_b<5;++_b) if(branches[_b].spent>branches[_best].spent) _best=_b;
    evolution_pending=_best; // Empates por orden de rama, estable y visible.
    if(_offer) { evolution_return=state; state="evolution"; }
};
buy_node = function(_b, _n) {
    if(_b<0 || _b>=array_length(branches) || _n<0 || _n>=array_length(branches[_b].nodes)) return false;
    var _node = branches[_b].nodes[_n];
    if (_node.purchased) { notice = "Ya comprado."; return false; }
    if (_node.requires >= 0 && !branches[_b].nodes[_node.requires].purchased) {
        notice = "Compra el nodo anterior de esta rama."; return false;
    }
    if (skill_points < _node.cost) { notice = "Faltan puntos de mejora."; return false; }
    skill_points -= _node.cost; branches[_b].nodes[_n].purchased = true;
    rebuild_stats(); evaluate_evolution(!evolution_deferred); save_progress(); notice = "Mejora adquirida."; return true;
};
buy_pet = function(_p) {
    if (!pets[_p].owned) {
        if (coins < pets[_p].price) { notice = "Faltan creditos."; return; }
        coins -= pets[_p].price; pets[_p].owned = true;
    }
    equipped_pet = _p; rebuild_stats(); save_progress(); notice = "Mascota equipada.";
};
start_run = function() {
    if(global.pausa) end_pause(false);
    with(obj_secuencia_muerte) instance_destroy();
    with(obj_fragmento_nave) instance_destroy();
    with (obj_nave) instance_destroy();
    with (obj_planeta) instance_destroy();
    with (obj_disparo) instance_destroy();
    with (obj_ataque_planeta) instance_destroy();
    with (obj_buff) instance_destroy();
    with (obj_spawner_buffs) instance_destroy();
    with (obj_fx) instance_destroy();
    with(obj_onda_ataque) instance_destroy();
    with (obj_efecto_impacto_bomba) instance_destroy();
    reset_camera();
    with (obj_laser_planeta) instance_destroy();
    with (obj_punto) instance_destroy();
    with (obj_onda) instance_destroy();
    planet_delay=-1; world_scale=1;
    rebuild_stats(); stage = 1; state = "playing"; notice = "";
    instance_create_depth(center_x, center_y, 10, obj_planeta);
    instance_create_depth(center_x + orbit_radius, center_y, -10, obj_nave);
    instance_create_depth(0, 0, 0, obj_spawner_buffs);
};
if (file_exists("flux_save.ini")) {
    ini_open("flux_save.ini");
    global.vol_maestro=clamp(ini_read_real("audio","master",1),0,1);
    global.vol_musica=clamp(ini_read_real("audio","music",1),0,1);
    global.vol_sfx=clamp(ini_read_real("audio","sfx",1),0,1);
    coins = max(0, floor(ini_read_real("player", "coins", 0)));
    skill_points = max(0, floor(ini_read_real("player", "points", 0)));
    for (var _b = 0; _b < 5; ++_b) {
        for (var _n = 0; _n < array_length(branches[_b].nodes); ++_n) {
            branches[_b].nodes[_n].purchased = ini_read_real("tree", string(_b)+"_"+string(_n), 0) == 1
                && (_n == 0 || branches[_b].nodes[_n - 1].purchased);
        }
    }
    for (var _p = 0; _p < array_length(pets); ++_p)
        pets[_p].owned = ini_read_real("pets", string(_p), 0) == 1;
    evolution=clamp(floor(ini_read_real("player","evolution",-1)),-1,4);
    evolution_deferred=ini_read_real("player","deferred",0)==1;
    equipped_pet = clamp(floor(ini_read_real("player", "pet", -1)), -1, array_length(pets)-1);
    if (equipped_pet >= 0 && !pets[equipped_pet].owned) equipped_pet = -1;
    ini_close();
}
rebuild_stats();

if(spent_points<15 && evolution>=0) { evolution=-1; rebuild_stats(); }
evaluate_evolution(false);
instance_create_depth(0,0,-100,obj_hud);
instance_create_depth(0,0,-110,obj_arbol_mejoras);

// Indice = evolution + 1: base (-1), luego las cinco ramas (0..4).
ship_sprites=[navedefault,NaveArsenalPesado,NaveNucleo,NaveNodriza,NaveBombardero,NaveCondensadorCosmico];
// Sprites de 70x70 a media escala: mantienen el tamano de juego aproximado.
ship_draw_scale=0.5;





// Cámara del mundo; GUI independiente y centro estable sin acumular desplazamientos.
world_camera=camera_create_view(0,0,room_width,room_height,0,noone,-1,-1,-1,-1);
view_enabled=true;view_visible[0]=true;view_camera[0]=world_camera;
view_xport[0]=0;view_yport[0]=0;
view_wport[0]=room_width;view_hport[0]=room_height;
camera_home_x=0;camera_home_y=0;
bomb_shake=0;bomb_offset_x=0;bomb_offset_y=0;
attack_shake=0;attack_flash=0;attack_flash_tint=c_white;
attack_impact=function(_shake,_tint,_flash) {
    attack_shake=min(20,attack_shake+_shake);
    attack_flash=max(attack_flash,_flash);attack_flash_tint=_tint;
};
add_bomb_shake=function(_amount) {
    bomb_shake=min(8,bomb_shake+max(0,_amount));
};
reset_camera=function() {
    bomb_shake=0;bomb_offset_x=0;bomb_offset_y=0;
attack_shake=0;attack_flash=0;attack_flash_tint=c_white;
    camera_set_view_pos(world_camera,camera_home_x,camera_home_y);
};
// BGM: sólo se detiene la instancia de música, no los efectos de interfaz.
bgm_instance=-1;bgm_asset=-1;
sync_music=function() {
    if(global.pausa) return;
    if(state!="playing") reset_camera();
    var _desired=state=="credits" ? snd_creditos : (state=="playing" ? snd_playing : snd_menu);
    if(bgm_asset==_desired && (state=="credits" || audio_is_playing(bgm_instance))) return;
    if(bgm_instance!=-1) audio_stop_sound(bgm_instance);
    bgm_asset=_desired;
    bgm_instance=audio_play_sound(bgm_asset,1,state!="credits");
    audio_sound_gain(bgm_instance,global.vol_musica,0);
};
audio_master_gain(global.vol_maestro);
sync_music();
apply_audio_settings=function() {
    // El master multiplica ambos canales desde el motor, una sola vez.
    audio_master_gain(global.vol_maestro);
    if(bgm_instance!=-1) audio_sound_gain(bgm_instance,global.vol_musica,0);
    for(var _i=array_length(sfx_voices)-1;_i>=0;--_i) {
        if(audio_is_playing(sfx_voices[_i])) audio_sound_gain(sfx_voices[_i],global.vol_sfx,0);
        else array_delete(sfx_voices,_i,1);
    }
};

instance_create_depth(0,0,-110,obj_menu_configuracion);
instance_create_depth(0,0,-120,obj_boton_reset);



instance_create_depth(0,0,-125,obj_menu_manager);

// Pausa selectiva: sólo se desactivan entidades de la partida, no los menús.
paused_instances=[];paused_voices=[];pause_snapshot=-1;
pause_world_objects=[obj_nave,obj_planeta,obj_disparo,obj_ataque_planeta,obj_laser_planeta,
    obj_buff,obj_spawner_buffs,obj_punto,obj_onda,obj_fx,obj_efecto_impacto_bomba,obj_fragmento_nave,obj_onda_ataque];
begin_pause=function() {
    if(state!="playing" || global.pausa) return;
    // Captura el último frame completo para mantener la escena visible y congelada.
    if(sprite_exists(pause_snapshot)) sprite_delete(pause_snapshot);
    pause_snapshot=-1;
    if(surface_exists(application_surface))
        pause_snapshot=sprite_create_from_surface(application_surface,0,0,
            surface_get_width(application_surface),surface_get_height(application_surface),false,false,0,0);
    global.pausa=true;state="paused";paused_instances=[];paused_voices=[];
    for(var _o=0;_o<array_length(pause_world_objects);++_o) {
        var _type=pause_world_objects[_o];
        for(var _i=0;_i<instance_number(_type);++_i) array_push(paused_instances,instance_find(_type,_i));
    }
    for(var _i=0;_i<array_length(paused_instances);++_i) instance_deactivate_object(paused_instances[_i]);
    if(bgm_instance!=-1 && audio_is_playing(bgm_instance)) {
        array_push(paused_voices,bgm_instance);audio_pause_sound(bgm_instance);
    }
    for(var _i=0;_i<array_length(sfx_voices);++_i) {
        var _voice=sfx_voices[_i];
        if(audio_is_playing(_voice)) { array_push(paused_voices,_voice);audio_pause_sound(_voice); }
    }
};
end_pause=function(_resume_audio) {
    for(var _i=0;_i<array_length(paused_instances);++_i) instance_activate_object(paused_instances[_i]);
    paused_instances=[];
    for(var _i=0;_i<array_length(paused_voices);++_i) {
        if(_resume_audio) audio_resume_sound(paused_voices[_i]);
        else audio_stop_sound(paused_voices[_i]);
    }
    paused_voices=[];global.pausa=false;block_gameplay_touch=true;
    if(sprite_exists(pause_snapshot)) sprite_delete(pause_snapshot);
    pause_snapshot=-1;
};
resume_run=function() {
    if(!global.pausa || state!="paused") return;
    end_pause(true);state="playing";
};
finish_paused_run=function() {
    if(!global.pausa) return;
    end_pause(false);state="menu";
    for(var _o=0;_o<array_length(pause_world_objects);++_o) {
        var _type=pause_world_objects[_o];
        with(_type) instance_destroy();
    }
    planet_delay=-1;world_scale=1;stage=1;notice="";
    reset_camera();save_progress();sync_music();
};
instance_create_depth(0,0,-140,obj_boton_pausa);

instance_create_depth(0,0,-90,obj_vfx_ataques);
