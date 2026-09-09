if(global.flux.state!="settings") exit;
draw_set_alpha(1);draw_set_color(c_black);draw_rectangle(0,0,720,1280,false);
draw_set_color(c_white);draw_set_halign(fa_center);draw_set_valign(fa_top);
draw_text(360,160,"Configuracion");
var _values=[global.vol_maestro,global.vol_musica,global.vol_sfx];
for(var _i=0;_i<3;++_i) {
    var _yy=340+_i*160;
    draw_set_color(c_white);draw_set_halign(fa_center);
    draw_text(360,_yy-40,labels[_i]+"  "+string(round(_values[_i]*100))+"%");
    draw_set_halign(fa_left);
    flux_button(80,_yy,70,70,"-",true);flux_button(570,_yy,70,70,"+",true);
    draw_set_color(c_dkgray);draw_rectangle(180,_yy+25,540,_yy+45,false);
    draw_set_color(c_white);draw_rectangle(180,_yy+25,180+360*_values[_i],_yy+45,false);
}
flux_button(160,1120,400,70,"Volver",true);
draw_set_color(c_white);draw_text(25,1030,global.flux.notice);
