if (!rewind_mode) {
    life-=delta_time/1000000;fragment_angle+=spin;
    if(life<=0 || y>room_height+100) instance_destroy();
    exit;
}

var _dt = delta_time / 1000000;
rewind_timer += _dt;

switch (rewind_state) {
    case "fall":
        fragment_angle += spin;
        if (rewind_timer >= 0.40) {
            rewind_state = "brake";
            rewind_timer = 0;
            gravity = 0;
        }
        break;
        
    case "brake":
        hspeed = lerp(hspeed, 0, clamp(10 * _dt, 0, 1));
        vspeed = lerp(vspeed, 0, clamp(10 * _dt, 0, 1));
        spin = lerp(spin, 0, clamp(10 * _dt, 0, 1));
        fragment_angle += spin;
        if (rewind_timer >= 0.25) {
            hspeed = 0;
            vspeed = 0;
            spin = 0;
            rewind_start_x = x;
            rewind_start_y = y;
            rewind_state = "rewind";
            rewind_timer = 0;
            rewind_duration = 0.60;
        }
        break;
        
    case "rewind":
        var _k = clamp(rewind_timer / rewind_duration, 0, 1);
        var _ease = _k * _k;
        x = lerp(rewind_start_x, rewind_target_x, _ease);
        y = lerp(rewind_start_y, rewind_target_y, _ease);
        fragment_angle = lerp(fragment_angle, initial_angle, _ease);
        if (_k >= 1) {
            rewind_state = "done";
            x = rewind_target_x;
            y = rewind_target_y;
        }
        break;
        
    case "done":
        x = rewind_target_x;
        y = rewind_target_y;
        break;
}
