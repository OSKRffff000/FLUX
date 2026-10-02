var _gm=global.flux;
if(_gm.state!="playing" || _gm.attack_flash<=0) exit;
var _alpha=draw_get_alpha(),_colour=draw_get_color();
gpu_set_blendmode(bm_add);draw_set_color(_gm.attack_flash_tint);draw_set_alpha(_gm.attack_flash);
draw_rectangle(0,0,display_get_gui_width(),display_get_gui_height(),false);
gpu_set_blendmode(bm_normal);draw_set_alpha(_alpha);draw_set_color(_colour);
