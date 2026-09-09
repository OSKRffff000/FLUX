gm=global.flux;
elapsed=0;exploded=false;lower_started=false;closed=false;
button_x=[-440,-440];button_ready=[false,false];input_ready=false;
ship_x=obj_nave.x;ship_y=obj_nave.y;
ship_angle=point_direction(ship_x,ship_y,gm.center_x,gm.center_y);
gm.state="dying";gm.reset_camera();gm.sync_music();gm.save_progress();
with(obj_planeta) image_speed=0;
flux_play_sfx(snd_golpe_muerte,10);
application_surface_draw_enable(false);
