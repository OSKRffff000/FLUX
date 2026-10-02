if(global.flux.state!="playing") exit;
var _dt=flux_world_dt();prev_x=x;prev_y=y;
if(telegraph>0) { telegraph=max(0,telegraph-_dt);exit; }
age+=_dt;
array_push(trail_points,{px:x,py:y,life:0.4});
for(var _i=array_length(trail_points)-1;_i>=0;--_i) {
    trail_points[_i].life-=_dt;
    if(trail_points[_i].life<=0) array_delete(trail_points,_i,1);
}
if(array_length(trail_points)>trail_length) array_delete(trail_points,0,1);
x+=lengthdir_x(velocity*_dt,heading);y+=lengthdir_y(velocity*_dt,heading);
trail_timer-=_dt;
if(trail_timer<=0) { trail_timer=0.1;flux_burst(x,y,tint,1); }
if(age>=max_life || x< -cull_margin || x>room_width+cull_margin || y< -cull_margin || y>room_height+cull_margin) instance_destroy();
