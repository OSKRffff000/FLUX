gm=global.flux;gm.state="credits";gm.notice="";
elapsed=0;duration=227;
bob_alpha=0;bob_fade_speed=0.6;
gm.sync_music();credits_voice=gm.bgm_instance;
sprite_index=spr_bobsponge;image_index=0;image_speed=1;
var _font=draw_get_font();draw_set_font(fnt_gridlite);
var _names=["Oscar Alejandro Espinoza Roman","Kevin Ignacio Palma Alvarado","Sandra Victoria Felix Armenta","Johanna Rojas Castro"];
var _scales=[0.8,0.65,0.95,1.1];
var _vx=[47,-61,36,-43],_vy=[24,32,-29,-38];
texts=[];
for(var _i=0;_i<4;++_i) {
    var _scale=min(_scales[_i],640/max(1,string_width(_names[_i])));
    array_push(texts,{label:_names[_i],px:360,py:260+_i*160,
        scale:_scale,vx:_vx[_i],vy:_vy[_i],
        base_w:string_width(_names[_i]),base_h:string_height(_names[_i]),
        half_w:string_width(_names[_i])*_scale*0.5,half_h:string_height(_names[_i])*_scale*0.5});
}
draw_set_font(_font);
