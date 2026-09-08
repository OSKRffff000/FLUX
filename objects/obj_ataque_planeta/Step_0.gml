if (global.flux.state!="playing") exit;
prev_x=x; prev_y=y;
x+=lengthdir_x(velocity*flux_world_dt(),heading); y+=lengthdir_y(velocity*flux_world_dt(),heading);
trail_timer-=flux_world_dt();
if (trail_timer<=0) { trail_timer=0.06; flux_burst(x,y,tint,1); }
if (x< -90 || x>room_width+90 || y< -90 || y>room_height+90) instance_destroy();
