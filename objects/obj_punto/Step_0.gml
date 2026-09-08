var _gm=global.flux;if(_gm.state!="playing") exit;
var _dt=flux_world_dt();life-=_dt;
var _px=x,_py=y;
if(instance_exists(obj_nave)) {
    var _s=instance_find(obj_nave,0),_magnet=_s.buff_active(FluxBuff.Iman);
    if(_magnet || point_distance(x,y,_s.x,_s.y)<65) {
        var _dist=min(point_distance(x,y,_s.x,_s.y),(_magnet ? 650 : 240)*flux_dt());
        var _dir=point_direction(x,y,_s.x,_s.y);
        x+=lengthdir_x(_dist,_dir);y+=lengthdir_y(_dist,_dir);
    } else { x+=lengthdir_x(48*_dt,heading);y+=lengthdir_y(48*_dt,heading); }
    if(flux_segment_hit(_px-_s.prev_x,_py-_s.prev_y,x-_s.x,y-_s.y,18)) {
        _gm.coins+=value;_gm.save_progress();instance_destroy();exit;
    }
}
if(life<=0) instance_destroy();
