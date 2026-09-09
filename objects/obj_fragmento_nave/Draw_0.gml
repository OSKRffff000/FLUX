draw_set_color(c_white);draw_set_alpha(clamp(life,0,1));
draw_triangle(x+lengthdir_x(fragment_size,fragment_angle),y+lengthdir_y(fragment_size,fragment_angle),
    x+lengthdir_x(fragment_size,fragment_angle+130),y+lengthdir_y(fragment_size,fragment_angle+130),
    x+lengthdir_x(fragment_size*0.6,fragment_angle+240),y+lengthdir_y(fragment_size*0.6,fragment_angle+240),false);
draw_set_alpha(1);
