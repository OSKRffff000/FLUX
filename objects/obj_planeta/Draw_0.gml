if(gm.state!="playing" && gm.state!="dead") exit;
var _old_colour=draw_get_color(),_old_alpha=draw_get_alpha();
var _health=clamp(hp/max_hp,0,1);
var _inner=radius+16;
var _outer=lerp(_inner,max(_inner,gm.orbit_radius),_health);
// Banda completa: borde interior fijo y grosor proporcional a la vida.
if(_outer>_inner) {
    draw_set_color(merge_color(make_color_rgb(230,230,230),make_color_rgb(240,90,90),1-_health));
    draw_set_alpha(0.14);
    draw_primitive_begin(pr_trianglestrip);
    for(var _i=0;_i<=128;++_i) {
        var _angle=_i*360/128;
        draw_vertex(x+lengthdir_x(_inner,_angle),y+lengthdir_y(_inner,_angle));
        draw_vertex(x+lengthdir_x(_outer,_angle),y+lengthdir_y(_outer,_angle));
    }
    draw_primitive_end();
}
// Ornamento detrás del sprite mientras exista alguno de los dos haces.
var _laser_visible=false;var _firing=false;var _pulse_time=0;
for(var _i=0;_i<array_length(laser_ids);++_i) {
    if(instance_exists(laser_ids[_i])) {
        var _laser=laser_ids[_i];_laser_visible=true;
        if(_laser.telegraph<=0) { _firing=true;_pulse_time=_laser.close_elapsed; }
    }
}
if(instance_exists(obj_nave) && obj_nave.buff_active(FluxBuff.Apagon)) _laser_visible=false;
if(_laser_visible) {
    var _pulse_radius=radius+12+(_firing ? 10+10*sin(_pulse_time*2*pi*2.5) : 0);
    draw_set_color(c_white);draw_set_alpha(0.22);
    draw_circle(x,y,_pulse_radius,false);
    draw_set_alpha(0.65);flux_arc(x,y,_pulse_radius+2,1,3);
}
// Base intacta y capa roja tenue, con desvanecimiento durante el destello.
draw_sprite_ext(sprite_index,image_index,x+planet_offset_x,y+planet_offset_y,
    planet_scale,planet_scale,0,c_white,1);
if(hit_timer>0) {
    var _flash_alpha=0.3*clamp(hit_timer/hit_duration,0,1);
    draw_sprite_ext(sprite_index,image_index,x+planet_offset_x,y+planet_offset_y,
        planet_scale,planet_scale,0,c_red,_flash_alpha);
}
draw_set_color(_old_colour);draw_set_alpha(_old_alpha);
