// Draw GUI: usa las mismas coordenadas que la detección de toque.
if(!instance_exists(global.flux) || global.flux.state!="menu") exit;
draw_set_alpha(1);
flux_button(gui_x,gui_y,button_width,button_height,label,!reset_in_progress);
