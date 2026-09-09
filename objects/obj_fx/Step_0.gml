if(global.flux.state=="dying") exit;
var _dt=flux_dt(); life-=_dt;
x+=lengthdir_x(velocity*_dt,heading); y+=lengthdir_y(velocity*_dt,heading);
velocity*=power(0.05,_dt);
if (life<=0) instance_destroy();
