// Se disipa también si el jugador muere durante el impacto.
image_xscale-=shrink_rate*flux_dt();
image_yscale=image_xscale;
if(image_xscale<=0) { instance_destroy();exit; }
image_alpha=0.55*image_xscale;
