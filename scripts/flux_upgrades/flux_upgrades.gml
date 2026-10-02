function flux_upgrade_catalog() {
    var _branches=[];
    var _nodes=[];
    array_push(_nodes,{name:"Calibración Básica", description:"Aumenta el daño base de cada impacto un 10% y el tamaño visual del proyectil un 5%.", cost:1, requires:-1, purchased:false, state:"disponible", effect:{damage_bonus:0.1, size_bonus:0.05}});
    array_push(_nodes,{name:"Carga Concentrada", description:"Aumenta el daño un 25% y el tamaño un 10%.", cost:2, requires:0, purchased:false, state:"bloqueado", effect:{damage_bonus:0.25, size_bonus:0.1}});
    array_push(_nodes,{name:"Munición Densa", description:"Aumenta el daño un 45% y el tamaño un 15%.", cost:3, requires:1, purchased:false, state:"bloqueado", effect:{damage_bonus:0.45, size_bonus:0.15}});
    array_push(_nodes,{name:"Impacto Sísmico", description:"Aumenta el daño un 70%. Los proyectiles ahora generan una pequeñísima vibración al chocar contra el planeta.", cost:4, requires:2, purchased:false, state:"bloqueado", effect:{damage_bonus:0.7, impact_shake:0.12}});
    array_push(_nodes,{name:"Núcleo Pesado", description:"Aumenta el daño un 100% (doble de daño inicial) y el tamaño un 30%.", cost:5, requires:3, purchased:false, state:"bloqueado", effect:{damage_bonus:1, size_bonus:0.3}});
    array_push(_nodes,{name:"Ojivas de Tungsteno", description:"Aumenta el daño un 140% y el tamaño un 40%.", cost:6, requires:4, purchased:false, state:"bloqueado", effect:{damage_bonus:1.4, size_bonus:0.4}});
    array_push(_nodes,{name:"Materia Condensada", description:"Aumenta el daño un 190% y el tamaño un 55%.", cost:7, requires:5, purchased:false, state:"bloqueado", effect:{damage_bonus:1.9, size_bonus:0.55}});
    array_push(_nodes,{name:"Destrucción Cataclísmica", description:"Aumenta el daño un 250% y el tamaño un 70%. Los disparos se ven visiblemente más anchos.", cost:8, requires:6, purchased:false, state:"bloqueado", effect:{damage_bonus:2.5, size_bonus:0.7}});
    array_push(_nodes,{name:"Proyectiles de Antimateria", description:"Aumenta el daño un 320% y el tamaño un 85%.", cost:9, requires:7, purchased:false, state:"bloqueado", effect:{damage_bonus:3.2, size_bonus:0.85}});
    array_push(_nodes,{name:"Aniquilación Absoluta", description:"Aumenta el daño un 400% y el tamaño un 100%. Los disparos ahora dejan una estela tras de sí debido a su densidad y tamaño.", cost:10, requires:8, purchased:false, state:"bloqueado", effect:{damage_bonus:4, size_bonus:1, bullet_trail:true}});
    array_push(_branches,{name:"Potencia",nodes:_nodes,spent:0});
    var _nodes=[];
    array_push(_nodes,{name:"Gatillo Ligero", description:"Reduce el tiempo entre disparos un 5% y aumenta la velocidad a la que viaja el proyectil un 10%.", cost:1, requires:-1, purchased:false, state:"disponible", effect:{interval_reduction:0.05, speed_bonus:0.1}});
    array_push(_nodes,{name:"Inyección de Plasma", description:"Reduce el tiempo de disparo un 12% y aumenta la velocidad del proyectil un 20%.", cost:2, requires:0, purchased:false, state:"bloqueado", effect:{interval_reduction:0.12, speed_bonus:0.2}});
    array_push(_nodes,{name:"Cañón Rotativo", description:"Reduce el tiempo de disparo un 20% y aumenta la velocidad del proyectil un 35%.", cost:3, requires:1, purchased:false, state:"bloqueado", effect:{interval_reduction:0.2, speed_bonus:0.35}});
    array_push(_nodes,{name:"Acelerador Magnético", description:"Reduce el tiempo de disparo un 30% y aumenta la velocidad del proyectil un 50%.", cost:4, requires:2, purchased:false, state:"bloqueado", effect:{interval_reduction:0.3, speed_bonus:0.5}});
    array_push(_nodes,{name:"Sobrecarga Térmica", description:"Reduce el tiempo de disparo un 42% y aumenta la velocidad del proyectil un 70%.", cost:5, requires:3, purchased:false, state:"bloqueado", effect:{interval_reduction:0.42, speed_bonus:0.7}});
    array_push(_nodes,{name:"Flujo Continuo", description:"Reduce el tiempo de disparo un 55% y aumenta la velocidad del proyectil un 95%.", cost:6, requires:4, purchased:false, state:"bloqueado", effect:{interval_reduction:0.55, speed_bonus:0.95}});
    array_push(_nodes,{name:"Hipervelocidad", description:"Reduce el tiempo de disparo un 68% y aumenta la velocidad del proyectil un 125%.", cost:7, requires:5, purchased:false, state:"bloqueado", effect:{interval_reduction:0.68, speed_bonus:1.25}});
    array_push(_nodes,{name:"Cadencia Cuántica", description:"Reduce el tiempo de disparo un 80% y aumenta la velocidad del proyectil un 160%.", cost:8, requires:6, purchased:false, state:"bloqueado", effect:{interval_reduction:0.8, speed_bonus:1.6}});
    array_push(_nodes,{name:"Lluvia de Meteoros", description:"Reduce el tiempo de disparo un 90% (disparo casi continuo) y aumenta la velocidad del proyectil un 200%.", cost:9, requires:7, purchased:false, state:"bloqueado", effect:{interval_reduction:0.9, speed_bonus:2}});
    array_push(_nodes,{name:"Rayo Cinético", description:"Reduce el tiempo de disparo un 95% y aumenta la velocidad del proyectil un 250%. El arma dispara tan rápido que parece una línea sólida ininterrumpida.", cost:10, requires:8, purchased:false, state:"bloqueado", effect:{interval_reduction:0.95, speed_bonus:2.5, kinetic_line:true}});
    array_push(_branches,{name:"Frecuencia",nodes:_nodes,spent:0});
    var _nodes=[];
    array_push(_nodes,{name:"Propulsores Ágiles", description:"Aumenta la velocidad de órbita un 10%.", cost:1, requires:-1, purchased:false, state:"disponible", effect:{orbit_bonus:0.1}});
    array_push(_nodes,{name:"Inversores de Empuje", description:"Aumenta la velocidad de órbita un 18%.", cost:2, requires:0, purchased:false, state:"bloqueado", effect:{orbit_bonus:0.18}});
    array_push(_nodes,{name:"Aerodinámica de Vacío", description:"Aumenta la velocidad de órbita un 25% y otorga 0.1 segundos de inmunidad (i-frames) justo al momento de invertir la dirección.", cost:3, requires:1, purchased:false, state:"bloqueado", effect:{orbit_bonus:0.25, turn_iframes:0.1}});
    array_push(_nodes,{name:"Motores de Iones", description:"Aumenta la velocidad de órbita un 30%. El cambio de dirección ahora deja una ligera estela visual.", cost:4, requires:2, purchased:false, state:"bloqueado", effect:{orbit_bonus:0.3, turn_trail:true}});
    array_push(_nodes,{name:"Reflejos Neuronales", description:"Aumenta la velocidad de órbita un 34% y los frames de inmunidad al girar suben a 0.2 segundos.", cost:5, requires:3, purchased:false, state:"bloqueado", effect:{orbit_bonus:0.34, turn_iframes:0.2}});
    array_push(_nodes,{name:"Gravedad Asistida", description:"Aumenta la velocidad de órbita un 37%. Permite a la nave frenar un 20% de su velocidad si el jugador no toca nada (ajuste del control estático).", cost:6, requires:4, purchased:false, state:"bloqueado", effect:{orbit_bonus:0.37, coast_brake:true}});
    array_push(_nodes,{name:"Derrape Orbital", description:"Aumenta la velocidad de órbita un 39%. Los frames de inmunidad al girar suben a 0.3 segundos.", cost:7, requires:5, purchased:false, state:"bloqueado", effect:{orbit_bonus:0.39, turn_iframes:0.3}});
    array_push(_nodes,{name:"Impulso Oscuro", description:"Aumenta la velocidad de órbita un 40%. Cambiar de dirección ahora esquiva limpiamente colisiones directas.", cost:8, requires:6, purchased:false, state:"bloqueado", effect:{orbit_bonus:0.4, clean_turn:true}});
    array_push(_nodes,{name:"Danza Estelar", description:"Aumenta la velocidad de órbita un 41%. Invertir la dirección teletransporta la nave un par de píxeles hacia atrás (Micro-salto) para evitar ataques cerrados.", cost:9, requires:7, purchased:false, state:"bloqueado", effect:{orbit_bonus:0.41, micro_jump:2}});
    array_push(_nodes,{name:"Órbita Espectral", description:"Aumenta la velocidad al límite máximo manejable (42%). La inmunidad al invertir dirección sube a 0.5 segundos y el micro-salto es más amplio.", cost:10, requires:8, purchased:false, state:"bloqueado", effect:{orbit_bonus:0.42, turn_iframes:0.5, micro_jump:8}});
    array_push(_branches,{name:"Maniobrabilidad",nodes:_nodes,spent:0});
    var _nodes=[];
    array_push(_nodes,{name:"Calibración Óptica", description:"Otorga un 5% de probabilidad de infligir daño crítico (hace el doble de daño).", cost:1, requires:-1, purchased:false, state:"disponible", effect:{crit:0.05}});
    array_push(_nodes,{name:"Sensores de Debilidad", description:"Aumenta la probabilidad de crítico a 12%.", cost:2, requires:0, purchased:false, state:"bloqueado", effect:{crit:0.12}});
    array_push(_nodes,{name:"Impacto Certero", description:"Aumenta la probabilidad a 20%. Los golpes críticos ahora hacen un 2.2x del daño base.", cost:3, requires:1, purchased:false, state:"bloqueado", effect:{crit:0.2, crit_multiplier:2.2}});
    array_push(_nodes,{name:"Cálculo Estructural", description:"Aumenta la probabilidad a 30%. Los proyectiles que salen como críticos parpadean en blanco.", cost:4, requires:2, purchased:false, state:"bloqueado", effect:{crit:0.3, crit_blink:true}});
    array_push(_nodes,{name:"Fractura Profunda", description:"Aumenta la probabilidad a 42%. El daño crítico sube a 2.5x.", cost:5, requires:3, purchased:false, state:"bloqueado", effect:{crit:0.42, crit_multiplier:2.5}});
    array_push(_nodes,{name:"Foco Perforante", description:"Aumenta la probabilidad a 55%.", cost:6, requires:4, purchased:false, state:"bloqueado", effect:{crit:0.55}});
    array_push(_nodes,{name:"Ruptura Tectónica", description:"Aumenta la probabilidad a 70%. El daño crítico sube a 3.0x.", cost:7, requires:5, purchased:false, state:"bloqueado", effect:{crit:0.7, crit_multiplier:3}});
    array_push(_nodes,{name:"Punto Ciego", description:"Aumenta la probabilidad a 85%. Cada disparo crítico tiene un 10% de probabilidad extra de hacer que el planeta suelte más puntos.", cost:8, requires:6, purchased:false, state:"bloqueado", effect:{crit:0.85, crit_drop_chance:0.1}});
    array_push(_nodes,{name:"Precisión Letal", description:"Aumenta la probabilidad a 95%. El daño crítico sube a 3.5x.", cost:9, requires:7, purchased:false, state:"bloqueado", effect:{crit:0.95, crit_multiplier:3.5}});
    array_push(_nodes,{name:"Sobrecarga Crítica", description:"100% de probabilidad de crítico. Todos los ataques hacen el cuádruple (4.0x) de daño base y destellan intensamente al impactar.", cost:10, requires:8, purchased:false, state:"bloqueado", effect:{crit:1, crit_multiplier:4, crit_flash:true}});
    array_push(_branches,{name:"Crítico",nodes:_nodes,spent:0});
    var _nodes=[];
    array_push(_nodes,{name:"Radar de Suministros", description:"Aumenta la frecuencia de aparición de potenciadores un 10% y su duración un 15%.", cost:1, requires:-1, purchased:false, state:"disponible", effect:{spawn_bonus:0.1, duration_bonus:0.15}});
    array_push(_nodes,{name:"Cápsulas Duraderas", description:"Aumenta la aparición un 20% y la duración un 30%.", cost:2, requires:0, purchased:false, state:"bloqueado", effect:{spawn_bonus:0.2, duration_bonus:0.3}});
    array_push(_nodes,{name:"Atracción Magnética", description:"Aumenta la aparición un 30%. El área de colisión (hitbox) para recoger los potenciadores se hace ligeramente más grande.", cost:3, requires:1, purchased:false, state:"bloqueado", effect:{spawn_bonus:0.3, pickup_area:1.3}});
    array_push(_nodes,{name:"Baterías Extendidas", description:"Aumenta la aparición un 45% y la duración de los potenciadores un 60%.", cost:4, requires:2, purchased:false, state:"bloqueado", effect:{spawn_bonus:0.45, duration_bonus:0.6}});
    array_push(_nodes,{name:"Sincronización de Recursos", description:"Aumenta la aparición un 60%. Al recoger cualquier potenciador, se otorgan puntos adicionales automáticamente.", cost:5, requires:3, purchased:false, state:"bloqueado", effect:{spawn_bonus:0.6, pickup_points:1}});
    array_push(_nodes,{name:"Campos de Contención", description:"Aumenta la aparición un 80% y la duración un 100% (los potenciadores duran el doble).", cost:6, requires:4, purchased:false, state:"bloqueado", effect:{spawn_bonus:0.8, duration_bonus:1}});
    array_push(_nodes,{name:"Lluvia de Bendiciones", description:"Aumenta la aparición un 105%. El área de colisión para recoger es ahora el doble de grande.", cost:7, requires:5, purchased:false, state:"bloqueado", effect:{spawn_bonus:1.05, pickup_area:2}});
    array_push(_nodes,{name:"Ciclo Eficiente", description:"Aumenta la aparición un 135% y la duración un 150%.", cost:8, requires:6, purchased:false, state:"bloqueado", effect:{spawn_bonus:1.35, duration_bonus:1.5}});
    array_push(_nodes,{name:"Anomalía Generosa", description:"Aumenta la aparición un 170%. Introduce un 5% de probabilidad de que caigan dos potenciadores exactamente al mismo tiempo.", cost:9, requires:7, purchased:false, state:"bloqueado", effect:{spawn_bonus:1.7, double_buff_chance:0.05}});
    array_push(_nodes,{name:"Dominio del Caos", description:"Aumenta la aparición un 200% y la duración un 250%. Siempre que tengas un potenciador activo, los puntos que caen del planeta valen el doble.", cost:10, requires:8, purchased:false, state:"bloqueado", effect:{spawn_bonus:2, duration_bonus:2.5, buff_double_points:true}});
    array_push(_branches,{name:"Utilidades",nodes:_nodes,spent:0});
    return _branches;
}

function flux_hex(_x,_y,_radius,_fill) {
    if(_fill) {
        draw_primitive_begin(pr_trianglefan);
        for(var _i=0;_i<6;++_i) draw_vertex(_x+lengthdir_x(_radius,_i*60),_y+lengthdir_y(_radius,_i*60));
        draw_primitive_end();
    } else {
        for(var _i=0;_i<6;++_i) draw_line(_x+lengthdir_x(_radius,_i*60),_y+lengthdir_y(_radius,_i*60),
            _x+lengthdir_x(_radius,(_i+1)*60),_y+lengthdir_y(_radius,(_i+1)*60));
    }
}
function flux_hex_contains(_dx,_dy,_r) {
    var _ax=abs(_dx),_ay=abs(_dy);
    return _ax<=_r && _ay<=sqrt(3)*_r*0.5 && sqrt(3)*_ax+_ay<=sqrt(3)*_r;
}
function flux_hit_feedback(_x,_y,_critical) {
    var _gm=global.flux;
    if(_gm.stats.impact_shake>0) _gm.add_bomb_shake(_gm.stats.impact_shake);
    if(_critical) {
        if(random(1)<_gm.stats.crit_drop_chance) {
            var _dir=point_direction(_gm.center_x,_gm.center_y,_x,_y);
            instance_create_depth(_x+lengthdir_x(10,_dir),_y+lengthdir_y(10,_dir),-4,obj_punto);
        }
        if(_gm.stats.crit_flash) {
            var _flash=instance_create_depth(_x,_y,-35,obj_efecto_impacto_bomba);
            _flash.impact_radius=24;_flash.image_alpha=0.8;
        }
    }
}
