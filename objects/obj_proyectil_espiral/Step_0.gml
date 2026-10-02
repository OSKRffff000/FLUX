if(global.flux.state!="playing") exit;
if(telegraph<=0) heading=(heading+turn_rate*flux_world_dt()+360) mod 360;
tint=image_blend;
event_inherited(); // Guarda posición anterior, mueve, emite estela y limpia fuera de pantalla.
