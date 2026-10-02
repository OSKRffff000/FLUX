if(global.flux.state!="playing" && global.flux.state!="dying") exit;
var _alpha=draw_get_alpha(),_colour=draw_get_color();
gpu_set_blendmode(bm_add);draw_set_color(tint);draw_set_alpha(max(0,life/max_life)*0.5);
flux_arc(x,y,radius,1,12);draw_set_alpha(max(0,life/max_life)*0.2);flux_arc(x,y,radius*0.8,1,24);
gpu_set_blendmode(bm_normal);draw_set_alpha(_alpha);draw_set_color(_colour);
