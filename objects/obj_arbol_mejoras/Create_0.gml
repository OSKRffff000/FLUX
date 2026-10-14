gm=global.flux;nodes=[];hex_radius=52;nodo_seleccionado=-1;
cam_x=0;cam_y=0;zoom=0.85;min_zoom=0.4;max_zoom=2;
dragging=false;drag_distance=0;pinching=false;last_x=0;last_y=0;last_pinch=0;
was_tree=false;input_ready=false;
// Mapa visual por rama y nivel (1..10); no modifica el catalogo ni los efectos.
// La carpeta Mejoras_Durabilidad corresponde a la rama Utilidades del catalogo.
node_sprites=[
    [spr_potencia_1,spr_potencia_2,spr_potencia_3,spr_potencia_4,spr_potencia_5,spr_potencia_6,spr_potencia_7,spr_potencia_8,spr_potencia_9,spr_potencia_10],
    [spr_frecuencia_1,spr_frecuencia_2,spr_frecuencia_3,spr_frecuencia_4,spr_frecuencia_5,spr_frecuencia_6,spr_frecuencia_7,spr_frecuencia_8,spr_frecuencia_9,spr_frecuencia_10],
    [spr_maniobrabilidad_1,spr_maniobrabilidad_2,spr_maniobrabilidad_3,spr_maniobrabilidad_4,spr_maniobrabilidad_5,spr_maniobrabilidad_6,spr_maniobrabilidad_7,spr_maniobrabilidad_8,spr_maniobrabilidad_9,spr_maniobrabilidad_10],
    [spr_critico_1,spr_critico_2,spr_critico_3,spr_critico_4,spr_critico_5,spr_critico_6,spr_critico_7,spr_critico_8,spr_critico_9,spr_critico_10],
    [spr_durabilidad_1,spr_durabilidad_2,spr_durabilidad_3,spr_durabilidad_4,spr_durabilidad_5,spr_durabilidad_6,spr_durabilidad_7,spr_durabilidad_8,spr_durabilidad_9,spr_durabilidad_10]
];
// El lienzo completo cabe dentro del hexagono, con espacio para el nivel debajo.
node_icon_size=hex_radius*1.1;
node_icon_offset_y=-hex_radius*0.1;
// Cinco sectores contiguos de la misma retícula axial. Cada sector tiene 1+2+3+4=10 celdas.
var _directions=[[1,0],[0,1],[-1,1],[-1,0],[0,-1],[1,-1]];
for(var _b=0;_b<5;++_b) {
    var _level=0,_a=_directions[_b],_c=_directions[(_b+1) mod 6];
    for(var _ring=1;_ring<=4;++_ring) {
        for(var _j=0;_j<_ring;++_j) {
            var _k=(_ring mod 2)==0 ? _ring-1-_j : _j;
            var _q=(_ring-_k)*_a[0]+_k*_c[0];
            var _r=(_ring-_k)*_a[1]+_k*_c[1];
            array_push(nodes,{branch:_b,level:_level,icon_sprite:node_sprites[_b][_level],
                wx:hex_radius*1.5*_q,wy:hex_radius*sqrt(3)*(_r+_q*0.5)});
            ++_level;
        }
    }
}
zoom_at=function(_factor,_sx,_sy) {
    var _wx=cam_x+(_sx-360)/zoom,_wy=cam_y+(_sy-480)/zoom;
    zoom=clamp(zoom*_factor,min_zoom,max_zoom);
    cam_x=_wx-(_sx-360)/zoom;cam_y=_wy-(_sy-480)/zoom;
};
