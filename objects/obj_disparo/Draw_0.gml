if(global.flux.state!="playing" && global.flux.state!="dying") exit;
var _alpha=draw_get_alpha(),_color=draw_get_color();
draw_set_color(c_white);
if(trail) {
    for(var _i=1;_i<array_length(trail_points);++_i) {
        draw_set_alpha(0.25*_i/array_length(trail_points));
        draw_line_width(trail_points[_i-1].px,trail_points[_i-1].py,trail_points[_i].px,trail_points[_i].py,radius*1.5);
    }
}
draw_set_alpha(critical && crit_blink ? 0.45+0.55*abs(sin(age*40)) : 1);
if(kinetic) {
    var _length=min(80,velocity/max(1,global.flux.stats.rate));
    draw_line_width(x,y,x-lengthdir_x(_length,heading),y-lengthdir_y(_length,heading),radius*2);
}
draw_circle(x,y,radius,false);
draw_set_alpha(_alpha);draw_set_color(_color);
