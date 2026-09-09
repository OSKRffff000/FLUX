if(global.flux.state!="playing" && global.flux.state!="dying") exit;
if(instance_exists(obj_nave) && obj_nave.buff_active(FluxBuff.Apagon)) exit;
var _old_colour=draw_get_color(),_old_alpha=draw_get_alpha();
draw_set_color(c_white);
if(telegraph>0) {
    draw_set_alpha(0.3);draw_line_width(x,y,end_x,end_y,2);
} else {
    draw_set_alpha(0.12);draw_line_width(x,y,end_x,end_y,beam_width*3);
    draw_set_alpha(0.45);draw_line_width(x,y,end_x,end_y,beam_width*1.6);
    draw_set_alpha(1);draw_line_width(x,y,end_x,end_y,beam_width);
}
draw_set_color(_old_colour);draw_set_alpha(_old_alpha);
