if (global.flux.state!="playing") exit;
var _dt=flux_world_dt(); prev_x=x; prev_y=y;
x+=lengthdir_x(velocity*_dt,heading); y+=lengthdir_y(velocity*_dt,heading);
lifetime-=_dt;
if (lifetime<=0 || point_distance(x,y,global.flux.center_x,global.flux.center_y)<70) instance_destroy();
