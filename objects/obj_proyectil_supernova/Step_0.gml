if(global.flux.state!="playing") exit;
if(age>=accelerate_at) velocity=min(burst_speed,velocity+1600*flux_world_dt());
event_inherited();
