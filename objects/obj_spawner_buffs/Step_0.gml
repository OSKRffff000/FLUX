if (gm.state!="playing") exit;
spawn_timer-=flux_world_dt();
if (spawn_timer<=0) {
    spawn_timer=random_range(6,9);
    // La sala completa coincide con la pantalla logica: 720 x 1280.
    // Siempre nacen fuera de uno de sus cuatro bordes, nunca del planeta.
    var _margin=40, _x=0, _y=0;
    switch (irandom(3)) {
        case 0: _x=-_margin; _y=random(room_height); break;
        case 1: _x=room_width+_margin; _y=random(room_height); break;
        case 2: _x=random(room_width); _y=-_margin; break;
        case 3: _x=random(room_width); _y=room_height+_margin; break;
    }
    var _buff=instance_create_depth(_x,_y,-4,obj_buff);
    _buff.heading=point_direction(_x,_y,gm.center_x,gm.center_y);
    _buff.kind=irandom(FluxBuff.Count-1);
}
