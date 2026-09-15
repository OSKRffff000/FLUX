gm=global.flux;
sprite_index=choose(spr_planeta9,spr_planeta10,spr_planeta11);
image_index=0;image_speed=1;
phase="idle";phase_time=0;selected=-1;was_menu=false;input_ready=false;
planet_x=-200;planet_y=640;planet_radius=450;panel_progress=0;
planet_darkness=0;blackout_drawn=false;
stars=[];
for(var _i=0;_i<80;++_i) {
    array_push(stars,{px:irandom(719),py:irandom(1279),size:choose(1,1,2),shade:choose(c_white,c_ltgray,c_gray)});
}
buttons=[];
var _labels=["Jugar","Arbol de Mejoras","Mascotas","Configuracion","Creditos"];
var _actions=["playing","tree","shop","settings","credits"];
for(var _i=0;_i<5;++_i) {
    var _angle=40-_i*20;
    array_push(buttons,{label:_labels[_i],action:_actions[_i],
        px:-200+lengthdir_x(600,_angle),py:640+lengthdir_y(600,_angle)-48});
}
// Cada capa tiene su propia geometría fija: frente, medio y fondo.
button_shapes_idle=[
    [[18,0],[260,7],[240,96],[0,86]],
    [[12,-5],[274,13],[251,106],[-7,91]],
    [[5,-10],[285,18],[257,117],[-16,96]]
];
button_shapes_selected=[
    [[8,-4],[271,3],[234,100],[-4,82]],
    [[1,-10],[279,16],[250,111],[-15,91]],
    [[-9,-16],[293,22],[260,125],[-25,99]]
];
button_vertices=function(_b,_active,_layer) {
    var _shape=_active ? button_shapes_selected[_layer] : button_shapes_idle[_layer];
    var _vertices=[];
    for(var _i=0;_i<4;++_i) array_push(_vertices,[_b.px+_shape[_i][0],_b.py+_shape[_i][1]]);
    return _vertices;
};
button_contains=function(_vertices,_mx,_my) {
    var _positive=false,_negative=false;
    for(var _i=0;_i<4;++_i) {
        var _a=_vertices[_i],_b=_vertices[(_i+1) mod 4];
        var _cross=(_b[0]-_a[0])*(_my-_a[1])-(_b[1]-_a[1])*(_mx-_a[0]);
        if(_cross>0) _positive=true;
        if(_cross<0) _negative=true;
    }
    return !(_positive && _negative);
};
