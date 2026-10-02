if(gm.state=="dying") {
    if(!instance_exists(obj_secuencia_muerte)) exit;
    var _sequence=instance_find(obj_secuencia_muerte,0);
    var _split=3+min(1,_sequence.elapsed/1.5)*7;
    draw_set_color(c_white);draw_set_alpha(1);
    flux_draw_ship(x,y,gm.evolution,_sequence.ship_angle,1,1,_split);
    exit;
}
if(gm.state!="playing") exit;
var _aim=point_direction(x,y,gm.center_x,gm.center_y);
draw_set_color(c_white);
// Solo cambia el dibujo; (x,y), los disparos y hit_radius conservan su centro.
for(var _e=0;_e<array_length(turn_echoes);++_e) {
    var _echo=turn_echoes[_e];
    flux_draw_ship(_echo.px,_echo.py,gm.evolution,_echo.angle,1,0.35*_echo.life/0.2);
}
var _alpha=(buff_active(FluxBuff.Fantasma) || turn_immunity>0) ? 0.35 : 1;
flux_draw_ship(x,y,gm.evolution,_aim,1,_alpha);
draw_set_alpha(1);
if(shield_charges>0) draw_circle(x,y,25,true);
if(laser_on) {
    var _end= buff_active(FluxBuff.Perforante) ? -gm.orbit_radius : 62;
    draw_set_alpha(0.2);draw_line_width(x,y,gm.center_x+lengthdir_x(_end,orbit_angle),gm.center_y+lengthdir_y(_end,orbit_angle),12);
    draw_set_alpha(1);draw_line_width(x,y,gm.center_x+lengthdir_x(_end,orbit_angle),gm.center_y+lengthdir_y(_end,orbit_angle),3);
}
if(gm.equipped_pet>=0) {
    draw_circle(x+lengthdir_x(32,_aim+100),y+lengthdir_y(32,_aim+100),gm.evolution==2 ? 10 : 5,true);
}
