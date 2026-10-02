if(global.flux.state!="playing") exit;
life-=flux_dt();radius=lerp(8,limit,1-life/max_life);
if(life<=0) instance_destroy();
