if(gm.state=="dying") {
    if(!instance_exists(obj_secuencia_muerte)) exit;
    var _sequence=instance_find(obj_secuencia_muerte,0);
    var _split=3+min(1,_sequence.elapsed/1.5)*7;
    var _matrix=matrix_get(matrix_world);
    matrix_set(matrix_world,matrix_build(x,y,0,0,0,_sequence.ship_angle,1,1,1));
    draw_set_color(c_white);draw_set_alpha(1);
    if(gm.ship_sprites_ready) {
        var _sprite=gm.ship_sprites[gm.evolution+1];
        draw_sprite_part_ext(_sprite,0,0,0,64,32,-32-2,-32-_split,1,1,c_white,1);
        draw_sprite_part_ext(_sprite,0,0,32,64,32,-32+2,_split,1,1,c_white,1);
    }
    matrix_set(matrix_world,_matrix);exit;
}
if(gm.state!="playing") exit;
var _aim=point_direction(x,y,gm.center_x,gm.center_y);
draw_set_color(c_white);
if(buff_active(FluxBuff.Fantasma)) draw_set_alpha(0.35);
if(gm.ship_sprites_ready) draw_sprite_ext(gm.ship_sprites[gm.evolution+1],0,x,y,1,1,_aim,c_white,draw_get_alpha());
else flux_ship_shape(x,y,gm.evolution,_aim,1);
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
