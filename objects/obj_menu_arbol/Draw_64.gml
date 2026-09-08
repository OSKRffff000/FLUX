if(gm.state!="tree") exit;
draw_set_alpha(1);draw_set_color(c_black);draw_rectangle(0,0,720,1280,false);
var _cx=360-cam_x*zoom,_cy=630-cam_y*zoom;
// Pentágono une los primeros nodos; cada radio es una rama progresiva.
draw_set_color(c_dkgray);
for(var _b=0;_b<5;++_b) {
    var _p=nodes[_b*6],_q=nodes[((_b+1) mod 5)*6];
    draw_line(360+(_p.wx-cam_x)*zoom,630+(_p.wy-cam_y)*zoom,360+(_q.wx-cam_x)*zoom,630+(_q.wy-cam_y)*zoom);
}
for(var _i=0;_i<array_length(nodes);++_i) {
    var _n=nodes[_i],_node=gm.branches[_n.branch].nodes[_n.level];
    var _xx=360+(_n.wx-cam_x)*zoom,_yy=630+(_n.wy-cam_y)*zoom;
    var _prev=_n.level==0 ? {wx:0,wy:0} : nodes[_i-1];
    draw_set_color(_node.purchased ? c_white : c_dkgray);
    draw_line_width(360+(_prev.wx-cam_x)*zoom,630+(_prev.wy-cam_y)*zoom,_xx,_yy,2);
    var _open=_n.level==0 || gm.branches[_n.branch].nodes[_n.level-1].purchased;
    draw_set_color(c_black);draw_circle(_xx,_yy,38*zoom,false);
    draw_set_color(_open ? c_white : c_gray);draw_circle(_xx,_yy,38*zoom,true);
    draw_set_halign(fa_center);draw_set_valign(fa_middle);
    draw_text_transformed(_xx,_yy,string(_n.level+1)+(_node.purchased ? " OK" : " / "+string(_node.cost)),max(0.65,zoom),max(0.65,zoom),0);
    if(zoom>=0.45) draw_text_transformed(_xx,_yy+55*zoom,"+"+string(round(_node.bonus*100))+"%",0.7,0.7,0);
    if(_n.level==0) draw_text_transformed(_xx,_yy-60*zoom,gm.branches[_n.branch].name,0.8,0.8,0);
}
draw_set_color(c_white);draw_circle(_cx,_cy,40*zoom,true);draw_text(_cx,_cy,"Flux");
draw_set_halign(fa_left);draw_set_valign(fa_top);
// Máscaras GUI evitan que los nodos dibujen encima de los controles.
draw_set_color(c_black);draw_rectangle(0,0,720,220,false);draw_rectangle(0,1020,720,1280,false);
draw_set_color(c_white);draw_text(25,35,"Arbol | Puntos: "+string(gm.skill_points)+" | Gastados: "+string(gm.spent_points));
draw_text(25,80,"Arrastra para mover. Pellizca o usa rueda / +/- para zoom.");
draw_text(25,120,"6 niveles por rama. Compra el anterior. Costo = nivel.");
draw_text(25,160,"Empates de evolucion: primera rama en orden del catalogo.");
draw_text(25,1035,gm.notice);
flux_button(20,1130,190,70,"Menu",true);
flux_button(230,1130,280,70,gm.evolution>=0 ? gm.evolution_names[gm.evolution] : "Ver evolucion",gm.spent_points>=15 && gm.evolution<0);
flux_button(530,1130,70,70,"-",true);flux_button(620,1130,70,70,"+",true);
