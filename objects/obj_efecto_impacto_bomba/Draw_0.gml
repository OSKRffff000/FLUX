if(global.flux.state!="playing" && global.flux.state!="dead") exit;
var _colour=draw_get_color(),_alpha=draw_get_alpha();
draw_set_color(c_white);draw_set_alpha(image_alpha);
draw_circle(x,y,impact_radius*image_xscale,false);
draw_set_color(_colour);draw_set_alpha(_alpha);
