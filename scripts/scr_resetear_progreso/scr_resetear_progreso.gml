/// @function scr_resetear_progreso()
/// @returns {Bool} true si el archivo se eliminó (o no existía).
function scr_resetear_progreso() {
    // save_progress y la carga cierran siempre el INI antes de devolver el control.
    var _archivo="flux_save.ini";
    if(file_exists(_archivo)) file_delete(_archivo);
    if(file_exists(_archivo)) return false;

    // El progreso de Flux reside en el manager referenciado por global.flux.
    if(variable_global_exists("flux") && instance_exists(global.flux)) {
        var _gm=global.flux;
        _gm.state="menu"; // Detiene recompensas y colisiones antes del reinicio.
        _gm.coins=0;
        _gm.skill_points=0;
        _gm.spent_points=0;
        _gm.stage=1;
        _gm.equipped_pet=-1;
        _gm.evolution=-1;
        _gm.evolution_pending=-1;
        _gm.evolution_deferred=false;
        _gm.evolution_return="tree";
        _gm.world_scale=1;
        _gm.planet_delay=-1;
        _gm.last_planet_hue=-1;
        _gm.notice="";
        for(var _b=0;_b<array_length(_gm.branches);++_b) {
            _gm.branches[_b].spent=0;
            for(var _n=0;_n<array_length(_gm.branches[_b].nodes);++_n)
                _gm.branches[_b].nodes[_n].purchased=false;
        }
        for(var _p=0;_p<array_length(_gm.pets);++_p)
            _gm.pets[_p].owned=false;
        _gm.rebuild_stats();
    }
    // Elimina también estado temporal: escudo, buffs y armas de la partida.
    with(obj_nave) instance_destroy();
    with(obj_planeta) instance_destroy();
    with(obj_disparo) instance_destroy();
    with(obj_ataque_planeta) instance_destroy(); // Incluye espirales por herencia.
    with(obj_laser_planeta) instance_destroy();
    with(obj_buff) instance_destroy();
    with(obj_spawner_buffs) instance_destroy();
    with(obj_punto) instance_destroy();
    with(obj_onda) instance_destroy();
    with(obj_fx) instance_destroy();
    with(obj_efecto_impacto_bomba) instance_destroy();
    // No llamar a save_progress(): el archivo debe permanecer eliminado.
    return true;
}
