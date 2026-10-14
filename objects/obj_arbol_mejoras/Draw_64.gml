if(gm.state!="tree") exit;
var _font=draw_get_font(),_colour=draw_get_color(),_alpha=draw_get_alpha();
var _ha=draw_get_halign(),_va=draw_get_valign();
draw_set_font(fnt_gridlite);draw_set_alpha(1);draw_set_color(c_black);draw_rectangle(0,0,720,1280,false);
var _cx=360-cam_x*zoom,_cy=480-cam_y*zoom;
draw_set_color(c_dkgray);flux_hex(_cx,_cy,hex_radius*zoom,true);
draw_set_color(c_white);flux_hex(_cx,_cy,hex_radius*zoom,false);
draw_set_halign(fa_center);draw_set_valign(fa_middle);draw_text_transformed(_cx,_cy,"FLUX",0.5,0.5,0);
for(var _i=0;_i<array_length(nodes);++_i) {
    var _n=nodes[_i],_node=gm.branches[_n.branch].nodes[_n.level];
    if(_node.state=="bloqueado") continue;
    var _xx=360+(_n.wx-cam_x)*zoom,_yy=480+(_n.wy-cam_y)*zoom;
    draw_set_color(_i==nodo_seleccionado ? c_white : (_node.purchased ? c_gray : c_black));
    flux_hex(_xx,_yy,hex_radius*zoom,true);
    draw_set_color(_i==nodo_seleccionado ? c_black : c_white);flux_hex(_xx,_yy,hex_radius*zoom,false);
    // Misma posicion y zoom que el hexagono interactivo; respeta la proporcion.
    var _sprite=_n.icon_sprite;
    var _width=sprite_get_width(_sprite),_height=sprite_get_height(_sprite);
    var _scale=node_icon_size*zoom/max(_width,_height);
    var _sx=_xx+(sprite_get_xoffset(_sprite)-_width*0.5)*_scale;
    var _sy=_yy+node_icon_offset_y*zoom+(sprite_get_yoffset(_sprite)-_height*0.5)*_scale;
    draw_sprite_ext(_sprite,0,_sx,_sy,_scale,_scale,0,draw_get_color(),1);
    var _label=string(_n.level+1)+(_node.purchased ? " OK" : "");
    draw_text_transformed(_xx,_yy+hex_radius*0.65*zoom,_label,0.4*zoom,0.4*zoom,0);
}
// Paneles fijos: nunca interceptan ni se confunden con los gestos del panal.
draw_set_color(c_black);draw_rectangle(0,0,720,175,false);draw_rectangle(0,790,720,1280,false);
draw_set_color(c_white);draw_set_halign(fa_left);draw_set_valign(fa_top);
draw_text_transformed(25,25,"Árbol de Mejoras",0.8,0.8,0);
draw_text_transformed(25,70,"Puntos: "+string(gm.skill_points)+" | Compradas: "+string(gm.upgrades_bought)+"/50",0.55,0.55,0);
draw_text_transformed(25,105,"Primer toque: información. Segundo toque: comprar.",0.42,0.42,0);
draw_text_transformed(25,135,"Arrastra / pellizca para explorar. Evolución: 15 puntos gastados.",0.4,0.4,0);
if(nodo_seleccionado>=0) {
    var _pos=nodes[nodo_seleccionado],_node=gm.branches[_pos.branch].nodes[_pos.level];
    var _name_scale=min(0.75,660/max(1,string_width(_node.name)));
    draw_text_transformed(30,805,_node.name,_name_scale,_name_scale,0);
    draw_text_ext_transformed(30,855,_node.description,36,660/0.52,0.52,0.52,0);
    draw_set_color(gm.skill_points<_node.cost ? c_red : c_white);
    draw_text_transformed(30,1015,"Costo: "+string(_node.cost)+" puntos",0.6,0.6,0);
    draw_set_color(c_white);draw_text_transformed(400,1015,_node.state,0.55,0.55,0);
} else draw_text_transformed(30,835,"Selecciona un hexágono para ver su mejora.",0.5,0.5,0);
draw_set_color(c_white);draw_text_transformed(25,1070,gm.notice,0.45,0.45,0);
// flux_button hereda fnt_gridlite: todos los textos de este menú usan la fuente indicada.
flux_button(20,1130,160,70,global.pausa ? "Volver" : "Menú",true);
flux_button(195,1130,315,70,"Evolución",gm.spent_points>=15 && gm.evolution<0);
flux_button(530,1130,70,70,"-",true);flux_button(620,1130,70,70,"+",true);
draw_set_font(_font);draw_set_color(_colour);draw_set_alpha(_alpha);draw_set_halign(_ha);draw_set_valign(_va);
