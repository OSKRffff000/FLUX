if(global.flux.state!="playing") exit;
draw_set_color(c_white);draw_set_alpha(max(0,1-radius/limit));flux_arc(x,y,radius,1,3);draw_set_alpha(1);
