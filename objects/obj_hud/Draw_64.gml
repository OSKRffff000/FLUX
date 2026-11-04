var _gm=global.flux;if(_gm.state!="playing") exit;
draw_set_color(c_white);draw_set_alpha(1);draw_set_halign(fa_left);draw_set_valign(fa_top);
draw_text(25,145,"FLUX | Planeta " + string(_gm.stage));
draw_text(25,1190,"Manten izquierda/derecha para orbitar. Suelta para parar.");

// Barras de recursos en gameplay (esquina superior derecha, debajo del boton de pausa)
flux_draw_bar_creditos(195);
flux_draw_bar_puntos(252);

if(!instance_exists(obj_nave)) exit;
var _s=instance_find(obj_nave,0),_slot=0;
for(var _i=0;_i<FluxBuff.Count;++_i) {
    var _buff=_s.buffs[_i];if(_buff.remaining<=0) continue;
    var _xx=40+(_slot mod 8)*88,_yy=48;
    draw_set_color(c_dkgray);draw_circle(_xx,_yy,29,true);
    draw_set_color(c_white);flux_buff_icon(_xx,_yy,_i,27);
    // 360° al recoger, 0° al expirar; empieza arriba y se consume en sentido horario.
    flux_arc(_xx,_yy,29,_buff.remaining/_buff.duration,3);
    draw_set_halign(fa_center);draw_text(_xx,_yy+35,string(ceil(_buff.remaining))+"s");
    ++_slot;
}
draw_set_halign(fa_left);
