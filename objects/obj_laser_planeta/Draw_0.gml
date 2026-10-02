if(global.flux.state!="playing" && global.flux.state!="dying") exit;
if(instance_exists(obj_nave) && obj_nave.buff_active(FluxBuff.Apagon)) exit;
var _old_colour=draw_get_color(),_old_alpha=draw_get_alpha();
gpu_set_blendmode(bm_add);draw_set_color(image_blend);
if(telegraph>0) {
    var _pulse=0.3+0.65*abs(sin(visual_clock*12));
    draw_set_alpha(0.10);draw_line_width(x,y,end_x,end_y,beam_width*1.4);
    draw_set_alpha(_pulse);draw_line_width(x,y,end_x,end_y,3);
    var _r=global.flux.orbit_radius;
    flux_arc(x+lengthdir_x(_r,heading),y+lengthdir_y(_r,heading),16+telegraph*10,1,3);
} else {
    var _pulse=1+0.1*sin(visual_clock*34);
    draw_set_alpha(0.1);draw_line_width(x,y,end_x,end_y,beam_width*4.5*_pulse);
    draw_set_alpha(0.3);draw_line_width(x,y,end_x,end_y,beam_width*2.2*_pulse);
    draw_set_alpha(0.9);draw_line_width(x,y,end_x,end_y,beam_width);
    draw_set_color(c_white);draw_set_alpha(1);draw_line_width(x,y,end_x,end_y,beam_width*0.42);
}
gpu_set_blendmode(bm_normal);draw_set_color(_old_colour);draw_set_alpha(_old_alpha);
