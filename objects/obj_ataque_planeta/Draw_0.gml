if (global.flux.state!="playing" && global.flux.state!="dead") exit;
draw_set_color(image_blend);
draw_set_alpha(0.08); draw_circle(x,y,radius*3.8,false);
draw_set_alpha(0.22); draw_circle(x,y,radius*2.3,false);
draw_set_alpha(1); draw_circle(x,y,radius,false);
draw_set_color(c_white); draw_circle(x,y,radius*0.35,false);
