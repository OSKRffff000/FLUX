if(global.flux.state!="playing") exit;
radius+=1300*flux_dt();
if(cleans) {
    with(obj_ataque_planeta) {
        if(point_distance(x,y,other.x,other.y)<=other.radius+radius) {
            flux_burst(x,y,tint,3);instance_destroy();
        }
    }
}
if(radius>=limit) instance_destroy();
