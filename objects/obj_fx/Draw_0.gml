if (global.flux.state!="playing" && global.flux.state!="dead" && global.flux.state!="dying") exit;
draw_set_color(tint); draw_set_alpha(clamp(life/max_life,0,1)); draw_circle(x,y,size*life/max_life,false); draw_set_alpha(1);
