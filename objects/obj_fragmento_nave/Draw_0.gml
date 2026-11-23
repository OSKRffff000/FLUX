draw_set_color(c_white);
var _alpha = rewind_mode ? 1 : clamp(life,0,1);
draw_set_alpha(_alpha);
draw_triangle(x+lengthdir_x(fragment_size,fragment_angle),y+lengthdir_y(fragment_size,fragment_angle),
    x+lengthdir_x(fragment_size,fragment_angle+130),y+lengthdir_y(fragment_size,fragment_angle+130),
    x+lengthdir_x(fragment_size*0.6,fragment_angle+240),y+lengthdir_y(fragment_size*0.6,fragment_angle+240),false);
if (rewind_mode && rewind_state == "rewind") {
    gpu_set_blendmode(bm_add);
    draw_set_alpha(0.3 * (1 - (rewind_timer / rewind_duration)));
    draw_line(x, y, rewind_target_x, rewind_target_y);
    gpu_set_blendmode(bm_normal);
}
draw_set_alpha(1);
