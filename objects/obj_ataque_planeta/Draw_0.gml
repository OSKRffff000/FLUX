if(global.flux.state!="playing" && global.flux.state!="dead" && global.flux.state!="dying") exit;
var _colour=draw_get_color(),_alpha=draw_get_alpha();
gpu_set_blendmode(bm_add);
draw_set_color(image_blend);
if(telegraph>0) {
    var _pulse=0.55+0.4*sin((warning_duration-telegraph)*24);
    draw_set_alpha(0.25);draw_line_width(x,y,warning_x,warning_y,4);
    draw_set_alpha(_pulse);flux_arc(warning_x,warning_y,18+telegraph*16,1,3);
    draw_line_width(warning_x-24,warning_y,warning_x+24,warning_y,2);
    draw_line_width(warning_x,warning_y-24,warning_x,warning_y+24,2);
} else {
    for(var _i=1;_i<array_length(trail_points);++_i) {
        var _a=trail_points[_i-1],_b=trail_points[_i];
        var _fade=clamp(_a.life/0.4,0,1);
        draw_set_color(image_blend);draw_set_alpha(0.12*_fade);
        draw_line_width(_a.px,_a.py,_b.px,_b.py,radius*4*trail_width*_fade);
        draw_set_alpha(0.7*_fade);draw_line_width(_a.px,_a.py,_b.px,_b.py,max(1,radius*1.5*trail_width*_fade));
    }
    var _pulse=rhythmic ? 0.55+0.45*abs(sin(age*18+pulse_phase)) : 1;
    var _r=radius*glow_scale;
    draw_set_color(image_blend);draw_set_alpha(0.12*_pulse);draw_circle(x,y,_r*5,false);
    draw_set_alpha(0.28*_pulse);draw_circle(x,y,_r*2.7,false);
    draw_set_alpha(_pulse);draw_circle(x,y,_r,false);
    draw_set_color(c_white);draw_set_alpha(0.95);draw_circle(x,y,radius*0.42,false);
}
gpu_set_blendmode(bm_normal);draw_set_color(_colour);draw_set_alpha(_alpha);
