gm=global.flux;nodes=[];
cam_x=0;cam_y=0;zoom=0.55;min_zoom=0.25;max_zoom=1.8;
dragging=false;drag_distance=0;pinching=false;last_x=0;last_y=0;last_pinch=0;
was_tree=false;input_ready=false;
for(var _b=0;_b<5;++_b) {
    var _angle=90-_b*72;
    for(var _level=0;_level<6;++_level) {
        var _distance=170+_level*145;
        array_push(nodes,{branch:_b,level:_level,wx:lengthdir_x(_distance,_angle),wy:lengthdir_y(_distance,_angle)});
    }
}
zoom_at=function(_factor,_sx,_sy) {
    var _wx=cam_x+(_sx-360)/zoom,_wy=cam_y+(_sy-630)/zoom;
    zoom=clamp(zoom*_factor,min_zoom,max_zoom);
    cam_x=_wx-(_sx-360)/zoom;cam_y=_wy-(_sy-630)/zoom;
};
