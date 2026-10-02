gm=global.flux;nodes=[];hex_radius=52;nodo_seleccionado=-1;
cam_x=0;cam_y=0;zoom=0.85;min_zoom=0.4;max_zoom=2;
dragging=false;drag_distance=0;pinching=false;last_x=0;last_y=0;last_pinch=0;
was_tree=false;input_ready=false;
// Cinco sectores contiguos de la misma retícula axial. Cada sector tiene 1+2+3+4=10 celdas.
var _directions=[[1,0],[0,1],[-1,1],[-1,0],[0,-1],[1,-1]];
for(var _b=0;_b<5;++_b) {
    var _level=0,_a=_directions[_b],_c=_directions[(_b+1) mod 6];
    for(var _ring=1;_ring<=4;++_ring) {
        for(var _j=0;_j<_ring;++_j) {
            var _k=(_ring mod 2)==0 ? _ring-1-_j : _j;
            var _q=(_ring-_k)*_a[0]+_k*_c[0];
            var _r=(_ring-_k)*_a[1]+_k*_c[1];
            array_push(nodes,{branch:_b,level:_level,wx:hex_radius*1.5*_q,wy:hex_radius*sqrt(3)*(_r+_q*0.5)});
            ++_level;
        }
    }
}
zoom_at=function(_factor,_sx,_sy) {
    var _wx=cam_x+(_sx-360)/zoom,_wy=cam_y+(_sy-480)/zoom;
    zoom=clamp(zoom*_factor,min_zoom,max_zoom);
    cam_x=_wx-(_sx-360)/zoom;cam_y=_wy-(_sy-480)/zoom;
};
